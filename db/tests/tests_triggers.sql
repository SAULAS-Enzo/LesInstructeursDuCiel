-- C1 : avion 1 déjà en vol (chevauche le vol 1)
INSERT INTO VOLS VALUES (100,'LFOZ','LFOA',60,NULL,'VFR','2026-09-05','09:30:00',2,10,1);

-- C11 : l'apprenti 1 est déjà sur le vol 5 (10:00-10:45)
INSERT INTO VOLS VALUES (101,'LFOZ','LFOZ',30,NULL,'VFR','2026-10-10','10:15:00',1,11,2);

-- C2 : l'avion 2 est à LFOZ, pas à LFOT
INSERT INTO VOLS VALUES (102,'LFOT','LFOZ',60,NULL,'VFR','2026-10-12','10:00:00',2,10,2);

-- C4 : 270 min = autonomie de l'avion 2 (4,5 h), pas strictement inférieur
INSERT INTO VOLS VALUES (103,'LFOZ','LFOT',270,NULL,'VFR','2026-10-14','10:00:00',2,10,2);

-- C6 : révision de l'avion 4 dépassée
INSERT INTO VOLS VALUES (104,'LFOZ','LFOZ',60,NULL,'VFR','2026-10-15','10:00:00',4,10,4);

-- C7 : l'instructeur 10 n'enseigne pas le CPL
INSERT INTO VOLS VALUES (105,'LFOZ','LFOZ',60,NULL,'VFR','2026-10-16','10:00:00',3,10,2);

-- C8 : l'avion 3 n'est pas lié à la formation PPL
INSERT INTO VOLS VALUES (106,'LFOT','LFOT',60,NULL,'VFR','2026-10-17','10:00:00',1,10,3);

-- C5 : dernier contrôle de l'avion 3 non valide (CT n°6 du 20/10)
INSERT INTO VOLS VALUES (107,'LFOT','LFOT',60,NULL,'VFR','2026-10-25','10:00:00',3,11,3);

-- C3 : contrôle technique pendant le vol 1 (09:00-10:00)
INSERT INTO CONTROLE_TECHNIQUE VALUES (100,TRUE,'2026-09-05','09:30:00',20,1);

-- C10 : l'apprenti 4 n'a pas l'ABL, il ne peut pas obtenir la LAPL
INSERT INTO POSSEDER VALUES (4,'LAPL','2026-10-01');