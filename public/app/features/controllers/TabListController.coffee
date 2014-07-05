define([], () ->
    ($settings) ->
        TabListController = ($rootScope, $scope, $settings, DataService) ->

            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            $scope.selected = DataService.dataPoint[id][0].name
            $scope.nav_type= $settings.ui.nav_type

            $scope.select = (selected) -> $scope.selected = selected
            $rootScope[id].select = $scope.select

            console.log(id)
            console.log( DataService.dataPoint[id])

            # Todo alter data on reset
            $scope.$watch( (() -> DataService.dataPoint[id]),
                ((newVal, oldVal) ->

                    # loop over -> kep default or set 0

                    $scope.tabs = DataService.dataPoint[id]
                    return
                ),
                true
            )
            return

        return [ '$rootScope', '$scope' , $settings, 'DataService', TabListController ]
)