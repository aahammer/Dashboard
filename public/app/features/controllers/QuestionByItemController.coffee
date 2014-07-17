define(['d3', 'angular', 'jquery'], (d3, angular,$) ->


    ($settings) ->
        ChartController = ($rootScope, $scope, DataService, $settings) ->

            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            margin =
                left:0
                right:0
                top:0
                bottom:20
            padding =
                left:0
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
            .attr('height', '25%')
            frame = angular.element("#"+id)

            valueScale = d3.scale.linear()
            .domain([0,10])
            .range([0,frame.width() - margin.left - margin.right - padding.left])
            categoryScale = d3.scale.ordinal()
            .rangeRoundBands([0, frame.height() - margin.top - margin.bottom - padding.bottom ],0.5,0.25)

            x_axis_g = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis')
            y_axis_g = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis')

            panel = svg.append('g').attr('transform',_translate(margin.left + padding.left ,margin.top))


            isActive = 0
            selectQuestion = (i) ->
                isActive = i
                redrawPanel(measure,'question')

            redrawPanel = (value, category) ->

                panel.selectAll('.bars').data([]).exit().remove();

                ## ENTER
                panel.selectAll('.bars')
                .data(data, (d) -> d[category] )
                .enter()
                .append('a')
                .attr('xlink:href', (d) -> '#/questions/' + d[category])
                .attr('class', 'bars')
                .append('rect')
                #.attr('id', (d,i)-> 'q'+i)
                .attr('class', (d,i) ->
                    if isActive == i
                        'isActive'
                    else
                        ''
                )
                .on('click', (d,i)-> selectQuestion(i);return)
                .attr('x', (d)-> valueScale(Math.min(0,d[value])))
                .attr('y', (d) ->  categoryScale(d[category]))
                .attr('height', categoryScale.rangeExtent()[1] / 10 )
                .attr('width', (d) ->
                    if Math.max(d[value],0) == 0
                        valueScale(0) - valueScale(d[value])
                    else valueScale(d[value]) -  valueScale(0)
                )


            renderPanel = (value, category) ->

                ## UPDATE
                panel.selectAll('.bars')
                .data(data, (d) -> d[category] )
                .select('rect')
                .transition()
                .duration(1000)
                .attr('x', (d)-> valueScale(Math.min(0,d[value])))
                .attr('width', (d) ->
                    if Math.max(d[value],0) == 0
                        valueScale(0) - valueScale(d[value])
                    else valueScale(d[value]) -  valueScale(0)
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
                .attr('class', (d,i) ->
                    if isActive == i
                        'isActive'
                    else
                        ''
                )
                .on('click', (d,i)-> selectQuestion(i); return)
                .attr('width', 0)
                .transition()
                .duration(1000)
                .ease('circle')
                .attr('x', (d)-> valueScale(Math.min(0,d[value])))
                .attr('y', (d) ->  categoryScale(d[category]))
                .attr('height', categoryScale.rangeExtent()[1] / 10 )
                .attr('width', (d) ->
                    if Math.max(d[value],0) == 0
                        valueScale(0) - valueScale(d[value])
                    else valueScale(d[value]) -  valueScale(0)
                )


                ## EXIT
                panel.selectAll('.bars')
                .data(data, (d) -> d[category])
                .exit()
                .remove()


            ### Interface ###
            # -> muss außerhalb konfiguriert werden, datenpunkte können auch $scope oder $rootScope punkte sein;

            redrawAxis = () ->

                x_axis = d3.svg.axis()
                .scale(valueScale)
                .orient('bottom')
                x_axis_g.call(x_axis)
                y_axis = d3.svg.axis()
                .scale(categoryScale)
                .orient('left')
                y_axis_g.call(y_axis)

            renderAxis = () ->

                x_axis = d3.svg.axis()
                .scale(valueScale)
                .orient('bottom')
                x_axis_g.transition().duration(1000).call(x_axis)
                y_axis = d3.svg.axis()
                .scale(categoryScale)
                .orient('left')
                y_axis_g.transition().duration(1000).call(y_axis)



            ######

            ### RUNTIME ACTIONS ###
            #
            # watch measure change
            $scope.$watch(  (() -> $rootScope[id].measure),
                ((current, last) ->

                    if current?
                        measure = current
                        switch current
                            when 'average' then valueScale.domain([0,10])
                            when 'top' then valueScale.domain([0,1])
                            when 'nps' then valueScale.domain([-1, 1])



                    if data.length > 0

                        renderPanel(measure, 'question')
                        renderAxis(measure, 'question')

                    return
                ), true )
            # watch window resize
            $scope.$watch(  (() -> frame.height()),
                ((current, last) ->

                    # change height and width

                    if data.length > 0
                        categoryScale
                        .rangeRoundBands([0, current - margin.top - margin.bottom - padding.bottom ], 1-(1/domain.length), 2/domain.length)
                        x_axis_g.attr('transform', _translate(margin.left + padding.left, current - margin.bottom))

                        redrawAxis()
                        redrawPanel(measure, 'question')
                    #renderPanel()

                    return
                ), true )


            $scope.$watch(  (() -> frame.width()),
                ((current, last) ->

                    if data.length > 0
                        valueScale.range([0,current - margin.left - margin.right - padding.left])
                        redrawAxis()
                        redrawPanel(measure, 'question')
                    return
                ), true )

            # watch data change
            # maybe every renderer should know about his data requirements
            $scope.$watch( (() -> DataService.dataPoint['questions_all']),
                ((current, last) ->


                    data = current


                    domain = []
                    angular.forEach(DataService.dataPoint['questions_distinct'], (d) -> domain.push(d.key) if d.value > 0 )

                    categoryScale.domain(domain)
                    .rangeRoundBands([0, frame.height() - margin.top - margin.bottom - padding.bottom ],1-(1/domain.length), 2/domain.length)

                    valueScale.range([0,frame.width() - margin.left - margin.right - padding.left])

                    renderAxis()
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