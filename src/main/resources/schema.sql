drop table if exists VOLS;
drop table if exists CONTROLE_TECHNIQUE;
drop table if exists POSSEDER;
drop table if exists FORMER;
drop table if exists CONVENIR;
drop table if exists APPRENTI_PILOTE;
drop table if exists INSTRUCTEUR;
drop table if exists TECHNICIEN;
drop table if exists AVION;
drop table if exists FORMATION;
drop table if exists PERSONNE;

CREATE TABLE PERSONNE (
    idPers INT(9) PRIMARY KEY,
    nomP VARCHAR(50) NOT NULL,
    prenomP VARCHAR(50) NOT NULL,
    dateDeNaissanceP CHAR(11),
    emailP VARCHAR(150) NOT NULL unique,
    motDePasse VARCHAR(200) NOT NULL
);

CREATE TABLE FORMATION(
    nomF VARCHAR(10) PRIMARY KEY,
    descriptionF VARCHAR(1000),
    formationNecessaire VARCHAR(10),
    constraint fk_formation FOREIGN KEY (formationNecessaire) REFERENCES FORMATION(nomF)
);

CREATE TABLE APPRENTI_PILOTE (
    idAppP INT(9) PRIMARY KEY ,
    nbHeuresVol INT,
    nomF VARCHAR(10),
    constraint  fk_apprenti_pilote_formaition FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint  fk_apprenti_pilote_heritage_personne FOREIGN KEY (idAppP) REFERENCES PERSONNE(idPers)
);

CREATE TABLE INSTRUCTEUR (
    idIns INT(9) PRIMARY KEY,
    nbheuresVol INT,
    constraint  fk_instructeur_heritage_personne FOREIGN KEY (idIns) REFERENCES PERSONNE(idPers)
);

CREATE TABLE TECHNICIEN (
    idTech INT(9) PRIMARY KEY,
    constraint  fk_technicien_heritage_personne FOREIGN KEY (idTech) REFERENCES PERSONNE(idPers)
);

CREATE TABLE AVION (
    idA INT PRIMARY KEY,
    nomA VARCHAR(50) NOT NULL,
    typeA VARCHAR(50) NOT NULL CHECK (typeA IN ('monomoteur', 'bimoteur', 'multimoteur, propulsion, piston')),
    specification VARCHAR(200),
    anneeDeFabrication INT(4) NOT NULL,
    dateLimiteRevision DATE NOT NULL,
    imgA VARCHAR(255),
    vitesseDeCroisiere INT(3),
    altitudeMax INT(6) NOT NULL,
    autonomie DECIMAL(4,1) NOT NULL,
    aerodromeActuel VARCHAR(50) NOT NULL
);

CREATE TABLE VOLS (
    idV INT(9) PRIMARY KEY,
    aerodromeDepart CHAR(4) NOT NULL,
    aerodromeArrivee CHAR(4) NOT NULL,
    dureeV INT NOT NULL,
    planDeV VARCHAR(255),
    regleV VARCHAR(50) NOT NULL CHECK (regleV IN ('IFR', 'VFR', 'VFRS')),
    dateV DATE NOT NULL,
    heureV TIME NOT NULL,
    idAppP INT(9),
    idIns INT (9),
    idA INT(9),

    constraint fk_vols_apprenti FOREIGN KEY (idAppP) REFERENCES APPRENTI_PILOTE(idAppP),
    constraint fk_vols_instructeur FOREIGN KEY (idIns) REFERENCES INSTRUCTEUR(idIns),
    constraint fk_vols_avion FOREIGN KEY (idA) REFERENCES AVION(idA)
);

CREATE TABLE CONTROLE_TECHNIQUE (
    idCT INT(9) PRIMARY KEY,
    estValideCT BOOLEAN NOT NULL ,
    dateCT DATE not null,
    heureCT TIME NOT NULL,
    idTech INT(9),
    idA INT(9),

    constraint fk_controle_technique_technicien FOREIGN KEY (idTech) REFERENCES TECHNICIEN(idTech),
    constraint fk_controle_technique_avion FOREIGN KEY (idA) REFERENCES AVION(idA)
);

CREATE TABLE POSSEDER (
    idPers INT(9),
    nomF VARCHAR(10),
    dateObtention DATE,

    constraint fk_possder_personne FOREIGN KEY (idPers) REFERENCES PERSONNE(idPers),
    constraint fk_posseder_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_posseder PRIMARY KEY (idPers, nomF)
);

CREATE TABLE FORMER (
    idIns INT(9),
    nomF VARCHAR(10),

    constraint fk_former_instructeur FOREIGN KEY (idIns) REFERENCES PERSONNE(idPers),
    constraint fk_former_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_former PRIMARY KEY (idIns, nomF)
);

CREATE TABLE CONVENIR (
    idA INT(9),
    nomF VARCHAR(10),

    constraint fk_convenir_avion FOREIGN KEY (idA) REFERENCES AVION(idA),
    constraint fk_convenir_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_convenir PRIMARY KEY (idA, nomF)
);