# TODO: Alter table style
# TODO: fill with DataService Data

define([], () ->

    ($settings) ->

        TableController = ($timeout, $scope, $location, $settings, DataService, StateManagementService ) ->


            selection = [];

            $scope.gridOptions =
                data: 'table'
                multiSelect: false
                selectedItems: selection
                headerRowHeight:42
                enableSorting: false
                # TODO this may change with the selection
                columnDefs:
                        [
                            { field: 'key', displayName: '', width: '80%'}
                            { field: 'value', displayName: 'Surveys', width: '20%'}
                        ]

            position = null

            ### RUNTIME ACTIONS ###
            #
            # watch table data change

            # watch user row selection
            $scope.$watch( (() -> selection),
                ((current, last) ->

                    if (current.length != 0)
                        $location.path('/items/'+current[0].key)
                    return
                ),
                true
            )

            ###
            $scope.$on('$viewContentLoaded', (event) ->

                console.log(event.targetScope.gridOptions)
                event.targetScope.gridOptions['selectRow'](0,true)
                #console.log($rootScope.$$listeners)
                #$rootScope.$$listeners['viewContentLoaded'] = []
            )
            ###
            $scope.$watch(  (() -> StateManagementService.state.item ),
                ((current, last) ->


                    if !position

                        $scope.table = DataService.dataPoint['items_distinct']

                        position = {}
                        i = 0
                        for item in DataService.dataPoint['items_distinct']
                            position[item.key] = i
                            i += 1

                    $location.path('/items/'+current)

                    console.log(position[current])

                    $timeout((() -> $scope.gridOptions.selectRow(position[current],true)), 100)

                    return
                ),
                true
            )


            #
            ######

            return

        return [ '$timeout', '$scope', '$location', $settings, 'DataService', 'StateManagementService', TableController ]
)
