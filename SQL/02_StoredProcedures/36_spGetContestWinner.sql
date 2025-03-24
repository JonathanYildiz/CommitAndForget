USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetContestWinner;

DELIMITER $$

CREATE PROCEDURE spGetContestWinner()
BEGIN
    -- DEBUG: Alle genehmigten Bilder auf den ersten Tag des letzten Monats setzen
    UPDATE tblImage
    SET dtCreationDate = LAST_DAY(CURRENT_DATE - INTERVAL 2 MONTH) + INTERVAL 1 DAY
    WHERE bApproved = 1;
   
    -- Überprüfen, ob es bereits Gewinner gibt
    IF EXISTS (
        SELECT 1 FROM tblImage 
        WHERE YEAR(dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
          AND MONTH(dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
          AND bApproved = 1
          AND bContestWon = 1
    ) THEN
        -- Falls ja, diese direkt zurückgeben
        SELECT img.nKey AS image_nKey
        		 , usr.szFirstName AS image_szUploadedBy
        		 , img.vbImage AS image_vbImage
		  FROM tblImage img
		  JOIN tbluser usr ON usr.nKey = img.nUserLink
        WHERE YEAR(dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
          AND MONTH(dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
          AND bApproved = 1
          AND bContestWon = 1;
    ELSE
        -- Falls noch kein Gewinner existiert, bestbewertete Bilder ermitteln
        DROP TEMPORARY TABLE IF EXISTS TempTopImages;
        CREATE TEMPORARY TABLE TempTopImages AS 
        SELECT mi.nKey
        FROM tblImage mi
        JOIN (
            SELECT r.nImageLink, AVG(r.nRating) AS avgRating
            FROM tblRating r
            JOIN tblImage i ON r.nImageLink = i.nKey
            WHERE YEAR(i.dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
              AND MONTH(i.dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
              AND i.bApproved = 1
            GROUP BY r.nImageLink
        ) ir ON mi.nKey = ir.nImageLink
        WHERE ir.avgRating = (
            SELECT MAX(avgRating) FROM (
                SELECT AVG(r.nRating) AS avgRating
                FROM tblRating r
                JOIN tblImage i ON r.nImageLink = i.nKey
                WHERE YEAR(i.dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
                  AND MONTH(i.dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
                  AND i.bApproved = 1
                GROUP BY r.nImageLink
            ) AS MaxRating
        );

        -- Die Gewinner als bContestWon markieren
        UPDATE tblImage 
        SET bContestWon = 1
        WHERE nKey IN (SELECT nKey FROM TempTopImages);

        -- Gewinner zurückgeben
        SELECT img.nKey AS image_nKey
        		 , usr.szFirstName AS image_szUploadedBy
        		 , img.vbImage AS image_vbImage
		  FROM tblimage img
		  JOIN tbluser usr ON usr.nKey = img.nUserLink
        WHERE img.nKey IN (SELECT nKey FROM TempTopImages);
    END IF;
END $$

DELIMITER ;
