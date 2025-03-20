USE dbcommitandforget;
DROP PROCEDURE IF EXISTS spGetImages;

DELIMITER $$
-- Laden von Bilder
CREATE PROCEDURE spGetImages(
	p_UserLink INT
)

BEGIN 

-- Wenn Gültiger Benutzer, dann Ratings des Benutzers dazu laden
IF EXISTS (
        SELECT 1
        FROM tbluser u
        WHERE u.nkey = p_UserLink 
        AND u.bIsAdmin = 0
    ) THEN

			SELECT 
				 img.nKey AS image_nKey,
			    vbImage AS image_vbImage,
			    bApproved AS image_bApproved,
				 dtCreationDate AS image_dtCreationDate,
			    bContestWon AS image_bContestWon,
			    case when usr.bIsAdmin = 1 then 'admin' ELSE usr.szEmail end AS image_szUploadedBy,
			    rat.nRating AS image_rRating
			    FROM tblimage img
			    JOIN tbluser usr ON usr.nKey = img.nUserLink
			    left JOIN tblrating rat ON rat.nImageLink = img.nKey
			    						 AND rat.nUserLink = p_UserLink
			    ORDER BY img.nKey;
		ELSE
        -- Ansonsten alle Bilder laden
        SELECT 
			    img.nKey AS image_nKey,
			    img.vbImage AS image_vbImage,
			    img.bApproved AS image_bApproved,
			    img.dtCreationDate AS image_dtCreationDate,
			    img.bContestWon AS image_bContestWon,
			    CASE 
			        WHEN usr.bIsAdmin = 1 THEN 'admin' 
			        ELSE usr.szEmail 
			    END AS image_szUploadedBy,
			    AVG(rat.nRating) AS image_rRating
			FROM tblimage img
			JOIN tbluser usr ON usr.nKey = img.nUserLink
			LEFT JOIN tblrating rat ON rat.nImageLink = img.nKey
			GROUP BY 
			    img.nKey,
			    img.vbImage,
			    img.bApproved,
			    img.dtCreationDate,
			    img.bContestWon,
			    usr.bIsAdmin,
			    usr.szEmail
			ORDER BY img.nKey;
    END IF;
END $$

DELIMITER ;



