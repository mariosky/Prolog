link(a,b).
link(c,a). 
link(b, c). 



path(Origen, Destino, [(Origen,Destino)], _) :-
     link(Origen,Destino).

path(Origen, Destino, [(Origen, Otro)|Resto], Visitados) :- 
    link(Origen, Otro),
    format("~w ~n", [Visitados]), 
    NuevosVisitados = [Otro | Visitados],
    path(Otro, Destino, Resto, NuevosVisitados).
