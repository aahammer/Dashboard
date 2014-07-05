// Generated by CoffeeScript 1.7.1
(function() {
  define(['crossfilter', 'd3'], function(crossfilter, d3) {
    return function($settings) {
      var DataService;
      DataService = function($rootScope, $settings) {
        var data, dataPoint, dimensions, hello, i, resetFilters, setupData, state;
        console.log("asgd hfj");
        state = {
          selection: 'speciality',
          item: null,
          module: null,
          question: null,
          measure: 'average'
        };
        data = {};
        dataPoint = {};
        hello = function() {
          return "world";
        };
        setupData = function() {
          d3.csv("data/data.csv", function(error, data) {
            return data.forEach(function(d, i) {
              d.total = +d.total;
              d.date = Date.parse(d.date);
              d.return_total = +d.return_total;
              d.return_rate = +d.return_rate;
              d.average = +d.average;
              d.top = +d.top;
              return d.nps = +d.nps;
            });
          });
          return crossfilter(data);
        };
        data = setupData();
        dimensions = {};
        dimensions['item'] = data.dimension(function(d) {
          return d.item;
        });
        dimensions['module'] = data.dimension(function(d) {
          return d.module;
        });
        dimensions['question'] = data.dimension(function(d) {
          return d.question;
        });
        dimensions['date'] = data.dimension(function(d) {
          return d.date;
        });
        resetFilters = function() {
          var dim, _i, _len;
          for (_i = 0, _len = dimensions.length; _i < _len; _i++) {
            dim = dimensions[_i];
            dim.filterAll();
          }
        };
        dataPoint['selections'] = [
          {
            name: "Speciality"
          }, {
            name: "Station"
          }
        ];
        dataPoint['items'] = [
          {
            id: "Surgery",
            total: 50
          }, {
            id: "Pediatric",
            total: 43
          }, {
            id: "Psychology",
            total: 27
          }
        ];
        dataPoint['modules'] = [
          {
            name: "Organisation"
          }, {
            name: "Treatment"
          }, {
            name: "Service"
          }
        ];
        dataPoint['measures'] = [
          {
            id: 'average',
            name: "Average"
          }, {
            id: 'top',
            name: "Topscore"
          }, {
            id: 'nps',
            name: "NPS"
          }
        ];
        i = 0;
        return {
          provideData: function(query) {
            console.log(query);
            if (i === 1) {
              dataPoint['selections'] = [
                {
                  name: "Hello"
                }, {
                  name: "Fuckin"
                }, {
                  name: "Change"
                }
              ];
            }
            if (i === 2) {
              dataPoint['selections'] = [
                {
                  name: "How"
                }, {
                  name: "you"
                }, {
                  name: "Speciality"
                }
              ];
            }
            return i = i + 1;

            /*
            
            for k,v of ages
            console.log k + " is " + v
            
            if query.from then
                reload File if not already set
            
            for k,v in query.where
                dimensions[k].filterAll()
                if v != '*' then dimensions[k].filter(v)
            
            for k in query.select
                data[k] = dimensions[?].top(Infinity)
            
             * set filters
            for k,v in selection.iteritems()
                dimensions[k].filterAll()
                if v != '*' then dimensions[k].filter(v)
            
            for k,v in selection.iteritems()
                 *data[k] = dimensions[?].filter.all()
                console.log(k)
             *selection.forEach( (d,i) -> console.log(d); connsole.log(i) )
             */
          },
          changeSelection: function(selection) {},
          changeItem: function(item) {
            dimensions['item'].filterAll();
            dimensions['item'].filter(item);
          },
          changeModule: function(module) {
            dimensions['module'].filterAll();
            dimensions['module'].filter(module);
          },
          changeMeasure: function(measure) {
            dimensions['measure'].filterAll();
            dimensions['measure'].filter(measure);
          },
          changeQuestion: function(question) {
            dimensions['question'].filterAll();
            dimensions['question'].filter(question);
          },
          dataPoint: dataPoint

          /*
          selections: [{name: "Speciality"},{name: "Station"}]
          items: [ { id: "Surgery", total: 50 },
                   { id: "Pediatric", total: 43},
                   { id: "Psychology", total: 27}
               ]
          modules: [{name: "Organisation"},{name: "Treatment"},{name: "Service"}]
          questions: ''
          measures:[{id:'average', name: "Average"},{id:'top', name: "Topscore"},{id:'nps', name: "NPS"}]
          history: ''
           */
        };
      };
      return ['$rootScope', $settings, DataService];
    };
  });

}).call(this);

//# sourceMappingURL=DataService.map