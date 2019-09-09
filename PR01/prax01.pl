male(ago).
male(karl).
male(enrico).
male(aron).
female(kadri).
female(helin).
female(helin2).
female(kass).
married(helin, ago).
married(ago, helin).
mother(kadri, helin).
mother(enrico, helin).
mother(helin, helin2).

father(Mina, Isa) :- 
    mother(Mina, Ema),
    male(Isa),
    female(Ema),
    married(Ema, Isa).

brother(Mina, Vend) :-
    mother(Mina, Ema),
    father(Mina, Isa),
    mother(Vend, Ema),
    father(Vend, Isa),
    Mina \= Vend,
    male(Vend).
    

sister(Mina, Ode) :-
    mother(Mina, Ema),
    father(Mina, Isa),
    mother(Ode, Ema),
    father(Ode, Isa),
    Mina \= Ode,
    female(Ode).

aunt(Mina, Tadi) :-
    (mother(Mina, Parent); father(Mina, Parent)),
    sister(Parent, Tadi),
    female(Tadi).


uncle(Mina, Onu) :-
    (mother(Mina, Parent); father(Mina, Parent)),
    sister(Parent, Vend),
    Onu == Vend,
    male(Vend).

grandfather(Mina, Vanaisa) :-
    mother(Mina, Ema), father(Ema, Vanaisa), male(Vanaisa);
    father(Mina, Ema), father(Ema, Vanaisa), male(Vanaisa).

grandmother(Mina, Vanaema) :-
    mother(Mina, Ema), mother(Ema, Vanaema), female(Vanaema);
    father(Mina, Ema), mother(Ema, Vanaema), female(Vanaema).
