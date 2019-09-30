laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).

bussiga(tallinn, riia, 300).

rongiga(riia, berlin, 680).

lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).


reisi(Start, End) :-
    lennukiga(Start, End, X);
    rongiga(Start, End, X);
    bussiga(Start, End, X);
    laevaga(Start, End, X);
    lennukiga(End, Start, X);
    rongiga(End, Start, X);
    bussiga(End, Start, X);
    laevaga(End, Start, X).


reisi(Start, End) :-
    (retract(lennuk(Start, X));
    retract(laevaga(Start, X));
    retract(rongiga(Start, X));
    retract(bussiga(Start, X))),
    reisi(Start, X),
    reisi(X, End).

reisi(Start, End, []) :- reisi(Start, End).

reisi(Start, End, Road) :-
    reisi(Start, X),
    !, assert(reisi(Start, End)),
    append([X], NewRoad, Road),
    reisi(X, End, NewRoad).
