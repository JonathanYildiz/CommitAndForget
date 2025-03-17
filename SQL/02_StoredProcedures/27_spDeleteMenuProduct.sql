USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteMenuProduct;

DELIMITER $$

CREATE PROCEDURE spDeleteMenuProduct(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductmenu WHERE nMenuLink = p_Key;
END $$

DELIMITER ;

