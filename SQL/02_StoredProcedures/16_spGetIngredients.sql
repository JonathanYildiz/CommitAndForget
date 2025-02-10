USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetIngredients;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetIngredients()

BEGIN 
SELECT 
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName
    FROM tblingredient i
    ORDER BY i.nKey;
END $$

DELIMITER ;



