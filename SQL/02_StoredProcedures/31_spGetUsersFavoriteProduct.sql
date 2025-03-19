USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetUsersFavoriteProduct;

DELIMITER $$
CREATE PROCEDURE spGetUsersFavoriteProduct(

    p_UserLink INT
    )

BEGIN
   
   SELECT p.szName AS product_Name,
   		 SUM(op.nQuantity) AS product_Count
	FROM tblproduct p
	JOIN tblorderproduct op ON op.nProductLink = p.nKey
	JOIN tblorder o ON o.nKey = op.nOrderLink
	WHERE o.nUserLink = p_UserLink
	GROUP BY p.szName
	ORDER BY SUM(op.nQuantity) DESC
	LIMIT 1;
   
END $$

DELIMITER ;
