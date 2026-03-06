-- stg_dvf.sql
-- Standardisation des données DVF brutes
-- Source : raw.raw_dvf

WITH source AS (
    SELECT * FROM {{ source("raw", "raw_dvf") }}
),

renamed AS (
    SELECT
        --Identifiants
        ROW_NUMBER() OVER () AS id_document,
        code_commune AS code_commune,
        commune AS nom_commune,
        code_departement AS code_departement,
        code_postal AS code_postal,

        --Dates
        CAST(date_mutation AS DATE) AS date_mutation,
        EXTRACT(YEAR FROM date_mutation)::INT AS annee_mutation,
        EXTRACT(MONTH FROM date_mutation)::INT AS mois_mutation,
        EXTRACT(QUARTER FROM date_mutation)::INT AS trimestre_mutation,

        --Bien immobilier 
        type_local AS type_bien,
        nombre_pieces_principales::INT AS nb_pieces,
        CAST(REPLACE(surface_reelle_bati::TEXT, ',', '.') AS FLOAT) AS surface_m2,
        CAST(REPLACE(surface_terrain::TEXT, ',', '.') AS FLOAT) AS surface_terrain_m2,
        nombre_de_lots::INT AS nombre_lots,
        CAST(REPLACE(surface_carrez_du_1er_lot::TEXT, ',', '.') AS FLOAT) AS surface_carrez_m2,

        --Prix
        CAST(valeur_fonciere AS FLOAT) AS prix_vente,
        CAST(REPLACE(prix_m2::TEXT, ',', '.') AS FLOAT)  AS prix_m2,

        --Localisation 
        no_voie AS numero_voie,
        type_de_voie AS type_voie,
        voie AS nom_voie,
        section AS section_cadastrale,

        --Colonnes calculées utiles 
        -- Catégorie de taille du bien
        CASE
            WHEN nombre_pieces_principales = 1 THEN 'Studio / T1'
            WHEN nombre_pieces_principales = 2 THEN 'T2'
            WHEN nombre_pieces_principales = 3 THEN 'T3'
            WHEN nombre_pieces_principales = 4 THEN 'T4'
            WHEN nombre_pieces_principales >= 5 THEN 'T5 et plus'
            ELSE 'Non renseigné'
        END AS categorie_bien,

        -- Tranche de prix
        CASE
            WHEN CAST(valeur_fonciere AS FLOAT) < 100000  THEN 'Moins de 100k'
            WHEN CAST(valeur_fonciere AS FLOAT) < 200000  THEN '100k - 200k'
            WHEN CAST(valeur_fonciere AS FLOAT) < 350000  THEN '200k - 350k'
            WHEN CAST(valeur_fonciere AS FLOAT) < 500000  THEN '350k - 500k'
            ELSE 'Plus de 500k'
        END AS tranche_prix,

        -- Saison de vente
        CASE
            WHEN EXTRACT(MONTH FROM date_mutation) IN (12, 1, 2)  THEN 'Hiver'
            WHEN EXTRACT(MONTH FROM date_mutation) IN (3, 4, 5)   THEN 'Printemps'
            WHEN EXTRACT(MONTH FROM date_mutation) IN (6, 7, 8)   THEN 'Été'
            ELSE 'Automne'
        END AS saison_vente

    FROM source
    WHERE
        valeur_fonciere IS NOT NULL
        AND surface_reelle_bati IS NOT NULL
        AND surface_reelle_bati > 0
        AND type_local IN ('Appartement', 'Maison')
        AND date_mutation IS NOT NULL
        --AND identifiant_de_document IS NOT NULL
)

SELECT * FROM renamed