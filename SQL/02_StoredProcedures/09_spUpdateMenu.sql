USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateMenu;

DELIMITER $$

CREATE PROCEDURE spUpdateMenu(
	 p_Key INT,
	 p_Name VARCHAR(200),
	 p_Price  DECIMAL(5,2),
     p_ImageLink INT
    )
BEGIN
   UPDATE tblmenu
   SET 
		szName = p_Name,
		rPrice = p_Price,
        nImageLink = CASE
			WHEN p_ImageLink IS NOT NULL THEN p_ImageLink
            ELSE nImageLink
		END
   WHERE nKey = p_Key;
END $$

DELIMITER ;

