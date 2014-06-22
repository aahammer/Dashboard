// Generated by CoffeeScript 1.7.1
(function() {
  define(['crossfilter', 'd3'], function(crossfilter, d3) {
    return function($settings) {
      var DataService;
      DataService = function($rootScope, $settings) {

        /* INIT VARIABLES */
        var data, dataPoint, dimensions, into, loadData, resetFilters, select, state, where;
        state = {};
        data = {};
        dimensions = {};
        dataPoint = {};

        /* TODO Remove Startup Code dependencies */
        dataPoint['selections'] = [
          {
            key: "Speciality"
          }, {
            key: "Station"
          }
        ];
        dataPoint['measures'] = [
          {
            key: 'AVERAGE',
            name: "Average"
          }, {
            key: 'TOP',
            name: "Topscore"
          }, {
            key: 'NPS',
            name: "NPS"
          }
        ];

        /*
        dataPoint['items'] = [ { id: "Surgery", total: 50 },
            { id: "Pediatric", total: 43},
            { id: "Psychology", total: 27}
        ]
        dataPoint['modules'] = [{key: "Organisation_"},{key: "Treatment_"},{key: "Service_"}]
         */

        /* Support Functions */
        where = function(where) {
          var key, value;
          for (key in where) {
            value = where[key];
            dimensions[key].filter(value);
          }
        };
        select = function(select, rollup) {
          var result;
          result = [];
          if ((rollup != null) && (rollup = 'count')) {
            result = dimensions[select].group().reduceCount().all();
          } else {
            result = dimensions[select].filterAll().all();
          }
          return result;
        };
        into = function(into, result) {
          dataPoint[into] = result;
        };
        loadData = function(source, deferred) {
          return d3.csv("data/" + source + ".csv", function(error, file) {
            var crossfilter_data;
            file.forEach(function(d, i) {
              d.total = +d.total;
              d.date = Date.parse(d.date);
              d.return_total = +d.return_total;
              d.return_rate = +d.return_rate;
              d.average = +d.average;
              d.top = +d.top;
              return d.nps = +d.nps;
            });
            crossfilter_data = crossfilter(file);
            dimensions['item'] = crossfilter_data.dimension(function(d) {
              return d.item;
            });
            dimensions['module'] = crossfilter_data.dimension(function(d) {
              return d.module;
            });
            dimensions['question'] = crossfilter_data.dimension(function(d) {
              return d.question;
            });
            dimensions['date'] = crossfilter_data.dimension(function(d) {
              return d.date;
            });
            state.from = source;
            return deferred.resolve(crossfilter_data);
          });
        };
        resetFilters = function() {
          var dim, _i, _len;
          for (_i = 0, _len = dimensions.length; _i < _len; _i++) {
            dim = dimensions[_i];
            dim.filterAll();
          }
        };

        /* GLOBAL INTERFACE */
        return {
          dataPoint: dataPoint,
          loadData: loadData,
          provideData: function(query) {
            var result;
            if (query.where != null) {
              where(query.where);
            }
            result = [];
            if (query.select != null) {
              if (query.rollup != null) {
                result = select(query.select, query.rollup);
              } else {
                result = select(query.select);
              }
            }
            if (query.into != null) {
              into(query.into, result);
            }
            resetFilters();
          }
        };
      };
      return ['$rootScope', $settings, DataService];
    };
  });

}).call(this);

//# sourceMappingURL=DataService.map
