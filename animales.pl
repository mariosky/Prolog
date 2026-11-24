% Representación del conocimiento

:- dynamic(isa/2).
% isa/2: X is a kind of Y
isa(gato, mamifero).
isa(perro, mamifero).
isa(gato, mamifero).
isa(águila, ave).
isa(mamifero,animal).
isa(ave, animal).
isa(planta, ser_vivo).
isa(animal, ser_vivo).
isa(pingüino, ave). 
isa(pingüino,no_vuela).

has_property(animal, se_alimenta, true).
has_property(mamifero, respira, true).
has_property(mamifero, sangre_caliente, true).
has_property(ave, vuela, true).
has_property(ave, tiene_alas, true).
has_property(ave, pone_huevos, true).
has_property(no_vuela, no_puede_volar, true).
has_property(pingüino, nada, true). % Specific to penguin
has_property(pingüino, vuela, false).
has_property(ave, nada, false).

property(Thing, Prop) :-
    has_property(Thing, Prop, true).

property(Thing, Prop) :-
	isa(Thing, Superclass),
    property(Superclass, Prop),
    \+ has_property(Thing, Prop, _).
