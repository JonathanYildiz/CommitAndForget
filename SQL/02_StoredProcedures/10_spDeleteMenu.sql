USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteMenu;

DELIMITER $$

CREATE PROCEDURE spDeleteMenu(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductmenu WHERE nMenuLink = p_Key;
   DELETE FROM tblmenu WHERE nKey = p_Key;
END $$

DELIMITER ;

