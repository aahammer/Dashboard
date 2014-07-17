define(['d3'], (d3) ->

    ###
        -> benötigt start konfiguartian
        -> werte können entweder statisch oder dynamisch über endpunkte gesetzt werden
    ###

    ($settings) ->

        RenderService = ($settings) ->

            _translate = (x,y) -> 'translate(' + x + ',' + y + ')'


            barRenderer = (panel, value, valueScale, category, categoryScale, options) ->

                this.value = value

                if options.layout = 'horizontal'
                    valueDim = 'x'
                    categoryDim = 'y'
                else
                    valueDim = 'y'
                    categoryDim = 'x'

                configure = (settings) ->
                    if settings.value?
                        this.value = settings.value
                    if settings.valueScale?
                        this.valueScale = settings.valueScale

                render = (data) ->

                    value = this.value

                    console.log(data)
                    console.log(value + ' -> ' + category)



                    ## UPDATE
                    panel.selectAll(options.selector)
                        .data(data, (d) -> d[category] )
                        .select('rect')
                        .transition()
                        .duration(1000)
                            .attr('width', (d) -> valueScale(d[value]))



                    ## ENTER
                    panel.selectAll(options.selector)
                    .data(data, (d) -> d[category] )
                    .enter()
                    .append('a')
                            .attr('xlink:href', (d) -> '#/questions/' + d[category])
                            .attr('class', 'questions')
                            .append('rect')
                                .attr('width', 0)
                                .transition()
                                .duration(1000)
                                .ease('circle')
                                .attr(valueDim, 0)
                                .attr(categoryDim, (d) ->
                                        #console.log(categoryScale(d.category))
                                        categoryScale(d[category])
                                )
                                .attr('height', categoryScale.rangeExtent()[1]/options.max )
                                .attr('width', (d) ->  valueScale(d[value]))



                    ## EXIT
                    panel.selectAll(options.selector)
                    .data(data, (d) -> d[category])
                    .exit()
                    .remove()


                return {

                    setup:configure
                    render:render

                }


            return  {
                _translate: _translate
                render : barRenderer
                #know your own dataendpoint as setting
            }

        return [ '$rootScope', $settings, RenderService ]
)