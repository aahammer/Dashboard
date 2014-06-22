define(['crossfilter','d3','jquery'], (crossfilter,d3,$) ->


    ($settings) ->
        DataService = ($rootScope, $settings) ->


            ### INIT VARIABLES ###
            state = {}
            data = {}
            dimensions = {}
            dataPoint = {}



            ### TODO Remove Startup Code dependencies ###

            dataPoint['selections'] = [{key: "Speciality"},{key: "Station"}]
            dataPoint['measures'] = [{key:'AVERAGE', name: "Average"},{key:'TOP', name: "Topscore"},{key:'NPS', name: "NPS"}]

            ###
            dataPoint['items'] = [ { id: "Surgery", total: 50 },
                { id: "Pediatric", total: 43},
                { id: "Psychology", total: 27}
            ]
            dataPoint['modules'] = [{key: "Organisation_"},{key: "Treatment_"},{key: "Service_"}]

            ###
            ### Support Functions ###
            #
            # Query Syntax currently supports select, from, where, into directives
            # + special syntax for rollup and optional settings like durable filters

            where = (where) ->
                for key, value of where
                    #console.log('-----> '+key)
                    dimensions[key].filter(value)
                return

            select = (select, rollup) ->
                    if rollup? and rollup = 'count'
                        dimensions[select].group().reduceCount().all()
                    else
                        dimensions[select].filterAll().all()

            into = (into, result) ->

                newResult = []
                newResult.push(jQuery.extend(true, {}, oldObject)) for oldObject in result
                #var newObject = jQuery.extend({}, oldObject);
                #var newObject = jQuery.extend(true, {}, oldObject);
                dataPoint[into] = newResult
                #console.log("INTO " +into + ":")
                #console.log(dataPoint[into])
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

                loadData: loadData

                provideData: (query) ->

                    console.log("providing data for ")
                    console.log(query)

                    if query.where? then where(query.where)
                    result = []
                    if query.select?
                        if query.rollup? then result = select(query.select, query.rollup)
                        else  result = select(query.select)
                    if query.into? then into(query.into, result)
                    resetFilters()

                    return




            }
            #
            ######

        return [ '$rootScope',  $settings, DataService ]
)