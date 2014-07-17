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
                query_module =
                    select: 'module'
                    rollup: 'count'
                    from: 'speciality'
                    into: 'modules'
                query_question =
                    select: 'question'
                    rollup: 'count'
                    from: 'speciality'
                    where:
                        item: 'surgery'
                        module: 'organisation'
                    into: 'questions'
                query_question_all =
                    select: 'question'
                    from: 'speciality'
                    into: 'questions_all'

                DataService.provideData(query_item)
                DataService.provideData(query_module)
                DataService.provideData(query_question_all)
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

                    when 'modules'
                        console.log("URKL " + urlParts[2])
                        query =
                            select: 'question'
                            rollup: 'count'
                            from: 'speciality'
                            where:
                                module: urlParts[2]
                            into: 'questions_distinct'
                        DataService.provideData(query)
                        query =
                            select: 'question'
                            from: 'speciality'
                            into: 'questions_all'
                        DataService.provideData(query)

                        console.log("sagas")
                        return

                    when 'measures'
                        $rootScope['questions'].measure = urlParts[2]
                        return

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
