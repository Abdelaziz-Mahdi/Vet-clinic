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

--Inside a transaction update the animal's table by setting the species column to unspecified. 
--start a transaction
BEGIN;

-- UPDATE species row in the animal's table
UPDATE animals 
SET species = 'unspecified' 
WHERE species IS NULL;

--Verify that the change was made.
SELECT species FROM animals;

--Then roll back the change and verify that the species columns returned to the state before the transaction.
-- rollback the change
ROLLBACK;
-- Check that the change was rolled back
SELECT species FROM animals;

--Inside a transaction: Update the animal's table by setting the species column to Digimon for all animals with a name ending in mon.
--start a transaction
BEGIN;

-- UPDATE species row in the animal's table
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

--Update the animal's table by setting the species column to Pokemon for all animals that don't have species already set.
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Verify that changes were made.
SELECT * FROM animals;

--Commit the transaction.
COMMIT;

--Verify that changes persist after commit.
SELECT * FROM animals;

--Inside a transaction delete all records in the animal's table, then roll back the transaction.
--start a transaction
BEGIN;

-- DELETE all rows in the animal's table
DELETE FROM animals;

-- Check that the change was made
SELECT * FROM animals;

-- rollback the change
ROLLBACK;

-- Check that the change was rolled back
SELECT * FROM animals;

--Inside a transaction: Delete all animals born after Jan 1st, 2022.
--start a transaction
BEGIN;

-- DELETE all rows in the animal's table
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

-- Check that the change was made
SELECT * FROM animals;

--Create a savepoint for the transaction.
SAVEPOINT delete_animals;

--Update all animals' weight to be their weight multiplied by -1.
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Check that the change was made
SELECT * FROM animals;

--Rollback to the savepoint
ROLLBACK TO delete_animals;

--Update all animals' negative weights to be their weight multiplied by -1.
-- UPDATE all rows in the animal's table
UPDATE animals
SET weight = weight * -1
WHERE weight < 0;

-- Check that the change was made
SELECT * FROM animals;

--Commit transaction
COMMIT;

--Write queries to answer the following questions:
--How many animals are there?
SELECT COUNT(id) 
FROM animals;

--How many animals have never tried to escape?
SELECT COUNT(id) 
FROM animals 
WHERE escape_attempts = 0;

--What is the average weight of animals?
SELECT AVG(weight_kg) 
FROM animals;

--Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts 
FROM animals GROUP BY neutered;

--What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) as minimum_weigth, MAX(weight_kg) as maximum_weight 
FROM animals GROUP BY species;

--What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
