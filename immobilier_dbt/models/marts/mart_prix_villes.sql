-- mart_prix_villes.sql
-- KPI Prix par ville, type de bien et année
{{ config(materialized='table') }}

SELECT
    nom_commune,
    code_departement,
    code_postal,
    type_bien,
    annee_mutation,

    -- Volume
    COUNT(*) AS nb_transactions,

    -- Prix au m²
    PERCENTILE_CONT(0.5) WITHIN GROUP
        (ORDER BY prix_m2) AS prix_m2_median,
    ROUND(AVG(prix_m2)::NUMERIC, 0) AS prix_m2_moyen,
    ROUND(MIN(prix_m2)::NUMERIC, 0) AS prix_m2_min,
    ROUND(MAX(prix_m2)::NUMERIC, 0) AS prix_m2_max,

    -- Prix de vente
    PERCENTILE_CONT(0.5) WITHIN GROUP
        (ORDER BY prix_vente) AS prix_vente_median,
    ROUND(AVG(prix_vente)::NUMERIC, 0) AS prix_vente_moyen,

    -- Surface
    PERCENTILE_CONT(0.5) WITHIN GROUP
        (ORDER BY surface_m2) AS surface_m2_mediane,
    ROUND(AVG(surface_m2)::NUMERIC, 1) AS surface_m2_moyenne,

    -- Répartition par catégorie de prix m²
    COUNT(CASE WHEN categorie_prix_m2 = 'Premium' THEN 1 END) AS nb_premium,
    COUNT(CASE WHEN categorie_prix_m2 = 'Élevé' THEN 1 END) AS nb_eleve,
    COUNT(CASE WHEN categorie_prix_m2 = 'Moyen' THEN 1 END) AS nb_moyen,
    COUNT(CASE WHEN categorie_prix_m2 = 'Abordable' THEN 1 END) AS nb_abordable,
    COUNT(CASE WHEN categorie_prix_m2 = 'Très abordable' THEN 1 END) AS nb_tres_abordable,

    -- Rendement locatif moyen
    ROUND(AVG(rendement_locatif_estime_pct)::NUMERIC, 2) AS rendement_moyen_pct,

    -- Maisons avec terrain
    COUNT(CASE WHEN has_terrain THEN 1 END) AS nb_avec_terrain,
    ROUND(AVG(surface_terrain_m2)::NUMERIC, 0) AS surface_terrain_moyenne

FROM {{ ref("fct_transactions") }}
GROUP BY nom_commune, code_departement, code_postal, type_bien, annee_mutation
HAVING COUNT(*) >= 5
ORDER BY nb_transactions DESC