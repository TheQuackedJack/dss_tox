-- Drop and recreate tables and sequences
-- Dropping tables and sequence if they exist
DROP TABLE IF EXISTS identifier;
DROP TABLE IF EXISTS dss_tox;
DROP SEQUENCE IF EXISTS identifier_id_seq;

-- Create the sequence for auto-incrementing IDs
CREATE SEQUENCE identifier_id_seq START 1;

-- Create the dss_tox table
CREATE TABLE dss_tox (
    id TEXT PRIMARY KEY, -- DTXSID
    preferred_name TEXT,
    cas_rn TEXT,
    inchi_key TEXT,
    iupac_name TEXT,
    smiles TEXT,
    molecular_formula TEXT,
    qsar_ready_smiles TEXT,
    ms_ready_smiles TEXT,
    average_mass FLOAT,
    monoisotopic_mass FLOAT
);

-- Create the identifier table with sequence for ID
CREATE TABLE identifier (
    id INTEGER DEFAULT nextval('identifier_id_seq'),
    value TEXT,
    dtxsid TEXT,
    PRIMARY KEY (id)
);
