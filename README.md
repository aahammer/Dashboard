# A technology test combining AngularJS and D3.js into a modular dashboard front end

After doing some minor data driven documents with D3.js, i searched for a more consistent way to combine different D3.js views into a single dashboard application.
Since i also wanted to get some experience with solid web app framework, i decided to use AngularJS for a more modulized data driven document. 

### The AngularJS / D3.js Dashboard Protoapp

The AngularJS / D3.js Dashboard Protoapp on Heroku. The app displays some randomly generated hypothetic patient survey data in a healthcare setting.
All components are wired in order to offer a responsive navigation experience to the user. 


### Results

After trying different more generic approaches I soon realized that D3.js is far to low level for an efficent generic declerative component approach.
When i tried to implement a generic solution for every possible scaling, axis alignment, data bindings etc. you see in the demo app, the configuration soon got out of hands.
It was far more efficent to build the D3.js components one by one with hard coded individual behaviour. 
But, and thats where AngularJS comes in: The interaction between all individually coded D3.js components was greatly simplified by using a central DataService and StateService.
The StateService watches URL changes and calls appropriate DataService actions. The DataService then provides new data, which Controllers are observing.

Another benefit for using AngularJS this way: Its adaptable to other libraries and components like ng-grid table representation.
This makes it easy to mash-up different technologies in a single application.