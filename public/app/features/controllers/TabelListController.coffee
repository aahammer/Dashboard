# TODO: Alter table style
# TODO: fill with DataService Data
define([], () ->

    ($settings) ->

        TabelListCtrl = ($scope, $settings, DataService) ->
            #console.log(DataService)
            $scope.data = $settings.data
            $scope.table = DataService[$scope.data]
            $scope.gridOptions = { data: 'table' }


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

        return [ "$scope", $settings, 'DataService', TabelListCtrl ]
)