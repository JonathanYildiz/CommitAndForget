USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetOrderHistory;

DELIMITER $$
CREATE PROCEDURE spGetOrderHistory()
BEGIN
   
  SELECT combined.szEmail AS user_Mail,
	       combined.nKey AS order_nKey,
	       combined.dtOrderDate AS order_CreationDate,
	       SUM(order_TotalPrice) AS order_TotalPrice
	FROM (
	    SELECT o.nKey,
	           o.dtOrderDate,
	           u.szEmail,
	           (p.rPrice * op.nQuantity) AS order_TotalPrice
	    FROM tblorder o
	    JOIN tbluser u ON u.nKey = o.nUserLink
	    LEFT JOIN tblorderproduct op ON op.nOrderLink = o.nKey
	    LEFT JOIN tblproduct p ON p.nKey = op.nProductLink
	    UNION ALL
	    SELECT o.nKey,
	           o.dtOrderDate,
	           u.szEmail,
	           (m.rPrice * om.nQuantity) AS order_TotalPrice
	    FROM tblorder o
	    JOIN tbluser u ON u.nKey = o.nUserLink
	    LEFT JOIN tblordermenu om ON om.nOrderLink = o.nKey
	    LEFT JOIN tblmenu m ON m.nKey = om.nMenuLink
	) AS combined
	GROUP BY combined.szEmail, combined.nKey, combined.dtOrderDate
	ORDER BY combined.nKey;
      
END $$

DELIMITER ;
