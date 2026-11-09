
:- dynamic conocido/2.

%=========================
% Reglas de producción 
%=========================

regla(aprobado, [
    edad_apta,
    ingresos_suficientes,
    empleo_estable,
    buen_historial,
    deuda_aceptable
]).

regla(edad_apta, [
    dato(edad, E),
    evaluar(entre(E, 18, 58))
]).

regla(ingresos_suficientes, [
    dato(ingresos, I),
    evaluar(I >= 12000)
]).

regla(empleo_estable, [
    dato(antiguedad, A),
    evaluar(A >= 12)
]).

regla(buen_historial, [
    dato(historial, bueno)
]).

regla(deuda_aceptable, [
    dato(ingresos, I),
    dato(deudas, D),
    dato(cuota, C),
    evaluar(D + C =< 0.40 * I)
]).

%=================================
% Funciones auxiliares para 
% Validar las reglas del negocio.
%=================================

probar(dato(Campo, Valor)) :-
    !,
    obtener(Campo, Valor).

probar(evaluar(Condicion)) :-
    !,
    comprobar(Condicion).

probar(Objetivo) :-
    regla(Objetivo, Condiciones),
    probar_todas(Condiciones).

probar_todas([]).

probar_todas([Primera|Resto]) :-
    probar(Primera),
    probar_todas(Resto).

comprobar(entre(X, Min, Max)) :-
    between(Min, Max, X).

comprobar(Comparacion) :-
    Comparacion =.. [Operador, _, _],
    memberchk(Operador, [>=, =<, >, <, =:=, =\=]),
    call(Comparacion).

%=====================================
% Meta: Evaluar el perfil del crédito
%=====================================

evaluar :-
    retractall(conocido(_, _)),
    regla(aprobado, Requisitos),
    nl,
    writeln('=== EVALUACION DE CREDITO ==='),
    nl,
    revisar(Requisitos, Fallas),
    nl,
    ( Fallas = [] ->
        writeln('RESULTADO: APROBADO')
    ;
        writeln('RESULTADO: RECHAZADO'),
        format('Criterios no cumplidos: ~w~n',
               [Fallas])
    ).

%====================================
% Revisar que las reglas se cumplan 
%====================================

revisar([], []).

revisar([Regla|Resto], Fallas) :-
    ( probar(Regla) ->
        format('~w: CUMPLE~n', [Regla]),
        Fallas = OtrasFallas
    ;
        format('~w: NO CUMPLE~n', [Regla]),
        Fallas = [Regla|OtrasFallas]
    ),
    revisar(Resto, OtrasFallas).

%========================================
% Recuperar dato, de la KB o del usuario.
%========================================

obtener(Campo, Valor) :-
    conocido(Campo, Guardado),
    !,
    Valor = Guardado.

obtener(Campo, Valor) :-
    pregunta(Campo, Texto),
    format('~w: ', [Texto]),
    read(Respuesta),
    ( valido(Campo, Respuesta) ->
        assertz(conocido(Campo, Respuesta)),
        Valor = Respuesta
    ;
        writeln('Respuesta invalida'),
        obtener(Campo, Valor)
    ).
% =====================================
% PREGUNTAS AL USUARIO
% =====================================

pregunta(edad, 'Edad en años').
pregunta(ingresos, 'Ingreso mensual en pesos').
pregunta(antiguedad, 'Antiguedad laboral en meses').
pregunta(historial, 'Historial crediticio (bueno/regular/malo)').
pregunta(deudas, 'Pagos mensuales de deudas actuales').
pregunta(cuota, 'Pago mensual del nuevo credito').

%=======================================
% Validación de entrada del usuario.
%=======================================

valido(edad, X) :-
    integer(X), between(1,18, X).

valido(historial, X) :-
    memberchk(X, [bueno, regular, malo]).

valido(Campo, X) :-
    memberchk(Campo,
       [ingresos, antiguedad, deudas, cuota]),
    number(X), X >= 0.