DROP PROCEDURE IF EXISTS spRegisterBenutzen;

DELIMITER $$

CREATE PROCEDURE spRegisterBenutzen(
	IN p_Name NVARCHAR(200),
    IN p_Strasse NVARCHAR(200),
    IN p_Hausnummer INT,
    IN p_Postleitzahl NVARCHAR(200),
    IN p_Wohnort NVARCHAR(200),
	IN p_Mail NVARCHAR(200),
    IN p_Passwort NVARCHAR(200)
)
BEGIN
	DECLARE v_Count INT;
    
-- Pruefen, ob die Mail bereits existiert (wenn v_Count = 0, dann Meil nicht existiert)
	SELECT COUNT(*) INTO v_Count
    FROM tblbenutzer
    WHERE szMail = p_Mail;
    
    IF v_Count > 0 THEN 
		SELECT 'Fehler: Die E-Mail-Adresse ist bereits registriert.' AS Nachricht;
	ELSE 
		INSERT INTO tblbenutzer (szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail, szPasswort)
        VALUES (p_Name, p_Strasse, p_Hausnummer,  p_Postleitzahl, p_Wohnort, p_Mail, p_Passwort);
        
        SELECT  nKey, szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail, bIsAdmin
        FROM tblbenutzer 
        WHERE  szMail = p_Mail;
    END IF;
    
END $$

DELIMITER ;