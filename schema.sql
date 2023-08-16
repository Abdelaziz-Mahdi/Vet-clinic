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
