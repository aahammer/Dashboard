define(['crossfilter','d3','jquery'], (crossfilter,d3,$) ->


    ($settings) ->
        DataService = ($rootScope, $settings) ->


            ### INIT VARIABLES ###
            state = {}
            data = {}
            dimensions = {}
            dataPoint = {}

            ###
            mycsv = """
            item,module,question,date,total,return_total,return_rate,AVERAGE,TOP,NPS
            Surgery,Treatment,I was satisfied with the treatment,2014-05-01,100,80,0.8,7.3,1,0
            Surgery,Treatment,Staff kept me well informed,2014-05-01,100,80,0.8,2,0.6,0.8
            Surgery,Treatment,Rooms were clean,2014-05-01,20,90,0.8,3.9,0.4,-0.1
            Surgery,Treatment,Doctors were always friendly,2014-05-01,20,90,0.8,0.4,0.8,-0.3
            Surgery,Organisation,I always found my way around,2014-05-01,100,80,0.8,7.1,0.3,0.4
            Surgery,Organisation,Meals were tasty,2014-05-01,100,80,0.8,5.8,0.2,1
            Pediatrics,Treatment,I was satisfied with the treatment,2014-05-01,100,80,0.8,6.8,0.7,0.8
            Pediatrics,Treatment,Staff kept me well informed,2014-05-01,80,40,0.8,7.2,0.7,0.1
            Pediatrics,Treatment,Rooms were clean,2014-05-01,100,80,0.8,7.6,0.4,0.9
            Pediatrics,Treatment,Doctors were always friendly,2014-05-01,20,90,0.8,1.8,0.2,0.4
            Pediatrics,Organisation,I always found my way around,2014-05-01,100,80,0.8,7.7,0.7,0
            Pediatrics,Organisation,Meals were tasty,2014-05-01,100,80,0.8,6.5,0,-0.3
            Neurology,Treatment,I was satisfied with the treatment,2014-05-01,100,80,0.8,0.1,0.3,0.4
            Neurology,Treatment,Staff kept me well informed,2014-05-01,100,80,0.8,5.5,1,-0.1
            Neurology,Treatment,Doctors were always friendly,2014-05-01,20,90,0.8,4.5,0,0.2
            Neurology,Treatment,Rooms were clean,2014-05-01,100,80,0.8,5.3,0.7,-0.5
            Neurology,Organisation,I always found my way around,2014-05-01,100,80,0.8,5.5,0.2,0.6
            Neurology,Organisation,Meals were tasty,2014-05-01,100,80,0.8,4.8,0.6,0.4
            Surgery,Treatment,I was satisfied with the treatment,2014-04-01,100,80,0.8,9.3,0,-0.1
            Surgery,Treatment,Staff kept me well informed,2014-04-01,100,80,0.8,6.9,0.7,-0.4
            Surgery,Treatment,Rooms were clean,2014-04-01,20,90,0.8,1.5,0.6,-0.1
            Surgery,Treatment,Doctors were always friendly,2014-04-01,20,90,0.8,6.9,0.6,0.2
            Surgery,Organisation,I always found my way around,2014-04-01,100,80,0.8,2.2,0.6,-0.3
            Surgery,Organisation,Meals were tasty,2014-04-01,100,80,0.8,8.7,0.4,-0.5
            Pediatrics,Treatment,I was satisfied with the treatment,2014-04-01,100,80,0.8,7.1,1,-0.2
            Pediatrics,Treatment,Staff kept me well informed,2014-04-01,80,40,0.8,8.9,0.8,-0.5
            Pediatrics,Treatment,Rooms were clean,2014-04-01,100,80,0.8,8.2,0.6,0.8
            Pediatrics,Treatment,Doctors were always friendly,2014-04-01,20,90,0.8,4.8,0.1,0.3
            Pediatrics,Organisation,I always found my way around,2014-04-01,100,80,0.8,8.9,0.3,0.1
            Pediatrics,Organisation,Meals were tasty,2014-04-01,100,80,0.8,6.6,0.3,1
            Neurology,Treatment,I was satisfied with the treatment,2014-04-01,100,80,0.8,4.3,0.4,-0.1
            Neurology,Treatment,Staff kept me well informed,2014-04-01,100,80,0.8,3.9,1,0
            Neurology,Treatment,Doctors were always friendly,2014-04-01,20,90,0.8,5.7,0.4,-0.2
            Neurology,Treatment,Rooms were clean,2014-04-01,100,80,0.8,5.3,0.3,0.6
            Neurology,Organisation,I always found my way around,2014-04-01,100,80,0.8,5.1,0.8,0.7
            Neurology,Organisation,Meals were tasty,2014-04-01,100,80,0.8,5.2,0.2,1
            Surgery,Treatment,I was satisfied with the treatment,2014-03-01,100,80,0.8,5.9,0.6,0.7
            Surgery,Treatment,Staff kept me well informed,2014-03-01,100,80,0.8,7.8,0,1
            Surgery,Treatment,Rooms were clean,2014-03-01,20,90,0.8,5.3,0.3,-0.2
            Surgery,Treatment,Doctors were always friendly,2014-03-01,20,90,0.8,2.1,0.5,0.6
            Surgery,Organisation,I always found my way around,2014-03-01,100,80,0.8,1.9,0,0
            Surgery,Organisation,Meals were tasty,2014-03-01,100,80,0.8,1,0.7,-0.5
            Pediatrics,Treatment,I was satisfied with the treatment,2014-03-01,100,80,0.8,4.4,0.1,-0.2
            Pediatrics,Treatment,Staff kept me well informed,2014-03-01,80,40,0.8,8.5,0.2,0.4
            Pediatrics,Treatment,Rooms were clean,2014-03-01,100,80,0.8,0.2,0.3,0.2
            Pediatrics,Treatment,Doctors were always friendly,2014-03-01,20,90,0.8,1.7,0.5,1
            Pediatrics,Organisation,I always found my way around,2014-03-01,100,80,0.8,7.4,0.2,-0.5
            Pediatrics,Organisation,Meals were tasty,2014-03-01,100,80,0.8,3.2,1,0.8
            Neurology,Treatment,I was satisfied with the treatment,2014-03-01,100,80,0.8,9.4,0,-0.2
            Neurology,Treatment,Staff kept me well informed,2014-03-01,100,80,0.8,5.6,0.5,0.1
            Neurology,Treatment,Doctors were always friendly,2014-03-01,20,90,0.8,6.6,0.1,0
            Neurology,Treatment,Rooms were clean,2014-03-01,100,80,0.8,6.1,0,0.7
            Neurology,Organisation,I always found my way around,2014-03-01,100,80,0.8,2.1,0.4,-0.5
            Neurology,Organisation,Meals were tasty,2014-03-01,100,80,0.8,4.7,0.3,0.4
            Surgery,Treatment,I was satisfied with the treatment,2014-02-01,100,80,0.8,7.9,1,0.1
            Surgery,Treatment,Staff kept me well informed,2014-02-01,100,80,0.8,8.9,0,0.5
            Surgery,Treatment,Rooms were clean,2014-02-01,20,90,0.8,0.2,0.1,0.9
            Surgery,Treatment,Doctors were always friendly,2014-02-01,20,90,0.8,6.7,0.2,1
            Surgery,Organisation,I always found my way around,2014-02-01,100,80,0.8,0.6,0.5,-0.1
            Surgery,Organisation,Meals were tasty,2014-02-01,100,80,0.8,8.7,0.9,0.6
            Pediatrics,Treatment,I was satisfied with the treatment,2014-02-01,100,80,0.8,5.5,0.5,0.6
            Pediatrics,Treatment,Staff kept me well informed,2014-02-01,80,40,0.8,5.8,0.7,-0.3
            Pediatrics,Treatment,Rooms were clean,2014-02-01,100,80,0.8,9.9,0.2,-0.4
            Pediatrics,Treatment,Doctors were always friendly,2014-02-01,20,90,0.8,0,0.5,0.9
            Pediatrics,Organisation,I always found my way around,2014-02-01,100,80,0.8,0.2,1,1
            Pediatrics,Organisation,Meals were tasty,2014-02-01,100,80,0.8,8.4,0.2,0.3
            Neurology,Treatment,I was satisfied with the treatment,2014-02-01,100,80,0.8,3.3,0.4,0.2
            Neurology,Treatment,Staff kept me well informed,2014-02-01,100,80,0.8,4.7,0.1,-0.3
            Neurology,Treatment,Doctors were always friendly,2014-02-01,20,90,0.8,9.1,0.7,-0.1
            Neurology,Treatment,Rooms were clean,2014-02-01,100,80,0.8,2.6,0.5,-0.1
            Neurology,Organisation,I always found my way around,2014-02-01,100,80,0.8,7.7,0.9,0.7
            Neurology,Organisation,Meals were tasty,2014-02-01,100,80,0.8,1,0.9,0.7
            Surgery,Treatment,I was satisfied with the treatment,2014-01-01,100,80,0.8,8.2,1,0.1
            Surgery,Treatment,Staff kept me well informed,2014-01-01,100,80,0.8,6.7,0.5,0.5
            Surgery,Treatment,Rooms were clean,2014-01-01,20,90,0.8,0.4,1,0
            Surgery,Treatment,Doctors were always friendly,2014-01-01,20,90,0.8,2,0.5,0.7
            Surgery,Organisation,I always found my way around,2014-01-01,100,80,0.8,4.3,0.2,0
            Surgery,Organisation,Meals were tasty,2014-01-01,100,80,0.8,1.6,0.2,0.7
            Pediatrics,Treatment,I was satisfied with the treatment,2014-01-01,100,80,0.8,2.7,0,0.5
            Pediatrics,Treatment,Staff kept me well informed,2014-01-01,80,40,0.8,8.4,0.9,-0.3
            Pediatrics,Treatment,Rooms were clean,2014-01-01,100,80,0.8,5.2,0.5,0.3
            Pediatrics,Treatment,Doctors were always friendly,2014-01-01,20,90,0.8,9.6,1,0.3
            Pediatrics,Organisation,I always found my way around,2014-01-01,100,80,0.8,7.8,0.3,0.1
            Pediatrics,Organisation,Meals were tasty,2014-01-01,100,80,0.8,4.7,0.7,-0.5
            Neurology,Treatment,I was satisfied with the treatment,2014-01-01,100,80,0.8,4.8,0.4,0
            Neurology,Treatment,Staff kept me well informed,2014-01-01,100,80,0.8,5.9,1,0.6
            Neurology,Treatment,Doctors were always friendly,2014-01-01,20,90,0.8,5,0.2,1
            Neurology,Treatment,Rooms were clean,2014-01-01,100,80,0.8,9,0.9,0.2
            Neurology,Organisation,I always found my way around,2014-01-01,100,80,0.8,0.7,1,-0.2
            Neurology,Organisation,Meals were tasty,2014-01-01,100,80,0.8,7.2,0.2,0.8
            Surgery,Treatment,I was satisfied with the treatment,2013-12-01,100,80,0.8,6.9,0.5,-0.2
            Surgery,Treatment,Staff kept me well informed,2013-12-01,100,80,0.8,1.3,0,0.6
            Surgery,Treatment,Rooms were clean,2013-12-01,20,90,0.8,1.7,0.6,0.7
            Surgery,Treatment,Doctors were always friendly,2013-12-01,20,90,0.8,2.2,0,1
            Surgery,Organisation,I always found my way around,2013-12-01,100,80,0.8,3.7,0.5,0.4
            Surgery,Organisation,Meals were tasty,2013-12-01,100,80,0.8,0.3,0,1
            Pediatrics,Treatment,I was satisfied with the treatment,2013-12-01,100,80,0.8,7.7,0.1,0.5
            Pediatrics,Treatment,Staff kept me well informed,2013-12-01,80,40,0.8,5.1,0.5,0.5
            Pediatrics,Treatment,Rooms were clean,2013-12-01,100,80,0.8,1.6,0,0.7
            Pediatrics,Treatment,Doctors were always friendly,2013-12-01,20,90,0.8,3,0.6,0.3
            Pediatrics,Organisation,I always found my way around,2013-12-01,100,80,0.8,1.1,0.8,-0.1
            Pediatrics,Organisation,Meals were tasty,2013-12-01,100,80,0.8,2.1,0.2,-0.3
            Neurology,Treatment,I was satisfied with the treatment,2013-12-01,100,80,0.8,4.2,0.3,0.2
            Neurology,Treatment,Staff kept me well informed,2013-12-01,100,80,0.8,0,0.9,-0.1
            Neurology,Treatment,Doctors were always friendly,2013-12-01,20,90,0.8,2.1,0.4,0.7
            Neurology,Treatment,Rooms were clean,2013-12-01,100,80,0.8,7.4,0.5,-0.3
            Neurology,Organisation,I always found my way around,2013-12-01,100,80,0.8,9.2,0.5,0.4
            Neurology,Organisation,Meals were tasty,2013-12-01,100,80,0.8,0.1,0.5,0.3
            Surgery,Treatment,I was satisfied with the treatment,2013-11-01,100,80,0.8,5.2,1,0.1
            Surgery,Treatment,Staff kept me well informed,2013-11-01,100,80,0.8,6,0.3,-0.2
            Surgery,Treatment,Rooms were clean,2013-11-01,20,90,0.8,1.1,1,0.1
            Surgery,Treatment,Doctors were always friendly,2013-11-01,20,90,0.8,6.8,0.9,0.3
            Surgery,Organisation,I always found my way around,2013-11-01,100,80,0.8,5.2,0,0.1
            Surgery,Organisation,Meals were tasty,2013-11-01,100,80,0.8,5.5,0.2,0.6
            Pediatrics,Treatment,I was satisfied with the treatment,2013-11-01,100,80,0.8,8.1,0.2,0.3
            Pediatrics,Treatment,Staff kept me well informed,2013-11-01,80,40,0.8,5.4,0.5,-0.5
            Pediatrics,Treatment,Rooms were clean,2013-11-01,100,80,0.8,2.4,0.4,0.5
            Pediatrics,Treatment,Doctors were always friendly,2013-11-01,20,90,0.8,4.3,0.1,-0.3
            Pediatrics,Organisation,I always found my way around,2013-11-01,100,80,0.8,7.4,1,0.8
            Pediatrics,Organisation,Meals were tasty,2013-11-01,100,80,0.8,3.9,0.4,0.6
            Neurology,Treatment,I was satisfied with the treatment,2013-11-01,100,80,0.8,7.1,1,0.1
            Neurology,Treatment,Staff kept me well informed,2013-11-01,100,80,0.8,8,0,0.5
            Neurology,Treatment,Doctors were always friendly,2013-11-01,20,90,0.8,9.1,0.9,0.7
            Neurology,Treatment,Rooms were clean,2013-11-01,100,80,0.8,3.9,0.9,1
            Neurology,Organisation,I always found my way around,2013-11-01,100,80,0.8,0.1,0.1,0.5
            Neurology,Organisation,Meals were tasty,2013-11-01,100,80,0.8,3.8,0.3,0.9
            Surgery,Treatment,I was satisfied with the treatment,2013-10-01,100,80,0.8,8.4,0.2,0.2
            Surgery,Treatment,Staff kept me well informed,2013-10-01,100,80,0.8,9.3,0.1,1
            Surgery,Treatment,Rooms were clean,2013-10-01,20,90,0.8,7.5,0.6,0.3
            Surgery,Treatment,Doctors were always friendly,2013-10-01,20,90,0.8,6,0.5,-0.2
            Surgery,Organisation,I always found my way around,2013-10-01,100,80,0.8,4.4,0,-0.2
            Surgery,Organisation,Meals were tasty,2013-10-01,100,80,0.8,6.3,0.1,0.2
            Pediatrics,Treatment,I was satisfied with the treatment,2013-10-01,100,80,0.8,4.5,0.8,-0.1
            Pediatrics,Treatment,Staff kept me well informed,2013-10-01,80,40,0.8,0.9,0.3,0.8
            Pediatrics,Treatment,Rooms were clean,2013-10-01,100,80,0.8,1,0.3,0.4
            Pediatrics,Treatment,Doctors were always friendly,2013-10-01,20,90,0.8,5.7,0.5,0.8
            Pediatrics,Organisation,I always found my way around,2013-10-01,100,80,0.8,8.7,0.3,1
            Pediatrics,Organisation,Meals were tasty,2013-10-01,100,80,0.8,8.1,0.9,0.2
            Neurology,Treatment,I was satisfied with the treatment,2013-10-01,100,80,0.8,0.4,1,0.2
            Neurology,Treatment,Staff kept me well informed,2013-10-01,100,80,0.8,2.9,0.6,0.5
            Neurology,Treatment,Doctors were always friendly,2013-10-01,20,90,0.8,0.3,0.8,0.5
            Neurology,Treatment,Rooms were clean,2013-10-01,100,80,0.8,0.5,0,0.3
            Neurology,Organisation,I always found my way around,2013-10-01,100,80,0.8,5.7,0.4,-0.2
            Neurology,Organisation,Meals were tasty,2013-10-01,100,80,0.8,4.1,0.4,0.9
            Surgery,Treatment,I was satisfied with the treatment,2013-09-01,100,80,0.8,6.5,0.2,-0.2
            Surgery,Treatment,Staff kept me well informed,2013-09-01,100,80,0.8,2.3,0.3,1
            Surgery,Treatment,Rooms were clean,2013-09-01,20,90,0.8,1.7,0.3,-0.2
            Surgery,Treatment,Doctors were always friendly,2013-09-01,20,90,0.8,4.8,0.9,-0.3
            Surgery,Organisation,I always found my way around,2013-09-01,100,80,0.8,2.1,0,0.5
            Surgery,Organisation,Meals were tasty,2013-09-01,100,80,0.8,6.5,0.1,0.7
            Pediatrics,Treatment,I was satisfied with the treatment,2013-09-01,100,80,0.8,9.6,0.3,0.1
            Pediatrics,Treatment,Staff kept me well informed,2013-09-01,80,40,0.8,2.7,0,0.2
            Pediatrics,Treatment,Rooms were clean,2013-09-01,100,80,0.8,3.1,0.3,0.6
            Pediatrics,Treatment,Doctors were always friendly,2013-09-01,20,90,0.8,3.2,0.9,1
            Pediatrics,Organisation,I always found my way around,2013-09-01,100,80,0.8,9,0.9,0.3
            Pediatrics,Organisation,Meals were tasty,2013-09-01,100,80,0.8,6.2,0.4,0.2
            Neurology,Treatment,I was satisfied with the treatment,2013-09-01,100,80,0.8,1.4,0.3,-0.4
            Neurology,Treatment,Staff kept me well informed,2013-09-01,100,80,0.8,9.1,0.2,0.6
            Neurology,Treatment,Doctors were always friendly,2013-09-01,20,90,0.8,6.5,0.8,-0.2
            Neurology,Treatment,Rooms were clean,2013-09-01,100,80,0.8,6.3,1,-0.5
            Neurology,Organisation,I always found my way around,2013-09-01,100,80,0.8,2.9,0.6,0.2
            Neurology,Organisation,Meals were tasty,2013-09-01,100,80,0.8,5.2,0,-0.5
            Surgery,Treatment,I was satisfied with the treatment,2013-08-01,100,80,0.8,1.5,0.5,0.3
            Surgery,Treatment,Staff kept me well informed,2013-08-01,100,80,0.8,6.2,0.5,-0.5
            Surgery,Treatment,Rooms were clean,2013-08-01,20,90,0.8,9.4,0.1,0.9
            Surgery,Treatment,Doctors were always friendly,2013-08-01,20,90,0.8,4.9,0.9,-0.3
            Surgery,Organisation,I always found my way around,2013-08-01,100,80,0.8,4.9,0.7,-0.5
            Surgery,Organisation,Meals were tasty,2013-08-01,100,80,0.8,3.9,0.8,0.4
            Pediatrics,Treatment,I was satisfied with the treatment,2013-08-01,100,80,0.8,4,0.6,0.9
            Pediatrics,Treatment,Staff kept me well informed,2013-08-01,80,40,0.8,8.4,0.9,0.6
            Pediatrics,Treatment,Rooms were clean,2013-08-01,100,80,0.8,8.1,0.2,0.5
            Pediatrics,Treatment,Doctors were always friendly,2013-08-01,20,90,0.8,8,1,0.5
            Pediatrics,Organisation,I always found my way around,2013-08-01,100,80,0.8,7.9,0.1,-0.1
            Pediatrics,Organisation,Meals were tasty,2013-08-01,100,80,0.8,1.3,1,0.9
            Neurology,Treatment,I was satisfied with the treatment,2013-08-01,100,80,0.8,0.2,0.8,-0.5
            Neurology,Treatment,Staff kept me well informed,2013-08-01,100,80,0.8,4.8,0.3,-0.5
            Neurology,Treatment,Doctors were always friendly,2013-08-01,20,90,0.8,2.3,0.7,1
            Neurology,Treatment,Rooms were clean,2013-08-01,100,80,0.8,2.5,0.4,-0.1
            Neurology,Organisation,I always found my way around,2013-08-01,100,80,0.8,7.4,0.9,0.4
            Neurology,Organisation,Meals were tasty,2013-08-01,100,80,0.8,8.5,0.7,0.2
            Surgery,Treatment,I was satisfied with the treatment,2013-07-01,100,80,0.8,6.6,0.2,0.8
            Surgery,Treatment,Staff kept me well informed,2013-07-01,100,80,0.8,3.5,1,0.3
            Surgery,Treatment,Rooms were clean,2013-07-01,20,90,0.8,9,0.3,0.4
            Surgery,Treatment,Doctors were always friendly,2013-07-01,20,90,0.8,3.4,0.8,-0.3
            Surgery,Organisation,I always found my way around,2013-07-01,100,80,0.8,6.7,0.7,0
            Surgery,Organisation,Meals were tasty,2013-07-01,100,80,0.8,8.6,0.9,-0.1
            Pediatrics,Treatment,I was satisfied with the treatment,2013-07-01,100,80,0.8,0.2,0.9,0.9
            Pediatrics,Treatment,Staff kept me well informed,2013-07-01,80,40,0.8,9.5,0.7,0.8
            Pediatrics,Treatment,Rooms were clean,2013-07-01,100,80,0.8,3,0.1,0.4
            Pediatrics,Treatment,Doctors were always friendly,2013-07-01,20,90,0.8,1.8,0.5,0.6
            Pediatrics,Organisation,I always found my way around,2013-07-01,100,80,0.8,6.1,1,0.4
            Pediatrics,Organisation,Meals were tasty,2013-07-01,100,80,0.8,0.3,0.9,1
            Neurology,Treatment,I was satisfied with the treatment,2013-07-01,100,80,0.8,7.5,0.8,-0.2
            Neurology,Treatment,Staff kept me well informed,2013-07-01,100,80,0.8,8.2,0,0.6
            Neurology,Treatment,Doctors were always friendly,2013-07-01,20,90,0.8,1.9,0.8,-0.3
            Neurology,Treatment,Rooms were clean,2013-07-01,100,80,0.8,5.9,0.1,-0.5
            Neurology,Organisation,I always found my way around,2013-07-01,100,80,0.8,1.6,1,-0.2
            Neurology,Organisation,Meals were tasty,2013-07-01,100,80,0.8,2.5,0,0.7
            Surgery,Treatment,I was satisfied with the treatment,2013-06-01,100,80,0.8,0.9,0,-0.4
            Surgery,Treatment,Staff kept me well informed,2013-06-01,100,80,0.8,0.5,0.6,-0.5
            Surgery,Treatment,Rooms were clean,2013-06-01,20,90,0.8,7.5,0,0.9
            Surgery,Treatment,Doctors were always friendly,2013-06-01,20,90,0.8,1.3,1,0.7
            Surgery,Organisation,I always found my way around,2013-06-01,100,80,0.8,3.6,0.8,0.4
            Surgery,Organisation,Meals were tasty,2013-06-01,100,80,0.8,8.4,0.2,-0.1
            Pediatrics,Treatment,I was satisfied with the treatment,2013-06-01,100,80,0.8,6.8,0.7,0.7
            Pediatrics,Treatment,Staff kept me well informed,2013-06-01,80,40,0.8,5.9,0.2,-0.4
            Pediatrics,Treatment,Rooms were clean,2013-06-01,100,80,0.8,2.2,0.8,-0.1
            Pediatrics,Treatment,Doctors were always friendly,2013-06-01,20,90,0.8,5.7,0.4,0.9
            Pediatrics,Organisation,I always found my way around,2013-06-01,100,80,0.8,1.7,0.5,0.8
            Pediatrics,Organisation,Meals were tasty,2013-06-01,100,80,0.8,7.7,0,0.2
            Neurology,Treatment,I was satisfied with the treatment,2013-06-01,100,80,0.8,3.2,0.9,0.9
            Neurology,Treatment,Staff kept me well informed,2013-06-01,100,80,0.8,5.2,0,1
            Neurology,Treatment,Doctors were always friendly,2013-06-01,20,90,0.8,2.2,0.5,0.9
            Neurology,Treatment,Rooms were clean,2013-06-01,100,80,0.8,9.8,0.9,0.7
            Neurology,Organisation,I always found my way around,2013-06-01,100,80,0.8,3.4,0.1,-0.4
            Neurology,Organisation,Meals were tasty,2013-06-01,100,80,0.8,1.1,0.3,1
            """
            ###



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

                    #file = d3.csv.parse(mycsv)
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