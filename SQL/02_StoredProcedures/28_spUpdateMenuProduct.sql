USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateMenuProduct;

DELIMITER $$
CREATE PROCEDURE spUpdateMenuProduct(

    p_MenuLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )

BEGIN
    INSERT INTO tblproductmenu (nMenuLink, nProductLink, nQuantity)
    VALUES (p_MenuLink, p_ProductLink, p_Quantity);
    
END $$

DELIMITER ;
