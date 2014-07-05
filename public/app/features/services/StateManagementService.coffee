define([], () ->

    ($settings) ->
        StateManagementService = ($rootScope, $settings, DataService) ->

            urlParser = document.createElement('a');

            $rootScope.$on('$locationChangeSuccess', (event, now, last) ->

                urlParser.href = now;
                #console.log(now)
                #console.log(urlParser)


                urlParts = /#\/(\w*)\/(\w*)/g.exec(urlParser.hash)

                DataService.provideData(
                    selection: urlParts[1]
                    item: urlParts[2]
                )

                query =
                    select: ['item', 'module', 'measure', 'question' ]
                    from: 'selection'
                    where:
                        item:'Surgery'
                        module:'Organisation'
                        measure: 'Average'
                        date: 'current()'

                ### TODO Statemachine
                               only change data in background and let views update automatically
                               -> on selection change
                                  -> update all items + enforce state change for total redraw
                               -> on item change
                                   -> update questions
                                   -> update timeseries
                               -> on module change
                                   -> update measures
                                   -> update questions
                                   -> update timeseries
                               -> on measure change
                                   -> update questions
                                   -> update timeseries
                               -> on question change
                                   -> update timeseries
                           # Maybe: Check for changes where there is no valid selection anymore and cascade default
                ###
                return
            )
            return

        return ['$rootScope', $settings, 'DataService', StateManagementService ]
)
