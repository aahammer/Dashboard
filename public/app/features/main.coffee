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
    ###
    app.config( ['$routeProvider',
      ($routeProvider) -> $routeProvider.when('/' ,
        controller :  'taglistController'
        templateUrl:  'taglist/taglist.html'
      ).otherwise( redirectTo: '/')
    ])


    domReady(-> angular.bootstrap(document, ['showoffApp']))
    ###
    #app.run(['$state', ($state) -> $state.transitionTo('base')])

    #console.log(app)
    domReady(-> angular.bootstrap(document, ['Dashboard']))
    #domReady(-> angular.bootstrap(document, ['myUiRouter']))

    return
)

#   jquery : "//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min"
#    angular :  "//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min"
#    d3 : "//cdnjs.cloudflare.com/ajax/libs/d3/3.4.5/d3.min"


