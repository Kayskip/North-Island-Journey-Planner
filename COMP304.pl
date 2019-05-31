/*
    Name: Karu Skipper
    ID : 300417869
    COMP304 Assignment 4 : (More Prolog)
    Due Date: 4th June.

    1. North Island Journey Planner

    1.1 Road Database
    Define a predicate road/3 to capture this information. You will use this predicate to help plan journeys around the North Island.
    One condition which we demand of any journey is that no town is visited twice;
    every station of a journey should provide a new town to enjoy.

    From                To                   km

    Wellington          Palmerston North     143
    Palmerston North    Wanganui             74
    Palmerston North    Napier               178
    Palmerston North    Taupo                259
    Wanganui            Taupo                231
    Wanganui            New Plymouth         163
    Wanganui            Napier               252
    Napier              Taupo                147
    Napier              Gisborne             215
    New Plymouth        Hamilton             242
    New Plymouth        Taupo                289
    Taupo               Hamilton             153
    Taupo               Rotorua              82
    Taupo               Gisborne             334
    Gisborne            Rotorua              291
    Rotorua             Hamilton             109
    Hamilton            Auckland             126

    Comments:
    Below I have listed all the journeys into the road predicate.
    I have done this so it can be accessed during routing.

*/

road(wellington, palmerston_north, 143).
road(palmerston_north, wanganui, 74).
road(palmerston_north, napier, 178).
road(palmerston_north, taupo, 259).
road(wanganui, taupo, 231).
road(wanganui, new_plymouth, 163).
road(wanganui, napier, 252).
road(napier, taupo, 147).
road(napier, gisborne, 215).
road(new_plymouth, hamilton, 242).
road(new_plymouth, taupo, 289).
road(taupo, hamilton, 153).
road(taupo, rotorua, 82).
road(taupo, gisborne, 334).
road(gisborne, rotorua, 291).
road(rotorua, hamilton, 109).
road(hamilton, auckland, 126).

/*
    Comments:
    I have created the route/3 predicate to take the start and finish location, as well as a list of places to be visited.
    Firstly, our base case checks when its an empty list (after recursing) calling apon the road and returning true.
    The main part of the predicate is to recurse through the road segments with the head of the locations to visit,
    from here we recurse on the head and check to see if theres another path from the head, parsing the finish and list
    of places to visit. If there is a path then this will return true.
*/

route(Start, Finish,[]):- road(Start, Finish,_).
route(Start, Finish, [Head | Visits]):- road(Start, Head, _),route(Head, Finish, Visits),!.

/*
    Comments:
    Here we have the base case for the route, this is when the list is empty(finished). 
    We need to check to see if our Result is correct and should == 0.
    All we are doing is subtracting the Distance to be stored in our result, this is so we can use it later
    to check if its == 0 in our base case. This means the route was successful, returning true if correct.
*/

route(Start,Finish,[],Distance):- road(Start, Finish, X),
                                  Result is (Distance-X), 
                                 (Result == 0).

route(Start,Finish,[Head | Visits], Distance):- road(Start, Head, X),
                                                Result is (Distance-X), 
                                                route(Head, Finish, Visits, Result).

/*
    1.4 Finding All Routes
    There is a predefined Prolog predicate findall/3 which you can use to find
    all the solutions to a goal. The first argument to findall is a Prolog term,
    the second argument is a Prolog goal and the third argument is a list. The list
    becomes bound to the list of instances of the term for which the goal succeeds.
    Using findall only makes sense if there are variables shared between the term
    and the goal. Often the term is just a variable, but it can be any term.

    For example:
    ?- findall((X,Y), append(X, Y, [1,2]), Results).
    Results = [ ([], [1, 2]), ([1], [2]), ([1, 2], [])].
    Write a predicate choice/3 to help plan routes: Predicate choice(Start, Finish, RoutesAndDistances) 
    should produce a list of all the routes (including their distances) between Start and Finish.

    Comments:
    We need to have visited predicate in order to use back tracking properly
    What this does is take the head of the list and compares it to the visited list, it recurses on this until
    the list is empty. Here we are utilising the inbuilt predicate member, which is True if Elem is a member of List
*/

visited([],_).
visited([Head | Visits], Visited) :- member(Head, Visited), visited(Visits, Visited).

/*
    Comments:
    we are also utilising the reverse predicate which: Is true when the elements of List2 are in reverse order compared to List1.
    this is helpful to also output our lists as it also writes.
    roads calls the traverse predicate and is used to gather the traversed data
*/

roads(Start, Finish, Visited, Distance) :- traverse(Start, Finish, [Start], X, Distance),  reverse(X, Visited).

