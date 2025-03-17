USE dbcommitandforget;
DROP PROCEDURE IF EXISTS spGetImages;

DELIMITER $$
-- Laden von Bilder
CREATE PROCEDURE spGetImages()

BEGIN 
SELECT 
	 img.nKey AS image_nKey,
    vbImage AS image_vbImage,
    bApproved AS image_bApproved,
	 dtCreationDate AS image_dtCreationDate,
    bContestWon AS image_bContestWon,
    case when usr.bIsAdmin = 1 then 'admin' ELSE usr.szEmail end AS image_szUploadedBy
    
    FROM tblimage img
    JOIN tbluser usr ON usr.nKey = img.nUserLink
    ORDER BY img.nKey;
END $$

DELIMITER ;



