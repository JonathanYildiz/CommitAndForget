USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spRateImage;

DELIMITER $$
CREATE PROCEDURE spRateImage(

    p_ImageLink INT,
    p_ImageRating INT,
    p_UserLink INT
    )

BEGIN
    -- Überprüfen, ob bereits ein Eintrag mit dem gleichen UserLink und ImageLink existiert
    IF NOT EXISTS (
        SELECT 1
        FROM tblrating
        WHERE nUserLink = p_UserLink AND nImageLink = p_ImageLink
    ) THEN
        -- Wenn kein Eintrag existiert, anlegen
        INSERT INTO tblrating (nRating, nUserLink, nImageLink)
        VALUES (p_ImageRating, p_UserLink, p_ImageLink);
    ELSE
        -- Wenn ein Eintrag existiert, aktualisiere den bestehenden Eintrag
        UPDATE tblrating
        SET nRating = p_ImageRating
        WHERE nUserLink = p_UserLink AND nImageLink = p_ImageLink;
    END IF;
END $$

DELIMITER ;
