define(['d3', 'angular', 'jquery'], (d3, angular,$) ->


    ($settings) ->
        ChartController = ($rootScope, $scope, DataService, StateManagementService, $settings) ->

            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            margin =
                left:40
                right:15
                top:10
                bottom:50
            padding =
                left:5
                bottom:5
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
            scale['x'] =  d3.time.scale().domain([new Date(2013,4,1), new Date(2014,5,1)]).range([0, frame.width() - margin.left - margin.right - padding.left]);
            scale['y'] = d3.scale.linear()
            .domain([10,0])
            .range([0, frame.height() - margin.top - margin.bottom - padding.bottom ],0.5,0.25)
            g = {}
            g['x'] = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis vertical')
            g['y'] = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis')


            panel = svg.append('g').attr('transform',_translate(margin.left + padding.left ,margin.top))

            line = {}
            line['measure'] = d3.svg.line().interpolate("bundle")

            renderPanel = (value, category, redraw) ->

                if redraw? and redraw
                    panel.selectAll('.lines').data([]).exit().remove();
                    duration = 0
                else duration = 1000

                value_baseline = 'y'
                value_extrusion = 'height'
                category_baseline = 'x'
                category_extrusion = 'width'


                line['measure'].x((d) -> scale[category_baseline](d[category]))
                    .y((d) -> scale[value_baseline](d[value]))





                ##UPDATE
                panel.selectAll('.lines')
                .data(data)
                .transition()
                .duration(duration)
                .attr('d', (d) ->  line['measure'](d) )

                ## ENTER
                panel.selectAll('.lines')
                    .data(data)
                    .enter()
                    .append('path')
                    .attr('class', 'lines')
                    .attr('stroke', 'black')
                    .attr('fill', 'none')
                    .attr('d', (d) -> line['measure'](d) )
                    .transition()
                    .duration(duration)
                    .ease('cubic-in-out')

                ## EXIT
                panel.selectAll('.lines')
                .data(data)
                .exit()
                .remove()



            ## Interface ##
            # -> muss außerhalb konfiguriert werden, datenpunkte können auch $scope oder $rootScope punkte sein;


            renderAxis = (duration) ->

                duration ?= 0
                # hor / vert

                x_axis = d3.svg.axis()
                .scale(scale['x'])
                .orient('bottom').ticks(d3.time.months, 1).tickFormat(d3.time.format('%b'))
                g['x'].call(x_axis)
                svg.selectAll(".vertical text").attr('y', 18)


                y_axis = d3.svg.axis()
                .scale(scale['y'])
                .orient('left').ticks(3)

                g['y'].transition().duration(duration).call(y_axis)




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

                        renderPanel(measure, 'date')
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
                        renderPanel(measure, 'date', true)
                    #renderPanel()

                    return
                ), true )


            $scope.$watch(  (() -> frame.width()),
                ((current, last) ->

                    if data.length > 0
                        # hor / vert
                        scale['x'].range([0, frame.width() - margin.left - margin.right - padding.left])
                        renderAxis()
                        renderPanel(measure, 'date', true)
                    return
                ), true )

            # watch data change
            # maybe every renderer should know about his data requirements
            $scope.$watch( (() -> DataService.dataPoint['question_history']),
                ((current, last) ->


                    data = [current]

                    ###
                    domain = []

                    ###

                    # hor / vert
                    scale['y'].range([0, frame.height() - margin.top - margin.bottom - padding.bottom ])


                    # hor / vert
                    scale['x']#.domain(domain)
                        .range([0, frame.width() - margin.left - margin.right - padding.left]);

                    renderAxis(1000)
                    renderPanel(measure, 'date')

                    return


                ),
                true
            )
            #
            ######

            return

        return ['$rootScope' , '$scope', 'DataService','StateManagementService', $settings, ChartController ]

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