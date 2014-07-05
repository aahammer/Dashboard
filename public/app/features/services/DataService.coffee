define(['crossfilter','d3'], (crossfilter,d3) ->

    ($settings) ->
        DataService = ($rootScope, $settings) ->

            console.log("asgd hfj")


            state = {   selection: 'speciality', item: null, module: null,  question: null, measure: 'average' }


            data = {}
            dataPoint = {}
            hello = () -> "world"
            setupData = () ->
                d3.csv("data/data.csv", (error, data) ->


                        data.forEach((d, i) ->
                            d.total = +d.total;
                            d.date = Date.parse(d.date)
                            d.return_total = +d.return_total;
                            d.return_rate = +d.return_rate;
                            d.average = +d.average;
                            d.top = +d.top;
                            d.nps = +d.nps;
                        )
                )
                return crossfilter(data)

            data = setupData();

            dimensions = {}
            dimensions['item']        = data.dimension( (d) ->  d.item )
            dimensions['module']      = data.dimension( (d) ->  d.module )
            dimensions['question']    = data.dimension( (d) ->  d.question )
            dimensions['date']        = data.dimension( (d) ->  d.date )

            resetFilters = () -> dim.filterAll() for dim in dimensions; return

            dataPoint['selections'] = [{name: "Speciality"},{name: "Station"}]
            dataPoint['items'] = [ { id: "Surgery", total: 50 },
                { id: "Pediatric", total: 43},
                { id: "Psychology", total: 27}
            ]
            dataPoint['modules'] = [{name: "Organisation"},{name: "Treatment"},{name: "Service"}]
            dataPoint['measures'] = [{id:'average', name: "Average"},{id:'top', name: "Topscore"},{id:'nps', name: "NPS"}]

            # dynamically create data providers
            # ask for external filter criteria for dimensions and put new data into data items
            # need to know where i get columnheaders from

            i =0
            return  {
                # Todo Option auf vergessen
                provideData: (query ) ->

                    # filter as told and put data into data sinks
                    # {select:, from:, where:, order: group
                    # -> where = list of filters for dimensions
                    # -> select = datasinks (e.g. selection, items, question, history, etc. )
                    # -> from = file
                    console.log(query)
                    if i == 1 then dataPoint['selections'] = [{name: "Hello"},{name: "Fuckin"},{name: "Change"}]

                    if i == 2 then dataPoint['selections'] = [{name: "How"},{name: "you"},{name: "Speciality"}]

                    i = i+1
                    # Todo Iterate over selection
                    ###

                    for k,v of ages
                    console.log k + " is " + v

                    if query.from then
                        reload File if not already set

                    for k,v in query.where
                        dimensions[k].filterAll()
                        if v != '*' then dimensions[k].filter(v)

                    for k in query.select
                        data[k] = dimensions[?].top(Infinity)

                    # set filters
                    for k,v in selection.iteritems()
                        dimensions[k].filterAll()
                        if v != '*' then dimensions[k].filter(v)

                    for k,v in selection.iteritems()
                        #data[k] = dimensions[?].filter.all()
                        console.log(k)
                    #selection.forEach( (d,i) -> console.log(d); connsole.log(i) )
                    ###

                changeSelection: (selection) -> return #load different dataset
                changeItem: (item) ->
                    dimensions['item'].filterAll()
                    dimensions['item'].filter(item)
                    return
                changeModule: (module) ->
                    dimensions['module'].filterAll()
                    dimensions['module'].filter(module)
                    return
                changeMeasure: (measure) ->
                    dimensions['measure'].filterAll()
                    dimensions['measure'].filter(measure)
                    return
                changeQuestion: (question) ->
                    dimensions['question'].filterAll()
                    dimensions['question'].filter(question)
                    return

                dataPoint: dataPoint
                ###
                selections: [{name: "Speciality"},{name: "Station"}]
                items: [ { id: "Surgery", total: 50 },
                         { id: "Pediatric", total: 43},
                         { id: "Psychology", total: 27}
                     ]
                modules: [{name: "Organisation"},{name: "Treatment"},{name: "Service"}]
                questions: ''
                measures:[{id:'average', name: "Average"},{id:'top', name: "Topscore"},{id:'nps', name: "NPS"}]
                history: ''

                ###
            }

        return [ '$rootScope', $settings, DataService ]
)