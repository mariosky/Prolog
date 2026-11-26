:- use_module(library(files)).
:- use_module(library(lists)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).


% Una orden produce un término que representa una acción.
orden(mirar) --> [mira].
orden(ir(Direccion)) --> [ve, al], direccion(Direccion).
orden(ir(Direccion)) --> [ir, al], direccion(Direccion).
orden(tomar(Objeto)) --> [toma], grupo_nominal(Objeto).
orden(abrir_puerta) --> [abre, la, puerta].
orden(inventario) --> [muestra, el, inventario].
orden(salir) --> [salir].

% Un grupo nominal tiene un determinante y un sustantivo
% que concuerdan en género.
grupo_nominal(Objeto) -->
    determinante(Genero),
    sustantivo(Genero, Objeto).

determinante(femenino) --> [la].
determinante(masculino) --> [el].

sustantivo(femenino, llave) --> [llave].
sustantivo(femenino, nota) --> [nota].

direccion(norte) --> [norte].
direccion(sur)   --> [sur].
direccion(este)  --> [este].
direccion(oeste) --> [oeste].


palabras(Palabras) -->
    espacios,
    lista_palabras(Palabras).

lista_palabras([Palabra|Resto]) -->
    palabra(Caracteres),
    { atom_chars(Palabra, Caracteres) },
    despues_palabra(Resto).
lista_palabras([]) --> [].

despues_palabra(Resto) -->
    espacio, espacios, lista_palabras(Resto).
despues_palabra([]) --> [].

palabra([C|Cs]) --> caracter_palabra(C), resto_palabra(Cs).

resto_palabra([C|Cs]) --> caracter_palabra(C), resto_palabra(Cs).
resto_palabra([]) --> [].

caracter_palabra(C) -->
    [C],
    { C \= ' ', C \= '\t', C \= '\n', C \= '\r' }.

espacios --> espacio, espacios.
espacios --> [].

espacio --> " ".
espacio --> "\t".
espacio --> "\n".
espacio --> "\r".


interpretar(Linea, Accion) :-
    phrase(palabras(Palabras), Linea),
    phrase(orden(Accion), Palabras).

% Predicado principal para leer y tokenizar
leer_comando(Linea) :-
    get_line_to_chars(user_input, Linea, []).

command_loop :-
    repeat,
    format("Dame un comando:~n", []), 
    leer_comando(Comando),
    interpretar(Comando, Accion),
    format("~s ~w ~n", [Comando, Accion]),  
    !.

loop :-
    repeat,
    format("Dame un comando:~n", []),
    leer_comando(Linea),
    (   interpretar(Linea, Accion)
    ->  (   Accion == salir
        ->  !
        ;   (   call(Accion)
            ->  true
            ;   format("No se pudo realizar la acción ~w.~n", [Accion])
            ),
            fail
        )
    ;   format("No entendí el comando: ~w ~n", [Accion]),
        fail
    ).
