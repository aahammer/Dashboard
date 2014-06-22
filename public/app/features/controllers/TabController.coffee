define([], () ->
    ($settings) ->

        TabController = ($scope, $settings, DataService) ->


            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id

            # INIT GUI #
            $scope.selected = DataService.dataPoint[id][0].key
            $scope.nav_type= $settings.ui.nav_type
            #
            ######


            ### RUNTIME INTERFACE ###
            #
            select = (selected) -> $scope.selected = selected
            $scope.select = select
            #
            ######


            ### RUNTIME ACTIONS ###
            #
            $scope.$watch( (() -> DataService.dataPoint[id]),
                ((current, last) ->
                    $scope.tabs = DataService.dataPoint[id]
                    return
                ),
                true
            )
            #
            ######


            return

        return ['$scope' , $settings, 'DataService', TabController ]
)