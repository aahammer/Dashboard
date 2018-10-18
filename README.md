# A technology test combining [AngularJS](https://angularjs.org/) and [D3.js](http://d3js.org/) into a modular dashboard front end

After doing some minor data driven documents with D3.js, i searched for a more consistent way to combine different D3.js views into a single dashboard application.
Since i also wanted to get some experience with solid web app framework, i decided to use AngularJS for a more modulized data driven document. 

### The AngularJS / D3.js Dashboard Protoapp


[The AngularJS / D3.js Dashboard Protoapp on Heroku](http://floating-temple-2493.herokuapp.com/). The app displays some randomly generated hypothetic patient survey data in a healthcare setting.
All components are wired in order to offer a responsive navigation experience to the user. 

![angular-d3js-dashboard](https://media.giphy.com/media/jU250MNxnWZRQs3PHF/giphy.gif)


### Results

After trying different more generic approaches I soon realized that D3.js is far to low level for an efficent generic declerative component approach.
When i tried to implement a generic solution for every possible scaling, axis alignment, data bindings etc. you see in the demo app, the configuration soon got out of hands.
It was far more efficent to build the D3.js components one by one with hard coded individual behaviour. 
But, and thats where AngularJS comes in: The interaction between all individually coded D3.js components was greatly simplified by using a central DataService and StateService.
The StateService watches URL changes and calls appropriate DataService actions. The DataService then provides new data, which Controllers are observing.

Another benefit for using AngularJS this way: Its adaptable to other libraries and components like ng-grid table representation.
This makes it easy to mash-up different technologies in a single application.

### Further technology insights:

Backend is supported by the [Scala Play Framework](https://www.playframework.com/). I read quite alot of Scala Stuff to get used to the language ( they got great learning ressources !) and the Play Framwork. But, in the end, i skipped most features and used the Framework only for delivering static sample content. As great as Scala and Play maybe, the learning effort is not worth it to me - currently ,) My next project will use Node again.

[Crossfilter](http://square.github.io/crossfilter/) - worked great as an efficent client side data storage in the DataService

[ng-grid](http://angular-ui.github.io/ng-grid/) - did its job, producing a table. The way its assumed to be configured did not always work straight with my way to modularize the application

[angular-ui-router](https://github.com/angular-ui/ui-router) - Great improvement over the old AngularJs router. Also i have to take a look a Angulars new Router implementation at some time.
