define([], () ->

    ($settings) ->
        ChartCtrl = ($scope, $settings) ->
            ###
             OnReload,
                 if content changed -> load
                 1. display old data
                 2 transition to new data


            ###

            ### Store here information about old state , if changed !
            $scope.$watch(  (() -> DataService[$scope.data]),
                ((newVal, oldVal) ->
                $scope.table = DataService[$scope.data]
                return
            ), true )
            ###

            return
        return [ "$scope", $settings, ChartCtrl ]
)