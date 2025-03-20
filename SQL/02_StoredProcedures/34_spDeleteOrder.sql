USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteOrder;

DELIMITER $$
CREATE PROCEDURE spDeleteOrder(
	IN p_OrderId INT
)
BEGIN
   
   DELETE 
	FROM tblorder
   WHERE nKey = p_OrderId;
   
   DELETE
   FROM tblordermenu
   WHERE nOrderLink = p_OrderId;
   
   DELETE
   FROM tblorderproduct
   WHERE nOrderLink = p_OrderId;
      
END $$

DELIMITER ;
