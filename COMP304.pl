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
    Below I have listed all the journeys into the roadSegment predicate.
    I have done this so it can be accessed during routing.

*/

roadSegment(wellington, palmerston_north, 143).
roadSegment(palmerston_north, wanganui, 74).
roadSegment(palmerston_north, napier, 178).
roadSegment(palmerston_north, taupo, 259).
roadSegment(wanganui, taupo, 231).
roadSegment(wanganui, new_plymouth, 163).
roadSegment(wanganui, napier, 252).
roadSegment(napier, taupo, 147).
roadSegment(napier, gisborne, 215).
roadSegment(new_plymouth, hamilton, 242).
roadSegment(new_plymouth, taupo, 289).
roadSegment(taupo, hamilton, 153).
roadSegment(taupo, rotorua, 82).
roadSegment(taupo, gisborne, 334).
roadSegment(gisborne, rotorua, 291).
roadSegment(rotorua, hamilton, 109).
roadSegment(hamilton, auckland, 126).

/*
    Comments:
    I have created the route/3 predicate to take the start and finish location, as well as a list of places to be visited.
    Firstly, our base case checks when its an empty list (after recursing) calling apon the roadSegment and returning true.
    The main part of the predicate is to recurse through the road segments with the head of the locations to visit,
    from here we recurse on the head and check to see if theres another path from the head, parsing the finish and list
    of places to visit. If there is a path then this will return true.

*/

route(Start, Finish,[]):- roadSegment(Start, Finish,_).
route(Start, Finish, [Head | Visits]):- roadSegment(Start, Head, _),route(Head, Finish, Visits),!.

/*
    Comments:
    Here we have the base case for the route, this is when the list is empty(finished). 
    We need to check to see if our Result is correct and should == 0.
    All we are doing is subtracting the Distance to be stored in our result, this is so we can use it later
    to check if its == 0 in our base case. This means the route was successful, returning true if correct.

*/

route(Start,Finish,[],Distance):- roadSegment(Start, Finish, X),
                                  Result is (Distance-X), 
                                 (Result == 0).

route(Start,Finish,[Head | Visits], Distance):- roadSegment(Start, Head, X),
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
    base case traverse predicate returns true if the roadSegment is true, meaning
    we have reached our goal of traversing to to finish node

*/

traverse(Start, Finish, Visited, [Finish | Visited], Distance) :- roadSegment(Start, Finish, Distance).
traverse(Start, Finish, Visited, Visits, Distance) :- roadSegment(Start, Town, DistanceToTown), 
                                                    Town \= Finish, not(member(Town, Visited)),
                                                    traverse(Town, Finish, [Town | Visited], Visits, DistanceToTownNew),
                                                    Distance is DistanceToTown + DistanceToTownNew.
 
choice(Start, Finish, RoutesAndDistances) :- findall((Visited, Distance), 
                                             roads(Start, Finish, Visited, Distance), RoutesAndDistances).


/*
    Comments:
    you can either run each test individually, or execute run().
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
run() :-   
           test1(), 
           test2(),
           test3(),
           test4(),
           test5(),
           test6(),
           test7(),
           !.

/* 
    Junk code

    route(wellington,taupo,[palmerston_north,wanganui,napier],616).

    returns true if the member is in the list 

    # visited([],_).
    # visited([Head | Visits], Visited) :- member(Head, Visited), visited(Visits, Visited),!.


    #visited(Head,Visits):- member(Head, Visits).
    #not(Q):- Q,!,fail.
    #not().
*/