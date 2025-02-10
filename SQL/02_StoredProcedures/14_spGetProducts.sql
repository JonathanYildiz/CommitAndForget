USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetProducts;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetProducts()

BEGIN 
SELECT 
	p.nKey AS product_key,
    p.szName AS produkt_name,
    i.nKey AS ingredient_key,
    i.szName AS ingredient_name
    FROM tblproduct p 
    LEFT JOIN tblproductingredient pi ON p.nKey = pi.nProductLink
    LEFT JOIN tblingredient i ON pi.nIngredientLink = i.nKey
    ORDER BY p.nKey, i.szName;
END $$

DELIMITER ;

