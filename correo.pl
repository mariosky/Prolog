:- use_module(library(files)).
:- use_module(library(lists)).
:- use_module(library(charsio)).
:- use_module(library(dcgs)).


% mariosky@gmail.com 
% as.mariosky@gmail.com 
% mariosky@qw.gmail.com

% correo --> nombre, arroba, dominio. 
nombre --> palabra. 


palabra --> letra,  resto_palabra.

letra --> [C], {(char_type(C, alphabetic)), \+ C =:= "@" }.

resto_palabra --> [].
resto_palabra --> letra,  resto_palabra. 


arroba --> "@".

dominio --> palabra, tld.
tld --> "com".
