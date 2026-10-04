DELIMITER $$

-- VOLS : C1, C2, C4, C5, C6, C7, C8, C11
DROP TRIGGER IF EXISTS trg_vols_bi $$
CREATE TRIGGER trg_vols_bi BEFORE INSERT ON VOLS FOR EACH ROW
BEGIN
    DECLARE debut DATETIME;
    DECLARE fin DATETIME;
    DECLARE lieu VARCHAR(50);
    DECLARE formEnCours VARCHAR(10);

    SET debut = TIMESTAMP(NEW.dateV, NEW.heureV);
    SET fin   = DATE_ADD(debut, INTERVAL NEW.dureeV MINUTE);

    -- C1 : l'avion n'est pas déjà sur un vol qui chevauche
    IF EXISTS (SELECT 1 FROM VOLS v
               WHERE v.idA = NEW.idA
                 AND TIMESTAMP(v.dateV, v.heureV) < fin
                 AND DATE_ADD(TIMESTAMP(v.dateV, v.heureV), INTERVAL v.dureeV MINUTE) > debut) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C1 : avion déjà utilisé sur cette période';
    END IF;

    -- C11 : apprenti / instructeur pas sur deux vols qui se chevauchent
    IF EXISTS (SELECT 1 FROM VOLS v
               WHERE ((NEW.idAppP IS NOT NULL AND v.idAppP = NEW.idAppP)
                   OR (NEW.idIns  IS NOT NULL AND v.idIns  = NEW.idIns))
                 AND TIMESTAMP(v.dateV, v.heureV) < fin
                 AND DATE_ADD(TIMESTAMP(v.dateV, v.heureV), INTERVAL v.dureeV MINUTE) > debut) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C11 : apprenti ou instructeur déjà sur un vol à ce moment';
    END IF;

    -- C2 : départ = dernier lieu connu de l'avion
    SELECT COALESCE(
             (SELECT v.aerodromeArrivee FROM VOLS v
              WHERE v.idA = NEW.idA AND TIMESTAMP(v.dateV, v.heureV) < debut
              ORDER BY TIMESTAMP(v.dateV, v.heureV) DESC LIMIT 1),
             a.aerodromeActuel)
      INTO lieu FROM AVION a WHERE a.idA = NEW.idA;
    IF lieu <> NEW.aerodromeDepart THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C2 : l''avion n''est pas sur l''aérodrome de départ';
    END IF;

    -- C4 : durée < autonomie (heures -> minutes)
    IF NEW.dureeV >= (SELECT autonomie FROM AVION WHERE idA = NEW.idA) * 60 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C4 : durée supérieure ou égale à l''autonomie';
    END IF;

    -- C5 : dernier contrôle technique valide (aucun contrôle = refus)
    IF NOT COALESCE((SELECT estValideCT FROM CONTROLE_TECHNIQUE
                     WHERE idA = NEW.idA AND TIMESTAMP(dateCT, heureCT) <= debut
                     ORDER BY TIMESTAMP(dateCT, heureCT) DESC LIMIT 1), FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C5 : dernier contrôle technique non valide';
    END IF;

    -- C6 : pas après la date limite de révision
    IF NEW.dateV > (SELECT dateLimiteRevision FROM AVION WHERE idA = NEW.idA) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C6 : date limite de révision dépassée';
    END IF;

    -- C7 et C8 : formation en cours de l'apprenti
    IF NEW.idAppP IS NOT NULL THEN
        SELECT nomF INTO formEnCours FROM APPRENTI_PILOTE WHERE idAppP = NEW.idAppP;

        IF NEW.idIns IS NOT NULL AND NOT EXISTS
           (SELECT 1 FROM FORMER WHERE idIns = NEW.idIns AND nomF = formEnCours) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C7 : l''instructeur n''enseigne pas cette formation';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM CONVENIR WHERE idA = NEW.idA AND nomF = formEnCours) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C8 : avion non lié à la formation de l''apprenti';
        END IF;
    END IF;
END $$

-- C3 : pas de contrôle technique pendant un vol
DROP TRIGGER IF EXISTS trg_ct_bi $$
CREATE TRIGGER trg_ct_bi BEFORE INSERT ON CONTROLE_TECHNIQUE FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM VOLS v
               WHERE v.idA = NEW.idA
                 AND TIMESTAMP(NEW.dateCT, NEW.heureCT) >= TIMESTAMP(v.dateV, v.heureV)
                 AND TIMESTAMP(NEW.dateCT, NEW.heureCT) <
                     DATE_ADD(TIMESTAMP(v.dateV, v.heureV), INTERVAL v.dureeV MINUTE)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C3 : l''avion est en vol à ce moment';
    END IF;
END $$

-- C10 : formation obtenue
DROP TRIGGER IF EXISTS trg_posseder_bi $$
CREATE TRIGGER trg_posseder_bi BEFORE INSERT ON POSSEDER FOR EACH ROW
BEGIN
    DECLARE requise VARCHAR(10);
    SELECT formationNecessaire INTO requise FROM FORMATION WHERE nomF = NEW.nomF;
    IF requise IS NOT NULL AND NOT EXISTS
       (SELECT 1 FROM POSSEDER WHERE idPers = NEW.idPers AND nomF = requise) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C10 : formation requise non obtenue';
    END IF;
END $$

-- C10 : formation suivie (à dupliquer en BEFORE UPDATE si tu changes nomF)
DROP TRIGGER IF EXISTS trg_apprenti_bi $$
CREATE TRIGGER trg_apprenti_bi BEFORE INSERT ON APPRENTI_PILOTE FOR EACH ROW
BEGIN
    DECLARE requise VARCHAR(10);
    SELECT formationNecessaire INTO requise FROM FORMATION WHERE nomF = NEW.nomF;
    IF requise IS NOT NULL AND NOT EXISTS
       (SELECT 1 FROM POSSEDER WHERE idPers = NEW.idAppP AND nomF = requise) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'C10 : formation requise non obtenue';
    END IF;
END $$

DELIMITER ;

DROP EVENT IF EXISTS ev_maj_aerodrome;

DELIMITER $$
CREATE EVENT ev_maj_aerodrome
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
    UPDATE AVION a
    JOIN (
        SELECT v.idA, v.aerodromeArrivee
        FROM VOLS v
        WHERE DATE_ADD(TIMESTAMP(v.dateV, v.heureV), INTERVAL v.dureeV MINUTE) <= NOW()
          AND TIMESTAMP(v.dateV, v.heureV) = (
                SELECT MAX(TIMESTAMP(v2.dateV, v2.heureV))
                FROM VOLS v2
                WHERE v2.idA = v.idA
                  AND DATE_ADD(TIMESTAMP(v2.dateV, v2.heureV), INTERVAL v2.dureeV MINUTE) <= NOW())
    ) dernier ON dernier.idA = a.idA
    SET a.aerodromeActuel = dernier.aerodromeArrivee
    WHERE a.idA > 0
      AND a.aerodromeActuel <> dernier.aerodromeArrivee;
END $$
DELIMITER ;