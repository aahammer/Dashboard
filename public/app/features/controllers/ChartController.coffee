define(['d3', 'angular'], (d3, angular) ->


    ($settings) ->
        ChartController = ($rootScope, $scope, $window, rs, DataService, $settings) ->


            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            # Init basic svg components according to settings
            svg = d3.select("#"+id).append('svg')
                        .attr('width', $settings.frame.width)
                        .attr('height', $settings.frame.height)
            frame = angular.element("#"+id)
            

            data = [{average:59, questions:'Shit'}, {average:87, questions:'Holy'},{average:43, questions:'Is'},{average:100, questions:'It'},{average:88, questions:'ForReal'}]
            valueScale = d3.scale.linear()
            .domain([0,100])
            .range([0,frame.width() - $settings.frame.margin.left - $settings.frame.margin.right])

            categoryScale = d3.scale.ordinal()
            .domain(['Shit', 'Holy','Is', 'It', 'ForReal'])
            #.rangePoints([0, frame.height() - $settings.frame.margin.top - $settings.frame.margin.bottom ], 1)
            .rangeRoundBands([0, frame.height() - $settings.frame.margin.top - $settings.frame.margin.bottom ],0.5,0.25)
            .rangeRoundBands([0, frame.height() - $settings.frame.margin.top - $settings.frame.margin.bottom ],0.5,0.25)

            rs.renderBars( svg.append('g').attr('transform','translate('+$settings.frame.margin.left+','+$settings.frame.margin.top+')')
                data
                'average'
                valueScale
                id
                categoryScale
                {
                    selector: id+'.bar'
                    layout: 'horizontal'
                    max: 10
                }
            )


            ### Interface ###
            #
            renderAxis = () ->

                x_axis_g = svg.append('g').attr('transform', rs._translate($settings.frame.margin.left, frame.height() - $settings.frame.margin.bottom))
                x_axis = d3.svg.axis()
                .scale(valueScale)
                .orient('bottom')
                x_axis_g.call(x_axis)

                y_axis_g = svg.append('g').attr('transform', rs._translate($settings.frame.margin.left, $settings.frame.margin.top))
                y_axis = d3.svg.axis()
                .scale(categoryScale)
                .orient('left')
                y_axis_g.call(y_axis)

            render = () ->
                return
            #
            ######

            ### RUNTIME ACTIONS ###
            #
            $scope.$watch(  (() -> $window.innerWidth),
                ((newVal, oldVal) ->
                    #console.log(newVal)
                    return
                ), true )

            $scope.$watch( (() -> DataService.dataPoint[id]),
                ((newVal, oldVal) ->
                    #data = DataService.dataPoint[id]
                    renderAxis()
                    return
                ),
                true
                )
            #
            ######

            return

        return ['$rootScope' , '$scope', '$window','RenderService', 'DataService', $settings, ChartController ]

)
