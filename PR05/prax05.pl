laevaga(tallinn, helsinki, 120, time(12, 45, 0.0), time(14, 45, 0.0)).
laevaga(tallinn, stockholm, 480, time(12, 45, 0.0), time(13, 45, 0.0)).
bussiga(tallinn, riia, 300, time(12, 45, 0.0), time(12, 46, 0.0)).
rongiga(riia, berlin, 680, time(12, 45, 0.0), time(12, 55, 0.0)).
lennukiga(tallinn, helsinki, 30, time(12, 45, 0.0), time(17, 45, 0.0)).
lennukiga(helsinki, paris, 180, time(12, 45, 0.0), time(15, 55, 0.0)).
lennukiga(paris, berlin, 120, time(12, 45, 0.0), time(22, 45, 0.0)).
lennukiga(paris, tallinn, 12, time(13, 45, 0.0), time(12, 45, 0.0)).


mineVahend(Start, End, lennukiga) :- lennukiga(Start, End, _, _, _); lennukiga(End, Start, _, _, _).
mineVahend(Start, End, rongiga) :- rongiga(Start, End, _, _, _); rongiga(End, Start, _, _, _).
mineVahend(Start, End, bussiga) :- bussiga(Start, End, _, _, _); bussiga(End, Start, _, _, _).
mineVahend(Start, End, laevaga) :- laevaga(Start, End, _, _, _); laevaga(End, Start, _, _, _).


mineHind(Start, End, Price) :-
    lennukiga(Start, End, Price, _, _);
    rongiga(Start, End, Price, _, _);
    bussiga(Start, End, Price, _, _);
    laevaga(Start, End, Price, _, _);
    lennukiga(End, Start, Price, _, _);
    rongiga(End, Start, Price, _, _);
    bussiga(End, Start, Price, _, _);
    laevaga(End, Start, Price, _, _).


mineStartToEnd(Start, End, StartTime, EndTime) :-
    (lennukiga(Start, End, _, StartTime, EndTime);
    rongiga(Start, End, _, StartTime, EndTime);
    bussiga(Start, End, _, StartTime, EndTime);
    laevaga(Start, End, _, StartTime, EndTime);
    lennukiga(End, Start, _, StartTime, EndTime);
    rongiga(End, Start, _, StartTime, EndTime);
    bussiga(End, Start, _, StartTime, EndTime);
    laevaga(End, Start, _, StartTime, EndTime)).


mineAeg(Start, End, Price, Time) :-
    (lennukiga(Start, End, Price, X, Y);
    rongiga(Start, End, Price, X, Y);
    bussiga(Start, End, Price, X, Y);
    laevaga(Start, End, Price, X, Y);
    lennukiga(End, Start, Price, X, Y);
    rongiga(End, Start, Price, X, Y);
    bussiga(End, Start, Price, X, Y);
    laevaga(End, Start, Price, X, Y)),
    aegade_vahe(X, Y, Time).


reisi(Start, End) :-
    mineHind(Start, End, _).


reisi(Start, End) :-
%    (retract(lennukiga(Start, X));
%    retract(laevaga(Start, X));
%    retract(rongiga(Start, X));
%    retract(bussiga(Start, X))),
%    reisi(Start, X),
%    reisi(X, End).
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
    path3(Stop, Finish, [Stop | Visited], Next, Price),
    Summa is +(Trip, Price).


reisi(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price).

min_list([Head], Head).

min_list([Head, Head2|Tail], Minimum) :-
    (Head >= Head2, min_list([Head2|Tail], Minimum));
    (Head < Head2, min_list([Head|Tail], Minimum)).


trips_to_best(Start, End, BestRoad, BestPrice) :-
    findall(Price, reisi(Start, End, _, Price), List),
    min_list(List, BestPrice),
    !,
    reisi(Start, End, BestRoad, BestPrice).


odavaim_reis(Start, End, BestRoad, BestPrice) :-
    trips_to_best(Start, End, BestRoad, BestPrice).


path4(Start, Stop, _, mine(Start, Stop, Transport), Hind, time(0, 0, 0), Stop) :- mineVahend(Start, Stop, Transport),  mineHind(Start, Stop, Hind).
path4(Start, Finish, Visited, mine(Start, Stop, Transport, Next), Summa, SumTime, NextStop) :-
    mineVahend(Start, Stop, Transport),
    mineAeg(Start, Stop, Trip, Time),
    not(member(Stop, Visited)),
    path4(Stop, Finish, [Stop | Visited], Next, Price, NextSumTime, NextStopFuture),
    !,
    mineVahend(Start, NextStop, _),
    mineVahend(NextStop, NextStopFuture, _),
    mineStartToEnd(Start, NextStop, _, OneEnd),
    mineStartToEnd(NextStop, NextStopFuture, OneStart, _),
    aegade_vahe(OneEnd, OneStart, Delta),
    time(H, _, _) = Delta,
    ((H < 1, aegade_vahe(time(24, 0, 0), Delta, X), sum_time(Time, X, Y), sum_time(NextSumTime, Y, SumTime));(H > 1, sum_time(NextSumTime, Time, SumTime))),
    Summa is +(Trip, Price).

trips_to_fastest(Start, End, Road, Price) :-
    path4(Start, End, [Start], Road, Price, SumTime, _),
    write(SumTime).


lyhim_reis(Start, End, Road, Price) :-
    trips_to_fastest(Start, End, Road, Price).


sum_time(Aeg1, Aeg2, Aeg3):-
    time(H1, M1, S1) = Aeg1,
    time(H2, M2, S2) = Aeg2,
    time(H3, M3, S3) = Aeg3,
    X is S2 + S1,
    ((X >= 60, S3 is X - 60, F1 is 1); (X < 60, S3 is X, F1 is 0)),
    Y is M2 + M1 + F1,
    ((Y >= 60, M3 is Y - 60, F2 is 1); (Y < 60, M3 is Y, F2 is 0)),
    H3 is H2 + H1 + F2.

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
