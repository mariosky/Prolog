
conc([], L, L) :- 
    format("Bajando L=~w~n", [L]).

conc([H|L1], L2, [H|L3]):-
    writeln([H|L3]),
    conc(L1,L2,L3), 
    writeln([H|L3]).