define(['angular', 'services/StorageService', 'services/StateManagementService', 'services/DataService', 'controllers/TabListController', 'controllers/TabListController', 'controllers/TabListController', 'controllers/TabelListController', 'angular-ui-router', 'angular-ng-grid']
    (angular, StorageService, StateManagementService, DataService, SelectionController, ModuleController, MeasureController, ItemTableController) ->

        app = angular.module('Dashboard', ['ui.router','ngGrid'])

        app.constant('DataSettings', {hello:"world"})
            .constant('Dummy', {hello:"world"})
            .constant('SelectionSettings',
                id: 'selections'
                ui:
                    nav_type:'nav-tabs'
            )
            .constant('ModuleSettings',
                id:'modules'
                ui:
                    nav_type:'nav-tabs'
            )
            .constant('MeasureSettings',
                id: 'measures'
                ui:
                    nav_type:'nav-pills'

            )
            .constant('ItemTableSettings',
                id: 'items'
            )

        app.factory('DataService', DataService('DataSettings'))
           .factory('StateManagementService', StateManagementService('Dummy'))
           .factory('StorageService', StorageService('StateSettings'))
        #app.factory('DataService', ['$http' , ($http) -> return {name:"asg"}])

        app.controller( 'SelectionController', SelectionController('SelectionSettings'))
            .controller( 'ModuleController', ModuleController('ModuleSettings'))
            .controller( 'MeasureController', MeasureController('MeasureSettings'))
            .controller( 'ItemTableController', ItemTableController('ItemTableSettings'))
            .controller( 'Dummy',['StateManagementService', (StateManagementService) -> return])



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
                            controller: 'SelectionController'
                        'itemTable':
                            templateUrl: 'views/TableListView.html'
                            controller: 'ItemTableController'
                        'module':
                            templateUrl: 'views/TabListView.html'
                            controller: 'ModuleController'
                        'question':
                            templateUrl: 'views/default.html'
                        'light':
                            templateUrl: 'views/default.html'
                        'barchart':
                            templateUrl: 'views/ChartView.html'
                        'measure':
                            templateUrl: 'views/TabListView.html'
                            controller: 'MeasureController'
                        'linechart':
                            templateUrl: 'views/default.html'
                    reloadOnSearch: false
                )

                return
            ])


        return app

)