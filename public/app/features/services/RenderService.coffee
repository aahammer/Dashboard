define(['d3'], (d3) ->

    ($settings) ->

        RenderService = ($settings) ->

            _translate = (x,y) -> 'translate(' + x + ',' + y + ')'

            createAxis = (settings) ->

                return

            renderBars = (panel, data, value, valueScale, category, categoryScale, options) ->

                if options.layout = 'horizontal'
                    valueDim = 'x'
                    categoryDim = 'y'
                else
                    valueDim = 'y'
                    categoryDim = 'x'


                panel.selectAll(options.selector)
                    .data(data)
                    .enter()
                    .append('a')
                        .attr('xlink:href', (d) -> '#/questions/' + d[category])
                        .append('rect')
                            .attr(valueDim, 0)
                            .attr(categoryDim, (d) ->
                                    #console.log(categoryScale(d.category))
                                    categoryScale(d[category])
                            )
                            .attr('height', categoryScale.rangeExtent()[1]/options.max )
                            .attr('width', (d) -> console.log(d[value]); valueScale(d[value]))

                return;


            return  {
                _translate: _translate
                axis: createAxis
                renderBars: renderBars
            }

        return [ '$rootScope', $settings, RenderService ]
)