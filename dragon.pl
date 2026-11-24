:- use_module(library(dcgs)).

:- dynamic(natnum/1).

dragon("r").

dragon(Ds) :-
    dragon(Ds0),
    phrase((seq(Ds0), "r", inv(Ds0)), Ds).

inv([]) --> [].
inv([D|Ds]) --> inv(Ds), swap(D).

swap(r) --> "l".
swap(l) --> "r".


natnum(0) :- true.

