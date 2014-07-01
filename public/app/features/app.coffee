define(['angular', 'services/StateManagementService', 'services/CrossfilterService', 'controllers/TabListController', 'controllers/TabListController', 'controllers/TabListController', 'controllers/TabelListController', 'angular-ui-router', 'angular-ng-grid']
    (angular, StateService, DataService, SelectionCtrl, ModuleCtrl, MeasureCtrl, ItemTableCtrl) ->

        app = angular.module('Dashboard', ['ui.router','ngGrid'])

        app.constant('DataSettings', {hello:"world"})
            .constant('StateSettings', {hello:"world"})
            .constant('SelectionSettings',
                data: 'selections'
                ui:
                    nav_type:'nav-tabs'
            )
            .constant('ModuleSettings',
                data:'modules'
                ui:
                    nav_type:'nav-tabs'
            )
            .constant('MeasureSettings',
                data: 'measures'
                ui:
                    nav_type:'nav-pills'

            )
            .constant('ItemTableSettings',
                data: 'items'
            )

        app.factory('DataService', DataService('DataSettings'))
           .factory('StateService', StateService('StateSettings'))
        #app.factory('DataService', ['$http' , ($http) -> return {name:"asg"}])

        app.controller( 'SelectionCtrl', SelectionCtrl('SelectionSettings'))
            .controller( 'ModuleCtrl', ModuleCtrl('ModuleSettings'))
            .controller( 'MeasureCtrl', MeasureCtrl('MeasureSettings'))
            .controller( 'ItemTableCtrl', ItemTableCtrl('ItemTableSettings'))



        app.config(['$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider) ->

                # /contacts?myParam1=value1&myParam2=wowcool"

                #$urlRouterProvider.otherwise("/")

                # TODO: redirect unmatched urls to base state with url: /selection/
                # TODO: Feature -> Map full qualified URLs (/selection/item/module/measure/question) to a prefilled page

                $stateProvider.state('base',
                    url: '/{view}/{selection}'
                    views:
                        'selection':
                            templateUrl: 'views/TabListView.html'
                            controller: 'SelectionCtrl'
                        'itemTable':
                            templateUrl: 'views/TableListView.html'
                            controller: 'ItemTableCtrl'
                        'module':
                            templateUrl: 'views/TabListView.html'
                            controller: 'ModuleCtrl'
                        'question':
                            templateUrl: 'views/default.html'
                        'light':
                            templateUrl: 'views/default.html'
                        'barchart':
                            templateUrl: 'views/default.html'
                        'measure':
                            templateUrl: 'views/TabListView.html'
                            controller: 'MeasureCtrl'
                        'linechart':
                            templateUrl: 'views/default.html'
                    reloadOnSearch: false
                )


                ###
                $stateProvider.state('home',
                    url: '/{selection}/{item}/{module}/{measure}/{question}/'
                    views:
                        'selection':
                            templateUrl: 'views/TabListView.html'
                            controller: 'SelectionCtrl'
                        'itemTable':
                            templateUrl: 'views/TableListView.html'
                            controller: 'ItemTableCtrl'
                        'module':
                            templateUrl: 'views/TabListView.html'
                            controller: 'ModuleCtrl'
                        'question':
                            templateUrl: 'views/default.html'
                        'light':
                            templateUrl: 'views/default.html'
                        'barchart':
                            templateUrl: 'views/default.html'
                        'measure':
                            templateUrl: 'views/TabListView.html'
                            controller: 'MeasureCtrl'
                        'linechart':
                            templateUrl: 'views/default.html'
                )
                ###
                return
            ])


        return app
        ###
        a



                .controller( "SelectionCtrl", SelectionCtrl("SelectionSettings"))
                .controller( "ModuleCtrl", ModuleCtrl("ModuleSettings"))
                .controller( "MeasureCtrl", MeasureCtrl("MeasureSettings"))
                .service('CrossfilterService', [ "$scope", () -> query:()->"Hello World" ])
                .controller( 'TableListCtrl',  ['$scope','CrossfilterService', ($scope, CrossfilterService) ->
                                                    $scope.data = CrossfilterService.query()
                                                    return
                            ])

                #.controller( "TableListCtrl", TableListCtrl)
                .config(['$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider) ->
                        $urlRouterProvider.otherwise("/")
                        $stateProvider.state('/',
                            url: '/'
                            views:
                                'selection_level_1':
                                    templateUrl: 'TabList/TabListView.html'
                                    controller: 'SelectionCtrl'
                                'selection_level_2':
                                    templateUrl: 'TableList/TableListView.html'
                                    controller: 'TableListCtrl'
                                'module':
                                    templateUrl: 'TabList/TabListView.html'
                                    controller: 'ModuleCtrl'
                                'question':
                                    templateUrl: 'views/default.html'
                                'light':
                                    templateUrl: 'views/default.html'
                                'barchart':
                                    templateUrl: 'views/default.html'
                                'measure':
                                    templateUrl: 'TabList/TabListView.html'
                                    controller: 'MeasureCtrl'
                                'linechart':
                                    templateUrl: 'views/default.html'
                        )
                        return
                ])

        return app
        ###
)
###
define(['angular', 'Crossfilter/CrossfilterService', 'TableList/TableListModule', 'TabList/TabListModule', 'TabList/TabListModule', 'TabList/TabListModule' ,'angular-ui-router'],
  (angular, CrossfilterService, TableListModule, SelectionTabList, ModuleTabList, MeasureTabList ) ->
    SelectionTabList('SelectionTabList',
          nav_type:'nav-tabs'
          data:[{name: "Speciality"},{name: "Station"}])
    ModuleTabList('ModuleTabList',
          nav_type:'nav-tabs'
          data:[{name: "Organisation"},{name: "Treatment"},{name: "Service"}] )
    MeasureTabList('MeasureTabList',
          nav_type:'nav-pills'
          data:[{name: "Average"},{name: "Topscore"},{name: "NPS"}] )


    app = angular.module('Dashboard', ['ui.router', TableListModule, 'SelectionTabList','ModuleTabList', 'MeasureTabList'])
    app.constant('DataSettings', key:'value' )
    app.service( 'DataService', CrossfilterService('DataSettings'))
    return app
)
###
###
  .run(
              ['$rootScope', '$state', '$stateParams',
              ($rootScope,   $state,   $stateParams) ->

                $rootScope.$state = $state;
                $rootScope.$stateParams = $stateParams;
])


angular.module("myApp", ["ui.router"]).config(function($stateProvider){
$stateProvider.state(stateName, stateConfig);
})


###