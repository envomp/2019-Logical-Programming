
mineVahend(Start, End, lennukiga) :- lennukiga(Start, End, _); lennukiga(End, Start, _).
mineVahend(Start, End, rongiga) :- rongiga(Start, End, _); rongiga(End, Start, _).
mineVahend(Start, End, bussiga) :- bussiga(Start, End, _); bussiga(End, Start, _).
mineVahend(Start, End, laevaga) :- laevaga(Start, End, _); laevaga(End, Start, _).


mineHind(Start, End, Price) :-
    lennukiga(Start, End, Price);
    rongiga(Start, End, Price);
    bussiga(Start, End, Price);
    laevaga(Start, End, Price);
    lennukiga(End, Start, Price);
    rongiga(End, Start, Price);
    bussiga(End, Start, Price);
    laevaga(End, Start, Price).


reisi(Start, End) :-
    mineHind(Start, End, _).


reisi(Start, End) :-
    (retract(lennuk(Start, X));
    retract(laevaga(Start, X));
    retract(rongiga(Start, X));
    retract(bussiga(Start, X))),
    reisi(Start, X),
    reisi(X, End).


path(Start, Stop, _, mine(Start, Stop)) :- mineHind(Start, Stop, _).
path(Start, Finish, Visited, mine(Start, Stop, Next)) :-
    mineHind(Start, Stop, _),
    not(member(Stop, Visited)),
    path(Stop, Finish, [Stop | Visited], Next).

reisi(Start, End, Road) :-
    path(Start, End, [Start], Road).


path2(Start, Stop, _, mine(Start, Stop, Transport)) :- mineVahend(Start, Stop, Transport).
path2(Start, Finish, Visited, mine(Start, Stop, Transport, Next)) :-
    mineVahend(Start, Stop, Transport),
    not(member(Stop, Visited)),
    path2(Stop, Finish, [Stop | Visited], Next).


reisi_transpordiga(Start, End, Road) :-
    path2(Start, End, [Start], Road).


path3(Start, Stop, _, mine(Start, Stop, Transport), Hind) :- mineVahend(Start, Stop, Transport),  mineHind(Start, Stop, Hind).
path3(Start, Finish, Visited, mine(Start, Next), +(Trip, Price)) :-
    mineHind(Start, Stop, Trip),
    not(member(Stop, Visited)),
    path3(Stop, Finish, [Stop | Visited], Next, Price).


reisi(Start, End, Road, Cost) :-
    path3(Start, End, [Start], Road, Price),
    Cost is eval(Price).

























