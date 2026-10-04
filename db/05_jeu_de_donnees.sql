-- Chaînes de formation (insérer le prérequis avant la formation qui en dépend)
INSERT INTO FORMATION (nomF, descriptionF, formationNecessaire) VALUES
('BIA',  'Brevet d''initiation aéronautique', NULL),
('ABL',  'Brevet de base ULM / planeur',      'BIA'),
('LAPL', 'Licence de pilote d''avion léger',  'ABL'),
('PPL',  'Licence de pilote privé',           'LAPL'),
('CPL',  'Licence de pilote professionnel',   'PPL'),
('ATPL', 'Licence de pilote de ligne',        'CPL'),
('MPL',  'Licence de pilote multi-équipage',  'ATPL'),
('CAEA', 'Certificat d''aptitude à l''enseignement aéronautique', NULL),
('IR',   'Instructeur qualifié IFR',          'CAEA'),
('QT',   'Qualification de type',             'IR'),
('MCC',  'Coopération multi-équipage',        'QT');

INSERT INTO PERSONNE (idPers, nomP, prenomP, dateDeNaissanceP, emailP, motDePasse) VALUES
(1,  'Martin',  'Lucas',    '2002-04-12', 'lucas.martin@ciel.fr',    'hash_a1'),
(2,  'Bernard', 'Emma',     '2003-09-30', 'emma.bernard@ciel.fr',    'hash_a2'),
(3,  'Dubois',  'Hugo',     '1999-01-21', 'hugo.dubois@ciel.fr',     'hash_a3'),
(4,  'Moreau',  'Chloé',    '2005-06-08', 'chloe.moreau@ciel.fr',    'hash_a4'),
(10, 'Leroy',   'Philippe', '1978-11-02', 'philippe.leroy@ciel.fr',  'hash_i1'),
(11, 'Roux',    'Sophie',   '1983-03-17', 'sophie.roux@ciel.fr',     'hash_i2'),
(20, 'Petit',   'Julien',   '1990-07-25', 'julien.petit@ciel.fr',    'hash_t1'),
(21, 'Faure',   'Marie',    '1987-12-05', 'marie.faure@ciel.fr',     'hash_t2');

