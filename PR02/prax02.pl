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

father(ago, ago2).
father(ago2, ago3).
father(ago3, ago4).
father(ago4, ago5).

ancestor(Child, Parent) :- mother(Child, Parent) ; father(Child, Parent).

ancestor(Child, Parent) :-
    (mother(Child, X) ; father(Child, X)),
    ancestor(X, Parent).

male_ancestor(Child, Parent) :- father(Child, Parent).

male_ancestor(Child, Parent) :-
    ancestor(Child, X),
    male_ancestor(X, Parent).

female_ancestor(Child, Parent) :- mother(Child, Parent).

female_ancestor(Child, Parent) :-
    ancestor(Child, X),
    female_ancestor(X, Parent).


ancestor1(Child, Parent, N) :- N == 0, ancestor(Child, Parent).

ancestor1(Child, Parent, N) :-
    ancestor(Child, X),
    ancestor1(Child, Parent, N - 1).


