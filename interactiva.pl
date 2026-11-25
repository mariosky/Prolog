
:- use_module(library(format)).
:- use_module(library(dcgs)).

command_loop :-
    repeat,
    format("Dame un comando", []), 
    read(X),
    /*
      logica aquí
    */
    format("~w~n", [X]),
    X = end,
    !.

limpiar :-
    put_code(27), format("[2J", []),
    put_code(27), format("[H", []),
    flush_output.
/*
oracion --> sujeto, predicado.
sujeto --> articulo, sustantivo.
predicado --> verbo, sujeto.
predicado --> verbo.
articulo --> [el].
articulo --> [la].
sustantivo --> [manzana].
sustantivo --> [hombre].
verbo --> [come].
*/

oracion --> sujeto(Num), predicado(Num).
sujeto(Num) --> articulo(Num,Gen), sustantivo(Num,Gen).
predicado(Num) --> verbo(Num), sujeto(_).
articulo(sing,fem)      -->     [la].
articulo(sing,masc)     -->     [el].
articulo(plural,fem)    -->     [las].
articulo(plural,masc)   -->     [los].
verbo(sing)             -->     [come].
verbo(plural)           -->     [comen].
sustantivo(sing,masc)   -->     [hombre].
sustantivo(sing,fem)    -->     [manzana].

