require.config
  paths :
    jquery : "assets/javascript/jquery"
    angular : "assets/javascript/angular"
    "angular-ui-router": "assets/javascript/angular-ui-router"
    "angular-resource" : "assets/javascript/angular-resource"
    "angular-ng-grid" : "assets/javascript/ng-grid"
    crossfilter: "assets/javascript/crossfilter"
    d3 : "assets/javascript/d3"

  shim :
    angular :
        deps: ['jquery']
        exports: 'angular'
    "angular-ui-router":
        deps: ['angular']
    "angular-resource":
        deps: ['angular']
    "angular-ng-grid":
        deps: ['angular']
    crossfilter:
        exports: 'crossfilter'


require([
  'angular',
  './app',
  'assets/javascript/domReady',
  ],


  (angular,app,domReady) ->

    domReady( ->
            injector = angular.bootstrap(document, ['Dashboard'])
            injector.get('StateManagementService').broadcastInitialState()
            return
        )


    return
)

#   jquery : "//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min"
#    angular :  "//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min"
#    d3 : "//cdnjs.cloudflare.com/ajax/libs/d3/3.4.5/d3.min"


