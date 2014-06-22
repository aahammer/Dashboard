define(['d3', 'angular', 'jquery'], (d3, angular,$) ->


    ($settings) ->
        ChartController = ($rootScope, $scope, DataService, StateManagementService, $settings) ->

            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            margin =
                left:200
                left_pct:0.44
                right:20
                top:20
                bottom:20
            padding =
                left:5
                bottom:5
                top:0
                bottom:0

            _translate = (x,y) -> 'translate(' + x + ',' + y + ')'

            data = []
            domain= []
            measure = 'average'

            # Init basic svg components according to settings
            svg = d3.select("#"+id).append('svg')
            .attr('width', '100%')
            .attr('height', '40%')
            frame = angular.element("#"+id)

            margin.left = frame.width() * margin.left_pct

            scale ={}
            scale['x'] =  d3.scale.linear()
                    #.domain([0,10])
                    .range([0,frame.width() - margin.left - margin.right - padding.left])
            scale['y'] = d3.scale.ordinal()
                #.rangeRoundBands([0, frame.height() - margin.top - margin.bottom - padding.bottom ],0.5,0.25)
            g = {}
            g['x'] = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis')
            g['y'] = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis')


            panel = svg.append('g').attr('transform',_translate(margin.left + padding.left ,margin.top))


            activeIndex = null

            renderPanel = (value, category, redraw) ->

                    if redraw? and redraw
                        panel.selectAll('.bars').data([]).exit().remove();
                        duration = 0
                    else duration = 1000

                    value_baseline = 'x'
                    value_extrusion = 'width'
                    category_baseline = 'y'
                    category_extrusion = 'height'

                    ## UPDATE
                    panel.selectAll('.bars')
                        .data(data, (d) -> d[category] )
                        .select('rect')
                        .attr('class', (d) ->
                            if domain[activeIndex] == d[category]
                                StateManagementService.state.value = d[measure]
                                'isActive'
                            else
                                ''
                        )
                        .transition()
                        .duration(duration)
                        .attr(value_baseline, (d)-> scale[value_baseline](Math.min(0,d[value])))
                        .attr(value_extrusion, (d) ->
                                    if Math.max(d[value],0) == 0
                                        scale[value_baseline](0) - scale[value_baseline](d[value])
                                    else scale[value_baseline](d[value]) -  scale[value_baseline](0)
                            )

                    ## ENTER
                    panel.selectAll('.bars')
                        .data(data, (d) -> d[category] )
                        .enter()
                        .append('a')
                        .attr('xlink:href', (d) -> '#/questions/' + d[category])
                        .attr('class', 'bars')
                        .append('rect')
                        #.attr('id', (d,i)-> 'q'+i)
                        .attr('class', (d) ->
                            if domain[activeIndex] == d[category]
                                StateManagementService.state.value = d[measure]
                                'isActive'
                            else
                                ''
                        )
                        #.on('click', (d,i)-> selectQuestion(i); return)
                        .attr(value_extrusion, 0)
                        .transition()
                        .duration(duration)
                        .ease('circle')
                        .attr(value_baseline, (d)-> scale[value_baseline](Math.min(0,d[value])))
                        .attr(category_baseline, (d) ->  scale[category_baseline](d[category]))
                        .attr(category_extrusion, Math.min(scale[category_baseline].rangeExtent()[1] / 10, 32) )
                        .attr(value_extrusion, (d) ->
                            if Math.max(d[value],0) == 0
                                scale[value_baseline](0) - scale[value_baseline](d[value])
                            else scale[value_baseline](d[value]) -  scale[value_baseline](0)
                            )


                    ## EXIT
                    panel.selectAll('.bars')
                        .data(data, (d) -> d[category])
                        .exit()
                        .remove()


            ### Interface ###
            # -> muss außerhalb konfiguriert werden, datenpunkte können auch $scope oder $rootScope punkte sein;


            renderAxis = (duration) ->

                duration ?= 0
                # hor / vert
                x_axis = d3.svg.axis()
                .scale(scale['x'])
                .orient('bottom')
                g['x'].transition().duration(duration).call(x_axis)
                y_axis = d3.svg.axis()
                .scale(scale['y'])
                .orient('left')
                g['y'].transition().duration(duration).call(y_axis)


            domain = []

            ######

            ### RUNTIME ACTIONS ###
            #
            # watch measure change
            $scope.$watch(  (() -> StateManagementService.state.measure),
                ((current, last) ->


                    if current?
                        measure = current
                        switch current
                            when 'AVERAGE' then scale['x'].domain([0,10])
                            when 'TOP' then scale['x'].domain([0,1])
                            when 'NPS' then scale['x'].domain([-0.5,1])


                    if data.length > 0

                        renderPanel(measure, 'question')
                        renderAxis(1000)

                    return
                ), true )

            $scope.$watch(  (() -> DataService.dataPoint['questions_distinct']),
                ((current, last) ->


                    domain = []
                    angular.forEach(current, (d) -> domain.push(d.key) if d.value > 0 )
                    activeIndex = 0

                    # should be rendered by questions_all
                    #renderPanel(measure, 'question')

                    return
            ), true )

            $scope.$watch(  (() -> StateManagementService.state.question),
                ((current, last) ->

                    activeIndex = $.inArray(current, domain)
                    renderPanel(measure, 'question', true)

                    return
                ), true )

            # watch window resize
            $scope.$watch(  (() -> frame.height()),
                ((current, last) ->

                    # change height and width

                    if data.length > 0

                        scale['y']
                            .rangeRoundBands([0, current - margin.top - margin.bottom - padding.bottom ], 1-(1/domain.length), 2/domain.length)
                        g['x'].attr('transform', _translate(margin.left + padding.left, current - margin.bottom))


                        renderAxis()
                        renderPanel(measure, 'question', true)
                        #renderPanel()

                    return
                ), true )


            $scope.$watch(  (() -> frame.width()),
                ((current, last) ->

                    margin.left = current * margin.left_pct

                    if data.length > 0
                        # hor / vert
                        scale['x'].range([0,current - margin.left - margin.right - padding.left])
                        #g['y'].attr('transform', _translate(margin.left, margin.top))
                        #g['x'].attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom))

                        renderAxis()
                        renderPanel(measure, 'question', true)

                    return
                ), true )

            # watch data change
            # maybe every renderer should know about his data requirements
            $scope.$watch( (() -> DataService.dataPoint['questions_all']),
                ((current, last) ->


                    data = current

                    # hor / vert
                    scale['y'].domain(domain)
                        .rangeRoundBands([0, frame.height() - margin.top - margin.bottom - padding.bottom ],1-(1/domain.length), 2/domain.length)

                    # hor / vert
                    scale['x'].range([0,frame.width() - margin.left - margin.right - padding.left])

                    renderAxis(1000)
                    renderPanel(measure, 'question')

                    return


                ),
                true
            )
            #
            ######

            return

        return ['$rootScope' , '$scope', 'DataService', 'StateManagementService', $settings, ChartController ]

)