laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).

bussiga(tallinn, riia, 300).

rongiga(riia, berlin, 680).

lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).


mineVahend(Start, End, lennukiga) :- lennukiga(Start, End, _).
mineVahend(Start, End, rongiga) :- rongiga(Start, End, _).
mineVahend(Start, End, bussiga) :- bussiga(Start, End, _).
mineVahend(Start, End, laevaga) :- laevaga(Start, End, _).


mineHind(Start, End, Price) :-
    lennukiga(Start, End, Price);
    rongiga(Start, End, Price);
    bussiga(Start, End, Price);
    laevaga(Start, End, Price).


reisi(Start, End) :-
    mineHind(Start, End, _).


reisi(Start, End) :-
    (retract(lennuk(Start, X));
    retract(laevaga(Start, X));
    retract(rongiga(Start, X));
    retract(bussiga(Start, X))),
    reisi(Start, X),
    reisi(X, End).

path(Node, Node, _, Node).
path(Start, Finish, Visited, mine(Start, Next)) :-
    mineHind(Start, Stop, _),
    not(member(Stop, Visited)),
    path(Stop, Finish, [Stop | Visited], Next).

reisi(Start, End, Road) :-
    path(Start, End, [Start], Road).


path2(Node, Node, _, Node).
path2(Start, Finish, Visited, mine(Start, Stop, Transport, Next)) :-
    mineVahend(Start, Stop, Transport),
    not(member(Stop, Visited)),
    path2(Stop, Finish, [Stop | Visited], Next).


reisi_transpordiga(Start, End, Road) :-
    path2(Start, End, [Start], Road).


path3(Node, Node, _, Node, 0).
path3(Start, Finish, Visited, mine(Start, Next), NewPrice) :-
    mineHind(Start, Stop, Trip),
    not(member(Stop, Visited)),
    NewPrice is +(Price, Trip),
    path3(Stop, Finish, [Stop | Visited], Next, Price).


reisi(Start, End, Road, Price) :-
    path3(Start, End, [Start], Road, Price).

























