define(['d3', 'angular', 'jquery'], (d3, angular,$) ->


    ($settings) ->
        ChartController = ($rootScope, $scope, DataService, $settings) ->

            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            margin =
                left:40
                right:0
                top:10
                bottom:10
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
            measure = 'average'

            # Init basic svg components according to settings
            svg = d3.select("#"+id).append('svg')
            .attr('width', '100%')
            .attr('height', '20%')
            frame = angular.element("#"+id)

            scale ={}
            scale['x'] =  d3.scale.ordinal()
            .rangeRoundBands([0, frame.width() - margin.left - margin.right - padding.left],0, 0.6)
            scale['y'] = d3.scale.linear()
                .domain([10,0])
                .range([0, frame.height() - margin.top - margin.bottom - padding.bottom ],0.5,0.25)
            g = {}
            g['x'] = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis')
            g['y'] = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis')


            panel = svg.append('g').attr('transform',_translate(margin.left + padding.left ,margin.top))


            isActive = 0
            selectQuestion = (i) ->
                isActive = i
                renderPanel(measure,'question',true)

            div = d3.select("body").append("div")
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

                console.log('rendering')

                ###
                    (() -> if Math.max(d[value],0) == 0
                        scale[value_baseline](0) - scale[value_baseline](d[value])
                    else scale[value_baseline](d[value]) -  scale[value_baseline](0))()) )
                ###

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
                .attr('xlink:href', (d) -> '#/questions/' + d[category])
                .attr('class', 'bars')


                .append('polygon')
                .attr('class', (d,i) ->
                    if isActive == i
                        'isActive'
                    else
                        ''
                )
                .on('click', (d,i)-> selectQuestion(i); return)
                .attr('points', (d) -> _points(
                        scale[category_baseline](d[category]),
                        Math.min(scale[value_baseline].range()[1],scale[value_baseline](0)),
                        Math.min(scale[category_baseline].rangeBand(), 32),
                        0 ))
                .transition()
                .duration(duration)
                .ease('cubic-in-out')
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



            ## Interface ##
            # -> muss außerhalb konfiguriert werden, datenpunkte können auch $scope oder $rootScope punkte sein;


            renderAxis = (duration) ->

                duration ?= 0
                # hor / vert
                ###
                x_axis = d3.svg.axis()
                .scale(scale['x'])
                .orient('bottom')
                g['x'].transition().duration(duration).call(x_axis)
                ###
                y_axis = d3.svg.axis()
                .scale(scale['y'])
                .orient('left').ticks(3)
                g['y'].transition().duration(duration).call(y_axis)



            ######

            ### RUNTIME ACTIONS ###
            #
            # watch measure change
            $scope.$watch(  (() -> $rootScope['questions'].measure),
                ((current, last) ->

                    console.log("measure changed")
                    if current?
                        measure = current
                        switch current
                            when 'average' then scale['y'].domain([10,0])
                            when 'top' then scale['y'].domain([1,0])
                            when 'nps' then scale['y'].domain([1, -0.5])

                    if data.length > 0

                        renderPanel(measure, 'question')
                        renderAxis(1000)

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
                        renderPanel(measure, 'question', true)
                    #renderPanel()

                    return
                ), true )


            $scope.$watch(  (() -> frame.width()),
                ((current, last) ->

                    if data.length > 0
                        # hor / vert
                        scale['x'].rangeRoundBands([0, Math.min(frame.width() - margin.left - margin.right - padding.left, domain.length * 60)],0, 0.5)
                        renderAxis()
                        renderPanel(measure, 'question', true)
                    return
                ), true )

            # watch data change
            # maybe every renderer should know about his data requirements
            $scope.$watch( (() -> DataService.dataPoint['questions_all']),
                ((current, last) ->


                    data = current


                    domain = []
                    angular.forEach(DataService.dataPoint['questions_distinct'], (d) -> domain.push(d.key) if d.value > 0 )

                    # hor / vert
                    scale['y'].range([0, frame.height() - margin.top - margin.bottom - padding.bottom ])

                    # hor / vert
                    scale['x'].domain(domain)
                        .rangeRoundBands([0, Math.min(frame.width() - margin.left - margin.right - padding.left, domain.length * 60)],0, 0.5)

                    renderAxis(1000)
                    renderPanel(measure, 'question')

                    return


                ),
                true
            )
            #
            ######

            return

        return ['$rootScope' , '$scope', 'DataService', $settings, ChartController ]

)

###
.on("mouseover", (d) ->
    div.transition()
    .duration(200)
    .style("opacity", .9);
    div.html(d[category])
    return
)
.on("mousemove", (d) ->
    div .style("left", (d3.event.pageX) + "px")
    .style("top", (d3.event.pageY) + "px")
    return
)
###