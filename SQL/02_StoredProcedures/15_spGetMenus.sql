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
	imgMenu.nKey AS imageMenu_nKey,
   imgMenu.vbImage AS imageMenu_vbImage,
   pm.nQuantity AS product_nQuantity,
	p.nKey AS product_nKey,
   p.szName AS product_szName,
   fnGetMenuOrderCount(m.nKey) AS menu_nOrderCount    
    FROM tblmenu m
	 LEFT JOIN tblimage imgMenu ON m.nImageLink = imgMenu.nKey
    LEFT JOIN tblproductmenu pm ON m.nKey = pm.nMenuLink
    LEFT JOIN tblproduct p ON pm.nProductLink = p.nKey
    ORDER BY m.nKey, p.nKey;
END $$

DELIMITER ;



