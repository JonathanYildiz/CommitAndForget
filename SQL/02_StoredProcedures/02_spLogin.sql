
DROP PROCEDURE IF EXISTS spLogin;

DELIMITER $$

CREATE PROCEDURE spLogin(
	IN p_Mail NVARCHAR(200),
    IN p_Passwort NVARCHAR(200)
)
BEGIN
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail, bIsAdmin
    FROM tblbenutzer
    WHERE szMail = p_Mail
    AND szPasswort = p_Passwort;
    
END $$

DELIMITER ;