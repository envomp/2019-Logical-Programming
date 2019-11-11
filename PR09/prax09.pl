liitlause --> (tuvi, sidesona, tuvi) ; (tuvi, sidesona, lihtlause).
liitkusilause --> kusiaatom, lihtlisa, kusialgusliit, kusilisa, kusilopp.

lihtlisa --> tuvi ; (tuvi, sidesona, lihtlisa).
kusilisa --> tuvi ; (tuvi, sidesona, kusilisa).

lihtlause --> lihtlisa, (lihtlopp ; []).
lihtkusilause --> kusialgus, tuvi, kusilopp.

tuvi --> pretuvi, posttuvi.
pretuvi --> (((([] ; osastav), nimisonafraas), tegusonafraas) ; (tegusonafraas)).
posttuvi --> ([] ; nimisonafraas), ([] ; liitnimisona), ([] ; nimisonafraas), ([] ; nimisonafraas), ([] ; nimisonafraas).

nimisonafraas --> ([] ; omadussonafraas), nimisona.
omadussonafraas --> ([] ; maarsona), omadussona.
tegusonafraas --> ([]; [ei]), tegusona , ([] ; nimisonafraas ; omadussonafraas).


%liitlause --> lihtlause, uhend, lihtlause.
%liitlause --> liitlause, uhend, lihtlause.
%uhend --> [','].
%lihtlause --> nimisonafraas, tegusonafraas.
%nimisonafraas --> maarsonafraas, nimisona.
%maarsonafraas --> omadussona, maarsona ; [].
%maarsona --> [kivile] ; [upakile].
%nimisona --> [sammal] ; [uhkus] ; [raha] ; [volad].
%omadussona --> [veerevale] ; [].
%tegusona --> [kasva] ; [ajab] ; [tuleb] ; [laheb] ; [jaavad].
%tegusonafraas --> meetod, tegusona, maarsonafraas.
%meetod --> [ei] ; [].

kusiaatom --> [kui].
kusialgus --> [kas].
kusialgusliit --> ["siis kas"].
kusilopp --> ["?"].
lihtlopp --> ["."] ; ["!"].
liitnimisona --> [sobimatuse].
omadussona --> [kole] ; [ilus] ; [lyhike] ; [must].
maarsona --> [liiga].
osastav --> [pakapiku] ; [tema].
nimisona --> [inimene] ; [pakapiku] ; [tema] ; [habe] ; [jouluvanaks] ; [raha] ; [volad] ; [koer] ; [kass].
tegusona --> [on] ; [kasvab] ; [elab] ; [tingib] ; [pohjustab] ; [tuleb] ; [laheb] ; [jaavad] ; [haugub] ; [nurrub].
sidesona --> [ja] ; [voi] ; [",sest"] ; [","].

