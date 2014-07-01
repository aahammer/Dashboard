define([], (crossfilter,d3) ->

    ($settings) ->
        CrossfilterService = ($rootScope, $settings) ->

            $rootScope.$on('$stateChangeStart', (event, toState, toParams, fromState, fromParams) -> console.log(toParams); return )
            $rootScope.$on('$locationChangeSuccess', (event,to,from) -> console.log(a); console.log(b);console.log(c); console.log(d))
            store = {}

            return  {

            store: (key, data) -> store[key] = data;  return
            load: (key)-> return store[key]

            }

        return ['$rootScope', $settings, CrossfilterService ]
)
