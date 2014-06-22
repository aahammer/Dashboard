define(['d3', 'angular', 'jquery'], (d3, angular,$) ->


    ($settings) ->
        ChartController = ($scope, DataService, StateManagementService, $settings) ->

            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id

            margin =
                left:40
                right:0
                top:10
                bottom:50
            padding =
                left:0
                bottom:0
                top:0
                bottom:0


            _translate = (x,y) -> 'translate(' + x + ',' + y + ')'
            _points = (x,y,w,h) ->
                [[x,y].join(','),[x+w,y].join(','),[x+w,y+h].join(','),[x,y+h].join(',')].join(' ')


            data = []
            domain= []
            measure = ''

            # Init basic svg components according to settings
            svg = d3.select("#"+id).append('svg')
            .attr('width', '100%')
            .attr('height', '20%')
            frame = angular.element("#"+id)

            scale ={}
            scale['x'] =  d3.scale.ordinal()
            #.rangeRoundBands([0, frame.width() - margin.left - margin.right - padding.left],0, 0.6)
            scale['y'] = d3.scale.linear()
            #.domain([10,0])
            #.range([0, frame.height() - margin.top - margin.bottom - padding.bottom ],0.5,0.25)
            g = {}
            g['x'] = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis')
            g['y'] = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis')


            panel = svg.append('g').attr('transform',_translate(margin.left + padding.left ,margin.top))


            isActive = 0
            selectItem = (i) ->
                isActive = i
                renderPanel(measure,'item',true)

            tooltip = d3.select("body").append("div")
                        .attr("class", "tooltip")
                        .style("opacity", 0)


            renderPanel = (value, category, redraw) ->

                if redraw? and redraw
                    panel.selectAll('.bars').data([]).exit().remove();
                    duration = 0
                else duration = 1000

                value_baseline = 'y'
                value_extrusion = 'height'
                category_baseline = 'x'
                category_extrusion = 'width'


                ## UPDATE
                panel.selectAll('.bars')
                .data(data, (d) -> d[category] )
                .select('polygon')
                .transition()
                .duration(duration)
                .attr('points', (d) -> _points(
                    scale[category_baseline](d[category]),
                    Math.min(scale[value_baseline].range()[1],scale[value_baseline](0)),
                    Math.min(scale[category_baseline].rangeBand(), 32),
                    scale[value_baseline](d[value]) - scale[value_baseline](0)))

                ## ENTER
                panel.selectAll('.bars')
                .data(data, (d) -> d[category] )
                .enter()
                .append('a')
                .attr('xlink:href', (d) -> '#/questionByItem/' + d[category])
                .attr('class', 'bars')


                .append('polygon')
                 .on("mouseover", (d)->
                        tooltip.transition()
                            .duration(200)
                            .style("opacity", 0.9)
                        tooltip.html(d[category])
                            .style("left", (d3.event.pageX - 28)  + "px")
                            .style("top", (d3.event.pageY - 28) + "px")
                        return
                )
                .on("mousemove", (d) ->
                    tooltip
                    .style("left", (d3.event.pageX - 28) + "px")
                    .style("top", (d3.event.pageY - 28) + "px")
                )
                .on("mouseout", (d) ->
                    tooltip.transition()
                    .duration(500)
                    .style("opacity", 0)
                    return
                )

                .attr('points', (d) -> _points(
                        scale[category_baseline](d[category]),
                        Math.min(scale[value_baseline].range()[1],scale[value_baseline](0)),
                        Math.min(scale[category_baseline].rangeBand(), 32),
                        0 ))
                .transition()
                .duration(duration)
                .ease('cubic-in-out')
                .attr('class', (d,i) ->
                    if isActive == i
                        'isActive'
                    else
                        ''
                )
                .attr('points', (d) -> _points(
                    scale[category_baseline](d[category]),
                    Math.min(scale[value_baseline].range()[1],scale[value_baseline](0)),
                    Math.min(scale[category_baseline].rangeBand(), 32),
                        scale[value_baseline](d[value]) - scale[value_baseline](0)))




                ## EXIT
                panel.selectAll('.bars')
                .data(data, (d) -> d[category])
                .exit()
                .remove()



            ## Interface
            renderAxis = (duration) ->

                duration ?= 0

                y_axis = d3.svg.axis()
                .scale(scale['y'])
                .orient('left').ticks(3)
                g['y'].transition().duration(duration).call(y_axis)


            position = null

            ######

            ### RUNTIME ACTIONS ###
            #
            # watch measure change
            $scope.$watch(  (() -> StateManagementService.state.measure),
                ((current, last) ->


                    if current?
                        measure = current
                        switch current
                            when 'AVERAGE' then scale['y'].domain([10,0])
                            when 'TOP' then scale['y'].domain([1,0])
                            when 'NPS' then scale['y'].domain([1, -0.5])

                    if data.length > 0

                        renderPanel(measure,'item')
                        renderAxis(1000)

                    return
                ), true )

            $scope.$watch(  (() -> StateManagementService.state.item),
                ((current, last) ->

                    if !position
                        position = {}
                        i = 0
                        for item in DataService.dataPoint['items_distinct']
                            position[item.key] = i
                            i += 1

                    selectItem(position[current])
                    renderPanel(measure,'item',true)
                    return
                ), true )

            # watch window resize
            $scope.$watch(  (() -> frame.height()),
                ((current, last) ->

                    # change height and width

                    if data.length > 0
                        # hor / vert
                        #categoryScale
                        scale['y'].range([0, current - margin.top - margin.bottom - padding.bottom ] )

                        g['x'].attr('transform', _translate(margin.left + padding.left, current - margin.bottom))

                        renderAxis()
                        renderPanel(measure, 'item', true)
                    #renderPanel()

                    return
                ), true )


            $scope.$watch(  (() -> frame.width()),
                ((current, last) ->

                    if data.length > 0
                        # hor / vert
                        scale['x'].rangeRoundBands([0, Math.min(frame.width() - margin.left - margin.right - padding.left, domain.length * 60)],0, 0.5)
                        renderAxis()
                        renderPanel(measure, 'item', true)
                    return
                ), true )

            # watch data change
            # maybe every renderer should know about his data requirements
            $scope.$watch( (() -> DataService.dataPoint['questionByItem']),
                ((current, last) ->


                    data = current

                    domain = []
                    angular.forEach(DataService.dataPoint['items_distinct'], (d) -> domain.push(d.key) if d.value > 0 )

                    # hor / vert
                    scale['y'].range([0, frame.height() - margin.top - margin.bottom - padding.bottom ])

                    # hor / vert
                    scale['x'].domain(domain)
                        .rangeRoundBands([0, Math.min(frame.width() - margin.left - margin.right - padding.left, domain.length * 60)],0, 0.5)

                    renderAxis(1000)
                    renderPanel(measure, 'item')

                    return


                ),
                true
            )
            #
            ######

            return

        return [ '$scope', 'DataService', 'StateManagementService', $settings, ChartController ]

)
