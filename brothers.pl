:- use_module(library(lists)).

parent(tom, tim).
parent(tom, sue).
parent(pam, tim).
parent(pam, sue).
parent(pam, joe).
parent(pete, joe).



half_sibling(X,Y) :-
    parent(Z,X),
    parent(Z,Y),
    X @< Y,
    \+ sibling(X,Y).

sibling(X,Y) :-
    parent(Z,X),
    parent(Z,Y),
    parent(Q,X),
    parent(Q,Y),
    X @< Y,
    Z @< Q.

% Hermanos completos (comparten ambos padres)
% Gemini
full_sibling(X, Y) :-
    X @< Y,
    findall(Z, (parent(Z, X), parent(Z, Y)), Parents),
    length(Parents, 2).
 
