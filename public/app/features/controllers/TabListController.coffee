define([], () ->
    ($settings) ->
        TabListController = ($scope, $stateParams, $settings, StateService, DataService) ->
            $scope.data = $settings.data

            console.log("hallo welt")
            if angular.isUndefined(StateService.load($scope.data))
                $scope.selected = DataService[$scope.data][0].name
            else $scope.selected = StateService.load($scope.data).selected

            $scope.nav_type= $settings.ui.nav_type

            $scope.select = (selected) ->
                    #$scope.selected = selected
                    StateService.store($scope.data, {selected:selected})

            # Do not need watch, cause this shit gets resetet by ui-router everytime anyways.
            $scope.$watch(  (() -> DataService[$scope.data]),
                ((newVal, oldVal) ->

                    $scope.tabs = newVal
                    return
                ),
                true
            )
            #

            return
        return [ "$scope", '$stateParams' , $settings, 'StateService','DataService', TabListController ]

)
###
() -> return DataService[data],  (newVal, oldVal) -> console.log(newVal); console.log(oldVal) , true)

$scope.$watch(function () {
return myService.tags;
},
function(newVal, oldVal) {
alert("Inside watch");
console.log(newVal);
console.log(oldVal);
},
true);

###