
liitlause --> (tuvi, sidesona, tuvi) ; (tuvi, sidesona, lihtlause).
liitkusilause --> kusiaatom, lihtlisa, kusialgusliit, kusilisa, kusilopp.

lihtlisa --> tuvi ; (tuvi, sidesona, lihtlisa).
kusilisa --> tuvi ; (tuvi, sidesona, kusilisa).

lihtlause --> lihtlisa, (lihtlopp ; []).
lihtkusilause --> kusialgus, tuvi, kusilopp.

tuvi --> pretuvi, posttuvi.
pretuvi --> (((([] ; osastav), nimisonafraas), tegusonafraas) ; (tegusonafraas)).
posttuvi --> ([] ; nimisonafraas), ([] ; liitnimisona), ([] ; nimisonafraas).

nimisonafraas --> ([] ; omadussonafraas), nimisona.
omadussonafraas --> ([] ; maarsona), omadussona.
tegusonafraas --> ([]; [ei]), tegusona , ([] ; nimisonafraas ; omadussonafraas).

kusiaatom --> [kui].
kusialgus --> [kas].
kusialgusliit --> ["siis kas"].
kusilopp --> ["?"].
lihtlopp --> ["."] ; ["!"].
liitnimisona --> [sobimatuse].
omadussona --> [kole] ; [ilus] ; [lyhike] ; [must] ; [].
maarsona --> [liiga] ; [kivile] ; [upakile].
osastav --> [pakapiku] ; [tema] ; [veerevale].
nimisona --> [sammal] ; [uhkus] ; [inimene] ; [pakapiku] ; [tema] ; [habe] ; [jouluvanaks] ; [raha] ; [volad] ; [koer] ; [kass].
tegusona --> [on] ; [kasvab] ; [elab] ; [tingib] ; [pohjustab] ; [tuleb] ; [laheb] ; [jaavad] ; [haugub] ; [nurrub] ; [kasva] ; [ajab] ; [tuleb] ; [laheb] ; [jaavad].
sidesona --> [ja] ; [voi] ; [",sest"] ; [","].


%liitlause --> lihtlause, uhend, (lihtlause ; liitlause).
%lihtlause --> nimisonafraas, tegusonafraas.
%nimisonafraas --> maarsonafraas, nimisona.
%maarsonafraas --> omadussona, maarsona ; [].
%tegusonafraas --> meetod, tegusona, maarsonafraas.
%
%maarsona --> [kivile] ; [upakile].
%omadussona --> [veerevale] ; [].
%tegusona --> [kasva] ; [ajab] ; [tuleb] ; [laheb] ; [jaavad].
%nimisona --> [sammal] ; [uhkus] ; [raha] ; [volad].
%uhend --> [','].
%meetod --> [ei] ; [].