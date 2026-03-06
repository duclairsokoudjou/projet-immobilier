## Pipeline Data End-to-End — Analytics Engineer

[![Python](https://img.shields.io/badge/Python-3.11-blue)] 

[![dbt](https://img.shields.io/badge/dbt-1.7-orange)] 

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)] 

[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)] 


## Problématique Business 

Une startup  souhaite créer un outil d'aide à la décision pour ses conseillers en investissement immobilier. 

Question : **Où investir en France pour maximiser la rentabilité ?** 

 

## Architecture 

<img width="1084" height="477" alt="image" src="https://github.com/user-attachments/assets/7e516a67-c907-40c5-be86-7419ac831fd9" />


## Dashboard 

<img width="1357" height="793" alt="image" src="https://github.com/user-attachments/assets/d6ae21be-d2dd-41db-a620-730a49f0a54f" />


Voir le dashboard : https://drive.google.com/drive/folders/1hpbs5ysrxuNV0P6PP2EITu0dIcE9xqNo?usp=sharing

 

## Stack Technique 

 
<table>
  <thead>
    <tr>
      <th>Couche</th>
      <th>Outil</th>
      <th>Usage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Ingestion</td>
      <td>Python + pandas</td>
      <td>Téléchargement et nettoyage DVF</td>
    </tr>
    <tr>
      <td>Stockage</td>
      <td>PostgreSQL 16</td>
      <td>Base de données locale</td>
    </tr>
    <tr>
      <td>Transform</td>
      <td>dbt Core</td>
      <td>Modélisation, tests, documentation</td>
    </tr>
    <tr>
      <td>Visualisation</td>
      <td>Power BI</td>
      <td>Dashboard interactif</td>
    </tr>
    <tr>
      <td>Versionning</td>
      <td>Git + GitHub</td>
      <td>Code et documentation</td>
    </tr>
  </tbody>
</table>

 

## Structure du projet 

<pre>
projet_immobilier_france/ 

├── scripts/          # Scripts Python ingestion 
├── immobilier_dbt/   # Projet dbt complet 
│   ├── models/       # Staging, Intermediate, Marts 
│   └── tests/        # Tests custom SQL 
└── README.md 
</pre>


## Lancer le projet 


# 1. Cloner le repo 
git clone https://github.com/[USERNAME]/projet-immobilier-france 
cd projet-immobilier-france 

# 2. Installer les dépendances 
python -m venv venv && venv\Scripts\activate 
pip install -r requirements.txt 

# 3. Configurer la base de données 
cp .env.example .env  # Remplis avec tes credentials PostgreSQL 

# 4. Télécharger et charger les données 
python scripts/01_download_dvf.py 
python scripts/02_load_to_postgres.py 

# 5. Lancer dbt 
cd immobilier_dbt 
dbt run && dbt test 




## Données 

 

- Source : [DVF — data.gouv.fr](https://www.data.gouv.fr/fr/datasets/demandes-de-valeurs-foncieres/) 
- Données officielles du gouvernement français 

 

## Auteur 

 

[DUCLAIR SOKOUDJOU] — [https://www.linkedin.com/feed/] — [duclairsokoudjou@gmail.com] 
