/* Database schema to keep the structure of the entire database. */

CREATE TABLE animals (
    ID SMALLSERIAL NOT NULL,
    NAME VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    escape_attempts SMALLINT,
    neutered BOOLEAN,
    weight_kg REAL,
    PRIMARY KEY(id)
);

ALTER TABLE animals ADD species VARCHAR(100);

--Create a table named owners
CREATE TABLE owners (id INT GENERATED ALWAYS AS IDENTITY, full_name VARCHAR(50), age INT, PRIMARY KEY (id));

--Create a table named species
CREATE TABLE species (id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR(50), PRIMARY KEY (id));

--Modify animals table:
--Make sure that id is set as autoincremented PRIMARY KEY
ALTER TABLE animals DROP COLUMN ID;
ALTER TABLE animals ADD id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY;

--Remove column species
ALTER TABLE animals DROP COLUMN species;

--Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id);

--Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners (id);


--Create a table named vets with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- name: string
-- age: integer
-- date_of_graduation: date
CREATE TABLE vets (id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR(50), age INT, date_of_graduation DATE, PRIMARY KEY (id));

-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.
CREATE TABLE specializations (id INT GENERATED ALWAYS AS IDENTITY, vet_id INT, species_id INT, PRIMARY KEY (id));
ALTER TABLE specializations ADD CONSTRAINT fk_vet FOREIGN KEY (vet_id) REFERENCES vets (id);
ALTER TABLE specializations ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id);
