-- fct_transactions.sql
-- Table de faits centrale — toutes les transactions enrichies
-- Matérialisée en TABLE pour performance Power BI
{{ config(materialized='table') }}

SELECT
    -- Clés
    id_document,
    code_commune,
    nom_commune,
    code_departement,
    code_postal,

    -- Temps
    date_mutation,
    annee_mutation,
    mois_mutation,
    trimestre_mutation,
    saison_vente,

    -- Bien
    type_bien,
    nb_pieces,
    surface_m2,
    surface_terrain_m2,
    surface_carrez_m2,
    nombre_lots,
    categorie_bien,
    has_terrain,
    is_vente_en_bloc,

    -- Prix
    prix_vente,
    prix_m2,
    tranche_prix,
    categorie_prix_m2,
    ratio_carrez_pct,
    rendement_locatif_estime_pct,

    -- Localisation
    numero_voie,
    type_voie,
    nom_voie,
    section_cadastrale

FROM {{ ref("int_transactions") }}