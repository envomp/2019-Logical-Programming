lind(hani). % fakt
lind(part).
roomaja(mutt).

lendab(X) :- roomaja(X) ; lind(X).
sureb(X) :- lendab(X).


% ja - ,
% või -s ;