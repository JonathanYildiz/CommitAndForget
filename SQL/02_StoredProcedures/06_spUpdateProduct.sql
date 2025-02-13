USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateProduct;

DELIMITER $$

CREATE PROCEDURE spUpdateProduct(
	 p_Key INT,
	 p_Name VARCHAR(200),
	 p_Price  DECIMAL(5,2),
     p_ImageLink INT,
     p_Energy INT
    )
BEGIN
   UPDATE tblproduct 
   SET 
		szName = p_Name,
		rPrice = p_Price,
        nEnergy = p_Energy,
        nImageLink = p_ImageLink
   WHERE nKey = p_Key;
END $$

DELIMITER ;

