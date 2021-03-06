// Generated by CoffeeScript 1.7.1
(function() {
  define(['d3', 'angular', 'jquery'], function(d3, angular, $) {
    return function($settings) {
      var ChartController;
      ChartController = function($rootScope, $scope, DataService, StateManagementService, $settings) {

        /* STARTUP CODE */
        var activeIndex, data, domain, frame, g, id, margin, measure, padding, panel, renderAxis, renderPanel, scale, svg, _translate;
        id = $settings.id;
        $scope.id = id;
        $rootScope[id] = {};
        margin = {
          left: 200,
          left_pct: 0.44,
          right: 20,
          top: 20,
          bottom: 20
        };
        padding = {
          left: 5,
          bottom: 5,
          top: 0,
          bottom: 0
        };
        _translate = function(x, y) {
          return 'translate(' + x + ',' + y + ')';
        };
        data = [];
        domain = [];
        measure = 'average';
        svg = d3.select("#" + id).append('svg').attr('width', '100%').attr('height', '40%');
        frame = angular.element("#" + id);
        margin.left = frame.width() * margin.left_pct;
        scale = {};
        scale['x'] = d3.scale.linear().range([0, frame.width() - margin.left - margin.right - padding.left]);
        scale['y'] = d3.scale.ordinal();
        g = {};
        g['x'] = svg.append('g').attr('transform', _translate(margin.left + padding.left, frame.height() - margin.bottom)).attr('class', 'axis');
        g['y'] = svg.append('g').attr('transform', _translate(margin.left, margin.top)).attr('class', 'axis');
        panel = svg.append('g').attr('transform', _translate(margin.left + padding.left, margin.top));
        activeIndex = null;
        renderPanel = function(value, category, redraw) {
          var category_baseline, category_extrusion, duration, value_baseline, value_extrusion;
          if ((redraw != null) && redraw) {
            panel.selectAll('.bars').data([]).exit().remove();
            duration = 0;
          } else {
            duration = 1000;
          }
          value_baseline = 'x';
          value_extrusion = 'width';
          category_baseline = 'y';
          category_extrusion = 'height';
          panel.selectAll('.bars').data(data, function(d) {
            return d[category];
          }).select('rect').attr('class', function(d) {
            if (domain[activeIndex] === d[category]) {
              StateManagementService.state.value = d[measure];
              return 'isActive';
            } else {
              return '';
            }
          }).transition().duration(duration).attr(value_baseline, function(d) {
            return scale[value_baseline](Math.min(0, d[value]));
          }).attr(value_extrusion, function(d) {
            if (Math.max(d[value], 0) === 0) {
              return scale[value_baseline](0) - scale[value_baseline](d[value]);
            } else {
              return scale[value_baseline](d[value]) - scale[value_baseline](0);
            }
          });
          panel.selectAll('.bars').data(data, function(d) {
            return d[category];
          }).enter().append('a').attr('xlink:href', function(d) {
            return '#/questions/' + d[category];
          }).attr('class', 'bars').append('rect').attr('class', function(d) {
            if (domain[activeIndex] === d[category]) {
              StateManagementService.state.value = d[measure];
              return 'isActive';
            } else {
              return '';
            }
          }).attr(value_extrusion, 0).transition().duration(duration).ease('circle').attr(value_baseline, function(d) {
            return scale[value_baseline](Math.min(0, d[value]));
          }).attr(category_baseline, function(d) {
            return scale[category_baseline](d[category]);
          }).attr(category_extrusion, Math.min(scale[category_baseline].rangeExtent()[1] / 10, 32)).attr(value_extrusion, function(d) {
            if (Math.max(d[value], 0) === 0) {
              return scale[value_baseline](0) - scale[value_baseline](d[value]);
            } else {
              return scale[value_baseline](d[value]) - scale[value_baseline](0);
            }
          });
          return panel.selectAll('.bars').data(data, function(d) {
            return d[category];
          }).exit().remove();
        };

        /* Interface */
        renderAxis = function(duration) {
          var x_axis, y_axis;
          if (duration == null) {
            duration = 0;
          }
          x_axis = d3.svg.axis().scale(scale['x']).orient('bottom');
          g['x'].transition().duration(duration).call(x_axis);
          y_axis = d3.svg.axis().scale(scale['y']).orient('left');
          return g['y'].transition().duration(duration).call(y_axis);
        };
        domain = [];

        /* RUNTIME ACTIONS */
        $scope.$watch((function() {
          return StateManagementService.state.measure;
        }), (function(current, last) {
          if (current != null) {
            measure = current;
            switch (current) {
              case 'AVERAGE':
                scale['x'].domain([0, 10]);
                break;
              case 'TOP':
                scale['x'].domain([0, 1]);
                break;
              case 'NPS':
                scale['x'].domain([-0.5, 1]);
            }
          }
          if (data.length > 0) {
            renderPanel(measure, 'question');
            renderAxis(1000);
          }
        }), true);
        $scope.$watch((function() {
          return DataService.dataPoint['questions_distinct'];
        }), (function(current, last) {
          domain = [];
          angular.forEach(current, function(d) {
            if (d.value > 0) {
              return domain.push(d.key);
            }
          });
          activeIndex = 0;
          console.log(activeIndex);
        }), true);
        $scope.$watch((function() {
          return StateManagementService.state.question;
        }), (function(current, last) {
          console.log("hm question changed ?");
          activeIndex = $.inArray(current, domain);
          console.log(activeIndex);
          renderPanel(measure, 'question', true);
        }), true);
        $scope.$watch((function() {
          return frame.height();
        }), (function(current, last) {
          if (data.length > 0) {
            scale['y'].rangeRoundBands([0, current - margin.top - margin.bottom - padding.bottom], 1 - (1 / domain.length), 2 / domain.length);
            g['x'].attr('transform', _translate(margin.left + padding.left, current - margin.bottom));
            renderAxis();
            renderPanel(measure, 'question', true);
          }
        }), true);
        $scope.$watch((function() {
          return frame.width();
        }), (function(current, last) {
          margin.left = current * margin.left_pct;
          if (data.length > 0) {
            scale['x'].range([0, current - margin.left - margin.right - padding.left]);
            renderAxis();
            renderPanel(measure, 'question', true);
          }
        }), true);
        $scope.$watch((function() {
          return DataService.dataPoint['questions_all'];
        }), (function(current, last) {
          console.log("hmm , rendering");
          console.log(activeIndex);
          data = current;
          scale['y'].domain(domain).rangeRoundBands([0, frame.height() - margin.top - margin.bottom - padding.bottom], 1 - (1 / domain.length), 2 / domain.length);
          scale['x'].range([0, frame.width() - margin.left - margin.right - padding.left]);
          renderAxis(1000);
          renderPanel(measure, 'question');
        }), true);
      };
      return ['$rootScope', '$scope', 'DataService', 'StateManagementService', $settings, ChartController];
    };
  });

}).call(this);

//# sourceMappingURL=QuestionsController.map
