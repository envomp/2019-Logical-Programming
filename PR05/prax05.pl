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

lyhim_reis(Start, End, Road, Price) :-
    pass.


sum_time(Aeg1, Aeg2, Aeg3):-
    time(H1,M1,S1) = Aeg1,
    time(H2,M2,S2) = Aeg2,
    time(H3, M3, S3) = Vahe,
    X is S2 - S1,
    ((X < 0, S3 is X + 60, F1 is 1); (X >= 0, S3 is X, F1 is 0)),
    Y is M2 - M1 - F1,
    ((Y < 0, M3 is Y + 60, F2 is 1); (Y >= 0, M3 is Y, F2 is 0)),
    Z is H2 - H1 - F2,
    ((Z < 0, H3 is Z + 24); (Z >= 0, H3 is Z)).

aegade_vahe(Aeg1, Aeg2, Vahe):-
    time(H1,M1,S1) = Aeg1,
    time(H2,M2,S2) = Aeg2,
    time(H3, M3, S3) = Vahe,
    X is S2 - S1,
    ((X < 0, S3 is X + 60, F1 is 1); (X >= 0, S3 is X, F1 is 0)),
    Y is M2 - M1 - F1,
    ((Y < 0, M3 is Y + 60, F2 is 1); (Y >= 0, M3 is Y, F2 is 0)),
    Z is H2 - H1 - F2,
    ((Z < 0, H3 is Z + 24); (Z >= 0, H3 is Z)).
