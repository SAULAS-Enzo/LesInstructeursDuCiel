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
    idPers BIGINT PRIMARY KEY AUTO_INCREMENT,
    nomP VARCHAR(50) NOT NULL,
    prenomP VARCHAR(50) NOT NULL,
    dateDeNaissanceP DATE,
    emailP VARCHAR(150) NOT NULL UNIQUE,
    motDePasse VARCHAR(200) NOT NULL
);

CREATE TABLE FORMATION(
    nomF VARCHAR(10) PRIMARY KEY CHECK(nomF IN ('BIA', 'ABL', 'LAPL', 'PPL', 'CPL', 'ATPL', 'MPL', 'CAEA', 'IR', 'QT', 'MCC')),
    descriptionF VARCHAR(1000),
    formationNecessaire VARCHAR(10),
    constraint fk_formation FOREIGN KEY (formationNecessaire) REFERENCES FORMATION(nomF)
);

CREATE TABLE APPRENTI_PILOTE (
    idAppP BIGINT PRIMARY KEY auto_increment,
    nbHeuresVol INT,
    nomF VARCHAR(10),
    constraint  fk_apprenti_pilote_formaition FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint  fk_apprenti_pilote_heritage_personne FOREIGN KEY (idAppP) REFERENCES PERSONNE(idPers)
);

CREATE TABLE INSTRUCTEUR (
    idIns BIGINT PRIMARY KEY auto_increment,
    nbheuresVol INT CHECK(nbheuresVol >= 200),
    constraint  fk_instructeur_heritage_personne FOREIGN KEY (idIns) REFERENCES PERSONNE(idPers)
);

CREATE TABLE TECHNICIEN (
    idTech BIGINT PRIMARY KEY auto_increment,
    constraint  fk_technicien_heritage_personne FOREIGN KEY (idTech) REFERENCES PERSONNE(idPers)
);

CREATE TABLE AVION (
    idA BIGINT PRIMARY KEY auto_increment,
    nomA VARCHAR(50) NOT NULL,
    typeA VARCHAR(50) NOT NULL CHECK (typeA IN ('monomoteur', 'bimoteur', 'multimoteur', 'propulsion', 'piston')),
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
    idV BIGINT PRIMARY KEY auto_increment,
    aerodromeDepart CHAR(4) NOT NULL,
    aerodromeArrivee CHAR(4) NOT NULL,
    dureeV INT NOT NULL,
    planDeV VARCHAR(255),
    regleV VARCHAR(50) NOT NULL CHECK (regleV IN ('IFR', 'VFR', 'VFRS')),
    dateV DATE NOT NULL,
    heureV TIME NOT NULL,
    idAppP BIGINT,
    idIns BIGINT,
    idA BIGINT,

    constraint fk_vols_apprenti FOREIGN KEY (idAppP) REFERENCES APPRENTI_PILOTE(idAppP),
    constraint fk_vols_instructeur FOREIGN KEY (idIns) REFERENCES INSTRUCTEUR(idIns),
    constraint fk_vols_avion FOREIGN KEY (idA) REFERENCES AVION(idA)
);

CREATE TABLE CONTROLE_TECHNIQUE (
    idCT BIGINT PRIMARY KEY auto_increment,
    estValideCT BOOLEAN NOT NULL ,
    dateCT DATE not null,
    heureCT TIME NOT NULL,
    idTech BIGINT,
    idA BIGINT,

    constraint fk_controle_technique_technicien FOREIGN KEY (idTech) REFERENCES TECHNICIEN(idTech),
    constraint fk_controle_technique_avion FOREIGN KEY (idA) REFERENCES AVION(idA)
);

CREATE TABLE POSSEDER (
    idPers BIGINT,
    nomF VARCHAR(10),
    dateObtention DATE,

    constraint fk_possder_personne FOREIGN KEY (idPers) REFERENCES PERSONNE(idPers),
    constraint fk_posseder_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_posseder PRIMARY KEY (idPers, nomF)
);

CREATE TABLE FORMER (
    idIns BIGINT,
    nomF VARCHAR(10),

    constraint fk_former_instructeur FOREIGN KEY (idIns) REFERENCES PERSONNE(idPers),
    constraint fk_former_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_former PRIMARY KEY (idIns, nomF)
);

CREATE TABLE CONVENIR (
    idA BIGINT(9),
    nomF VARCHAR(10),

    constraint fk_convenir_avion FOREIGN KEY (idA) REFERENCES AVION(idA),
    constraint fk_convenir_formation FOREIGN KEY (nomF) REFERENCES FORMATION(nomF),
    constraint pk_convenir PRIMARY KEY (idA, nomF)
);