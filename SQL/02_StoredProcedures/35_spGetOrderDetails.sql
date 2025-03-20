USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetOrderDetails;

DELIMITER $$
CREATE PROCEDURE spGetOrderDetails(
	IN p_OrderId INT
)
BEGIN
   
   SELECT m.szName AS item_Name
   	  , om.nQuantity AS item_Quantity
        , m.rPrice AS item_Price      
	FROM tblorder o
	JOIN tblordermenu om ON om.nOrderLink = o.nKey
	JOIN tblmenu m ON m.nKey = om.nMenuLink
	WHERE o.nKey = p_OrderId
	
	UNION ALL
	
	SELECT p.szName AS item_Name
	     , op.nQuantity AS item_Quantity
		  , p.rPrice AS item_Price
	FROM tblorder o
	JOIN tblorderproduct op ON op.nOrderLink = o.nKey
	JOIN tblproduct p ON p.nKey = op.nProductLink
	WHERE o.nKey = p_OrderId;
      
END $$

DELIMITER ;
