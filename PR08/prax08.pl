is_a(roovloomad, elusolend).
is_a(mitte-roovloomad, elusolend).
is_a(veeimetajad, roovloomad).
is_a(kalad, roovloomad).
is_a(saarmas, veeimetajad).
is_a(kobras, veeimetajad).
is_a(ahven, kalad).
is_a(haug, kalad).
is_a(zooplankton, mitte-roovloomad).
is_a(veetaimed, mitte-roovloomad).
is_a(vesikatk, veetaimed).
is_a(vetikas, veetaimed).
is_a(a1, a).
is_a(a2, a).
is_a(a3, a).
is_a(a7, a).
is_a(a8, a).
is_a(b1, b).

eats(zooplankton, veetaimed).
eats(kalad, zooplankton).
eats(veeimetajad, kalad).
eats(b, a).

get_len([], 0).
get_len([_|Tail], Count) :- get_len(Tail, Sum), Count is Sum + 1.


terminal(Leaf, Leaf) :- not(is_a(_, Leaf)).
terminal(Class, Leaf) :- is_a(SubClass, Class), terminal(SubClass, Leaf).

count_terminals(Class, List, Count) :- findall(Leaf, terminal(Class, Leaf), List), get_len(List, Count).

extinction(Predator, DeadTopPredators, DeadCount) :- not(eats(_, Predator)), count_terminals(Predator, DeadTopPredators, DeadCount).
extinction(Pray, DeadSpieces, DeadCount) :- eats(Predator, Pray),
    extinction(Predator, DeadLast, Count),
    count_terminals(Pray, DeadLeaves, DeadLeavesCount),
    append(DeadLast, DeadLeaves, DeadSpieces),
    DeadCount is Count + DeadLeavesCount.



:-dynamic best/3.


cycle :- eats(_, Pray), extinction(Pray, TempSpieces, TempCount),
    ((best(_, _, Best), TempCount > Best, retractall(best(_, _, _)), asserta(best(Pray, TempSpieces, TempCount))); true).


find_most_sensitive_species(Spieces, DeadCount, DeadSpieces) :- asserta(best(bump, [], 0)), findall(_, cycle, _), best(Spieces, DeadSpieces, DeadCount).

