
:- consult(data).

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


path3(Start, Stop, _, mine(Start, Stop, Transport), Hind) :- mineVahend(Start, Stop, Transport),  mineHind(Start, Stop, Hind).
path3(Start, Finish, Visited, mine(Start, Stop, Transport, Next), Summa) :-
    mineVahend(Start, Stop, Transport),
    mineHind(Start, Stop, Trip),
    not(member(Stop, Visited)),
    length(Visited, X),
    X < 2,
    path3(Stop, Finish, [Stop | Visited], Next, Price),
    Summa is +(Trip, Price).


reisi(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price).

reisi_answer(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price),
    !.

min_list([Head], Head).

min_list([Head, Head2|Tail], Minimum) :-
    (Head >= Head2, min_list([Head2|Tail], Minimum));
    (Head < Head2, min_list([Head|Tail], Minimum)).


trips_to_best(Start, End, BestRoad, BestPrice) :-
    findall(Price, reisi(Start, End, _, Price), List),
    min_list(List, BestPrice),
    !,
    reisi_answer(Start, End, BestRoad, BestPrice).


odavaim_reis(Start, End, BestRoad, BestPrice) :-
    trips_to_best(Start, End, BestRoad, BestPrice).


path4(Start, Stop, _, mine(Start, Stop, Transport), Hind, SumTime, Stop) :- mineVahend(Start, Stop, Transport),  mineHind(Start, Stop, Hind), mineStartToEnd(Start, Stop, StartTime, EndTime), aegade_vahe(StartTime, EndTime, SumTime).
path4(Start, Finish, Visited, mine(Start, Stop, Transport, Next), Summa, SumTime, NextStop) :-
    mineVahend(Start, Stop, Transport),
    mineAeg(Start, Stop, Trip, Time),
    not(member(Stop, Visited)),
    length(Visited, X),
    X < 1,
    path4(Stop, Finish, [Stop | Visited], Next, Price, NextSumTime, NextStopFuture),
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
    findall(SumTime, path4(Start, End, [Start], _, _, SumTime, _), List),
    min_time_list(List, BestTime),
    !,
    path4(Start, End, [Start], Road, Price, BestTime, _), !.


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
