define([], () ->

    () ->

        Controller = ( $scope, StateManagementService ) ->

            $scope.state = {}

            $scope.$watch(  (() -> StateManagementService.state ),
                ((current, last) ->

                    $scope.state = StateManagementService.state
                    return
                ), true )

            return

        return ['$scope', 'StateManagementService', Controller ]
)