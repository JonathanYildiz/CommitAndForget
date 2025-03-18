USE dbcommitandforget;

DROP FUNCTION IF EXISTS fnGetMenuOrderCount;

DELIMITER $$

CREATE FUNCTION fnGetMenuOrderCount(p_MenuLink INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE orderCount INT;
    
    SELECT IFNULL(SUM(om.nQuantity), 0) INTO orderCount
    FROM tblordermenu om
    WHERE om.nMenuLink = p_MenuLink;
    
    RETURN orderCount;
END $$

DELIMITER ;
