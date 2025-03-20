USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetOrderHistory;

DELIMITER $$
CREATE PROCEDURE spGetOrderHistory()
BEGIN
   
   SELECT u.szEmail AS user_Mail,
	       o.nKey AS order_nKey,
	       o.dtOrderDate AS order_CreationDate,
	       SUM(IFNULL(m.rPrice, 0) * IFNULL(om.nQuantity, 0)) + SUM(IFNULL(p.rPrice, 0) * IFNULL(op.nQuantity, 0)) AS order_TotalPrice
	FROM tblorder o
	JOIN tbluser u ON u.nKey = o.nUserLink
	LEFT JOIN tblordermenu om ON om.nOrderLink = o.nKey
	LEFT JOIN tblmenu m ON m.nKey = om.nMenuLink
	LEFT JOIN tblorderproduct op ON op.nOrderLink = o.nKey
	LEFT JOIN tblproduct p ON p.nKey = op.nProductLink
	GROUP BY u.szEmail, o.nKey, o.dtOrderDate
	ORDER BY o.nKey;
      
END $$

DELIMITER ;
