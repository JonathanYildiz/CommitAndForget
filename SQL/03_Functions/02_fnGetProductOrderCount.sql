USE dbcommitandforget;

DROP FUNCTION IF EXISTS fnGetProductOrderCount;

DELIMITER $$

CREATE FUNCTION fnGetProductOrderCount(p_ProductLink INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE orderCount INT;
    
    SELECT IFNULL(SUM(op.nQuantity), 0) INTO orderCount
    FROM tblorderproduct op
    WHERE op.nProductLink = p_ProductLink;
    
    RETURN orderCount;
END $$

DELIMITER ;