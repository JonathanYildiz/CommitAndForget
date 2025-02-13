USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetIngredients;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetIngredients(
p_ProductLink INT
)

BEGIN 
SELECT 
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName,
    pi.nQuantity AS ingredient_nQuantity
    FROM tblingredient i
    LEFT JOIN tblproductingredient pi ON pi.nIngredientLink = i.nKey AND pi.nProductLink = p_ProductLink
    ORDER BY i.nKey;
END $$

DELIMITER ;



