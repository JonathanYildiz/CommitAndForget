DROP PROCEDURE IF EXISTS spUpdateUser;

DELIMITER $$

CREATE PROCEDURE spUpdateUser(
	IN p_Key INT, 
	IN p_Firstname NVARCHAR(200),
    IN p_Lastname NVARCHAR(200),
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
	SELECT nKey, szFirstname, szLastname, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword
    FROM tbluser
    WHERE nKey = p_Key;
   
	IF v_Count = 0 THEN
		SELECT 'Error: User is not found!' AS Nachricht;
    ELSE
		UPDATE tbluser
        SET 
			szFirstname = p_Firstname,
            szLastname = p_Lastname,
            szStreet = p_Street,
            szHouseNumber = p_HouseNumber,
            szPostalCode = p_PostalCode, 
            szCity = p_City,
            szEmail = p_Email,
            szPassword = p_Password
		WHERE nKey = p_Key;
        
        SELECT nKey, szFirstname, szLastname, szStreet, szHouseNumber, szPostalCode, szCity, szEmail
        FROM tbluser 
        WHERE nKey = p_Key;
	END IF;
			
END $$

DELIMITER ;