/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals
WHERE NAME LIKE '%mon';

SELECT * FROM animals
WHERE EXTRACT('Year' FROM DATE_OF_BIRTH) BETWEEN '2016' AND '2019';

SELECT * FROM animals
WHERE NEUTERED = TRUE AND ESCAPE_ATTEMPTS < 3;

SELECT DATE_OF_BIRTH from animals
WHERE NAME IN ('Agumon', 'Pikachu');

SELECT NAME, ESCAPE_ATTEMPTS FROM animals WHERE WEIGHT_KG > 10.5;

SELECT * FROM animals WHERE NEUTERED = TRUE;

SELECT * FROM animals WHERE NAME != 'Gabumon';

SELECT * FROM animals WHERE WEIGHT_KG BETWEEN 10.4 AND 17.3;
