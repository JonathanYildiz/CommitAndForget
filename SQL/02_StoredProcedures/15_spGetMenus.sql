USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetMenus;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetMenus()

BEGIN 
SELECT 
	m.nKey AS menu_nKey,
    m.szName AS menu_szName,
    m.rPrice AS menu_rPrice,
    m.nImageLink AS menu_nImageLink,
	p.nKey AS product_nKey,
    p.szName AS product_szName,
    p.nEnergy AS product_nEnergy,
    p.rPrice AS product_rPrice,
    p.nImageLink AS product_nImageLink,
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName
    FROM tblmenu m
    LEFT JOIN tblproductmenu pm ON m.nKey = pm.nMenuLink
    LEFT JOIN tblproduct p ON pm.nProductLink = p.nKey
    LEFT JOIN tblproductingredient pi ON p.nKey = pi.nProductLink
    LEFT JOIN tblingredient i ON pi.nIngredientLink = i.nKey
    ORDER BY m.nKey, p.szName, i.szName;
END $$

DELIMITER ;



