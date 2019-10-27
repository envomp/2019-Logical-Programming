
:- consult(data).
:- dynamic cheapest/1.
:- dynamic stops/1.

mineVahend(Start, End, lennukiga) :- lennukiga(Start, End, _, _, _); lennukiga(End, Start, _, _, _).


mineHind(Start, End, Price) :-
    lennukiga(Start, End, Price, _, _).


mineStartToEnd(Start, End, StartTime, EndTime) :-
    lennukiga(Start, End, _, StartTime, EndTime).


mineAeg(Start, End, Price, Time) :-
    lennukiga(Start, End, Price, X, Y),
    aegade_vahe(X, Y, Time).


reisi(Start, End) :-
    mineHind(Start, End, _).


reisi(Start, End) :-
    reisi(Start, End, _).


path(Start, Stop, _, mine(Start, Stop)) :- mineHind(Start, Stop, _).
path(Start, Finish, Visited, mine(Start, Stop, Next)) :-
    mineHind(Start, Stop, _),
    not(member(Stop, Visited)),
    path(Stop, Finish, [Stop | Visited], Next).

reisi(Start, End, Road) :-
    Start \= End,
    path(Start, End, [Start], Road).


path2(Start, Stop, _, mine(Start, Stop, Transport)) :- mineVahend(Start, Stop, Transport).
path2(Start, Finish, Visited, mine(Start, Stop, Transport, Next)) :-
    mineVahend(Start, Stop, Transport),
    not(member(Stop, Visited)),
    path2(Stop, Finish, [Stop | Visited], Next).


reisi_transpordiga(Start, End, Road) :-
    path2(Start, End, [Start], Road).


path3(Start, Stop, _, mine(Start, Stop, Transport), Hind, ProgressiveCost) :-
    mineVahend(Start, Stop, Transport),
    mineHind(Start, Stop, Hind),
    NewProgressiveCost is ProgressiveCost + Hind,
    cheapest(BestProgressiveCost),
    NewProgressiveCost =< BestProgressiveCost,
    retractall(cheapest(BestProgressiveCost)),
    asserta(cheapest(NewProgressiveCost)).

path3(Start, Finish, Visited, mine(Start, Stop, Transport, Next), Summa, ProgressiveCost) :-
    mineVahend(Start, Stop, Transport),
    mineHind(Start, Stop, Trip),
    not(member(Stop, Visited)),
    length(Visited, X),
    stops(AllowedStops),
    X < AllowedStops,
    NewProgressiveCost is ProgressiveCost + Trip,
    cheapest(BestProgressiveCost),
    NewProgressiveCost =< BestProgressiveCost,
    path3(Stop, Finish, [Stop | Visited], Next, Price, NewProgressiveCost),
    Summa is +(Trip, Price).


reisi(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price, 0).

reisi_answer(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price, 0),
    !.

min_list([Head], Head).

min_list([Head, Head2|Tail], Minimum) :-
    (Head >= Head2, min_list([Head2|Tail], Minimum));
    (Head < Head2, min_list([Head|Tail], Minimum)).


trips_to_best(Start, End, BestRoad, BestPrice) :-
    asserta(cheapest(1000000)),
    asserta(stops(2)),
    stops(Stops),
    findall(TempPrice, reisi(Start, End, _, TempPrice), _),
    retractall(stops(Stops)),
    asserta(stops(10)),
    ((findall(Price, reisi(Start, End, _, Price), List), min_list(List, BestPrice), !, reisi_answer(Start, End, BestRoad, BestPrice));
     (cheapest(BestPricePreGen), reisi_answer(Start, End, BestRoad, BestPricePreGen))).


odavaim_reis(Start, End, BestRoad, BestPrice) :-
    trips_to_best(Start, End, BestRoad, BestPrice).


path4(Start, Stop, _, mine(Start, Stop, Transport), Hind, SumTime, Stop, ProgressiveCost) :-
    mineVahend(Start, Stop, Transport),
    mineHind(Start, Stop, Hind),
    mineStartToEnd(Start, Stop, StartTime, EndTime),
    aegade_vahe(StartTime, EndTime, SumTime),
    mineAeg(Start, Stop, Trip, Time),
    time(H, _, _) = Time,
    NewProgressiveCost is ProgressiveCost + H,
    cheapest(BestProgressiveCost),
    NewProgressiveCost =< BestProgressiveCost,
    retractall(cheapest(BestProgressiveCost)),
    asserta(cheapest(NewProgressiveCost)).

