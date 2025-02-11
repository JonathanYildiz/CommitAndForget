DROP PROCEDURE IF EXISTS spUpdateUser;

DELIMITER $$

CREATE PROCEDURE spUpdateUser(
	IN p_Key INT, 
	IN p_FirstName NVARCHAR(200),
    IN p_LastName NVARCHAR(200),
    IN p_Street NVARCHAR(200),
    IN p_HouseNumber NVARCHAR(200),
    IN p_PostalCode NVARCHAR(200),
    IN p_City NVARCHAR(200),
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200)
)
BEGIN
	DECLARE v_Count INT;
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword
    FROM tbluser
    WHERE nKey = p_Key;
   
	IF v_Count = 0 THEN
		SELECT 'Fehler: Benutzer ist nicht gefunden!' AS Nachricht;
    ELSE
		UPDATE tbluser
        SET 
			szFirstName = p_FirstName,
            szLastName = p_LastName,
            szStreet = p_Street,
            szHouseNumber = p_HouseNumber,
            szPostalCode = p_PostalCode, 
            szCity = p_City,
            szEmail = p_Email,
            szPassword = coalesce(nullif(p_Password, ""), szPassword)
            
		WHERE nKey = p_Key;
        
        SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail
        FROM tbluser 
        WHERE nKey = p_Key;
	END IF;
			
END $$

DELIMITER ;