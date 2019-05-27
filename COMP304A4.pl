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


    1.2 Route Planning
    Write a predicate route/3 to plan routes: route(Start, Finish, Visits)
    should succeed if there is a route from Start to Finish visiting the towns in
    list Visits.

    Below I have listed all the roads into the route format of, route(Start, Finish, Visits).
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

route(Start, Finish, Visits):- road(From, To, Visits).