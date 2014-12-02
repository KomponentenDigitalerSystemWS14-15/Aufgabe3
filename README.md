# Aufgabe3

Die Komponenten ```full_adder``` und ```full_adder_n``` wurden aus dem Vorlesungskript �bernommen.
Momentan werden diese Komponenten jedoch nicht benutzt. Stattdessen wird die Addition mit der
entsprechenden Funkion aus ```numeric_std``` berechnet.

Um die Verl�ngerung der ```std_logic_vector``` Signale durchzuf�hren, werden diese auf einen ```signed```
Vektor gecastet. Dabei handelt es sich immer noch um einen ```std_logic_vector```, jedoch wird bei arithmetischen
Operationen aus ```numeric_std``` das Vorzeichen ber�cksichtigt. Dabei wird davon ausgegangen, dass negative Zahlen
in Zweier-Komplement-Darstellung bereit stehen. Mittels ```resize``` werden die Vektoren entsprechend mit 1 oder 0
gepadded.