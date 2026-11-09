consult :-
    write('Enter patient ID: '),
    read(Patient),
    findall(Diagnosis, diagnosis_interactive(Patient, Diagnosis), Diagnoses),
    ( Diagnoses = []
    -> format('~s No diagnosis determined.~n', [Patient])
    ; format('~s Possible diagnoses: ~w~n', [Patient, Diagnoses])
    ).

diagnosis_interactive(Patient, has_flu) :-
    ask(Patient, fever),
    ask(Patient, cough),
    ask(Patient, fatigue).

diagnosis_interactive(Patient, has_cold) :-
    ask(Patient, runny_nose),
    ask(Patient, sneezing),
    \+ ask(Patient, high_fever).

ask(Patient, Symptom) :-
    stored_symptom(Patient, Symptom), !.
    ask(Patient, Symptom) :-
    format('Does ~s have ~s? (yes/no) ', [Patient, Symptom]),
    read(Answer),
    (Answer = yes
    -> assertz(stored_symptom(Patient, Symptom)),
    true
    ; assertz(stored_symptom(Patient, not(Symptom))),
    fail
    ).

stored_symptom(Patient, not(_)) :- !, fail.
stored_symptom(Patient, S) :- stored_symptom(Patient, S).