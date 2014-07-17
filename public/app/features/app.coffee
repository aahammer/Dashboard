define(['angular',
        'services/StorageService',
        'services/StateManagementService',
        'services/DataService',
        #'services/RenderService',
        'controllers/TabController',
        'controllers/TabController',
        'controllers/TabController',
        'controllers/TableController',
        'controllers/QuestionsController',
        'controllers/QuestionByItemController',
        'controllers/QuestionOverTimeController',
        'angular-ui-router',
        'angular-ng-grid']
    (angular,
     StorageService,
     StateManagementService,
     DataService,
     #RenderService,
     SelectionController,
     ModuleController,
     MeasureController,
     ItemTableController,
     QuestionsController,
     QuestionByItemController,
     QuestionOverTimeController) ->

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
            .constant('QuestionsSettings',
                id: 'questions'
            )
            .constant('QuestionByItemSettings',
                id: 'questionByItem'
            )

        app.factory('DataService', DataService('DataSettings'))
           .factory('StateManagementService', StateManagementService('Dummy'))
           .factory('StorageService', StorageService('StateSettings'))
        #.factory('RenderService', RenderService('Dummy'))
        #.factory('RenderService', RenderService('Dummy'))
        #app.factory('DataService', ['$http' , ($http) -> return {name:"asg"}])

        app.controller( 'SelectionController', SelectionController('SelectionSettings'))
            .controller( 'ModuleController', ModuleController('ModuleSettings'))
            .controller( 'MeasureController', MeasureController('MeasureSettings'))
            .controller( 'ItemTableController', ItemTableController('ItemTableSettings'))
            .controller( 'Dummy',['StateManagementService', (StateManagementService) -> return])
            .controller( 'QuestionsController', QuestionsController('QuestionsSettings'))
            .controller( 'QuestionByItemController', QuestionByItemController('QuestionByItemSettings'))
            .controller( 'QuestionOverTimeController', QuestionOverTimeController('QuestionsSettings'))

        app.config(['$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider) ->

                # /contacts?myParam1=value1&myParam2=wowcool"

                #$urlRouterProvider.otherwise("/")

                # TODO: redirect unmatched urls to base state with url: /selection/
                # TODO: Feature -> Map full qualified URLs (/selection/item/module/measure/question) to a prefilled page

                $stateProvider.state('base',
                    url: '/{view}/{selection}'
                    views:
                        'selection':
                            templateUrl: 'views/TabView.html'
                            controller: 'SelectionController'
                        'itemTable':
                            templateUrl: 'views/TableView.html'
                            controller: 'ItemTableController'
                        'module':
                            templateUrl: 'views/TabView.html'
                            controller: 'ModuleController'
                        #'question':
                        #    templateUrl: 'views/default.html'
                        #'light':
                        #    templateUrl: 'views/default.html'
                        'questions':
                            templateUrl: 'views/ChartView.html'
                            controller: 'QuestionsController'
                        'measure':
                            templateUrl: 'views/TabView.html'
                            controller: 'MeasureController'
                        'questionByItem':
                            templateUrl: 'views/ChartView.html'
                            controller: 'QuestionByItemController'
                        'questionOverTime':
                            templateUrl: 'views/ChartView.html'
                            controller: 'QuestionOverTimeController'
                    reloadOnSearch: false
                )

                return
            ])


        return app

)