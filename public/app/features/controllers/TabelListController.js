// Generated by CoffeeScript 1.7.1
(function() {
  define([], function() {
    return function($settings) {
      var TabelListCtrl;
      TabelListCtrl = function($scope, $settings, DataService) {
        $scope.data = $settings.data;
        $scope.table = DataService[$scope.data];
        $scope.gridOptions = {
          data: 'table'
        };

        /*
            OnReload,
                if content changed -> load
                1. display old data
                2 transition to new data
         */

        /* Store here information about old state , if changed !
        $scope.$watch(  (() -> DataService[$scope.data]),
            ((newVal, oldVal) ->
            $scope.table = DataService[$scope.data]
            return
        ), true )
         */
      };
      return ["$scope", $settings, 'DataService', TabelListCtrl];
    };
  });

}).call(this);

//# sourceMappingURL=TabelListController.map
