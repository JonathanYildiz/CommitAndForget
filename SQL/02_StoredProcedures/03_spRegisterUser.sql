DROP PROCEDURE IF EXISTS spRegisterUser;

DELIMITER $$

CREATE PROCEDURE spRegisterUser(
	IN p_FirstName NVARCHAR(200),
    IN p_LastName NVARCHAR(200),
    IN p_Street NVARCHAR(200),
    IN p_HouseNumber NVARCHAR(200),
    IN p_PostalCode NVARCHAR(200),
    IN p_City NVARCHAR(200),
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200),
    IN p_IsAdmin BIT
  
)
BEGIN
	DECLARE v_Count INT;
    
-- Pruefen, ob die Mail bereits existiert (wenn v_Count = 0, dann Meil nicht existiert)
	SELECT COUNT(*) INTO v_Count
    FROM tbluser
    WHERE szEmail = p_Email;
    
    IF v_Count > 0 THEN 
		SELECT 'Fehler: Die E-Mail-Adresse ist bereits registriert.' AS Nachricht;
	ELSE 
		INSERT INTO tbluser (szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword, bIsAdmin)
        VALUES (p_FirstName, p_LastName,  p_Street, p_HouseNumber,  p_PostalCode, p_City, p_Email, p_Password, p_IsAdmin);
        
        SELECT  nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
        FROM tbluser 
        WHERE  szEmail = p_Email;
    END IF;
    
END $$

DELIMITER ;