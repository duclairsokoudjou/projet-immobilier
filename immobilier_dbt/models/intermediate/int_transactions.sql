-- int_transactions.sql
-- Enrichissement des transactions avec catégories et segmentation

WITH stg AS (
    SELECT * FROM {{ ref("stg_dvf") }}
),

enriched AS (
    SELECT
        --Toutes les colonnes du staging 
        id_document,
        code_commune,
        nom_commune,
        code_departement,
        code_postal,
        date_mutation,
        annee_mutation,
        mois_mutation,
        trimestre_mutation,
        saison_vente,
        type_bien,
        nb_pieces,
        surface_m2,
        surface_terrain_m2,
        surface_carrez_m2,
        nombre_lots,
        categorie_bien,
        prix_vente,
        prix_m2,
        tranche_prix,
        numero_voie,
        type_voie,
        nom_voie,
        section_cadastrale,

        -- Enrichissements supplémentaires

        -- Catégorie prix au m² (différent de tranche_prix qui est sur le prix total)
        CASE
            WHEN prix_m2 < 2000  THEN 'Très abordable'
            WHEN prix_m2 < 4000  THEN 'Abordable'
            WHEN prix_m2 < 7000  THEN 'Moyen'
            WHEN prix_m2 < 12000 THEN 'Élevé'
            ELSE 'Premium'
        END AS categorie_prix_m2,

        -- Ratio surface Carrez vs surface réelle (qualité du bien)
        CASE
            WHEN surface_carrez_m2 IS NOT NULL AND surface_m2 > 0
            THEN ROUND((surface_carrez_m2 / surface_m2 * 100)::NUMERIC, 1)
            ELSE NULL
        END AS ratio_carrez_pct,

        -- Flag maison avec terrain
        CASE
            WHEN type_bien = 'Maison' AND surface_terrain_m2 > 0
            THEN TRUE
            ELSE FALSE
        END AS has_terrain,

        -- Flag transaction en bloc (plusieurs lots)
        CASE
            WHEN nombre_lots > 1 THEN TRUE
            ELSE FALSE
        END AS is_vente_en_bloc,

        -- Rendement théorique locatif estimé (loyer moyen INSEE ~15€/m²/mois)
        -- Indicateur approximatif, à mentionner comme tel
        CASE
            WHEN prix_vente > 0
            THEN ROUND((surface_m2 * 15 * 12 / prix_vente * 100)::NUMERIC, 2)
            ELSE NULL
        END AS rendement_locatif_estime_pct

    FROM stg
)

SELECT * FROM enriched


