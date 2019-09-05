% ja - ,
% või - ;

ema(liia, juku).
ema(kati, liia).
isa(ken, karin).
isa(juhan, liia).

vanem(X, Y) :- isa(X, Y); ema(X, Y).
vanavanem(X, Z) :- vanem(X, Y), vanem(Y, Z).