-- Formations obtenues (dans l'ordre des chaînes, pour le trigger C10)
INSERT INTO POSSEDER (idPers, nomF, dateObtention) VALUES
(1, 'BIA',  '2019-06-15'), (1, 'ABL',  '2021-07-01'), (1, 'LAPL', '2024-05-20'),
(2, 'BIA',  '2020-06-10'), (2, 'ABL',  '2023-08-12'),
(3, 'BIA',  '2016-06-10'), (3, 'ABL',  '2018-07-01'), (3, 'LAPL', '2020-05-20'), (3, 'PPL', '2023-09-14'),
(4, 'BIA',  '2022-06-18'),
(10, 'CAEA', '2010-03-01'), (10, 'IR', '2013-04-10'),
(11, 'CAEA', '2012-03-01'), (11, 'IR', '2014-04-10'), (11, 'QT', '2017-05-02'), (11, 'MCC', '2019-06-20');

-- Formation en cours : PPL, LAPL, CPL et ABL (prérequis tous obtenus)
INSERT INTO APPRENTI_PILOTE (idAppP, nbHeuresVol, nomF) VALUES
(1, 35, 'PPL'), (2, 12, 'LAPL'), (3, 85, 'CPL'), (4, 3, 'ABL');

INSERT INTO INSTRUCTEUR (idIns, nbheuresVol) VALUES (10, 450), (11, 1200);
INSERT INTO TECHNICIEN (idTech) VALUES (20), (21);

INSERT INTO AVION (idA, nomA, typeA, specification, anneeDeFabrication, dateLimiteRevision,
                   imgA, vitesseDeCroisiere, altitudeMax, autonomie, aerodromeActuel) VALUES
(1, 'Cessna 172 F-GABC', 'monomoteur', 'Moteur Lycoming 160 ch', 2008, '2027-03-01', NULL, 122, 13500, 5.0, 'LFOZ'),
(2, 'Piper PA-28 F-GDEF', 'monomoteur', 'Moteur Lycoming 180 ch', 2012, '2027-01-15', NULL, 115, 14000, 4.5, 'LFOZ'),
(3, 'Diamond DA42 F-HGHI', 'bimoteur',   'Deux moteurs diesel',    2016, '2027-06-30', NULL, 160, 18000, 6.0, 'LFOT'),
(4, 'Robin DR400 F-GJKL',  'monomoteur', 'Révision dépassée (test C6)', 1995, '2026-09-30', NULL, 130, 15000, 4.0, 'LFOZ');

-- Avions utilisables par formation (C8)
INSERT INTO CONVENIR (idA, nomF) VALUES
(1, 'ABL'), (1, 'LAPL'), (1, 'PPL'),
(2, 'LAPL'), (2, 'PPL'), (2, 'CPL'),
(3, 'CPL'),
(4, 'ABL'), (4, 'LAPL');

-- Formations enseignées (C7)
INSERT INTO FORMER (idIns, nomF) VALUES
(10, 'ABL'), (10, 'LAPL'), (10, 'PPL'),
(11, 'PPL'), (11, 'CPL');

-- Contrôles techniques (avant les vols pour que C3 et C5 passent)
INSERT INTO CONTROLE_TECHNIQUE (idCT, estValideCT, dateCT, heureCT, idTech, idA) VALUES
(1, TRUE,  '2026-09-01', '08:00:00', 20, 1),
(2, FALSE, '2026-08-15', '08:00:00', 20, 2),
(3, TRUE,  '2026-08-20', '08:00:00', 21, 2),
(4, TRUE,  '2026-09-01', '09:00:00', 21, 3),
(5, TRUE,  '2026-08-20', '10:00:00', 20, 4),
(6, FALSE, '2026-10-20', '08:00:00', 21, 3);  -- sert au test C5

INSERT INTO VOLS (idV, aerodromeDepart, aerodromeArrivee, dureeV, planDeV, regleV, dateV, heureV, idAppP, idIns, idA) VALUES
-- Cessna (1)
(1,  'LFOZ', 'LFOA', 60,  'plan_v1.pdf',  'VFR', '2026-09-05', '09:00:00', 1, 10, 1),
(2,  'LFOA', 'LFOZ', 60,  'plan_v2.pdf',  'VFR', '2026-09-05', '11:00:00', 1, 10, 1),
(3,  'LFOZ', 'LFOT', 90,  'plan_v3.pdf',  'VFR', '2026-09-12', '14:00:00', 4, 10, 1),
(4,  'LFOT', 'LFOZ', 90,  'plan_v4.pdf',  'VFR', '2026-09-12', '16:00:00', 4, 10, 1),
(5,  'LFOZ', 'LFOZ', 45,  'plan_v5.pdf',  'VFR', '2026-10-10', '10:00:00', 1, 10, 1),
-- Piper (2)
(6,  'LFOZ', 'LFOA', 75,  'plan_v6.pdf',  'VFR', '2026-09-08', '10:00:00', 2, 10, 2),
(7,  'LFOA', 'LFOZ', 75,  'plan_v7.pdf',  'VFR', '2026-09-08', '13:00:00', 2, 10, 2),
(8,  'LFOZ', 'LFOZ', 60,  'plan_v8.pdf',  'VFR', '2026-09-20', '15:00:00', 2, 10, 2),
-- Diamond (3)
(9,  'LFOT', 'LFPN', 120, 'plan_v9.pdf',  'IFR', '2026-09-15', '09:00:00', 3, 11, 3),
(10, 'LFPN', 'LFOT', 120, 'plan_v10.pdf', 'IFR', '2026-09-15', '13:00:00', 3, 11, 3),
(11, 'LFOT', 'LFOT', 90,  'plan_v11.pdf', 'VFR', '2026-10-05', '08:30:00', 3, 11, 3);