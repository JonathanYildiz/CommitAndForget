USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spAddMenuToOrder;

DELIMITER $$

CREATE PROCEDURE spAddMenuToOrder(
	p_OrderLink INT,
    p_MenuLink INT,
    p_Quantity INT
    )
BEGIN    
	INSERT INTO tblordermenu(nOrderLink, nMenuLink, nQuantity)
    VALUES (p_OrderLink, p_MenuLink, p_Quantity);
END $$

DELIMITER ;

