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

