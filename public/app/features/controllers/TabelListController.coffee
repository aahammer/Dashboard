# TODO: Alter table style
# TODO: fill with DataService Data

define([], () ->

    ($settings) ->

        TabelListCtrl = ($rootScope, $scope, $settings, DataService) ->



            id = $settings.id
            $scope.gridOptions = { data: 'table' }


            $scope.$watch( (() -> DataService.dataPoint[id]),
                ((newVal, oldVal) ->
                    $scope.table = DataService.dataPoint[id]
                    return
                ),
                true
            )

            return

        return [ '$rootScope', '$scope', $settings, 'DataService', TabelListCtrl ]
)
###
define([], () ->

    ($settings) ->

        TableListController = ( $rootScope, $scope, $settings, DataService) ->

            $scope.data = $settings.data
            console.log($settings.data)
            #$scope[$settings.data].doSomething = () -> console.log("hallo Welt")
            this.scope = $scope
            $rootScope.items = ()->console.log("hallo Welt")
            this.scope.gridOptions = {data: 'table'}
            this.scope.table = [ name:"alfons", name:"bert"]
            return( this )

        TableListController.prototype =
            hallo : () ->
                console.log("welt")
                return

        return [ '$rootScope', "$scope", $settings, 'DataService', TableListController ]
)
###
###

)###