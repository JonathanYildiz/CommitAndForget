USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spAddProductToOrder;

DELIMITER $$

CREATE PROCEDURE spAddProductToOrder(
	p_OrderLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )
BEGIN    
	INSERT INTO tblorderproduct(nOrderLink, nProductLink, nQuantity)
    VALUES (p_OrderLink, p_ProductLink, p_Quantity);
END $$

DELIMITER ;

