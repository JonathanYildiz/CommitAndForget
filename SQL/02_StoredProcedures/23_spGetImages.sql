USE dbcommitandforget;
select * from tblimage;
DROP PROCEDURE IF EXISTS spGetImages;

DELIMITER $$
-- Laden von Bilder
CREATE PROCEDURE spGetImages()

BEGIN 
SELECT 
	nKey AS image_nKey,
    vbImage AS image_vbImage,
    bApproved AS image_bApproved,
	dtCreationDate AS image_dtCreationDate,
    bContestWon AS image_bContestWon
    
    FROM tblimage 
    ORDER BY nKey;
END $$

DELIMITER ;



