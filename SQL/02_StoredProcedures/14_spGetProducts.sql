USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetProducts;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetProducts()

BEGIN 
SELECT 
	p.nKey AS product_nKey,
    p.szName AS product_szName,
    p.nEnergy AS product_nEnergy,
    p.rPrice AS product_rPrice,
    img.nKey AS image_nKey,
    img.vbImage AS image_vbImage,
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName,
    pi.nQuantity AS ingredient_nQuantity,
    fnGetProductOrderCount(p.nKey) AS product_nOrderCount
    FROM tblproduct p 
    LEFT JOIN tblproductingredient pi ON p.nKey = pi.nProductLink
    LEFT JOIN tblimage img ON p.nImageLink = img.nKey
    LEFT JOIN tblingredient i ON pi.nIngredientLink = i.nKey
    ORDER BY p.nKey, i.szName;
END $$

DELIMITER ;

