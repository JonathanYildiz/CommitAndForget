USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateIngredient;

DELIMITER $$

CREATE PROCEDURE spUpdateIngredient(
	 p_Key INT,
	 p_Name VARCHAR(200)
    )
BEGIN
   UPDATE tblingredient
   SET 
		szName = p_Name
   WHERE nKey = p_Key;
END $$

DELIMITER ;

