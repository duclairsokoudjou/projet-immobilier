-- Test custom : vérifie qu'aucun prix_m2 n'est négatif ou nul 

-- Ce test DOIT retourner 0 lignes pour passer 

 

SELECT 
    id_document, 
    prix_m2, 
    prix_vente, 
    surface_m2
FROM {{ ref("fct_transactions") }} 
WHERE prix_m2 <= 0 OR prix_m2 IS NULL 