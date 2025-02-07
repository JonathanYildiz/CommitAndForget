USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spCreateIngredient;

DELIMITER $$

CREATE PROCEDURE spCreateIngredient(
	p_Name VARCHAR(200)
    )
BEGIN
	INSERT INTO tblingredient (szName)
	VALUES (p_Name);
END $$

DELIMITER ;

