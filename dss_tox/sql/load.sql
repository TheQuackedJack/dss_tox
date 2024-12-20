-- Load data into dss_tox from all files
-- Note: Replace 'st_read' function and file paths with appropriate database-specific logic or libraries
DO $$
DECLARE
    file TEXT;
BEGIN
    FOR file IN ARRAY dss_tox_files LOOP
        EXECUTE format(
            $$INSERT INTO dss_tox
            SELECT DISTINCT
                DTXSID AS id,
                PREFERRED_NAME AS preferred_name,
                CASRN AS cas_rn,
                INCHIKEY AS inchi_key,
                IUPAC_NAME AS iupac_name,
                SMILES AS smiles,
                MOLECULAR_FORMULA AS molecular_formula,
                QSAR_READY_SMILES AS qsar_ready_smiles,
                MS_READY_SMILES AS ms_ready_smiles,
                CAST(AVERAGE_MASS AS FLOAT) AS average_mass,
                CAST(MONOISOTOPIC_MASS AS FLOAT) AS monoisotopic_mass
            FROM st_read(
                '%s',
                layer = 'Sheet 1',
                open_options = ['HEADERS=FORCE', 'FIELD_TYPES=AUTO']
            );$$,
            file
        );
    END LOOP;
END $$;

-- Load identifiers into identifier
DO $$
DECLARE
    file TEXT;
BEGIN
    FOR file IN ARRAY dss_tox_files LOOP
        EXECUTE format(
            $$INSERT INTO identifier (value, dtxsid)
            SELECT
                value,
                DTXSID AS dtxsid
            FROM (
                SELECT
                    DTXSID,
                    UNNEST(STRING_SPLIT(IDENTIFIER, '|')) AS value
                FROM st_read(
                    '%s',
                    layer = 'Sheet 1',
                    open_options = ['HEADERS=FORCE', 'FIELD_TYPES=AUTO']
                )
                WHERE IDENTIFIER IS NOT NULL
            );$$,
            file
        );
    END LOOP;
END $$;