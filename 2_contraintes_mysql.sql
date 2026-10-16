
-- ============================================================
-- PokéDex TCG - Contraintes de validation (MySQL 8)
-- Fichier : 2_contraintes_mysql.sql
-- ============================================================

USE pokedex_tcg;

-- ============================================================
-- 1. AJOUT DES CONTRAINTES DE VALIDATION
-- ============================================================

-- Email du dresseur : format avec @ et un point
ALTER TABLE DRESSEUR
ADD CONSTRAINT chk_email_format
CHECK (email LIKE '%_@_%._%');

-- Mot de passe non vide et au moins 8 caractères
ALTER TABLE DRESSEUR
ADD CONSTRAINT chk_mot_de_passe
CHECK (CHAR_LENGTH(mot_de_passe) >= 8);

-- Nom de l'édition non vide
ALTER TABLE EDITION
ADD CONSTRAINT chk_nom_edition
CHECK (TRIM(nom_edition) <> '');

-- Nom du Pokémon non vide
ALTER TABLE POKEMON
ADD CONSTRAINT chk_nom_pokemon
CHECK (TRIM(nom_pokemon) <> '');

-- Une carte est holographique ou non (0 ou 1)
ALTER TABLE CARTE
ADD CONSTRAINT chk_foil
CHECK (foil IN (0, 1));

-- Nom de carte non vide
ALTER TABLE CARTE
ADD CONSTRAINT chk_nom_carte
CHECK (TRIM(nom_carte) <> '');

-- Nom du tournoi non vide
ALTER TABLE TOURNOI
ADD CONSTRAINT chk_nom_tournoi
CHECK (TRIM(nom_tournoi) <> '');

-- ============================================================
-- 2. VERIFICATION DES CONTRAINTES
-- ============================================================

SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    cc.CHECK_CLAUSE
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.CHECK_CONSTRAINTS cc
    ON tc.CONSTRAINT_SCHEMA = cc.CONSTRAINT_SCHEMA
    AND tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_SCHEMA = 'pokedex_tcg'
  AND tc.CONSTRAINT_TYPE = 'CHECK'
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_NAME;

-- ============================================================
-- 3. TESTS DES CONTRAINTES
-- Chaque test doit provoquer une erreur.
-- Les exécuter séparément, sans enlever les commentaires
-- des autres tests.
-- ============================================================

-- TEST 1 : Email invalide
-- INSERT INTO DRESSEUR (pseudo, email, mot_de_passe)
-- VALUES ('Test1', 'email_invalide', 'password');

-- TEST 2 : Mot de passe trop court
-- INSERT INTO DRESSEUR (pseudo, email, mot_de_passe)
-- VALUES ('Test2', 'test2@example.com', 'abc');

-- TEST 3 : Nom Pokémon vide
-- INSERT INTO POKEMON (nom_pokemon, numero_pokedex, type_elementaire)
-- VALUES ('', 999, 'Feu');

-- TEST 4 : Valeur foil invalide
-- INSERT INTO CARTE
-- (id_carte, nom_carte, numero_carte, rarete, foil, id_edition)
-- VALUES ('TEST-001', 'Carte Test', 1, 'Commune', 3, 'BASE');

-- TEST 5 : Nom édition vide
-- INSERT INTO EDITION
-- (id_edition, nom_edition, date_sortie, nb_cartes)
-- VALUES ('TEST', '', '2024-01-01', 20);

-- TEST 6 : ELO négatif
-- INSERT INTO DRESSEUR (pseudo, email, mot_de_passe, elo)
-- VALUES ('Test3', 'test3@example.com', 'password', -100);

-- TEST 7 : Note supérieure à 5
-- INSERT INTO AVIS (id_dresseur, id_carte, note)
-- VALUES (1, 'BASE-001', 6);

-- TEST 8 : Rareté invalide
-- INSERT INTO CARTE
-- (id_carte, nom_carte, numero_carte, rarete, foil, id_edition)
-- VALUES ('TEST-002', 'Carte Test', 1, 'Mega Rare', 0, 'BASE');

-- TEST 9 : Date de tournoi incohérente
-- INSERT INTO TOURNOI
-- (nom_tournoi, lieu, date_debut, date_fin)
-- VALUES ('Tournoi Test', 'Paris', '2024-06-10', '2024-06-05');

-- TEST 10 : Quantité négative
-- INSERT INTO COLLECTION (id_dresseur, id_carte, quantite)
-- VALUES (1, 'BASE-002', -1);

-- ============================================================
-- 4. TESTS D'INTEGRITE REFERENTIELLE
-- Tests à exécuter séparément sur une base de test
-- ============================================================

-- TEST 11 : Référence vers une édition inexistante
-- Doit échouer grâce à la clé étrangère
-- INSERT INTO CARTE
-- (id_carte, nom_carte, numero_carte, rarete, foil, id_edition)
-- VALUES ('FAKE-001', 'Carte Fantome', 1, 'Commune', 0, 'FAKE');

-- TEST 12 : ON DELETE CASCADE
-- La suppression d'une édition entraîne celle de ses cartes.
-- ATTENTION : ce test modifie les données.
-- DELETE FROM EDITION WHERE id_edition = 'JNG';
-- SELECT * FROM CARTE WHERE id_edition = 'JNG';

-- TEST 13 : ON DELETE CASCADE
-- La suppression d’un dresseur efface aussi les lignes qui le référencent.
-- Ne pas exécuter sur la base utilisée pour les autres tests.
-- DELETE FROM DRESSEUR WHERE id_dresseur = 1;

-- ============================================================
-- FIN DU FICHIER
-- ============================================================
