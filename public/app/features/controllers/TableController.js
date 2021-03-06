// Generated by CoffeeScript 1.7.1
(function() {
  define([], function() {
    return function($settings) {
      var TableController;
      TableController = function($timeout, $scope, $location, $settings, DataService, StateManagementService) {
        var position, selection;
        selection = [];
        $scope.gridOptions = {
          data: 'table',
          multiSelect: false,
          selectedItems: selection,
          headerRowHeight: 42,
          enableSorting: false,
          columnDefs: [
            {
              field: 'key',
              displayName: '',
              width: '80%'
            }, {
              field: 'value',
              displayName: 'Surveys',
              width: '20%'
            }
          ]
        };
        position = null;

        /* RUNTIME ACTIONS */
        $scope.$watch((function() {
          return selection;
        }), (function(current, last) {
          if (current.length !== 0) {
            $location.path('/items/' + current[0].key);
          }
        }), true);

        /*
        $scope.$on('$viewContentLoaded', (event) ->
        
            console.log(event.targetScope.gridOptions)
            event.targetScope.gridOptions['selectRow'](0,true)
             *console.log($rootScope.$$listeners)
             *$rootScope.$$listeners['viewContentLoaded'] = []
        )
         */
        $scope.$watch((function() {
          return StateManagementService.state.item;
        }), (function(current, last) {
          var i, item, _i, _len, _ref;
          if (!position) {
            $scope.table = DataService.dataPoint['items_distinct'];
            position = {};
            i = 0;
            _ref = DataService.dataPoint['items_distinct'];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              item = _ref[_i];
              position[item.key] = i;
              i += 1;
            }
          }
          $location.path('/items/' + current);
          $timeout((function() {
            return $scope.gridOptions.selectRow(position[current], true);
          }), 100);
        }), true);
      };
      return ['$timeout', '$scope', '$location', $settings, 'DataService', 'StateManagementService', TableController];
    };
  });

}).call(this);

//# sourceMappingURL=TableController.map