path4(Start, Finish, Visited, mine(Start, Stop, Transport, Next), Summa, SumTime, NextStop, ProgressiveCost) :-
    mineVahend(Start, Stop, Transport),
    mineAeg(Start, Stop, Trip, Time),
    not(member(Stop, Visited)),
    length(Visited, X),
    stops(AllowedStops),
    X < AllowedStops,
    time(H2, _, _) = Time,
    NewProgressiveCost is ProgressiveCost + H2,
    cheapest(BestProgressiveCost),
    NewProgressiveCost =< BestProgressiveCost,
    path4(Stop, Finish, [Stop | Visited], Next, Price, NextSumTime, NextStopFuture, NewProgressiveCost),
    mineVahend(Start, NextStop, _),
    mineVahend(NextStop, NextStopFuture, _),
    mineStartToEnd(Start, NextStop, _, OneEnd),
    mineStartToEnd(NextStop, NextStopFuture, OneStart, _),
    aegade_vahe(OneEnd, OneStart, Delta),
    time(H, _, _) = Delta,
    ((H < 1, aegade_vahe(time(24, 0, 0), Delta, X), sum_time(Time, X, Y), sum_time(NextSumTime, Y, SumTime)) ; (H >= 1, sum_time(NextSumTime, Time, SumTime))),
    Summa is +(Trip, Price).


min_time_list([Head], Head).

min_time_list([Head, Head2|Tail], Minimum) :-
    time(X1, Y1, _) = Head,
    time(X2, Y2, _) = Head2,
    ((X1 == X2, Y1 < Y2, min_time_list([Head|Tail], Minimum)) ;
    (X1 == X2, Y1 >= Y2, min_time_list([Head2|Tail], Minimum)) ;
    (X1 > X2, min_time_list([Head2|Tail], Minimum)) ;
    (X1 < X2, min_time_list([Head|Tail], Minimum))).

trips_to_fastest(Start, End, Road, Price, BestTime) :-
    asserta(cheapest(100)),
    asserta(stops(2)),
    stops(Stops),
    findall(SumTime, path4(Start, End, [Start], _, _, SumTime, _, 0), _),
    retractall(stops(Stops)),
    asserta(stops(10)),
    findall(SumTime, path4(Start, End, [Start], _, _, SumTime, _, 0), List),
    min_time_list(List, BestTime),
    !,
    path4(Start, End, [Start], Road, Price, BestTime, _, 0), !.


lyhim_reis(Start, End, Road, Price, BestTime) :-
    trips_to_fastest(Start, End, Road, Price, BestTime).


sum_time(Aeg1, Aeg2, Aeg3):-
    time(H1, M1, S1) = Aeg1,
    time(H2, M2, S2) = Aeg2,
    time(H3, M3, S3) = Aeg3,
    X is S2 + S1,
    ((X >= 60, S3 is X - 60, F1 is 1); (X < 60, S3 is X, F1 is 0)),
    Y is M2 + M1 + F1,
    ((Y >= 60, M3 is Y - 60, F2 is 1); (Y < 60, M3 is Y, F2 is 0)),
    H3 is H2 + H1 + F2.
%    write(Aeg1), nl,
%    write(Aeg2), nl,
%    write(Aeg3), nl, nl

aegade_vahe(Aeg1, Aeg2, Vahe):-
    time(H1, M1, S1) = Aeg1,
    time(H2, M2, S2) = Aeg2,
    time(H3, M3, S3) = Vahe,
    X is S2 - S1,
    ((X < 0, S3 is X + 60, F1 is 1); (X >= 0, S3 is X, F1 is 0)),
    Y is M2 - M1 - F1,
    ((Y < 0, M3 is Y + 60, F2 is 1); (Y >= 0, M3 is Y, F2 is 0)),
    Z is H2 - H1 - F2,
    ((Z < 0, H3 is Z + 24); (Z >= 0, H3 is Z)).
