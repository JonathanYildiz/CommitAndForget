USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spCreateImage;

DELIMITER $$

CREATE PROCEDURE spCreateImage(
    p_Image LONGBLOB,
    p_UserLink int
)
BEGIN
    INSERT INTO tblImage (vbImage, bApproved, dtCreationDate, bContestWon, nUserLink)
    VALUES (p_Image, 0, NOW(), 0, p_UserLink);
	
    
    SELECT nKey from tblimage WHERE vbImage = p_Image;


END $$

DELIMITER ;

