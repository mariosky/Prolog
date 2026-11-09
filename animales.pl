% Representación del Conocimiento

% isa/2: X is a kind of Y
isa(gato, mamifero).
isa(perro, mamifero).
isa(ave, animal).
isa(mamifero, animal).
isa(planta, ser_vivo).
isa(animal, ser_vivo).
isa(pingüino, ave).
isa(pingüino, no_vuela).


% has_property/3: X has property P with value V
has_property(animal, se_alimenta, true).
has_property(mamifero, respira, aire).
has_property(mamifero, sangre_caliente, true).
has_property(ave, tiene_alas, true).
has_property(ave, pone_huevos, true).
has_property(no_vuela, puede_volar, false).
has_property(pingüino, nada, true). % Specific to penguin
has_property(bird, nada, false).

property(Thing, Prop, Value) :-
    has_property(Thing, Prop, Value).

property(Thing, Prop, Value) :-
    isa(Thing, Superclass),
    %\+ has_property(Thing, Prop, _),
    property(Superclass, Prop, Value),
    \+ has_property(Thing, Prop, _).

%Origen