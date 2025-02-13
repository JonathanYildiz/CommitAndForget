USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spCreateImage;

DELIMITER $$

CREATE PROCEDURE spCreateImage(
    p_Image LONGBLOB 
)
BEGIN
    INSERT INTO tblImage (vbImage, bApproved, dtCreationDate, bContestWon)
    VALUES (p_Image, 0, now(), 0);
	
    
    SELECT nKey from tblimage WHERE vbImage = p_Image;


END $$

DELIMITER ;

