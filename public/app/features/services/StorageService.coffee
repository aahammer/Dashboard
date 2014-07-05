define([], () ->

    ($settings) ->
        StorageService = ($rootScope, $settings) ->


            store = {}

            return  {

            store: (key, data) -> store[key] = data;  return
            load: (key)-> return store[key]

            }

        return ['$rootScope', $settings, StorageService ]
)



#return