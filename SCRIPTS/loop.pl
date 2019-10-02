isEnd(X, Y):- X \= Y.
loop(X, Y) :- write(X), isEnd(X, Y), loop(X+1, Y).