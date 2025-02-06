USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spCreateMenu;

DELIMITER $$

CREATE PROCEDURE spCreateMenu(
	p_Name VARCHAR(200),
	p_Price  DECIMAL(5,2),
    p_ImageLink INT 
    )
BEGIN
	IF p_ImageLink IS NULL THEN
		SET p_ImageLink = NULL;
	END IF;
    
   INSERT INTO tblmenu (szName, rPrice, nImageLink)
   VALUES (p_Name, p_Price, p_ImageLink);
END $$

DELIMITER ;

