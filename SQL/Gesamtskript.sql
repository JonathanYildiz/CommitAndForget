
-- HinzufÃ¼gen: 01_CreateDB.sql


DROP DATABASE if EXISTS dbcommitandforget;
-- Create new Database with utf8mb4 and Collation utf8mb4_general_ci
CREATE DATABASE dbcommitandforget 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;


-- Fertig: 01_CreateDB.sql


-- HinzufÃ¼gen: 02_CreateTables.sql

USE dbcommitandforget;
-- Create the tblUser table if it does not exist
CREATE TABLE IF NOT EXISTS tblUser (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    szFirstName NVARCHAR(200) NOT NULL,
    szLastName NVARCHAR(200) NOT NULL,
    szStreet NVARCHAR(200) NOT NULL,
    szHouseNumber NVARCHAR(200) NOT NULL,
    szPostalCode NVARCHAR(200) NOT NULL,
    szCity NVARCHAR(200) NOT NULL,
    szEmail NVARCHAR(200) UNIQUE NOT NULL,
    szPassword NVARCHAR(200) NOT NULL,
    bIsAdmin BIT DEFAULT 0
);

-- Check if the tblImage table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblImage (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    vbImage LONGBLOB NOT NULL, 
    bApproved BIT DEFAULT 0,
    dtCreationDate DATE NOT NULL DEFAULT (CURDATE()),
    bContestWon BIT DEFAULT 0
);

