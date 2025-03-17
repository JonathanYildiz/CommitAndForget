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
      nImageLink = p_ImageLink
   WHERE nKey = p_Key;
END $$

DELIMITER ;

