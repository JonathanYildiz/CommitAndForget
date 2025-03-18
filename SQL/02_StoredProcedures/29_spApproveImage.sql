USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spApproveImage;

DELIMITER $$
CREATE PROCEDURE spApproveImage(

    p_ImageLink INT
    )

BEGIN

    UPDATE tblimage i
    SET i.bApproved = 1
    WHERE i.nKey = p_ImageLink;
    
END $$

DELIMITER ;
