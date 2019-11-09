liitlause --> (tuvi, sidesona, tuvi) ; (tuvi, sidesona, lihtlause).
liitkusilause --> kusiaatom, lihtlisa, kusialgusliit, kusilisa, kusilopp.

lihtlisa --> tuvi ; (tuvi, sidesona, lihtlisa).
kusilisa --> tuvi ; (tuvi, sidesona, kusilisa).

lihtlause --> lihtlisa, lihtlopp.
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
omadussona --> [kole] ; [ilus] ; [lyhike] ; [must].
maarsona --> [liiga].
osastav --> [pakapiku] ; [tema].
nimisona --> [inimene] ; [pakapiku] ; [tema] ; [habe] ; [jouluvanaks] ; [raha] ; [volad].
tegusona --> [on] ; [kasvab] ; [elab] ; [tingib] ; [pohjustab] ; [tuleb] ; [laheb] ; [jaavad].
sidesona --> [ja] ; [voi] ; [sest] ; [","].
