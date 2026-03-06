-- mart_evolution.sql
-- Évolution YoY (Year-over-Year) du prix médian par ville

WITH prix_annuel AS (
    SELECT
        nom_commune,
        code_departement,
        type_bien,
        annee_mutation,
        PERCENTILE_CONT(0.5) WITHIN GROUP
            (ORDER BY prix_m2) AS prix_m2_median,
        ROUND(AVG(prix_m2)::NUMERIC, 0) AS prix_m2_moyen,
        COUNT(*) AS nb_transactions,
        ROUND(AVG(rendement_locatif_estime_pct)::NUMERIC, 2) AS rendement_moyen_pct
    FROM {{ ref("fct_transactions") }}
    GROUP BY nom_commune, code_departement, type_bien, annee_mutation
    HAVING COUNT(*) >= 5
),

avec_evolution AS (
    SELECT
        *,
        LAG(prix_m2_median) OVER (
            PARTITION BY nom_commune, type_bien
            ORDER BY annee_mutation
        ) AS prix_m2_annee_precedente,
    ROUND(
        (
            (prix_m2_median - LAG(prix_m2_median) OVER (
                PARTITION BY nom_commune, type_bien
                ORDER BY annee_mutation
            )) / NULLIF(LAG(prix_m2_median) OVER (
                PARTITION BY nom_commune, type_bien
                ORDER BY annee_mutation
            ), 0) * 100
        )::NUMERIC
    , 2) AS evolution_pct_yoy
    FROM prix_annuel
)


SELECT * FROM avec_evolution
ORDER BY nom_commune, type_bien, annee_mutation

