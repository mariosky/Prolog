
:- use_module(library(format)).
:- use_module(library(charsio)).
:- use_module(library(dcgs)).

% Predicado principal para leer y tokenizar
leer_comando(Palabras) :-
    get_line_to_chars(user_input, Linea, []),
    phrase(oracion(Palabras), Linea).

% Gramática DCG
oracion([Palabra|Resto]) -->
    espacios,
    palabra(Chars),
    { Chars \= [], atom_chars(Palabra, Chars) },
    oracion(Resto).
oracion([]) -->
    espacios.

% Extrae caracteres que no sean espacios ni saltos de línea
palabra([C|Cs]) -->
    [C],
    { \+ char_type(C, whitespace) },
    palabra(Cs).
palabra([]) --> [].

% Consume espacios, tabulaciones y saltos de línea (\n)
espacios --> [C], { char_type(C, whitespace) }, espacios.
espacios --> [].

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

enter_command_loop :-
    repeat,
    format("Dame un comando", []), 
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

*/
