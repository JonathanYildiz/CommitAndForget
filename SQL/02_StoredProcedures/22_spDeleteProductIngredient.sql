USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteProductIngredient;

DELIMITER $$

CREATE PROCEDURE spDeleteProductIngredient(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductingredient WHERE nProductLink = p_Key;
END $$

DELIMITER ;

