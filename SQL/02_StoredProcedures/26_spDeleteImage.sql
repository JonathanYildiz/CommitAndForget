USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteImage;

DELIMITER $$

CREATE PROCEDURE spDeleteImage(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblimage WHERE nKey = p_Key;
   
END $$

DELIMITER ;