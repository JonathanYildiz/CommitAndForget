DROP PROCEDURE IF EXISTS spUpdateUser;

DELIMITER $$

CREATE PROCEDURE spUpdateUser(
    IN p_Key INT, 
    IN p_FirstName VARCHAR(200),
    IN p_LastName VARCHAR(200),
    IN p_Street VARCHAR(200),
    IN p_HouseNumber VARCHAR(200),
    IN p_PostalCode VARCHAR(200),
    IN p_City VARCHAR(200),
    IN p_Email VARCHAR(200),
    IN p_Password VARCHAR(200),
    IN p_IsAdmin bit
)
BEGIN
    DECLARE v_Count INT;
    
    -- Prüfen, ob der Benutzer existiert
    SELECT COUNT(*)
    INTO v_Count
    FROM tbluser
    WHERE nKey = p_Key;
   
    IF v_Count = 0 THEN
        SELECT 'Fehler: Benutzer ist nicht gefunden!' AS Nachricht;
    ELSE
        -- Benutzer aktualisieren
        UPDATE tbluser
        SET 
            szFirstName = coalesce(p_FirstName, szFirstName),
            szLastName = coalesce(p_LastName, szLastName),
            szStreet = coalesce(p_Street, szStreet),
            szHouseNumber = coalesce(p_HouseNumber, szHouseNumber),
            szPostalCode = coalesce(p_PostalCode, szPostalCode), 
            szCity = coalesce(p_City, szCity),
            szEmail = coalesce(p_Email, szEmail),
            bIsAdmin = coalesce(p_IsAdmin, bIsAdmin),
            szPassword = coalesce(nullif(p_Password, ""), szPassword)
        WHERE nKey = p_Key;
        
        -- Zurückgeben der aktualisierten Benutzerdaten
        SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
        FROM tbluser 
        WHERE nKey = p_Key;
    END IF;
    
END $$

DELIMITER ;
