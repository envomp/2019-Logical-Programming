% kommentaar
/*
["Ago", "Peeter", "Mai", [peep, []], 89] list
[El1, El2 |_]
[_|Tail] <- eeldatalse vähemalt ühte elementi
[Tail] <- cõib ka 0 olla

predikaat/n

, -ja
; - või
not - eitus
-> - implikatsioon

repeat - kutsub uuesti
! -kärpimine, reeglist ära lõigata mingi usa
fail - kustutab vahetulemuse ja hüppab algusesse

consult - saab faili laadida
reconsult- taaskasutada sama fail
get - lugeda sümbol
put - väljastab sümboli
write - väljastab sõne

div - jagamine
max - maksimum mitmest elemendist
min - minimum mitmest elemendist

term_variables(+Term, -List).
string_to_atom(?String, ?Atom).
string_to_list(?String, ?List).
string_to_length(+String, -Length).
string_concat(?String1, ?String2, ?String3).
sub_stirng(+String, ?Start, ?Length, ?After, ?Substring).

findall(+Template, +Goal, -Bag).
bagof(+Template, +Goal, -Bag).

foo(a, b, c).
foo(a, b, d).
foo(b, c, e).
foo(b, c, f).
foo(c, c, g).

bagof(C, foo(A, B, C), Cs).
A = a, B = b, C=G308, Cs = [c, d] ;
A = b, B = c, C=G308, Cs = [e, f] ;
A = c, B = c, C=G308, Cs = [g]

Dünaamilised muutujad.
assert(Clause). - Loob predikaadi.
asserta(Clause). - Lisatakse mälus ette. (Kohe kätte saadav)
assertz(Clause). - Lisiatakse mälus järgi. (Viimane kätte saadav)

retract(Clause). - esimene match kustutatakse
retractall(Clause). - kõik kustutatakse
abolish()

Term =.. List

foo(hello, X) =.. List.
List = [foo, hello, X]

Term =.. [baz, foo(1)].
Term = baz(foo(1))

*/

male(ago).
male(ago2).
male(ago3).
male(ago4).
male(ago5).
female(kadri).
female(kadri2).
female(kadri3).
female(kadri4).
female(kadri5).

mother(kadri, kadri2).
mother(kadri2, kadri3).
mother(kadri3, kadri4).
mother(kadri4, kadri5).

married(kadri, ago).
married(kadri2, ago2).
married(kadri3, ago3).
married(kadri4, ago4).
married(kadri5, ago5).

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
    brother(Parent, Vend),
    Onu == Vend,
    male(Vend).

grandfather(Mina, Vanaisa) :-
    mother(Mina, Ema), father(Ema, Vanaisa), male(Vanaisa);
    father(Mina, Ema), father(Ema, Vanaisa), male(Vanaisa).

grandmother(Mina, Vanaema) :-
    mother(Mina, Ema), mother(Ema, Vanaema), female(Vanaema);
    father(Mina, Ema), mother(Ema, Vanaema), female(Vanaema).

ancestor(Child, Parent) :- mother(Child, Parent) ; father(Child, Parent).

ancestor(Child, Parent) :-
    (mother(Child, X) ; father(Child, X)),
    ancestor(X, Parent).

male_ancestor(Child, Parent) :- father(Child, Parent).

male_ancestor(Child, Parent) :-
    ancestor(Child, X),
    male_ancestor(X, Parent).

male_ancestor1(Child, Parent) :- ancestor(Child, Parent), male(Parent).


female_ancestor(Child, Parent) :- mother(Child, Parent).

female_ancestor(Child, Parent) :-
    ancestor(Child, X),
    female_ancestor(X, Parent).


ancestor1(Child, Parent, N) :- N == 1, (mother(Child, Parent) ; father(Child, Parent)).

ancestor1(Child, Parent, N) :-
    X is -(N, 1),
    (mother(Child, Y) ; father(Child, Y)),
    ancestor1(Y, Parent, X).


count_children(Parent, N) :-
    bagof(Children, (mother(Children, Parent) ; father(Children, Parent)), List),
    length(List, N).

ancestor2(Child, Parent, X) :- count_children(Parent, Y), Y > X.

ancestor2(Child, Parent, N) :-
    (mother(Child, Y) ; father(Child, Y)),
    ancestor2(Y, Parent, N).
