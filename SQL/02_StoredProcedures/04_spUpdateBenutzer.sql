DROP PROCEDURE IF EXISTS spUpdateBenutzer;

DELIMITER $$

CREATE PROCEDURE spUpdateBenutzer(
	IN p_Key INT, 
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
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail, szPasswort
    FROM tblbenutzer
    WHERE nKey = p_Key;
   
	IF v_Count = 0 THEN
		SELECT 'Fehler: Benutzer ist nicht gefunden!' AS Nachricht;
    ELSE
		UPDATE tblbenutzer
        SET 
			szName = p_Name,
            szStrasse = p_Strasse,
            nHausnummer = p_Hausnummer,
            szPostleitzahl = p_Postleitzahl, 
            szWohnort = p_Wohnort,
            szMail = p_Mail,
            szPasswort = p_Passwort
		WHERE nKey = p_Key;
        
        SELECT nKey, szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail
        FROM tblbenutzer 
        WHERE nKey = p_Key;
	END IF;
			
END $$

DELIMITER ;