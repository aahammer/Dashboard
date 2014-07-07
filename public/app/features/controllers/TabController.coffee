define([], () ->
    ($settings) ->

        TabController = ($rootScope, $scope, $settings, DataService) ->


            ### STARTUP CODE ###

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            # INIT GUI #
            $scope.selected = DataService.dataPoint[id][0].key
            $scope.nav_type= $settings.ui.nav_type
            #
            ######


            ### RUNTIME INTERFACE ###
            #
            select = (selected) -> $scope.selected = selected
            $scope.select = select
            $rootScope[id].select = select
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

        return [ '$rootScope', '$scope' , $settings, 'DataService', TabController ]
)