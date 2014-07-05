define([], () ->

    ($settings) ->
        ChartController = ($scope, $settings) ->

            ###
                Basic Idea: A Chart Controller offers one area where data can be added for display
                Several axis translations can be set for X and Y axis, A data object is later on assigned to axis
                It can also be controlled if an axis should be drawn (how and where, including margins)

                External configuration needed ->
                    Axis Content
                    Axis Display Definition
                    Data Content ( x and y values, ... etc)
                    Data Display Definition ( -> bar-X, bar-Y, lilne-X, line-Y, )
                    General Settings ( draw grid, etc ..... )
                    Data Display Method (?) -> configure different draw methods / maybe a d3 js draw service ?

                what do i need ?
                i need data, axis, information about how/if to paint axis, and data
                paint style

                Todo Scheiss viel arbeit
            ###

            ### Store here information about old state , if changed !
            $scope.$watch(  (() -> DataService[$scope.data]),
                ((newVal, oldVal) ->
                $scope.table = DataService[$scope.data]
                return
            ), true )
            ###

            return
        return [ "$scope", $settings, ChartController ]
)

### Howto inject different draw methods ?
    drawData( width, height, translated data )
    Controller aggregates all needed directives and data and translates data coordinates to screen coordinates
    -> the individual drawing process is handled by draw providers in final coordinates
    -> first drawing provider: bardrawer
###