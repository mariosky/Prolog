% :- dynamic posicion_actual/1, inventario/1, estado_puerta/1.

:- dynamic posicion_actual/1.
:- dynamic inventario/1.
:- dynamic estado_puerta/1.

% --- MAPA DEL JUEGO (Conexiones entre habitaciones) ---
% formato: conectar(Habitacion1, Direccion, Habitacion2)
conectar(vestibulo, norte, pasillo_central).
conectar(pasillo_central, sur, vestibulo).

conectar(pasillo_central, este, pasillo_este).
conectar(pasillo_este, oeste, pasillo_central).

conectar(pasillo_central, oeste, pasillo_oeste).
conectar(pasillo_oeste, este, pasillo_central).

conectar(pasillo_central, norte, puerta_salida).
conectar(puerta_salida, sur, pasillo_central).

% --- UBICACIÓN DE OBJETOS ---
% formato: objeto_en(Objeto, Habitacion)
:- dynamic objeto_en/2.
objeto_en(llave, pasillo_este).
objeto_en(nota, pasillo_oeste).

% --- ESTADO INICIAL ---
posicion_actual(vestibulo).
estado_puerta(cerrada).

% --- COMANDOS DEL JUEGO ---

% 1. Iniciar el juego
iniciar :-
    retractall(posicion_actual(_)),
    retractall(inventario(_)),
    retractall(estado_puerta(_)),
    retractall(objeto_en(_,_)),
    assertz(posicion_actual(vestibulo)),
    assertz(estado_puerta(cerrada)),
    assertz(objeto_en(llave, pasillo_este)),
    assertz(objeto_en(nota, pasillo_oeste)),
    format('===================================================\n'),
    format('      BIENVENIDO AL JUEGO DE LOS PASILLOS         \n'),
    format('===================================================\n'),
    format('Te despiertas en un vestíbulo oscuro. Debes escapar.\n'),
    format('Comandos disponibles:\n'),
    format('  mirar.               - Describe dónde estás.\n'),
    format('  ir(Direccion).       - Muévete al norte, sur, este u oeste.\n'),
    format('  tomar(Objeto).       - Recoge un objeto del suelo.\n'),
    format('  inventario.          - Muestra lo que llevas contigo.\n'),
    format('  abrir_puerta.        - Intenta abrir la puerta de salida.\n'),
    format('===================================================\n\n'),
    mirar.

% 2. Describir el entorno
mirar :-
    posicion_actual(Habitacion),
    describir(Habitacion),
    listar_objetos(Habitacion), !.

% Descripciones de los lugares
describir(vestibulo) :-
    format('Estás en el vestíbulo de entrada. Al norte hay un pasillo central.\n').
describir(pasillo_central) :-
    format('Estás en el pasillo central. Hay caminos hacia el norte, sur, este y oeste.\n').
describir(pasillo_este) :-
    format('Estás en el pasillo este. Se siente una ligera corriente de aire.\n').
describir(pasillo_oeste) :-
    format('Estás en el pasillo oeste. Las paredes están llenas de moho.\n').
describir(puerta_salida) :-
    estado_puerta(cerrada),
    format('Estás frente a la gran puerta de salida. Está fuertemente CERRADA con llave.\n').
describir(puerta_salida) :-
    estado_puerta(abierta),
    format('Estás frente a la puerta de salida. Está ABIERTA. ¡La libertad te espera!\n').

% Listar objetos en el suelo
listar_objetos(Habitacion) :-
    objeto_en(Objeto, Habitacion),
    format('Ves algo aquí: un(a) ~w.\n', [Objeto]), fail.
listar_objetos(_).

% 3. Moverse
ir(Direccion) :-
    posicion_actual(Aqui),
    conectar(Aqui, Direccion, Alli),
    retract(posicion_actual(Aqui)),
    assertz(posicion_actual(Alli)),
    format('Te mueves hacia el ~w...\n\n', [Direccion]),
    mirar, !.
ir(_) :-
    format('No puedes ir en esa dirección.\n').

% 4. Tomar objetos
tomar(Objeto) :-
    posicion_actual(Aqui),
    objeto_en(Objeto, Aqui),
    retract(objeto_en(Objeto, Aqui)),
    assertz(inventario(Objeto)),
    format('Has recogido: ~w.\n', [Objeto]), !.
tomar(Objeto) :-
    format('No veo ningún ~w aquí.\n', [Objeto]).

% 5. Mostrar inventario
inventario :-
    format('Llevas contigo:\n'),
    forall(inventario(X), format('  - ~w\n', [X])).

% 6. Acciones especiales: Abrir la puerta y ganar
abrir_puerta :-
    posicion_actual(puerta_salida),
    inventario(llave),
    retract(estado_puerta(cerrada)),
    assertz(estado_puerta(abierta)),
    format('Metes la llave en la cerradura, gira con un clic... ¡La puerta se abre!\n'),
    format('¡HAS ESCAPADO CON ÉXITO! ¡Ganaste el juego!\n'), !.
abrir_puerta :-
    posicion_actual(puerta_salida),
    format('La puerta está cerrada. Necesitas una llave para abrirla.\n'), !.
abrir_puerta :-
    format('No hay ninguna puerta de salida aquí.\n').
