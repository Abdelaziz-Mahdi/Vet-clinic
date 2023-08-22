/* Database schema to keep the structure of the entire database. */

-- Create a table named animals.
CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    escape_attempts SMALLINT,
    neutered BOOLEAN,
    weight_kg REAL,
    species_id INT,
    owner_id INT,
    PRIMARY KEY(id),
    ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id),
    CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners (id)
    );

-- Create a table named owners
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50),
    age INT, email VARCHAR(120),
    PRIMARY KEY (id)
    );

-- Create a table named species
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    PRIMARY KEY (id)
    );

-- Create a table named vets.
CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY (id)
    );

-- Create a "join table" called specializations to handle relationship between vets and species.
CREATE TABLE specializations (
    id INT GENERATED ALWAYS AS IDENTITY,
    vet_id INT, species_id INT, PRIMARY KEY (id),
    CONSTRAINT fk_vet FOREIGN KEY (vet_id) REFERENCES vets (id),
    CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id)
    );

-- Create a "join table" called visits to handle relationship between vets and animals, it should also keep track of the date of the visit.
CREATE TABLE visits (
    id INT GENERATED ALWAYS AS IDENTITY, vet_id INT,
    animal_id INT, date_of_visit DATE, PRIMARY KEY (id),
    CONSTRAINT fk_vet FOREIGN KEY (vet_id) REFERENCES vets (id),
    CONSTRAINT fk_animal FOREIGN KEY (animal_id) REFERENCES animals (id)
    );
