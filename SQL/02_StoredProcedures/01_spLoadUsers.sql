USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spLoadUsers;

DELIMITER $$

CREATE PROCEDURE spLoadUsers()
BEGIN
    SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
    FROM tbluser;
END $$

DELIMITER ;
