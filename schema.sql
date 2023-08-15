/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    ID SMALLSERIAL NOT NULL,
    NAME VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    escape_attempts SMALLINT,
    neutered BOOLEAN,
    weight_kg REAL,
    PRIMARY KEY(id)
);
