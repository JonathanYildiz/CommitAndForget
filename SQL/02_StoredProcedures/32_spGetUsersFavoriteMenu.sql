USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetUsersFavoriteMenu;

DELIMITER $$
CREATE PROCEDURE spGetUsersFavoriteMenu(

    p_UserLink INT
    )

BEGIN
   
   SELECT m.szName AS menu_Name,
   		 SUM(om.nQuantity) AS menu_Count
	FROM tblmenu m
	JOIN tblordermenu om ON om.nMenuLink = m.nKey
	JOIN tblorder o ON o.nKey = om.nOrderLink
	WHERE o.nUserLink = p_UserLink
	GROUP BY m.szName
	ORDER BY SUM(om.nQuantity) DESC
	LIMIT 1;
   
END $$

DELIMITER ;
