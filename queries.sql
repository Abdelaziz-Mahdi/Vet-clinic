/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals
WHERE name LIKE '%mon';

SELECT * FROM animals
WHERE EXTRACT('Year' FROM DATE_OF_BIRTH) BETWEEN '2016' AND '2019';

SELECT * FROM animals
WHERE NEUTERED = TRUE AND ESCAPE_ATTEMPTS < 3;

SELECT DATE_OF_BIRTH from animals
WHERE name IN ('Agumon', 'Pikachu');

SELECT name, ESCAPE_ATTEMPTS FROM animals WHERE WEIGHT_KG > 10.5;

SELECT * FROM animals WHERE NEUTERED = TRUE;

SELECT * FROM animals WHERE name != 'Gabumon';

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

--Write queries (using JOIN) to answer the following questions:
--What animals belong to Melody Pond?

SELECT animals.name as melody_animals_names
FROM animals
JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).

SELECT animals.name as names_of_pokemon_species
FROM animals
JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.

SELECT owners.full_name as owner_name, animals.name as animal_name
FROM owners
LEFT JOIN animals
ON owners.id = animals.owner_id;

-- How many animals are there per species?

SELECT species.name as species_name, COUNT(animals.id) AS total_animals
FROM species
LEFT JOIN animals
ON species.id = animals.species_id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.

SELECT animals.name as Jennifer_digimon_animals_names
FROM animals
JOIN owners
ON animals.owner_id = owners.id
JOIN species
ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.

SELECT animals.name as dean_zero_escape_animals
FROM animals
JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Who owns the most animals?

SELECT owners.full_name as top_animals_owner_name, COUNT(animals.id) AS total_animals
FROM owners
LEFT JOIN animals
ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY total_animals DESC
LIMIT 1;

--Write queries to answer the following:
-- Who was the last animal seen by William Tatcher?

SELECT animals.name as last_animal_seen_by_william_tatcher
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?

SELECT COUNT(DISTINCT animals.id) AS total_animals_seen_by_stephanie_mendez
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.

SELECT vets.name as vet_name, species.name as species_name
FROM vets
LEFT JOIN specializations
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

SELECT animals.name as animals_visited_stephanie_mendez
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?

SELECT animals.name as animal_name, COUNT(visits.id) AS total_visits
FROM animals
JOIN visits
ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY total_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?

SELECT animals.name as animal_name
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC
LIMIT 1;

-- Details for most recent visit:
--animal information, vet information, and date of visit.

SELECT animals.name as animal_name, animals.date_of_birth as date_of_birth, animals.escape_attempts as escape_attempts, animals.neutered as neutered, animals.weight_kg as weight_kg, vets.name as vet_name, visits.date_of_visit as date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(visits.id) AS total_visits
FROM animals
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
JOIN specializations
ON vets.id = specializations.vet_id
WHERE animals.species_id != specializations.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT species.name as species_name, COUNT(visits.id) AS total_visits
FROM species
JOIN animals
ON species.id = animals.species_id
JOIN visits
ON animals.id = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY total_visits DESC
LIMIT 1;

-- Test proformanse of queries

-- TEST 1
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
CREATE INDEX animal_id_index ON visits(animal_id);
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
DROP INDEX animal_id_index;


-- TEST 2
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;.
CREATE INDEX vet_id_index ON visits(vet_id);
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
DROP INDEX vet_id_index;

-- TEST 3
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
CREATE INDEX email_index ON owners(email);
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
DROP INDEX email_index;
