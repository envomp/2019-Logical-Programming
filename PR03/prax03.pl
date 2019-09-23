my_member(_, []) :- fail.
my_member(El, [El|_]).
my_member(El, [_|Tail]) :- my_member(El,Tail).

viimane_element(Head,[Head]).
viimane_element(Head,[_|Tail]) :- viimane_element(Head,Tail).

suurim([],[]).
suurim([H],[H]).
suurim([H1,H2|Tail],[M|U]) :-
    M is max(H1,H2),
    append([H2],Tail ,Answer),
    suurim(Answer,U).


paki([],[]).
paki([H],[H]).
paki([Head1,Head2|Tail], [Head1|U]) :-
    Head1 == Head2,
    paki([Head2|Tail],[Head1|U]);
    Head1 \= Head2,
    paki([Head2|Tail], U).


duplikeeri([],[]).
duplikeeri([H1| Tail1], [H1,H1|Tail2]):- duplikeeri(Tail1, Tail2).


helper(X, Element, Answer) :- X \= 0, Y is X - 1, append([Element], Answer2, Answer), helper(Y, Element, Answer2); Answer = [], X == 0.

kordista([], _, []).
kordista([Head|Tail], X, Vastus) :- helper(X, Head, Answer), append(Answer, Answer2, Vastus), kordista(Tail, X, Answer2).


paaritu_arv(X) :- 1 is X rem 2.
paaris_arv(X) :- 0 is X rem 2.
suurem_kui(X, Number) :- X > Number.

vordle_predikaadiga([], _, []).
vordle_predikaadiga([Head|Tail], [Method], Answer) :-
        Term =.. [Method, Head],
        write(Term),
        nl,
        Term,
        vordle_predikaadiga(Tail, [Method], Vastus),
        append([Head], Vastus, Answer),
        write(Answer).

vordle_predikaadiga([Head|Tail], [Method], Vastus) :-
        vordle_predikaadiga(Tail, [Method], Vastus).

vordle_predikaadiga([Head|Tail], [Method, X], Answer) :-
        Term =.. [Method, Head, X],
        write(Term),
        nl,
        Term,
        vordle_predikaadiga(Tail, [Method, X], Vastus),
        append([Head], Vastus, Answer),
        write(Answer).

vordle_predikaadiga([Head|Tail], [Method, X], Vastus) :-
        vordle_predikaadiga(Tail, [Method, X], Vastus).

