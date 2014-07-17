# Parameter:
# <chart id=firstchart style=margin-left, margin-top, margin-right, margin-bottom, padding-left, .... >
#
#   <axis id=xaxis location=bottom, top, left right show=true> data </axis>
#   <axis id=yaxis location=bottom, top, left right show=true> data </axis>
#
#   <bars scale=xaxis orient=left, top, bottom, right>
#       <data src=xyz>
#            <value>
#            <category>
#       </data>
#   </bars>
# </chart>
###
chart: knows no data
    id:
    style:
        margin-left
        margin-top
        margin-right
        margin-bottom
        padding-left
        padding-top
        padding-bottom
        padding-right
    panels:[
    ]
    axis: [
        {id:
        orient:left}
        {}
    ]

renderer:
    data:
    value:
    value-axis:
    class:
    class-axis:

axis: knows no data

###
define(['d3', 'angular'], (d3, angular) ->


    ($settings) ->
            ChartController = ($rootScope, $scope, $window, rs, DataService, $settings) ->


                ### STARTUP CODE ###

                # INIT ID Infrastructure
                id = $settings.id
                $scope.id = id
                $rootScope[id] = {}

                data = []

                panels = {}
                renderer = {}

                axis = {}

                # Init basic svg components according to settings
                svg = d3.select("#"+id).append('svg')
                            .attr('width', $settings.frame.width)
                            .attr('height', $settings.frame.height)
                frame = angular.element("#"+id)

                valueScale = d3.scale.linear()
                        .domain([0,100])
                        .range([0,frame.width() - $settings.frame.margin.left - $settings.frame.margin.right])
                categoryScale = d3.scale.ordinal()
                        .rangeRoundBands([0, frame.height() - $settings.frame.margin.top - $settings.frame.margin.bottom ],0.5,0.25)
                x_axis_g = svg.append('g').attr('transform', rs._translate($settings.frame.margin.left, frame.height() - $settings.frame.margin.bottom))
                y_axis_g = svg.append('g').attr('transform', rs._translate($settings.frame.margin.left, $settings.frame.margin.top))
                panels['bars'] = svg.append('g').attr('transform',rs._translate($settings.frame.margin.left,$settings.frame.margin.top))


                ### Interface ###
                # -> muss außerhalb konfiguriert werden, datenpunkte können auch $scope oder $rootScope punkte sein;
                renderAxis = () ->

                    x_axis = d3.svg.axis()
                    .scale(valueScale)
                    .orient('bottom')
                    x_axis_g.call(x_axis)
                    y_axis = d3.svg.axis()
                    .scale(categoryScale)
                    .orient('left')
                    y_axis_g.transition().duration(1000).call(y_axis)

                measure = 'return_total'
                renderer['bars'] =
                    rs.render(
                        panels['bars']
                        measure
                        valueScale
                        'question'
                        categoryScale
                        {
                            selector: '.'+id
                            layout: 'horizontal'
                            max: 10
                        }
                    )


                #
                ######

                ### RUNTIME ACTIONS ###
                #
                # watch measure change
                $scope.$watch(  (() -> $rootScope[id].measure),
                    ((current, last) ->



                        renderer['bars'].configure(
                            value: current
                        )
                        renderer['bars'].render(data)
                        console.log('hallo')
                        return
                    ), true )
                # watch window resize
                $scope.$watch(  (() -> $window.innerWidth),
                    ((current, last) ->

                        # change height and width
                        valueScale.range([0,frame.width() - $settings.frame.margin.left - $settings.frame.margin.right])

                        #renderAxis()
                        #renderContent()
                        return
                    ), true )

                # watch data change
                # maybe every renderer should know about his data requirements
                $scope.$watch( (() -> DataService.dataPoint[id+'_all']),
                    ((current, last) ->

                        data = DataService.dataPoint[id+'_all']

                        domain = []
                        angular.forEach(DataService.dataPoint[id], (d) -> domain.push(d.key) if d.value > 0 )

                        categoryScale.domain(domain)
                            .rangeRoundBands([0, frame.height() - $settings.frame.margin.top - $settings.frame.margin.bottom ],1-(1/domain.length), 2/domain.length)


                        renderAxis()
                        renderer['bars'].render(data)
                        return
                    ),
                    true
                    )
                #
                ######

                return

            return ['$rootScope' , '$scope', '$window','RenderService', 'DataService', $settings, ChartController ]

    )
