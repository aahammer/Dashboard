define(['crossfilter','d3'], (crossfilter,d3) ->

    ($settings) ->
        CrossfilterService = ($rootScope, $settings) ->


            state = {   selection: 'speciality', item: null, module: null,  question: null, measure: 'average' }


            data = {}
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


            return  {

                tellApplicationState: (selection, item, module, question, measure) ->
                        resetFilters()
                        dimensions['item'].filter(item)
                        dimensions['module'].filter(module)
                        return
                selections: [{name: "Speciality"},{name: "Station"}]
                items: [ { id: "Surgery", total: 50 },
                         { id: "Pediatric", total: 43},
                         { id: "Psychology", total: 27}
                     ]
                modules: [{name: "Organisation"},{name: "Treatment"},{name: "Service"}]
                getQuestions: () -> return
                measures:[{id:'average', name: "Average"},{id:'top', name: "Topscore"},{id:'nps', name: "NPS"}]
                getQuestionHistory: () -> return
            }

        return [ '$rootScope', $settings, CrossfilterService ]
)

# state =  selection, item, module, question, measure
###
     d3.csv("test/data.csv", function(error, data) {
        console.log(data);

        data.forEach(function(d, i) {
            d.total = +d.total;
            d.return_total = +d.return_total;
            d.return_rate = +d.return_rate;
            d.average = +d.average;
            d.top = +d.top;
            d.nps = +d.nps;
        });

        specialty_satisfaction = crossfilter(data);

        dim_speciality   = specialty_satisfaction.dimension(function(d){return d.specialty;});
        dim_module      = specialty_satisfaction.dimension(function(d){return d.module;});
        dim_question    = specialty_satisfaction.dimension(function(d){return d.question;});
        dim_year        = specialty_satisfaction.dimension(function(d){return d.year;});
        dim_month       = specialty_satisfaction.dimension(function(d){return d.month;});

        measure_average = specialty_satisfaction.dimension(function(d){return d.average;});

        console.log(dim_speciality.group());

        dim_speciality.filter("surgery");
        dim_module.filter("organisation");
        console.log(dim_year.filter("2014").top(Infinity));

        console.log(dim_question.group().reduceSum(function(fact){return fact.average}).top(Infinity));

    });
###