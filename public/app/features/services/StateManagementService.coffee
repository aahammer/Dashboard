define([], () ->

    ($settings) ->

        StateManagementService = ($rootScope, $settings, DataService) ->



            ### Handle wrong URLS ###

            ### INIT Application ###
            urlParser = document.createElement('a');

            initApplication = () ->

                query_item =
                    select: 'item'
                    rollup: 'count'
                    from: 'speciality'
                    where:
                        date: Date.parse('2014-05-01')
                    into: 'items'
                    optional:
                        keepFilter: true
                query_module =
                    select: 'module'
                    rollup: 'count'
                    from: 'speciality'
                #where:
                #    date: Date.parse('2014-05-01')
                    into: 'modules'
                    optional:
                        keepFilter: false
                query_question =
                    select: 'question'
                    from: 'speciality'
                    where:
                        item: 'surgery'
                        module: 'organisation'
                #    date: Date.parse('2014-05-01')
                    into: 'questions'
                    optional:
                        keepFilter: false

                DataService.provideData(query_item)
                DataService.provideData(query_module)
                DataService.provideData(query_question)

                return

            initApplication()
            ######

            ### RUNTIME ###
            #
            $rootScope.$on('$locationChangeSuccess', (event, now, last) ->

                urlParser.href = now;

                console.log(now)

                urlParts = /#\/(\w*)\/(\w*)/g.exec(urlParser.hash)

                switch ( if urlParts[1]? then urlParts[1] else 'error')
                    when 'selections' then console.log('selections'); return
                    when 'items' then console.log('items'); return
                    when 'modules' then console.log('modules');return
                    when 'measures' then console.log('measures');return
                    when 'questions' then console.log('questions');return
                    else console.log('error in url part 1')


                return
            )
            #
            ######


            ### GLOBAL INTERFACE ###
            return {}


        return ['$rootScope', $settings, 'DataService', StateManagementService ]
)
