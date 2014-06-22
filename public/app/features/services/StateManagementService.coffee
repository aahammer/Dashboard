define([], () ->

    ($settings) ->

        StateManagementService = ($rootScope, $q, $location, $settings,  DataService) ->


            state =
                selection: 'speciality'
                item: null
                module: null
                measure: null
                question: null
                date: Date.parse('2014-05-01')


            ### Handle wrong URLS ###

            ### INIT Application ###
            urlParser = document.createElement('a');

            queries = {}

            initApplication = () ->

                deferred = $q.defer()
                DataService.loadData(state.selection, deferred)

                deferred.promise.then(() ->


                    queries['items_distinct'] =
                        select: 'item'
                        rollup: 'count'
                        from: 'speciality'
                        into: 'items_distinct'
                    DataService.provideData(queries['items_distinct'])
                    state.item = DataService.dataPoint['items_distinct'][0].key

                    queries['modules'] =
                        select: 'module'
                        rollup: 'count'
                        from: 'speciality'
                        into: 'modules'
                    DataService.provideData(queries['modules'])
                    state.module = DataService.dataPoint['modules'][0].key


                    queries['questions_distinct'] =
                        select: 'question'
                        rollup: 'count'
                        from: 'speciality'
                        where:
                            item: state.item
                            module: state.module
                        into: 'questions_distinct'
                    DataService.provideData(queries['questions_distinct'])
                    state.question = DataService.dataPoint['questions_distinct'][0].key

                    for question in DataService.dataPoint['questions_distinct']
                        if question.value != 0
                            state.question = question.key
                            break


                    state.measure = DataService.dataPoint['measures'][0].key


                    console.log(DataService.dataPoint['questions_distinct'][1].value)

                    queries['questions_all'] =
                        select: 'question'
                        from: 'speciality'
                        where:
                            item: state.item
                            module: state.module
                            date: state.date
                        into: 'questions_all'
                    DataService.provideData(queries['questions_all'])

                    console.log(DataService.dataPoint['questions_distinct'][1].value)

                    queries['question_history'] =
                        select: 'date'
                        from: 'speciality'
                        where:
                            item: state.item
                            module: state.module
                            question: state.question
                        into: 'question_history'
                    DataService.provideData(queries['question_history'])

                    console.log(DataService.dataPoint['questions_distinct'][1].value)

                    queries['datum_distinct'] =
                        select: 'date'
                        rollup: 'count'
                        from: 'speciality'
                        into: 'datum_distinct'
                    DataService.provideData(queries['datum_distinct'])


                    queries['questionByItem'] =
                        select: 'item'
                        from: 'speciality'
                        where:
                            question: state.question
                            module: state.module
                            date: state.date
                        into: 'questionByItem'
                    DataService.provideData(queries['questionByItem'])



                    return
                )
                return

            initApplication()
            ######

            ### RUNTIME ###
            #
            visit = 0;
            $rootScope.$on('$locationChangeStart', (event, now, last) ->

                # TODO check for valid urls by data content
                if visit == 0
                    $location.path('/selections/Speciality')
                    visit = 1
                return
            )
            $rootScope.$on('$locationChangeSuccess', (event, now, last) ->



                urlParser.href = now;

                urlParts = /#\/(\w*)\/(.*)/g.exec(urlParser.hash)

                switch ( if urlParts[1]? then urlParts[1] else 'error')
                    when 'selections' then  return
                    when 'items'
                        state.item = urlParts[2]

                        queries['questions_all'].where =
                                                item: state.item
                                                module: state.module
                                                date: state.date
                        DataService.provideData(queries['questions_all'])


                        queries['question_history'].where =
                                item: state.item
                                module: state.module
                                question: state.question
                        DataService.provideData(queries['question_history'])

                        #state.question = state.question


                    when 'modules'
                        state.module = urlParts[2]

                        queries['questions_distinct'].where =
                                                              item: state.item
                                                              module: state.module

                        DataService.provideData(queries['questions_distinct'])

                        for question in DataService.dataPoint['questions_distinct']
                            if question.value != 0
                                state.question = question.key
                                break

                        queries['questions_all'].where =
                                                         item: state.item
                                                         module: state.module
                                                         date: state.date
                        DataService.provideData(queries['questions_all'])

                        queries['question_history'].where =
                                        item: state.item
                                        module: state.module
                                        question: state.question
                        DataService.provideData(queries['question_history'])

                        queries['questionByItem'].where =
                            question: state.question
                            module: state.module
                            date: state.date
                        into: 'questionByItem'
                        DataService.provideData(queries['questionByItem'])

                        # unselect all questions
                        #state.question  = null

                        return

                    when 'measures'
                        state.measure = urlParts[2]

                    when 'questions'
                        state.question = decodeURI(urlParts[2])


                        queries['question_history'].where =
                                                        item: state.item
                                                        module: state.module
                                                        question: state.question
                        DataService.provideData(queries['question_history'])


                        queries['questionByItem'].where =
                                                question: state.question
                                                module: state.module
                                                date: state.date
                        into: 'questionByItem'
                        DataService.provideData(queries['questionByItem'])


                    when 'questionByItem'
                        state.item = urlParts[2]

                    else console.log('error in url part 1')


                return
            )
            #
            ######

            broadcastInitialState = () ->
                console.log("broadcasting")
                state.item = "SDGSG"
                #tmp = state.item
                #state.item = ''
                #state.item = tmp

                #DataService.dataPoint['moByItem'] = DataService.dataPoint['questionByItem']
                #state.measure = state.measure
                #state.item = state.item


            ### GLOBAL INTERFACE ###
            return {
                broadcastInitialState:broadcastInitialState
                state: state
            }


        return ['$rootScope', '$q', '$location', $settings, 'DataService', StateManagementService ]
)
