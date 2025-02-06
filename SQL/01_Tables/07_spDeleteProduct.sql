select * from tblproduct;
USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteProduct;

DELIMITER $$

CREATE PROCEDURE spDeleteProduct(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductmenu WHERE nProductLink = p_Key;
   DELETE FROM tblproductingredient WHERE nProductLink = p_Key;
   DELETE FROM tblproduct WHERE nKey = p_Key;
END $$

DELIMITER ;

