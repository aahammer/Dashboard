# TODO: Alter table style
# TODO: fill with DataService Data

define([], () ->

    ($settings) ->

        TableController = ($rootScope, $scope, $location, $settings, DataService) ->

            # INIT ID Infrastructure
            id = $settings.id
            $scope.id = id
            $rootScope[id] = {}

            selection = [];

            $scope.gridOptions =
                data: 'table'
                multiSelect: false
                selectedItems: selection
                headerRowHeight:0
                # TODO this may change witjh the selection
                columnDefs:
                        [
                            { field: 'key', displayName: 'Speciality', width: '80%'}
                            { field: 'value', displayName: 'Total', width: '20%'}
                        ]

            ### RUNTIME ACTIONS ###
            #
            # watch table data change
            $scope.$watch( (() -> DataService.dataPoint[id]),
                ((currrent, last) ->
                    $scope.table = DataService.dataPoint[id]
                    return
                ),
                true
            )
            # watch user row selection
            $scope.$watch( (() -> selection),
                ((current, last) ->
                    if (current.length != 0)
                        # TODO change dynamic
                        $location.path('/items/'+current[0].id)
                    else
                        # initialization is here, because gridOptions is not avaliable on startup
                        $scope.gridOptions.selectRow(0,true)
                    return
                ),
                true
            )
            #
            ######

            return

        return [ '$rootScope', '$scope', '$location', $settings, 'DataService', TableController ]
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