-- Check if the tblRating table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblRating (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nRating INT NOT NULL,
    nUserLink INT NOT NULL,
    nImageLink INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblRating_User 
        FOREIGN KEY (nUserLink) 
        REFERENCES tblUser(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblRating_Image 
        FOREIGN KEY (nImageLink) 
        REFERENCES tblImage(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
); 

-- Check if the tblInvoice table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblInvoice (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nInvoiceNumber INT NOT NULL,
    bPaid BIT DEFAULT 0,
    szPaymentMethod NVARCHAR(200) NOT NULL
);

-- Check if the tblOrder table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblOrder (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    dtOrderDate DATE NOT NULL DEFAULT (CURDATE()),
    nUserLink INT NOT NULL,
    nInvoiceLink INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblOrder_User 
        FOREIGN KEY (nUserLink) 
        REFERENCES tblUser(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblOrder_Invoice 
        FOREIGN KEY (nInvoiceLink) 
        REFERENCES tblInvoice(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Check if the tblProduct table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblProduct (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nEnergy INT,
    szName NVARCHAR(200) NOT NULL,
    rPrice DECIMAL(5,2) NOT NULL,
    nImageLink INT,
    
    -- Foreign key definition
    CONSTRAINT fk_tblProduct_Image 
        FOREIGN KEY (nImageLink) 
        REFERENCES tblImage(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Check if the tblOrderProduct table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblOrderProduct (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nOrderLink INT NOT NULL,
    nProductLink INT NOT NULL,
    nQuantity INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblOrderProduct_Order 
        FOREIGN KEY (nOrderLink) 
        REFERENCES tblOrder(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblOrderProduct_Product 
        FOREIGN KEY (nProductLink) 
        REFERENCES tblProduct(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Check if the tblMenu table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblMenu (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName NVARCHAR(200) NOT NULL,
    rPrice DECIMAL(5,2) NOT NULL,
    nImageLink INT,
    
    -- Foreign key definition
    CONSTRAINT fk_tblMenu_Image
        FOREIGN KEY (nImageLink) 
        REFERENCES tblImage(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Check if the tblProductMenu table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblProductMenu (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nProductLink INT NOT NULL,
    nMenuLink INT NOT NULL,
    nQuantity INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblProductMenu_Product 
        FOREIGN KEY (nProductLink) 
        REFERENCES tblProduct(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblProductMenu_Menu 
        FOREIGN KEY (nMenuLink) 
        REFERENCES tblMenu(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Check if the tblIngredient table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblIngredient (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName NVARCHAR(200) NOT NULL
);

-- Check if the tblProductIngredient table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblProductIngredient (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nIngredientLink INT NOT NULL,
    nProductLink INT NOT NULL,
    nQuantity INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblProductIngredient_Ingredient
        FOREIGN KEY (nIngredientLink) 
        REFERENCES tblIngredient(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblProductIngredient_Product 
        FOREIGN KEY (nProductLink) 
        REFERENCES tblProduct(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Fertig: 02_CreateTables.sql


-- HinzufÃ¼gen: 01_spLoadUsers.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spLoadUsers;

DELIMITER $$

CREATE PROCEDURE spLoadUsers()
BEGIN
    SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
    FROM tbluser;
END $$

DELIMITER ;

-- Fertig: 01_spLoadUsers.sql


-- HinzufÃ¼gen: 02_spLogin.sql

DROP PROCEDURE IF EXISTS spLogin;

DELIMITER $$

CREATE PROCEDURE spLogin(
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200)
)
BEGIN
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
    FROM tbluser
    WHERE szEmail = p_Email
    AND szPassword = p_Password;
    
END $$

DELIMITER ;

-- Fertig: 02_spLogin.sql


-- HinzufÃ¼gen: 03_spRegisterUser.sql

DROP PROCEDURE IF EXISTS spRegisterUser;

DELIMITER $$

CREATE PROCEDURE spRegisterUser(
	IN p_FirstName NVARCHAR(200),
    IN p_LastName NVARCHAR(200),
    IN p_Street NVARCHAR(200),
    IN p_HouseNumber NVARCHAR(200),
    IN p_PostalCode NVARCHAR(200),
    IN p_City NVARCHAR(200),
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200)
  
)
BEGIN
	DECLARE v_Count INT;
    
-- Pruefen, ob die Mail bereits existiert (wenn v_Count = 0, dann Meil nicht existiert)
	SELECT COUNT(*) INTO v_Count
    FROM tbluser
    WHERE szEmail = p_Email;
    
    IF v_Count > 0 THEN 
		SELECT 'Fehler: Die E-Mail-Adresse ist bereits registriert.' AS Nachricht;
	ELSE 
		INSERT INTO tbluser (szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword)
        VALUES (p_FirstName, p_LastName,  p_Street, p_HouseNumber,  p_PostalCode, p_City, p_Email, p_Password);
        
        SELECT  nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
        FROM tbluser 
        WHERE  szEmail = p_Email;
    END IF;
    
END $$

DELIMITER ;

-- Fertig: 03_spRegisterUser.sql


-- HinzufÃ¼gen: 04_spUpdateUser.sql

DROP PROCEDURE IF EXISTS spUpdateUser;

DELIMITER $$

CREATE PROCEDURE spUpdateUser(
	IN p_Key INT, 
	IN p_FirstName NVARCHAR(200),
    IN p_LastName NVARCHAR(200),
    IN p_Street NVARCHAR(200),
    IN p_HouseNumber NVARCHAR(200),
    IN p_PostalCode NVARCHAR(200),
    IN p_City NVARCHAR(200),
	IN p_Email NVARCHAR(200),
    IN p_Password NVARCHAR(200)
)
BEGIN
	DECLARE v_Count INT;
-- Pruefen, ob die Mail-Passwort-Kombination existiert 
	SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword
    FROM tbluser
    WHERE nKey = p_Key;
   
	IF v_Count = 0 THEN
		SELECT 'Fehler: Benutzer ist nicht gefunden!' AS Nachricht;
    ELSE
		UPDATE tbluser
        SET 
			szFirstName = p_FirstName,
            szLastName = p_LastName,
            szStreet = p_Street,
            szHouseNumber = p_HouseNumber,
            szPostalCode = p_PostalCode, 
            szCity = p_City,
            szEmail = p_Email,
            szPassword = p_Password
		WHERE nKey = p_Key;
        
        SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail
        FROM tbluser 
        WHERE nKey = p_Key;
	END IF;
			
END $$

DELIMITER ;

-- Fertig: 04_spUpdateUser.sql


-- HinzufÃ¼gen: 05_spCreateProduct.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spCreateProduct;

DELIMITER $$

CREATE PROCEDURE spCreateProduct(
	p_Name VARCHAR(200),
	p_Price  DECIMAL(5,2),
    p_ImageLink INT 
    )
BEGIN
	IF p_ImageLink IS NULL THEN
		SET p_ImageLink = NULL;
	END IF;
    
   INSERT INTO tblproduct (szName, rPrice, nImageLink)
   VALUES (p_Name, p_Price,  p_ImageLink);
END $$

DELIMITER ;


-- Fertig: 05_spCreateProduct.sql


-- HinzufÃ¼gen: 06_spUpdateProduct.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateProduct;

DELIMITER $$

CREATE PROCEDURE spUpdateProduct(
	 p_Key INT,
	 p_Name VARCHAR(200),
	 p_Price  DECIMAL(5,2),
     p_ImageLink INT
    )
BEGIN
   UPDATE tblproduct 
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


-- Fertig: 06_spUpdateProduct.sql


-- HinzufÃ¼gen: 07_spDeleteProduct.sql


USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteProduct;

DELIMITER $$

CREATE PROCEDURE spDeleteProduct(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductmenu WHERE nProductLink = p_Key;
   DELETE FROM tblproductingredient WHERE nProductLink = p_Key;
   DELETE FROM tblproduct WHERE nKey = p_Key;
END $$

DELIMITER ;


-- Fertig: 07_spDeleteProduct.sql


-- HinzufÃ¼gen: 08_spCreateMenu.sql

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


-- Fertig: 08_spCreateMenu.sql


-- HinzufÃ¼gen: 09_spUpdateMenu.sql

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


-- Fertig: 09_spUpdateMenu.sql


-- HinzufÃ¼gen: 10_spDeleteMenu.sql

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


-- Fertig: 10_spDeleteMenu.sql


-- HinzufÃ¼gen: 11_spCreateIngredient.sql

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


-- Fertig: 11_spCreateIngredient.sql


-- HinzufÃ¼gen: 12_spUpdateIngredient.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateIngredient;

DELIMITER $$

CREATE PROCEDURE spUpdateIngredient(
	 p_Key INT,
	 p_Name VARCHAR(200)
    )
BEGIN
   UPDATE tblingredient
   SET 
		szName = p_Name
   WHERE nKey = p_Key;
END $$

DELIMITER ;


-- Fertig: 12_spUpdateIngredient.sql


-- HinzufÃ¼gen: 13_spDeleteIngredient.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteIngredient;

DELIMITER $$

CREATE PROCEDURE spDeleteIngredient(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductingredient WHERE nIngredientLink = p_Key;
   DELETE FROM tblingredient WHERE nKey = p_Key;
END $$

DELIMITER ;


-- Fertig: 13_spDeleteIngredient.sql


-- HinzufÃ¼gen: 01_CreateTestData_tblMenuProductIngredient.sql

-- Testdaten fÃ¼r Table: Menu
INSERT INTO tblmenu (szName, rPrice) VALUES 
('Low-Carb Menu', 8.99),
('Protein Power Menu', 10.50),
('Vegan Fit Menu', 9.75);

-- Testdaten fÃ¼r Table: Product
INSERT INTO tblproduct (szName, nEnergy, rPrice) VALUES 
('Quinoa Bowl with Avocado', 300, 6.99),
('Grilled Chicken Breast', 201, 7.49),
('Vegan Wrap with Hummus', 363, 5.99),
('Salmon with Broccoli',  241, 8.49),
('Salad with Feta and Walnuts', 743, 5.49);

-- Testdaten fÃ¼r Table: Ingredient
INSERT INTO tblingredient (szName) VALUES 
('Quinoa'),
('Avocado'),
('Chicken Breast'),
('Hummus'),
('Salmon'),
('Broccoli'),
('Feta Cheese'),
('Walnuts'),
('Whole Wheat Wrap'),
('Olive Oil');

-- Fertig: 01_CreateTestData_tblMenuProductIngredient.sql


-- HinzufÃ¼gen: 02_CreateTestData_tblUser.sql

USE dbcommitandforget;

-- Testdaten fÃ¼r tblBenutzer einfÃ¼gen
INSERT INTO tbluser (szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword, bIsAdmin) 
VALUES 
('Max', 'Mustermann', 'HauptstraÃŸe', '12', '12345', 'Berlin', 'max@example.com', 'passwort123', 1),
('Anna',  'Beispiel', 'NebenstraÃŸe', '5A', '54321', 'Hamburg', 'anna@example.com', 'geheim123', 0),
('Lukas', 'Meyer', 'DorfstraÃŸe', '33A', '67890', 'MÃ¼nchen', 'lukas@example.com', 'securepass', 0),
('Lisa',  'Schmidt', 'BahnhofstraÃŸe', '33B', '11111', 'KÃ¶ln', 'lisa@example.com', 'meinPasswort', 0),
('asdf', 'asdf', 'asdf', 'asdf', 'asdf', 'asdf', 'asdf', 'asdf', 1),
('Tom',  'Bauer', 'RingstraÃŸe', '7S', '22222', 'Frankfurt', 'tom@example.com', 'passwort321', 1);

-- Fertig: 02_CreateTestData_tblUser.sql

