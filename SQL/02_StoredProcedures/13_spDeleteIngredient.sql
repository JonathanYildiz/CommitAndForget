USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteIngredient;

DELIMITER $$

CREATE PROCEDURE spDeleteIngredient(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductingredient WHERE nIngredientLink = p_Key;
   DELETE FROM tblingredient WHERE nKey = p_Key;
END $$

DELIMITER ;