/*
    Comments:
    base case traverse predicate returns true if the road is true, meaning
    we have reached our goal of traversing to to finish node.
    We first check if Start is connected to a Town and that Town
    is not the Finish, we also check to see if the town hasnt already been visited.
    We then recurse on this list, adding it to the visited list, checking further towns
    Finally we combine the distances to get a total distance of the trip

    Junk code I am experimenting with to simplify predicates:
    # routing(Start, Finish, [Start, Finish], Distance) :- route(Start, Finish,Distance).
    # routing(Start, Finish, [Start|Connections]) :- route(Start, ToConnection, X), Y is Distance-X, routing(ToConnection, Finish, Connections,Y).
*/

traverse(Start, Finish, Visited, [Finish | Visited], Distance) :- road(Start, Finish, Distance).
traverse(Start, Finish, Visited, Visits, Distance) :- road(Start, Town, DistanceToTown), 
                                                    Town \= Finish, not(member(Town, Visited)),
                                                    traverse(Town, Finish, [Town | Visited], Visits, DistanceToTownNew),
                                                    Distance is DistanceToTown + DistanceToTownNew.
 
/*
    Comments:
    finds all the routes and distances between start and finish
    we use the roads predicate and combine it with the findall predicate, making our
    predicate a lot more simple.
    findall combines them all into a list, this is helpful to store the distances of our
    desired journey, working out implementation of the distances took the most time >:(
*/

choice(Start, Finish, RoutesAndDistances) :- findall((Visited, Distance), 
                                             roads(Start, Finish, Visited, Distance), RoutesAndDistances),!.

choice(Start,Finish,RoutesAndDistances):-findall((Visits,Distance), 
                                         roads(Start, Finish, Visits, Distance), RoutesAndDistances).

/*
    1.4.1 Finding All Routes Including Towns
    Write a predicate via/4 to help planning routes: via(Start, Finish, Via,
    RoutesAndDistances) should produce a list of all the routes (including their
    distances) between Start and Finish which visit towns within Via
    
    Comments:
    Thankfully this section was a lot easier to implement as I basically copy and pasted choice haha,
    I used the generate and filter pattern discussed in lectures.
    We do the same as choice and get all the routes from start to finish, then
    we filter that sh*t down so we only get routes that only visit the towns within via 

    I made the helper method visited which handles the recursion etc so we can check if we have visited the town or not
    and all that does is grab the desired var and 
*/
via(Start, Finish, Via, RoutesAndDistances) :- findall((Visited), (roads(Start, Finish, Visited, Distance), visited(Via, Visited)), RoutesAndDistances).

/*
    Comments:
    This is a helper method which does the opposite affect to visited
    and avoids locations.
    again this was easy because its basically the same concept just altered
    here we are using findall again! we want 
    
 */


avoiding(Start, Finish, Avoiding, RoutesAndDistances) :- findall((Visited,Distance),
                                                        (routes(Start, Finish, Visited, Distance), avoided(Avoiding, Visited)), RoutesAndDistances).

avoided([],_).
avoided([Head | Avoid], Visited) :-
   not(member(Head, Visited)),
   avoided(Avoid, Visited).
 
/*
    1.4.3 Testing
    Give Prolog queries to show that route/4, choice/3, via/4 and avoiding/4
    work properly.

    Comments:
    You can either run each test individually, or execute run().
    this will run each individual test and return an overall result
*/

test1() :- route(wellington, taupo, [palmerston_north], 402),!.
test2() :- route(taupo, hamilton, [gisborne, rotorua], 734),!.
test3() :- route(wellington, auckland, [palmerston_north,taupo,gisborne,rotorua,hamilton],1262),!.
test4() :- route(wellington, taupo, [palmerston_north, napier]),!.
test5() :- route(wellington, wanganui, [palmerston_north], 217),!.

test6() :- choice(wellington, wanganui, Routes), write(Routes),!.
test7() :- choice(wellington, auckland, Routes), write(Routes),!.
test8() :- choice(new_plymouth, gisborne, Routes), write(Routes),!.

test9() :- via(),!.


run() :-   test1(), 
           test2(),
           test3(),
           test4(),
           test5(),
           test6(),
           test7(),
           !.

/* 
    Junk code:
    this assignment was so dumb my brain hurtsdsfji v
    route(wellington,taupo,[palmerston_north,wanganui,napier],616).

    returns true if the member is in the list 

    # visited([],_).
    # visited([Head | Visits], Visited) :- member(Head, Visited), visited(Visits, Visited),!.


    #visited(Head,Visits):- member(Head, Visits).
    #not(Q):- Q,!,fail.
    #not().

    I have had no sleep I hate prolog jgndvs kl';hdflnbml,sdkn
*/