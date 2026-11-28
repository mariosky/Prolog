:- use_module(library(files)).
:- use_module(library(lists)).
:- use_module(library(charsio)).
:- use_module(library(dcgs)).

as --> [].
as -->[a], as.

bs --> "".
bs --> "c", bs.


xy([]) --> [].
%xy([C|Cs]) --> letraxy(C), xy(Cs).
xy([C|Cs]) --> [C],{ C = 'X'; C = 'Y' },xy(Cs).

letraxy("X") --> "X".
letraxy("Y") --> "Y".

% ?- length(Ls,_), phrase(xy,Ls).

% Test
% ?- phrase(as, "aaaa").

% Generar
% ?- phrase(as, Ls), atom_chars(String, Ls).


% Completar 
%?- phrase(as, [a,X,a]).
%X = a.


seq([]) --> [].
seq([L|Ls]) --> [L], seq(Ls).

... --> [] | [_], ... . 
%?- phrase((...,[X,X],...), "helloo!!").

% HTML element:
% string o term: 
% element(TagName, Attributes, Children)

tags([]) --> [].
tags([element(TagName, _, Children)|Rest]) 
        --> [TagName], 
        tags(Children), 
        tags(Rest).
tags([Text|Rest]) -->
    %[Text],
    {atom(Text)}, 
    tags(Rest). 


%texts([Text|Rest]) -->
%    {
%        atom(Text) ->
%            Result = Text
%        ;
%            atom_string(Result, Text)
%    },
%    [Result],
%    texts(Rest).



run(Names) :-
    DOM = [
       element(html, [], [
           element(head, [], [
               element(title, [], ['Ejemplo'])
           ]),
           element(body, [], [
               element(h1, [], ['Hola']),
               element(p, [], ['Mundo'])
           ])
       ])
   ],
   phrase(tags(DOM), Names).
    
exp1 --> "1".
exp1 --> exp1, "+", exp1.

exp --> "1", expr.
expr --> "".
expr --> "+", exp.

name([]) --> [].
name([C|Cs]) --> [C], {char_type(C, alphabetic) ; C = '_'}, name(Cs).

%extension --> name([_._]).
%dot --> ".".

extension(jpg) --> ".jpg".
extension(png) --> ".png".

file_name(Ext) --> name([_|_]), extension(Ext).

file_name(Name, Ext) --> 
    name(Name),
    extension(Ext).


%word --> [].


%words --> [].
%words --> ws, word, ws, words.

%ws -->[W], {char_type(W, whitespace)}, ws | [].



word([C|Cs]) --> [C], {char_type(C, alphabetic)}, word(Cs).
word([]) --> [].


words([]) --> [].
words([[C|Cs]|Ws]) -->
    ws,
    word([C|Cs]),
    ws,
    words(Ws).

ws -->[W], {char_type(W, whitespace)}, ws | [].

