DROP PROCEDURE IF EXISTS spLogin;

DELIMITER $$

CREATE PROCEDURE spLogin(
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200)
)
BEGIN
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
    FROM tbluser
    WHERE szEmail = p_Email
    AND szPassword = p_Password;
    
END $$

DELIMITER ;