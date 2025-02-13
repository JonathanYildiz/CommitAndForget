DROP PROCEDURE IF EXISTS spUpdateImage;
select * from tblimage;
DELIMITER $$

CREATE PROCEDURE spUpdateImage(
    IN p_Key INT, 
    IN p_Approved BIT,
    IN p_ContestWon BIT
)
BEGIN
    DECLARE v_Count INT;
    
    -- Prüfen, ob der Benutzer existiert
    SELECT COUNT(*)
    INTO v_Count
    FROM tblimage
    WHERE nKey = p_Key;
   
    IF v_Count = 0 THEN
        SELECT 'Fehler: Bild konnte nicht gefunden werden!' AS Nachricht;
    ELSE
        -- Benutzer aktualisieren
        UPDATE tblimage
        SET 
			bApproved = p_Approved,
            bContestWon = p_ContestWon
        WHERE nKey = p_Key;
        
        -- Zurückgeben der aktualisierten Bilderdaten
        SELECT nKey, vbImage, bApproved, dtCreationDate, bContestWon
        FROM tblimage 
        WHERE nKey = p_Key;
    END IF;
    
END $$

DELIMITER ;
