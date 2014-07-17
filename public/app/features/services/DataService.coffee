define(['crossfilter','d3'], (crossfilter,d3) ->


    ($settings) ->
        DataService = ($rootScope, $q, $settings) ->


            ### INIT VARIABLES ###
            state = {}
            data = {}
            dimensions = {}
            dataPoint = {}


            ### TODO Remove Startup Code dependencies ###
            dataPoint['selections'] = [{key: "Speciality"},{key: "Station"}]
            dataPoint['items'] = [ { id: "Surgery", total: 50 },
                { id: "Pediatric", total: 43},
                { id: "Psychology", total: 27}
            ]
            dataPoint['modules'] = [{key: "Organisation_"},{key: "Treatment_"},{key: "Service_"}]
            dataPoint['measures'] = [{key:'average', name: "Average"},{key:'top', name: "Topscore"},{key:'nps', name: "NPS"}]

            ### Support Functions ###
            #
            # Query Syntax currently supports select, from, where, into directives
            # + special syntax for rollup and optional settings like durable filters

            where = (where) ->

                for key, value of where
                    dimensions[key].filterAll()
                    dimensions[key].filter(value)
                    return

            select = (select, rollup) ->
                    result = []
                    if rollup? and rollup = 'count'
                        result =dimensions[select].group().reduceCount().all()
                    else
                        result = dimensions[select].filterAll().all()
                    return result

            into = (into, result) ->
                console.log(into)
                console.log(result)
                dataPoint[into] = result
                return

            optional = (optional) ->
                if optional.resetFilters? and optional.resetFilters
                    resetFilters()
                    return

            # Todo make this code more generic
            loadData = (source, deferred) ->

                d3.csv("data/"+source+".csv", (error, file) ->


                    file.forEach((d, i) ->
                        d.total = +d.total;
                        d.date = Date.parse(d.date)
                        d.return_total = +d.return_total;
                        d.return_rate = +d.return_rate;
                        d.average = +d.average;
                        d.top = +d.top;
                        d.nps = +d.nps;
                    )

                    crossfilter_data = crossfilter(file)

                    dimensions['item']        = crossfilter_data.dimension( (d) ->  d.item )
                    dimensions['module']      = crossfilter_data.dimension( (d) ->  d.module )
                    dimensions['question']    = crossfilter_data.dimension( (d) ->  d.question )
                    dimensions['date']        = crossfilter_data.dimension( (d) ->  d.date )

                    state.from = source

                    deferred.resolve(crossfilter_data)
                    #deferred.reject()
                )

            resetFilters = () -> dim.filterAll() for dim in dimensions; return
            #
            ######

            ### GLOBAL INTERFACE ###
            #
            return  {

                dataPoint: dataPoint

                provideData: (query) ->

                    deferred = $q.defer()

                    if query.from? and query.from != state.from
                       loadData(query.from, deferred)
                    else deferred.resolve()

                    deferred.promise.then(() ->

                        if query.where? then where(query.where)
                        result = []
                        if query.select?
                            if query.rollup? then result = select(query.select, query.rollup)
                            else  result = select(query.select)
                        if query.into? then into(query.into, result)
                        if query.optional? then optional(query.optional)
                        return

                    )
                    return

            }
            #
            ######

        return [ '$rootScope', '$q', $settings, DataService ]
)