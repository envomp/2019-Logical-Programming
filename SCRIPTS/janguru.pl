kanguru(ago).
janes(helin).
naine(kadri).
tark(kadri).
isa(ago, kadri).
ema(helin, kadri).

tutar(X, Y) :- naine(X), isa(Y, X); ema(Y, X).
janguru(X, Y, Z) :- tutar(X, Y), tutar(X, Z), janes(Y), kanguru(Z).
filosoof(X, Y, Z) :- janguru(X, Y, Z), tark(X).
peatub(X, Y, Z) :- filosoof(X, Y, Z).
