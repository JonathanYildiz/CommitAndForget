USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteUser;

DELIMITER $$

CREATE PROCEDURE spDeleteUser(
	 p_Key INT
    )
BEGIN
   DELETE FROM tbluser WHERE nKey = p_Key;
   
END $$

DELIMITER ;