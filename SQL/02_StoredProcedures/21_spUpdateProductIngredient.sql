USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateProductIngredient;

DELIMITER $$
CREATE PROCEDURE spUpdateProductIngredient(

    p_IngredientLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )

BEGIN
    INSERT INTO tblproductingredient (nIngredientLink, nProductLink, nQuantity)
    VALUES (p_IngredientLink, p_ProductLink, p_Quantity);
    
END $$

DELIMITER ;
