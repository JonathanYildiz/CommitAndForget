﻿
-- HinzufÃ¼gen: 01_CreateDB.sql


DROP DATABASE if EXISTS dbcommitandforget;
-- Create new Database with utf8mb4 and Collation utf8mb4_unicode_ci
CREATE DATABASE dbcommitandforget 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
SET GLOBAL max_allowed_packet = 67108864;


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
    vbImage LONGBLOB, 
    bApproved BIT DEFAULT 0,
    dtCreationDate DATE NOT NULL DEFAULT (CURDATE()),
    bContestWon BIT DEFAULT 0,
	nUserLink INT,
	
	-- Foreign key definition
	CONSTRAINT fk_tblImage_User 
        FOREIGN KEY (nUserLink) 
        REFERENCES tblUser(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
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

-- Check if the tblOrderMenu table exists, if not, create it
CREATE TABLE IF NOT EXISTS tblOrderMenu (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    nOrderLink INT NOT NULL,
    nMenuLink INT NOT NULL,
    nQuantity INT NOT NULL,
    
    -- Foreign key definition
    CONSTRAINT fk_tblOrderMenu_Order 
        FOREIGN KEY (nOrderLink) 
        REFERENCES tblOrder(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_tblOrderMenu_Menu 
        FOREIGN KEY (nMenuLink) 
        REFERENCES tblMenu(nKey) 
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
    IN p_Password NVARCHAR(200),
    IN p_IsAdmin BIT
  
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
		INSERT INTO tbluser (szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword, bIsAdmin)
        VALUES (p_FirstName, p_LastName,  p_Street, p_HouseNumber,  p_PostalCode, p_City, p_Email, p_Password, p_IsAdmin);
        
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
    IN p_FirstName VARCHAR(200),
    IN p_LastName VARCHAR(200),
    IN p_Street VARCHAR(200),
    IN p_HouseNumber VARCHAR(200),
    IN p_PostalCode VARCHAR(200),
    IN p_City VARCHAR(200),
    IN p_Email VARCHAR(200),
    IN p_Password VARCHAR(200),
    IN p_IsAdmin bit
)
BEGIN
    DECLARE v_Count INT;
    
    -- PrÃ¼fen, ob der Benutzer existiert
    SELECT COUNT(*)
    INTO v_Count
    FROM tbluser
    WHERE nKey = p_Key;
   
    IF v_Count = 0 THEN
        SELECT 'Fehler: Benutzer ist nicht gefunden!' AS Nachricht;
    ELSE
        -- Benutzer aktualisieren
        UPDATE tbluser
        SET 
            szFirstName = coalesce(p_FirstName, szFirstName),
            szLastName = coalesce(p_LastName, szLastName),
            szStreet = coalesce(p_Street, szStreet),
            szHouseNumber = coalesce(p_HouseNumber, szHouseNumber),
            szPostalCode = coalesce(p_PostalCode, szPostalCode), 
            szCity = coalesce(p_City, szCity),
            szEmail = coalesce(p_Email, szEmail),
            bIsAdmin = coalesce(p_IsAdmin, bIsAdmin),
            szPassword = coalesce(nullif(p_Password, ""), szPassword)
        WHERE nKey = p_Key;
        
        -- ZurÃ¼ckgeben der aktualisierten Benutzerdaten
        SELECT nKey, szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, bIsAdmin
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
    p_ImageLink INT,
    p_Energy INT
    )
BEGIN
	IF p_ImageLink IS NULL THEN
		SET p_ImageLink = NULL;
	END IF;
    
   INSERT INTO tblproduct (szName, rPrice, nImageLink, nEnergy)
   VALUES (p_Name, p_Price,  p_ImageLink, p_Energy);
   
      SELECT LAST_INSERT_ID() AS nKey;
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
     p_ImageLink INT,
     p_Energy INT
    )
BEGIN
   UPDATE tblproduct 
   SET 
		szName = p_Name,
		rPrice = p_Price,
        nEnergy = p_Energy,
        nImageLink = p_ImageLink
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
   
   SELECT LAST_INSERT_ID() AS nKey;
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
      nImageLink = p_ImageLink
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


-- HinzufÃ¼gen: 14_spGetProducts.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetProducts;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetProducts()

BEGIN 
SELECT 
	p.nKey AS product_nKey,
    p.szName AS product_szName,
    p.nEnergy AS product_nEnergy,
    p.rPrice AS product_rPrice,
    img.nKey AS image_nKey,
    img.vbImage AS image_vbImage,
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName,
    pi.nQuantity AS ingredient_nQuantity,
    fnGetProductOrderCount(p.nKey) AS product_nOrderCount
    FROM tblproduct p 
    LEFT JOIN tblproductingredient pi ON p.nKey = pi.nProductLink
    LEFT JOIN tblimage img ON p.nImageLink = img.nKey
    LEFT JOIN tblingredient i ON pi.nIngredientLink = i.nKey
    ORDER BY p.nKey, i.szName;
END $$

DELIMITER ;


-- Fertig: 14_spGetProducts.sql


-- HinzufÃ¼gen: 15_spGetMenus.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetMenus;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetMenus()

BEGIN 
SELECT 
	m.nKey AS menu_nKey,
   m.szName AS menu_szName,
   m.rPrice AS menu_rPrice,
	imgMenu.nKey AS imageMenu_nKey,
   imgMenu.vbImage AS imageMenu_vbImage,
   pm.nQuantity AS product_nQuantity,
	p.nKey AS product_nKey,
   p.szName AS product_szName,
   p.nEnergy AS product_nEnergy,
   fnGetMenuOrderCount(m.nKey) AS menu_nOrderCount    
    FROM tblmenu m
	 LEFT JOIN tblimage imgMenu ON m.nImageLink = imgMenu.nKey
    LEFT JOIN tblproductmenu pm ON m.nKey = pm.nMenuLink
    LEFT JOIN tblproduct p ON pm.nProductLink = p.nKey
    ORDER BY m.nKey, p.nKey;
END $$

DELIMITER ;




-- Fertig: 15_spGetMenus.sql


-- HinzufÃ¼gen: 16_spGetIngredients.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetIngredients;

DELIMITER $$
-- Laden von Produkten mit Zutaten
CREATE PROCEDURE spGetIngredients(
p_ProductLink INT
)

BEGIN 
SELECT 
    i.nKey AS ingredient_nKey,
    i.szName AS ingredient_szName,
    pi.nQuantity AS ingredient_nQuantity
    FROM tblingredient i
    LEFT JOIN tblproductingredient pi ON pi.nIngredientLink = i.nKey AND pi.nProductLink = p_ProductLink
    ORDER BY i.nKey;
END $$

DELIMITER ;




-- Fertig: 16_spGetIngredients.sql


-- HinzufÃ¼gen: 17_spCreateOrder.sql

USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spCreateOrder;

DELIMITER $$

CREATE PROCEDURE spCreateOrder(
	p_UserLink INT,
    p_Paid BIT,
    p_PaymentMethod NVARCHAR(200)
    )
BEGIN    
	DECLARE p_InvoiceID INT;
    DECLARE p_OrderID INT;
    DECLARE p_InvoiceNumber INT;
	
    START TRANSACTION;
    
		SELECT COALESCE(MAX(nInvoiceNumber), 0) + 1 INTO p_InvoiceNumber from tblinvoice;  
    
		INSERT INTO tblinvoice (nInvoiceNumber, bPaid, szPaymentMethod)
		VALUES (p_InvoiceNumber, p_Paid, p_PaymentMethod);
    
		SET p_InvoiceID = last_insert_id();
    
		INSERT INTO tblorder (dtOrderDate, nUserLink, nInvoiceLink)
		VALUES (now(), p_UserLink, p_InvoiceID);
    
		SET p_OrderID = last_insert_id();
    COMMIT;
    
    SELECT  p_OrderID as newOrderID, p_InvoiceID as newInvoiceID, p_InvoiceNumber AS InvoiceNumber;
    
END $$

DELIMITER ;


-- Fertig: 17_spCreateOrder.sql


-- HinzufÃ¼gen: 18_spDeleteUser.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteUser;

DELIMITER $$

CREATE PROCEDURE spDeleteUser(
	 p_Key INT
    )
BEGIN
   DELETE FROM tbluser WHERE nKey = p_Key;
   
END $$

DELIMITER ;

-- Fertig: 18_spDeleteUser.sql


-- HinzufÃ¼gen: 19_spAddMenuToOrder.sql

USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spAddMenuToOrder;

DELIMITER $$

CREATE PROCEDURE spAddMenuToOrder(
	p_OrderLink INT,
    p_MenuLink INT,
    p_Quantity INT
    )
BEGIN    
	INSERT INTO tblordermenu(nOrderLink, nMenuLink, nQuantity)
    VALUES (p_OrderLink, p_MenuLink, p_Quantity);
END $$

DELIMITER ;


-- Fertig: 19_spAddMenuToOrder.sql


-- HinzufÃ¼gen: 20_spAddProductToOrder.sql

USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spAddProductToOrder;

DELIMITER $$

CREATE PROCEDURE spAddProductToOrder(
	p_OrderLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )
BEGIN    
	INSERT INTO tblorderproduct(nOrderLink, nProductLink, nQuantity)
    VALUES (p_OrderLink, p_ProductLink, p_Quantity);
END $$

DELIMITER ;


-- Fertig: 20_spAddProductToOrder.sql


-- HinzufÃ¼gen: 21_spUpdateProductIngredient.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateProductIngredient;

DELIMITER $$
CREATE PROCEDURE spUpdateProductIngredient(

    p_IngredientLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )

BEGIN
    INSERT INTO tblproductingredient (nIngredientLink, nProductLink, nQuantity)
    VALUES (p_IngredientLink, p_ProductLink, p_Quantity);
    
END $$

DELIMITER ;

-- Fertig: 21_spUpdateProductIngredient.sql


-- HinzufÃ¼gen: 22_spDeleteProductIngredient.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteProductIngredient;

DELIMITER $$

CREATE PROCEDURE spDeleteProductIngredient(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductingredient WHERE nProductLink = p_Key;
END $$

DELIMITER ;


-- Fertig: 22_spDeleteProductIngredient.sql


-- HinzufÃ¼gen: 23_spGetImages.sql

USE dbcommitandforget;
DROP PROCEDURE IF EXISTS spGetImages;

DELIMITER $$
-- Laden von Bilder
CREATE PROCEDURE spGetImages(
	p_UserLink INT
)

BEGIN 

-- Wenn GÃƒÂ¼ltiger Benutzer, dann Ratings des Benutzers dazu laden
IF EXISTS (
        SELECT 1
        FROM tbluser u
        WHERE u.nkey = p_UserLink 
        AND u.bIsAdmin = 0
    ) THEN

			SELECT 
				 img.nKey AS image_nKey,
			    vbImage AS image_vbImage,
			    bApproved AS image_bApproved,
				 dtCreationDate AS image_dtCreationDate,
			    bContestWon AS image_bContestWon,
			    case when usr.bIsAdmin = 1 then 'admin' ELSE usr.szEmail end AS image_szUploadedBy,
			    rat.nRating AS image_rRating
			    FROM tblimage img
			    JOIN tbluser usr ON usr.nKey = img.nUserLink
			    left JOIN tblrating rat ON rat.nImageLink = img.nKey
			    						 AND rat.nUserLink = p_UserLink
			    ORDER BY img.nKey;
		ELSE
        -- Ansonsten alle Bilder laden
        SELECT 
			    img.nKey AS image_nKey,
			    img.vbImage AS image_vbImage,
			    img.bApproved AS image_bApproved,
			    img.dtCreationDate AS image_dtCreationDate,
			    img.bContestWon AS image_bContestWon,
			    CASE 
			        WHEN usr.bIsAdmin = 1 THEN 'admin' 
			        ELSE usr.szEmail 
			    END AS image_szUploadedBy,
			    AVG(rat.nRating) AS image_rRating
			FROM tblimage img
			JOIN tbluser usr ON usr.nKey = img.nUserLink
			LEFT JOIN tblrating rat ON rat.nImageLink = img.nKey
			GROUP BY 
			    img.nKey,
			    img.vbImage,
			    img.bApproved,
			    img.dtCreationDate,
			    img.bContestWon,
			    usr.bIsAdmin,
			    usr.szEmail
			ORDER BY img.nKey;
    END IF;
END $$

DELIMITER ;




-- Fertig: 23_spGetImages.sql


-- HinzufÃ¼gen: 24_spCreateImage.sql

USE dbcommitandforget;
-- Erstellen von Ordner mit dem Rechnung zusammen 
DROP PROCEDURE IF EXISTS spCreateImage;

DELIMITER $$

CREATE PROCEDURE spCreateImage(
    p_Image LONGBLOB,
    p_UserLink int
)
BEGIN
    INSERT INTO tblImage (vbImage, bApproved, dtCreationDate, bContestWon, nUserLink)
    VALUES (p_Image, 0, NOW(), 0, p_UserLink);
	
    
    SELECT nKey from tblimage WHERE vbImage = p_Image;


END $$

DELIMITER ;


-- Fertig: 24_spCreateImage.sql


-- HinzufÃ¼gen: 25_spUpdateImage.sql

DROP PROCEDURE IF EXISTS spUpdateImage;
select * from tblimage;
DELIMITER $$

CREATE PROCEDURE spUpdateImage(
    IN p_Key INT, 
    IN p_Approved BIT,
    IN p_ContestWon BIT
)
BEGIN
    DECLARE v_Count INT;
    
    -- PrÃ¼fen, ob das Image existiert
    SELECT COUNT(*)
    INTO v_Count
    FROM tblimage
    WHERE nKey = p_Key;
   
    IF v_Count = 0 THEN
        SELECT 'Fehler: Bild konnte nicht gefunden werden!' AS Nachricht;
    ELSE
        -- Benutzer aktualisieren
        UPDATE tblimage
        SET 
			bApproved = p_Approved,
            bContestWon = p_ContestWon
        WHERE nKey = p_Key;
        
        -- ZurÃ¼ckgeben der aktualisierten Bilderdaten
        SELECT nKey, vbImage, bApproved, dtCreationDate, bContestWon
        FROM tblimage 
        WHERE nKey = p_Key;
    END IF;
    
END $$

DELIMITER ;

-- Fertig: 25_spUpdateImage.sql


-- HinzufÃ¼gen: 26_spDeleteImage.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteImage;

DELIMITER $$

CREATE PROCEDURE spDeleteImage(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblimage WHERE nKey = p_Key;
   
END $$

DELIMITER ;

-- Fertig: 26_spDeleteImage.sql


-- HinzufÃ¼gen: 27_spDeleteMenuProduct.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteMenuProduct;

DELIMITER $$

CREATE PROCEDURE spDeleteMenuProduct(
	 p_Key INT
    )
BEGIN
   DELETE FROM tblproductmenu WHERE nMenuLink = p_Key;
END $$

DELIMITER ;


-- Fertig: 27_spDeleteMenuProduct.sql


-- HinzufÃ¼gen: 28_spUpdateMenuProduct.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spUpdateMenuProduct;

DELIMITER $$
CREATE PROCEDURE spUpdateMenuProduct(

    p_MenuLink INT,
    p_ProductLink INT,
    p_Quantity INT
    )

BEGIN
    INSERT INTO tblproductmenu (nMenuLink, nProductLink, nQuantity)
    VALUES (p_MenuLink, p_ProductLink, p_Quantity);
    
END $$

DELIMITER ;

-- Fertig: 28_spUpdateMenuProduct.sql


-- HinzufÃ¼gen: 29_spApproveImage.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spApproveImage;

DELIMITER $$
CREATE PROCEDURE spApproveImage(

    p_ImageLink INT
    )

BEGIN

    UPDATE tblimage i
    SET i.bApproved = 1
    WHERE i.nKey = p_ImageLink;
    
END $$

DELIMITER ;

-- Fertig: 29_spApproveImage.sql


-- HinzufÃ¼gen: 30_spRateImage.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spRateImage;

DELIMITER $$
CREATE PROCEDURE spRateImage(

    p_ImageLink INT,
    p_ImageRating INT,
    p_UserLink INT
    )

BEGIN
    -- ÃœberprÃ¼fen, ob bereits ein Eintrag mit dem gleichen UserLink und ImageLink existiert
    IF NOT EXISTS (
        SELECT 1
        FROM tblrating
        WHERE nUserLink = p_UserLink AND nImageLink = p_ImageLink
    ) THEN
        -- Wenn kein Eintrag existiert, anlegen
        INSERT INTO tblrating (nRating, nUserLink, nImageLink)
        VALUES (p_ImageRating, p_UserLink, p_ImageLink);
    ELSE
        -- Wenn ein Eintrag existiert, aktualisiere den bestehenden Eintrag
        UPDATE tblrating
        SET nRating = p_ImageRating
        WHERE nUserLink = p_UserLink AND nImageLink = p_ImageLink;
    END IF;
END $$

DELIMITER ;

-- Fertig: 30_spRateImage.sql


-- HinzufÃ¼gen: 31_spGetUsersFavoriteProduct.sql

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

-- Fertig: 31_spGetUsersFavoriteProduct.sql


-- HinzufÃ¼gen: 32_spGetUsersFavoriteMenu.sql

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

-- Fertig: 32_spGetUsersFavoriteMenu.sql


-- HinzufÃ¼gen: 33_spGetOrderHistory.sql

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

-- Fertig: 33_spGetOrderHistory.sql


-- HinzufÃ¼gen: 34_spDeleteOrder.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spDeleteOrder;

DELIMITER $$
CREATE PROCEDURE spDeleteOrder(
	IN p_OrderId INT
)
BEGIN
   
   DELETE 
	FROM tblorder
   WHERE nKey = p_OrderId;
   
   DELETE
   FROM tblordermenu
   WHERE nOrderLink = p_OrderId;
   
   DELETE
   FROM tblorderproduct
   WHERE nOrderLink = p_OrderId;
      
END $$

DELIMITER ;

-- Fertig: 34_spDeleteOrder.sql


-- HinzufÃ¼gen: 35_spGetOrderDetails.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetOrderDetails;

DELIMITER $$
CREATE PROCEDURE spGetOrderDetails(
	IN p_OrderId INT
)
BEGIN
   
   SELECT m.szName AS item_Name
   	  , om.nQuantity AS item_Quantity
        , m.rPrice AS item_Price      
	FROM tblorder o
	JOIN tblordermenu om ON om.nOrderLink = o.nKey
	JOIN tblmenu m ON m.nKey = om.nMenuLink
	WHERE o.nKey = p_OrderId
	
	UNION ALL
	
	SELECT p.szName AS item_Name
	     , op.nQuantity AS item_Quantity
		  , p.rPrice AS item_Price
	FROM tblorder o
	JOIN tblorderproduct op ON op.nOrderLink = o.nKey
	JOIN tblproduct p ON p.nKey = op.nProductLink
	WHERE o.nKey = p_OrderId;
      
END $$

DELIMITER ;

-- Fertig: 35_spGetOrderDetails.sql


-- HinzufÃ¼gen: 36_spGetContestWinner.sql

USE dbcommitandforget;

DROP PROCEDURE IF EXISTS spGetContestWinner;

DELIMITER $$

CREATE PROCEDURE spGetContestWinner()
BEGIN
    -- DEBUG: Alle genehmigten Bilder auf den ersten Tag des letzten Monats setzen
    UPDATE tblImage
    SET dtCreationDate = LAST_DAY(CURRENT_DATE - INTERVAL 2 MONTH) + INTERVAL 1 DAY
    WHERE bApproved = 1;
   
    -- ÃœberprÃ¼fen, ob es bereits Gewinner gibt
    IF EXISTS (
        SELECT 1 FROM tblImage 
        WHERE YEAR(dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
          AND MONTH(dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
          AND bApproved = 1
          AND bContestWon = 1
    ) THEN
        -- Falls ja, diese direkt zurÃ¼ckgeben
        SELECT img.nKey AS image_nKey
        		 , usr.szFirstName AS image_szUploadedBy
        		 , img.vbImage AS image_vbImage
		  FROM tblImage img
		  JOIN tbluser usr ON usr.nKey = img.nUserLink
        WHERE YEAR(dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
          AND MONTH(dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
          AND bApproved = 1
          AND bContestWon = 1;
    ELSE
        -- Falls noch kein Gewinner existiert, bestbewertete Bilder ermitteln
        DROP TEMPORARY TABLE IF EXISTS TempTopImages;
        CREATE TEMPORARY TABLE TempTopImages AS 
        SELECT mi.nKey
        FROM tblImage mi
        JOIN (
            SELECT r.nImageLink, AVG(r.nRating) AS avgRating
            FROM tblRating r
            JOIN tblImage i ON r.nImageLink = i.nKey
            WHERE YEAR(i.dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
              AND MONTH(i.dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
              AND i.bApproved = 1
            GROUP BY r.nImageLink
        ) ir ON mi.nKey = ir.nImageLink
        WHERE ir.avgRating = (
            SELECT MAX(avgRating) FROM (
                SELECT AVG(r.nRating) AS avgRating
                FROM tblRating r
                JOIN tblImage i ON r.nImageLink = i.nKey
                WHERE YEAR(i.dtCreationDate) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
                  AND MONTH(i.dtCreationDate) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
                  AND i.bApproved = 1
                GROUP BY r.nImageLink
            ) AS MaxRating
        );

        -- Die Gewinner als bContestWon markieren
        UPDATE tblImage 
        SET bContestWon = 1
        WHERE nKey IN (SELECT nKey FROM TempTopImages);

        -- Gewinner zurÃ¼ckgeben
        SELECT img.nKey AS image_nKey
        		 , usr.szFirstName AS image_szUploadedBy
        		 , img.vbImage AS image_vbImage
		  FROM tblimage img
		  JOIN tbluser usr ON usr.nKey = img.nUserLink
        WHERE img.nKey IN (SELECT nKey FROM TempTopImages);
    END IF;
END $$

DELIMITER ;

-- Fertig: 36_spGetContestWinner.sql


-- HinzufÃ¼gen: 01_fnGetMenuOrderCount.sql

USE dbcommitandforget;

DROP FUNCTION IF EXISTS fnGetMenuOrderCount;

DELIMITER $$

CREATE FUNCTION fnGetMenuOrderCount(p_MenuLink INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE orderCount INT;
    
    SELECT IFNULL(SUM(om.nQuantity), 0) INTO orderCount
    FROM tblordermenu om
    WHERE om.nMenuLink = p_MenuLink;
    
    RETURN orderCount;
END $$

DELIMITER ;

-- Fertig: 01_fnGetMenuOrderCount.sql


-- HinzufÃ¼gen: 02_fnGetProductOrderCount.sql

USE dbcommitandforget;

DROP FUNCTION IF EXISTS fnGetProductOrderCount;

DELIMITER $$

CREATE FUNCTION fnGetProductOrderCount(p_ProductLink INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE orderCount INT;
    
    SELECT IFNULL(SUM(op.nQuantity), 0) INTO orderCount
    FROM tblorderproduct op
    WHERE op.nProductLink = p_ProductLink;
    
    RETURN orderCount;
END $$

DELIMITER ;

-- Fertig: 02_fnGetProductOrderCount.sql


-- HinzufÃ¼gen: 01_CreateTestData_tblUser.sql

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

-- Fertig: 01_CreateTestData_tblUser.sql


-- HinzufÃ¼gen: 02_CreateTestData_tblMenuProductIngredient.sql

-- Testdaten fÃ¼r Table: Menu
INSERT INTO tblmenu (szName, rPrice) VALUES 
('Low-Carb Menu', 8.99),
('Protein Power Menu', 10.50),
('Vegan Fit Menu', 9.75);

INSERT INTO tblimage (vbImage, nUserLink) VALUES
(X'89504E470D0A1A0A0000000D4948445200000200000002000806000000F478D4FA0000000473424954080808087C086488000000097048597300000BD000000BD0017731748F0000001974455874536F667477617265007777772E696E6B73636170652E6F72679BEE3C1A0000200049444154789CECDD77785CC5D936F07BCE76ADB45A7569D5655B96E42277CB057763639BEE4E6F4928A104120809692F492079D380E4CD97462040A821A124841E42EFCD05776CB95BB664D5ADF3FDB16BB08D8BA49D3DE7ECEEFDBBAEB96CB03467766777E7D93933CF082925888C2284B001C80390758CE239CEBF1F282E9D9B4FE9A91B407B2FCAFEE3FC7B8B9432A877E3890E100C00480F42883C007500061FF6670D00AB814D23324A08C00600AB017C72F09F52CA16231B46E9810100292384B0223AA01F3EC8D721FA2D9F887AA705D180E0F0E0608394326464C328753000A07E1142D401188FCF07F8C1000602B019D92EA2141704B00E9F0705AB01BC21A55C6D68AB28293100A05E1142540398112BD3019418DB22223AC876002F00781EC0F352CA8D06B787920003003A22214429A203FD8141BFD2D81611511F7C8A583000E00529E55683DB4326C40080000042880200D3F0F9805F6B68838848A535F83C2078514AB9DBE0F690093000485342886C0053F1F9803F148030B45144A40709E0637C1E10FC474AD9666C93C8080C00D28810220BC04200E7009802C0626C8B88C804C2005E02F017000F4B29DB0D6E0FE98401408A13425800CC02702E80D3006418DB222232B12E007F0770378067A5946183DB4309C4002045092186233AE82F0757EC1351DF6D07701F80BBA5941F1ADD18528F01400A11421403380BD129FE46839B4344A9E303446F11DC2BA5DC617463480D0600494E08E142746AFF5C00B3C1FBFA4494386100CF207A8BE0EF52CA6E83DB437160009084841002D115FCE722BAA82FCBD81611511A6A07F030A2C1C07F240793A4C300208908211C002E00F0754473EE131199C106003F0570A794D26F7463A87718002401214406802F213AF0FB0C6E0E11D1D16C433410F89D94B2CBE8C6D0B131003031218407C0E500AE015060707388887A6B37805F00F8B59472BFD18DA1236300604242885C005703F82A00AFC1CDD185C3AAC197EB40A6D3824CA70559B13F3FFF6FEB61FF7DE0EF5664B9A27F77DA34A31F467A0B85815028FA670A7FAEF40423E8F047D0DE1346873F7CD0DF23E888FDD9EE0FA3A32772D8BF47FFBEAD35007F28759F9FC3B402B81DC02FA5947B8D6E0C1D8A018089C4B6F17D0DC0A500320D6E8E72164DA022DF8901452E0C2C726140B1EBB3BF97E539A13111716A90321A040483D13FE910110934EF0B60DDAE1EACDFE3C7FA5D7EACDBDD83F5BBFDD8BC37807024253F933B00FC1F809F731BA17930003001214439806F00B81880D3E0E6C44508A0C4EB880EEC070DF0038A335055E084CDC2513EAD48090443D160201C31BA35A6170C4B6C6AF163FD6E7F3440D8EDC7BADD7EACDFDD83ED6DC1549858E901F007003F91526E31BA31E98E01808184100301DC80E8763E9BC1CDE9178FCB8A89B51E4CAEF362626D36EA4BDD70D939154F47108E4403816028A56F11244A772082553B7AF0EAFA76BCBCAE03AFAEEFC0FE9EA49D610922BA7DF01629E53AA31B93AE18001840083108C0F7002C419225EE3978C09F3CD88BE195999CBAA7BEFBEC1641287A361DF55944021F3677E1E575491D1084013C00E07B52CAB5463726DD3000D0512C6BDF8D884EF7DB0D6E4EAF64675831A1361B270CCEC6E43A2F865570C02785A40402C168E167515C2212F8686B175E5ED781FFAE6DC76B1B3AD0D69D34014100C04F00FC88D905F5C3004027428805006E03506D745B8EC5E3B262E2600EF8A4330602CA1D1E1024C90CC14600574A299F30BA21E98001408209212A01FC0AC0A946B7E5689C760D731BF3B0687C21660FCF85DDCA119F0C2211BD35E00F3010502C10967866651B1E7A671F9E5AD1869EA0A91765FE03C05552CA4F8D6E482A6300902042083B806B017C1B4086C1CDF9028B2630ADC18B454D8558302A1F99CEA45A8A40E9E0C08C40C4D4035552EAF087F1C4876D78E89DBD78714DBB59B71E7601B819C0CFA49401A31B938A18002480106206805F03A833BA2D871B3BC083454D85387D6C010A3C49B9F180D24D30149D1160209010BB3B4278F4BD7D78E89DBD786B53A7D1CD3992D5002E97523E6F7443520D030085841025007E066099D16D39589D2F030B9B0AB1A8A91095F9499D6680D25930040402CC2790409FB604F0D0BB7BF1F03B7BB17A478FD1CD39DC5F015C2BA5DC6E74435205030005841016005700F801008FC1CD010094E63AB0707C74D01F5AEE36BA3944EA8442803F08844DBFA02DA97DBCB53B160CECC3D656D3CCC0EF07F01D00774829F902881303803809212600F80D801146B70500C6D464E1EA79E59837329FABF729B58542400F6F0D245A4402FFFCA815BF7C6E27DEFED434B708DE07709994F235A31B92CC1800F49310221BD1E9FE0B01183ED4CE1E968BABE79563D2E06CA39B42A42F7F205A28E15E59D7815F3EB703CFAC32C5017F12C09F10BD2DD0667463921103807E10428C06F020801A23DB61D504CE185780AB4E2AC7104EF3533A8B44801E3F0F1FD2C98A6DDDF8D5733BF1B7F7F62164FC0E820D00164B29DF31BA21C98601401F0921AE04F0531898C9CF65D770EE94125C7E62292AB8A88FE873C1503410E0E79A2E36EF0DE0D72FEEC4DDAFB7A03B60E8AD980080AF4B296F33B211C98601402F0921BC884E379D6E541B72336DF8D24C1F2E99E9435E26B7F0111D9194D15B0281A0D12D491B2D9D21FCFEBFBBF1BBFFEEC6DECE90914D7914C08552CA56231B912C1800F48210621CA20756541971FDB23C07AE985386734F28468683097B887A251CBB2DC0DD02BAE90A4470F7EB7B70C70BBBD0BCCFB075199B002C9152BE69540392050380E310425C03E05618705CAF2FC7819BCEA8C2A20985B072493F51FF0483D1DD02FCACD34D2822F1D0DB7BF13FFFDC866DAD86CCC404015C2FA5FC8511174F160C008E4208910BE04E00A7E87D6DA74DC31573CAF0B5F9E5FCC64FA4026F0B18A22B10C1CF9FD9813B5EDC65D4D9038F01B8404AB9D7888B9B1D03802388EDEDBF1F4085DED75E302A1F3F5C5AC38C7D4489100E03DD7EE60ED0D9A72D017CEB1FCD78E243436ECD6F06B0943903BE8801C041841002C075007E04C0AAE7B5EB4A3370EBB28198DAE0D5F3B244E9A9C7CFD90003FC674D3BAEFFDB1623D20C8700DC08E07F2507BDCF3000881142E401B80BC07C3DAFEB755BF1CD532B71D10C1FEFF313E9895B060D118A48FCF1E53DF8F153DBD0DAA5FB02CD27019C27A56CD1FBC266C4000080106212A253FE657A5D5313C0F9534BF0ED33AA90CB2D7D44C6884480EE1E1E306480BD9D21DCFCCF6DF8F3AB7BA0732EA166446F09BCA2EB554D28ED030021C459882EF6D36D149E589B8D9F9C359087F41099056F0918E6E3ADDDF8C6DFB6E0D5F51D7A5E3688E8E2C07BF5BCA8D9A475002084B81AC0CFA1532EFFD25C076E5E5283D3C716E871B994B26947175E5EB92FAE3A7CB90ECC1891AFA845FDD7D91DC2A3AFED8CAB0E875560D1149FA216C5E7A197B6C11F8AEF73E4F4094570BB745D76F345C1109E7F6727B6C579F2DDE4DA2C5471116F9F3DFADE3E7CFB1F5BF53C795002F89A94F2977A5DD06C0C7EC7194708F1630037E875BD734E28C6ADCB07705B5F3FBDBC721FAEB8677D5C754CAAC9344500B0B3D51FF763C97468A60900AEF9EB0674F8E39B429F58EF458DD10180CD8A9F3DBB13AF6C88EF9BE81D8BCB1900F4C3E9237330674836AEFFDB16FCE5755D6ED10B00BF1042144B29751B0BCC4433BA017A13425884107F824E837F8EDB8ABB2F6FC0ED17D472F027223A860CBB86DB9756E2EE0B6A9093A15B4078BD10E24F4288B4FB804EAB004008E1423457F4057A5CEF843A2F5EF9C1689C32DAF86F9D4444C9E294462F5EF9463D4E1894A5D7252F00F0686C8C481B691300082172003C03E0E4445FCB6611F8DEC26AFCE3EBC3E1CB7124FA72444429C7E7B5E11F970DC27717F860B3E8B24CEB6400CFC4C68AB49016018010A214C04B002625FA5A038A5C78FA5B2370F5BC72705B3F1151FF6902B86656319EBE7A300614E8F2656A128097626346CA4BF90040083118C0AB008626FA5AE79C508CFF7E6F144656E9366D454494F2469667E0BF5FAFC7394D797A5C6E2880576363474A4BE90020768CEFCB48704E7F2EF423224A2C9D1708560078393686A4AC940D00841073003C0F20A12BF0B8D08F88483F3A2E10CC07F07C6C2C4949291900C4B2FB3D0E2061A9F6AC9AC077B9D08F884877072F104CF0192A6E008FC7C694949372018010E272007F410253FB663A2DB8FFAA21B8860BFD88880C716081E0FD970C4066626FBDDA00FC2536B6A494940A006251DAED48606A5F5F8E03FFFEE608CC1A969BA84B1011512FCDAAF7E0DF57D5C2E74DE8712E02C0EDA9361390320140EC3ECD9D48E0E03FBC2213CFDF34124378880F1191690CF1B9F0FC3575185E9691C8CB080077A6D29A80940800622B351F4102A7FDE70CCFC5BFBED98862AF3D51972022A27E2ACEB6E15F5FADC59C86EC445EC606E09154D91D90F401406CAFE69348E082BF4B66F870DF9543E0E6163F2222D3723B34DC77710D2E999CD01357DD009E4C853C01491D00C4B2353D8D046DF5D304F0A3A503F0D3B307C2C2D57E44D41B96A4FE584D7A164DE0A70BCBF1A3D3CA12B9483B1FC0D3C99E3130695FA9B17CCD4F2141497E5C760D775FDE80CB4E4CEAFE2522BD59AC8083B70A8D76D9B442DC7D410D5CF6840D7315009E4AE6B3030C3E80BB7F6227363D8E04A5F72DF4D871FF554330AA9A297DCDC297EBC0A49ACCB8EA68AC30C7E24D97C312F763713BCC13BB4FACC944A73F12571D2E93DC5E53F11AF1E53AA20180944020A8A055D45F0B867BF1E415B558FAFBF5D8D59E90BE188A689E80D952CAEE445C20918494D2E836F449ECCCE64791A053FDEA7C1978F0EAA1A8C87726A27A224A27DD3D403064742BD2DEE6BD012CFEDD3AACDED193A84B3C0EE07429653851174884640C00FE84E8D9CDCA4D1A9C8DBF5E39041E57524E8C109119757503A1A41A1752D2FE9E3096FD613D5E59D791A84BDC29A5BC305195278279E6117B4108F1632468F01F3FD08387AE1ECAC19F88D47239018B396E71A4338FD38287BE3410E3AB13762BF082D818953492260010425C0DE08644D4DD58998987AE19CA93FC88483D21800C27A025CDC76DCACAB06B78E8CB03D198B8844137C4C6AAA49014B70062E917FF820464F9AB2BCDC03FAF6F446E6642D3481251BA8B48A0AB2BFA27196A6F6708F36E5F93A8350112C03952CA7B1351B94AA60F0084109300BC800464F91B50E4C23F6F68445136B7EC10910E2211A0B33BBA43800CB5737F10F36E5F83F5BBFD89A83E0860BA94F2954454AE8AA9030021441E80F70194A9AEBB3CCF89A7BED988D25C1EE54B443A0A87A34100196E6B6B00736F5B832D7B0389A8BE19C00829654B222A57C1B437A5841002C05D48C0E05FECB5E3B1AF0FE3E04F44FAB358A26B02C870A55E3B1EBB6C108AB313720BB80CC05DB1B1CC944C1B0000B80EC07CD595E667D9F08FAF0F4775A14B75D54444BD63B546770790E1AAF31DF8C76583909F99901D60F3111DCB4CC994B70084101300BC04C5990ABD6E2B1EFFFA700CAB882F0B1B1191128100D09390E967EAA38FB676E3E45FAF416B97F29C0D210053A494AFA9AE385EA69B011042E402B81F8A07FF4CA7050F5F338C833F119987DD0ED8B903C90C8695BAF0F097072253FD76702B80FB63639BA9982E00007027141FF0E3B46B78F0EAA11853C3DCFE4464324E07130599C4984A371EFCD200386DCA87C60A44C736533155002084B806C0292AEBB46802F75CDE8089B5D92AAB252252C7E58C260C22C34D1C90897B2EAC49C411F0A7C4C638D3304D0020841807E056D5F57E7F5135660D33DDCC0B11D1E73401B8B82BC92C66D57BF0FD937D89A8FAD6D858670AA6080084105E000F4071B29F85E30B71C51CE5BB088988D4B35AB91EC044AE985E8485A37254576B03F0406CCC339C290200007F0250A5B2C2A1E56EDC7E41ADCA2A8988128BEB014CE5F6A595185AAA7CCB7815A2639EE10CDF062884B812C0AF54D699E3B6E2C5EF8E42653EF7D9EAE1FDF56D08C799DF7C6855361C36E3EF81AEDBD689B6CE605C75D414672027CBF8F4D25B5BBAB1636F7C694E8B731D28CD333E67C6BEF60036ECE88AAB8E6CB70D037D093B09AED7FC41898F37B51DFD072400BF3FFAE7515834604485F18F251D7CDA12C0B49FADC6BEAE90EAAAAF9252DEA6BAD2BE30340010428C06F02A00659F96164DE0E16B8662FA10E5533774146597BE8C0E7F24AE3ADEFDE168D49418FF8136FFE677F1CA86F8CE0BBFE3EC01387B46A9A216F5DF37FEBC1ABF7B69575C757C694A217E727E9DA216F5DF3DCF6FC515F7AC8FAB8E49359978F2DBA314B5A8FF366CEFC4A86FBD13571D990E0DCDB78E50D4223A9E173ED98F85FF6F7DDC5F740E130030514A19DF8B210E86DD021042640378100A077F00F8EEC26A0EFE4444A4CCF4C11E7C7781F2458176000FC6C6424318B906E067006A545678C6B8025C39978BFE888848AD2B6714E18C91CABF5CD6203A161AC290002096EAF74295750E2977E3D7170E5659251111D1677EBDAC12437CCAD7C45C181B1375A77B002084B000F80D00652BBEBC6E2BEEBD62085C76B36C6A2022A254E3B26BB8F7A21A783394EED410007E131B1B7565C48879050065AB573401FCE92BF5A82AE08A7F22224AACAA3C07FE746E3514270A1C81E8D8A82B5D0300214409801FA8ACF33B6756630617FD1111914E66D479F09D05CA77FAFC203646EA46EF19809F01F0A8AA6C6E632EAE9E57AEAA3A2222A25EB97A6611E60E51BA80DF039D1704EA16000821660058A6AA3E8FCB8A5F9EC74C7F4444648C5F2EAE80C7A9F4D6FDB2D858A90B5D020021841DC0AF55D6F9A3A53528F61A9F6D8D8888D25371B60D3F3A5DF9D6F35FC7C6CC84D36B06E05A00CAD2894D1F9283B34F2856551D111151BF9C3D3E0FD3072BBBB30D44C7CA6B55567834090F0084109500BEADAA3EB7C382DBCE1FA4AA3A2222A2B8DCB6A4026E87D2E1F4DBB1B133A1F49801F815800C55957D7F5135CAF3B8E58F8888CCA13CD78EEF9FAC74574006141F927724090D0084100B009CAAAABE4983B371D174E5F9988988928F836BA0CCE4A24905983430536595A7C6C6D084495800208470015076D4A1D3AEE1F60B6A218C3F319688C878761B5467A3A1FE1302B87D69259C36A5C3EA6DB1B134211239037023806A5595DD747A156A0A8D3F979C88C81484009C0EA35B4107A9C977E0A6F94A67A9AB111D4B13C29A884A851083007C43557D63077870E9893CE5CFAC4A3C3674F82371D561B598E31C87FC2C1B4A3CB6B8EAC854BB2FB8DFBC19D6B81F8B3723211F117D96E9B4C4FD58F2B3E2FB7D55AC162DFED7D8810567562B60B500A1B08296910A974E2DC4DFDFDF87B73675AAAAF21B4288BBA5946B555578809052AAAE1342887B012C575197C3AAE1A5EF8FC2E01265EB08898852472402747419DD0A3AC8273B7B30E5A7ABE00F291B5FEF93529EA5AAB203947FED12420C04B044557DD79F5AC9C19F88E868348D0B024D66709113D7CF559AD67F496C6C552A11F3AE3700503207DA5899892B4FE2D43F11D13139ECD140804CE3CA1945682C53F6E5D582E8D8AA94D2578C10A21CC0B9AAEABB75F90058B9CA9588E8F8B820D054AC9AC0AD6728FD027B6E6C8C554675C8F80D004A56DACC199E8BA6414A4F5A22224A5D564BB4906934D564624E83B271CC06858BEB0185018010A218C0C56AEA026E3A53D90E4222A2F460E75A00B3B969BE4F65FE9A8B6363AD122A6700BE0640498EDE33C7156268B95B45554444E9C36A012C9C053093A1A52E9C39324755754E44C75A2594040042885C0097AAA8CBAA09DC787AC2CF4020224A4D0E73E43BA0CFDD38CFA7723DDBA5B131376EAA6600AE06A02409F239538A99F18F88A8BFAC56C02489B528AA26DF81739AF254559789E8981BB7B8130109213C003E05E08DB7314EBB86F76F1987622FEF631111F55B300474F718DD0A3AC88EB62046DCBC023DC1F8B2A6C6B402A89452EE8FA7121561E2E55030F803C097679672F027228A97CDCABC0026539C6DC397A714A8AACE8BE8D81B97B8660084101900360188FB51795C567CF09371C8719B23F7381151520B06816EBFD1ADA083ECEB0AA1F1072BB0BF47C9D90DBB01544929FB9D073ADE10F14B5030F803C095279571F0272252C5C6E382CD2627C38A2B6716A9AAAE00D131B8DFFA3D0320847000D80020EEB30F0B3D76BC7FEB586438B87D858848994010E8E12C809974052218F13F2BB0AB3DA8A2BA6D006AA494FDEAE47866002E8082C11F00AE5D50CEC19F884835BB0D2AB3D050FC32EC1AAE9DAD2C978F0FD1B1B85FFA150008210480AFF7F7A207ABC877E282694AE20822223A1C4F0A349D0B26E5A3225759BF7C3D3626F7597F6700A602A8E9E7EF1EE2BA0515B05B19A112112584CDCA590093B15B04AE3B51D92C400DA263729FF537005072E29FD76DC5E2A64215551111D1910811BD1540A6B278742EBC19CA6E7DF76B4CEE73002084700158D89F8B1D6EF9A42238EDDCAB4A4494505C0B603A4E9B86E5E39465075C181B9BFBA43FA3EF6900B2FAF17B871002B8683AEFFD1311259C10D114C1642A174D2A50159765213A36F7497F020025D3FFD31B7230A08839FF8988746167006036030A1C983ED8A3AABA3E8FCD7D0A0062E710CFEEEB458EE4E219FCF64F44A41B8B85E9814DE8E249CAD203CF8E8DD1BDD6D757C35900E25EB55096E7C09C4625A7191211516FD9380B60367386785096A3644BA005D131BAD7FA1A009CD3C79F3FA2F3A796C0C214954444FA6200603A164DE0FC89F9AAAAEBD318DDEB004008311C40639F9B7318BB55E0BC2925F1564344447DA569D15B01642AE74DC887DDA2E44B71636CACEE95BECC002859FC77CAE8021478B8279588C8109C05309D824C2B4E69F4AAAAAED76375AF0200218405C0F27E37E72017CFE0B77F2222C3300030A58B272B5B0CB83C36661F576F67006601887BE41E52EE46D3A0EC78AB2122A2FE128241800935D56462884FC9D6F81244C7ECE3EA6D00A064FAFF6226FE2122321E03005352380BD0AB31FBB8018010A25F19860E97E5B260F104E6FD2722329C95070499D1E2D1B9C8722A59A4795A6CEC3EA6DECC002C0490116F6B163715C1EDE0EA53222253E02C80E9B81D1A168F5692232703BD38B3A737018092BDFF278F5676E8011111C5CBC6DD586674B2BADD00C71DBB8F19000821B2014C89B7151E971593062B7B504444142F8BC6D4C026346940263C6A6E034C898DE14775BCDE9F0A05A97F670FCF814D4D920322225285B7014CC7661198DDA0E480200BA263F8511D2F0098A1A215278DE0F43F1191E9F03680299D3454D98CF931C7F0840700564D60F6301EFC4344643A9AE06D00139A5DEF8155CD7939FD0B008410050086C67BF58983B3919DC16926222253B2727796D964BB2C983820534555436363F9111D2BF49B0620EE10641EA7FF8988CC8B870399D2BCA14AB2E60A44C7F2233A5600A0E6FEFF4806004444A6C5190053D2631D40420380FA52372AF39DF1564344448922B80EC08C2AF3ECA82F51723640DF020021442980DA78AF3A9FDFFE8988CC8FB300A6345FCD6D80DAD898FE05470BFBA6ABB82AA7FF898892000300533A6998B2D3738F38A61F2D00887BFABF28DB8E5155C73D8B8088888CC68580A634AADC8D228F925C0D471CD3131600CC1D91C7C3A68888928110D1D4C0642A42007387289905E85D002084A8065019EFD598FD8F8828897016C0944E52B30EA03236B61FE248215FDCDFFE6D168169F53CFC87882869701D80294DABCD527596CE17C6F6840400F5A56E38ED9C4E22224A1A9C013025A74D4BD876C0238DD271EF001859CDC57F444449450806012635B23C4345355F18DB0F0900841075004AE2BDCA884A25398C8988484FBC0D604A23D4040025B131FE3387CF008C57719591DCFE4744947C3803604A8A660080C3C6F8C303803AC4C96E15682873C75B0D1111E98D01802935F85CB0AB590878CC1980B80380863237EC56260020224A3A023C17C084EC1681069F928580C70C0006C75B3BA7FF8988921813029992A2DB00878CF19FF5B410C20A6060BCB5730120115112E30C8029295A08383036D603387406A00640DC4987B90590882889310030254533003644C77A00870600714FFF3BAC1AEA4BB90090882869695CC36546F5252E38D4ACAFFB6CAC3F3800887B01E09072B7AA948544446404CE009892CD223044F14240A53300BCFF4F4494E484008F72352745EB00123303C0FBFF44442980B300A634B25CC92DF623CE00C41D007006808828053000302545330087060042883C0079F1D4E8B06AA867064022A2E4C75C00A6545FE254B110302F36E67F360310F7B77F5FAE0356AE1E25224A7EFC2C3725AB26E0F3DA555455077C1E00C4BD00B0444DA38888C868BC05605A25D971A7EB016263BEBA19801C47BC55101191193000302D9F9A0040ED0C40316700888852078300532ACE5632D672068088888E82018029299D0110421C921BB8BF4A7238034044943218009892A235003542089B86E8F63FEBF17EFA78B8089088288530ADBB29290A00AC00F234004AD2F795F016001151EA603A60532A51B3060000B29405005C044844944A18009851B19A1900405500909B6983C3CAFB45444429833300A6E4B00AE4BAE3BE6B0FA80A00B800908828C570FC372D45EB00D404003E2FEFFF1311A514CE009896A2AD806A0200DEFF272222D287A275008A6600B803808828B57006C0B47C6A76026469003CF1D6C2350044442988418029295A03E0B142C10CC0BA1DDD78E48DDD0ADA434444A6D1D30348A31B41875BB7DBAFA29A2C2501C01DFF6E56D016222222D289BA444044444494341800101111A5210600444444698801001111511A620040444494861800101111A521060044444469284B03A024A300111111250DBF06E03DA35B41444444BA7A4F03F08ED1AD202222225DBDA30178D1E85610111191AE5ED4A4944F02F89BD12D212222225DFC4D4AF9A4905242085100E063008546B78A88888812661780A152CADD1A00482977035800609DA1CD222222A244590760416CCC8776E0FF4A29DF02D008E00EF004682222A25421111DDB1B63633D004048F9C5B15E085106600C80D100860170EAD4482222228A5F0F808F10DDE9F7B694B2F9F01F38620040444444A94D3BFE8F10111151AA610040444494861800101111A5210600444444698801001111511A620040444494861800101111A5210600444444698801001111511A620040444494861800101111A5210600444444698801001111511A620040444494861800101111A52131E5F492938545ECD334DFC46FD70000200049444154ECD134B15708EC79E6BEE688D10DA3C49AB5BCCC190ECA2100348B4DAC78F6BEE62EA3DB44FA61FFA737F67FFA99BDBC4C0B06649E66415E24827C19963902803CF88784001C1916999D6FEFCAF2DA77656459373ADD960F9D1996FFD89DDA13CFDCD71C32A8FDD44BD317978E0C7487A78582B226E88F9407FCE1627F77A4C0DF15CEEEEE0CB9BBDA43F6EEF69026633D2F04E0745BA5DB63F5BB32AD5D0E97A5CDE1D2F6D89C96ED36BBB6C566171BED4ECB4B2F3CB4F52D631F19F506FB3FBDB1FFD3D7ECE565D6404F64414F57786A4F676858577BB8BABD3550D4B62790E1EF0A0B290FFDF92F0400C7E2725B645165C62E6F81FDCD4CAFED216786E58167EE6B0E287E0CD447B3979759BB3BC317B5ED099CBB7373F7C8DDCDDDAE445C27BFD4D9535C91F17E7681FD2F2EB7E50FEC7B7360FFA737F67FFA9ABDBCCCDED3155ED2D11A5CD4BA3B306EE7A75D85DD9D61D1DBDFEF53007038A7DB222B0667AECDF7397F9F9165FD256707F4337349E9808EB6D0D57B77F42CD8BABEABB2BB23D4EB4E57C1E5B648DF00F7E6DC62C7BF32BDB69F3FFFC0D6B57A5E3FDDB1FFD31BFB3F7DCD5E5E66ED6A0F5DBD675BCF259B3FE918D4D38701FF7071050007CBCAB185CB6B33DFCF2B71FEF4A547B73DA0A24E3AD4B485A5535B77FB6FDCDDDCDDB46353B7271251D27571130228AECA682F2873BD915368BFE5C587B73D67749B5211FB3FBDB1FFD3DB09A7952CDEBBC3FF8D2D6B3A46B4EF0B5A54D52B5597B241EEBD13E617DD28A5044BFC65F269C567D70CF36CD634A1BCAF54172120AB87646D9D744AF125463F6FA952D8FFE95DD8FFE95DC69F54787DD940774B42FA2BF69784282875F6540DC9FAB327CF7ECDB3F735F724EA3AA96AE282E21BB7ACE9B8AE796D678ED16DE90F5F4DC6FE8AC159B7677AADDFE1CE92BE63FFA737F67FFA1A3E39CF6EB56B3FD9B2A6E3923D5B7B321279AD844785B9C50EFF84F945D71B1D49254B39E1B49245A503DDFBF4E81B3D4A715546FBE4538BCF33FA794D96C2FE4FEFC2FE4FEF327676C13539458E1E9DFA47BF1742F5504FF3B485BE26A39F60B396E98B7DB583C7785724C3545F5F8B1090834666AF99BEC837D4E8E7D9AC85FD9FDE85FD9FDE65E282A231550D599FEADC37FABE106C0E4D369E90F7F4CC65A54EA39F7033955133F21F70BA2D11A3DFA8892E0E972532725AFEA3B396956A463FE7662AECFFF42EECFFF42DC326E5DA874DCAFD97CDA119D127C6BC104AAA33F64F5BE89B68F4936F7499BED857575997B9CBE837A6DEA5BC36B365DA22DF08A39F7FA30BFBDFF83E60FFB3FF8D2A1317148D2BA9CA6835B02F8C7B1138DD96C8B8B9853F37BA130CECFCEB32BDB6B0D16F46A34A469635DC34AFE8FB46F703FB9FFDCFFE67FFEB5D46CDC8FFB133C3F0591FE35F08B5A3B257CF5C5AEA35BA43F42AB39695DA874EC87D4D08E39F7B3394FA71DEF7672E2BCD30BA5FD8FFEC7FF63FFB3FD165F4AC82AC818DD91F19FDBCC78AE10D9000A4AF26A36DC6E2D26AA33B27D165E6D2D2FCAA86ACED463FDF662BE5B5992D339694961ADD3FEC7FF63FFB9FFD9FA8326E4E615949758699767818DE80CF4A5E89B367DA42DF78A33B295165FA625F5D71654687D1CFB3594B4199AB6BDA22DF48A3FB89FDCFFE67FFB3FF5597A6794523F38A9DDD463FCF8715C31B7048C9CAB585A69C5E72AAD19DA5BA4C3DA364B6B7D01130FAF9357BF1E4D983534E2F39D9E8FE62FFB3FFD9FFEC7F5565E282A2F95939B6A0D1CFEF118AE10DF84271BA2D91890B8ABE6174A729EBFC938BAFCCC8B2A6ED629FBE1617FB3FAD0BFB3FBD4BAAF5FFF8B9855F33C162BF231757A63562C6C5289A26E48869F9FF30BAF3E22DA3A6E73FA859CC97D843B30899956B0B65E5D842A66C1FFB9FFDCFFE4F68FF7B726DA14CAF79FBBF714ADE6346F75FBC65F8E4BC47CD98D84908C88C2C6B444829316B795946382887858291BA50400E0A062295017FB8AC6B7FA866EBFACEF2788E1B8CD7C046CFA6CAFAACD1CFFEB579AF516DE88F59CBCA3C9B3FE9787BED7B6D838C6A83C36591A503DC5BB3726CAB6C0E6D8BCDA16DB4DAB44FAC36B1C26215AB0FE4E79EBDBCCC1A0EC9BA50500E090523B5417FA43AE08F94B7EF0B346C5BDF55E2EF66FFF715FB5F0DF67FFF395C16593AD0BD2D2BC7B6D2E6D09A6D766D83CDAEADB1DAB515255519ABEFB9654D1800864FCEB3E4163BEBC2A1C8905050D60603919AA03F52D6BE37D0B06D4397CFC8FEAF19E6F9B4BC3673F48B0F6F6D31AA0DFDD1745251CEAEE69E77367EBCBFDAA8366466DB64E920F7A68C2CEB7A9B5DDB6A73689BAC366D9DCDA1AD76B8B4154FFCE1D3EEE346303397953A279D5CFCD5214D396FE49538F5CA4F7C48292C777526530AE1698B7C238BAB32DA8D78AE728B1DFE86A69CB7262E28BA46C5D69A994B4B33272E28BAAE617CCEBB3945C6DCC364FFB3FFD9FFBD2B79254EFF90A69CB7279D527CEDBC0B2ADCF13E96134E2B714F985F746DFDB89CB7730A1D7E231E534199B36BF2A9C5938CEED7DE96F1271536E5973A3B0D79AE4A9D3DC326E5BE36F5CC92AF7CF517436DC76B6B9F1FDCD4337D53464DCF7FA8A054DFD58C191E6B78D2C9C55F35BA738F57269D527C4966B6BEC93D728A1C8191D3F31F997A66C9F4443FBEA96794CC1E392DFFEFDE02BBAE8301FB9FFDCFFE3F7AFF8F9A91FFB7E98B7C3313FDF84E38AD64E688A9797FD3BBFF5D99D6C8B8B985D718DDBFC72B6366155CE9CAD477BD4741A9B37BD48CFC87662C2E9DDCD7F6F6FB81CE5A56AA8D9B5378BB9E2B5B354DC84123B3D74D3DD337C5E88E3EBC4C5BE86BAA1D95FD899EF7D33C79F6E09859057F36E25C8599CB4A3346CF2CB8272BD71662FFB3FFD9FF86F47F68EC890577CFBFA8C2A5F7E39D7C6AB16BD4F4FCBBF5EC7F2120AB87666D9C30BF28E1814E5FCBB83985D3AA8764ADD7733D9DB7D0111837A7F0F678CE5550F141E01C3DB3E09EAC1CFD5E08168B9083C778574C5BE81B6D74C74F5BE41B5137D6FB81C5AADF1B3FD36B0B8F9A91FFC0CCA5A599463FFE994B4B3D23A7E53FEAF6E817F5B2FFD9FFE9DEFFA367153C3CF7BCF22CA31FFF94D34BB21AA7E43DAC67FF6B9A90031B3D9F4C985734C1E8C73F6E4EE1F801C33DABF45CE89795630B8D9E59708F8AC05FE50741EE88A9794FB832ADBA6D77B0DA34D9303EE7DDE98B7C0D7A77FCF4C5BEDA214D396FDAECFA9DE0E4CAB446464CCD7B7CE6D2D25CA35FF847E8FFC2C629794FE9B9DD85FD6F9EC2FED7A7FF474ECF7F72DE0515F946F7F7E165F2A9C5F9C34FC87BD2A163FF5B2C42D68ECAFE60C2FCA246BD1FEFB83985C3068DCC7EDFA2E38C4FECFDFF84CAF7BFF22766DA42DFE8A20A97AED9AEEC0E4D0E1EED5DD934AFE87F662E2D4DD89B63E6D2D2DCA67945DFAB1BE3FDD8E1D2775F676199AB2B194E4F9C7A66C9F47C9FBEEB43D8FFE629ECFF04F57FB9AB7BD6B252D3DDFA38BC4C3AA5788ADEFD6FB56972C070CF27A36716DC3266764171A21EDBC8E9F945A366E4FF78C070CF6AAB4DDFA37B8B2A333A1231E395A8378A7760A367A39E4FD0C12F868AC199BB47CDC87F60EA425F9F17451C5EA62DF4358D9A91FFD7CAFAAC9D7A46FB079701C33D9F26F2834D7599B1A4B4A87A68D656F63FFB9FFD1F7F19D8E8D972D2F9E58546F76B6FCBE4538B0BAB1AB2B618F15C6916217D03DC2DC34FC8FBDBF8B98571AF15183BBB60FAB0C9B98FF86ADC7B8CCA97306844F686441D9627A494489491D3F29FF8E0A596F909BCC471E59538FD3985F6ED7697658FDDA1ED88ED87DD68B5696B2C36B112800C076543281819140CC89AA03F5C16F4478AFDDD91FCD6DDFE923DDB7A9C46B55D08A0714ADE3FDF7B71CF7CA3DAD05FB3979769BB9A7B9EFEE8E59699ECFFFE61FFC72FD9FB7FC4B4FCA7977C6DC0DCEB17BC6EE0B3D8774208316C52EE531FBFBAF74423FB3F3BDF1EC82974EC70B82C7B6D0E6DA7CDAE355B6C6293C522D646227255240C69B18AFA48580E0A8564552810290BF8234581EE70DEBE5DFEE2B63D01BB516DD73481C6A9794FBCFBFCEE9313769144478313E617DD64DA3488262E2EB72532617ED18D4647F3F196A67945DFD77BBA34150AFB3FBD8BCB6D894C3AA5F83B46F75FBC65DC9CC2EFB0FFFBDDFF097FFFEBF222987246C9DC1C1E84D1EB925BECF0EBB1A75BAFC2FE67FFB3FF7B5FF24A9C81994B4B671BDD6FAACAA4938B671B954428194B5E89D3AF57FFEBF622E05198BD2BBE01EED6198B4BAB8D7ED3B2FFD9FFEC7FFD4BE940F7FE93CE2F1F64747FA92E1317140D2AAA70ED37FAF9357BD1BBFF757D11CC5C5A9A5F599FB5C3E827D9ACA5669867F3CCA5A51EA3DFACEC7FF67F22CA8967971554D667ED34FA79366B19D898BDED8C2BAA4DB7C55355193FB730A76270A6218B4393A10C6CF46C3DF52B55397AF689EE2F8259CB4AED83477B571AFD649BAD3434E5BC154F46A76429ECFFF4EEFF93BF54E9183CC6BBCAE8E7DB6C65D8E4DC0F7B93BB3DD94BCD508F75E088EC0F8C7EBECD56864DCAFDE04B3FAAB7EADD1F86BD1046CDC8BF5FEFBD94662C76A7161933BBE0F746BF31D9FFEC7F9DFBFF01F63FA4DD69914DF38AEE36BA3FF42E8D53F2EE66FF1BDFFF86BE08A69C5E729ADE4923CC540ACB5D9D53CF2839D1E83723FB9FFD6F48FF9F51727A7EA931278C9AA11455B8BA672D2F5B60743F185526CC2F9A9FEF737619DD0F06F67FD7CC65A5F38DEC03C35F043397967AEBC67A3F32BA33F42C4240368CCF79DB0CB9DC8D2EEC7FE3FBC0C832E79CF29CFA71392B8CEE13BDFB7FD8A4DC0F4FBFAC3ADBE8E7DFE832617E91A776B4F77DA3FB44EFFE1F3A21F7FD932FA9347CBD8FE12F80835E0837A5C356A1DC62877FE282A26F18FD7C9BADB0FFD3BBA44BFFE79538FD934F4DFCFEEE642BE3E614DE980E5B05CDD6FF09CD04D857B3969565B66CEF7960D59BAD27F9BBC3C2E8F6A8E4745B64FDD89C7FE49638963D7B5F738FD1ED3123F67F7A8BF5FF83ABDE6C9D9B8AFD3FA429F7C98ABACC257FBB634397D1ED31A3F1738B327A3AC3F77FF24EEB8294ECFFF1394F54D4672D3555FF1B1D811CA94C5FE41B3E6864F63A3DCF564E54D1B4E8D1A5D317FB6A8D7E5E93A5B0FFD3BBCC5E5E36A27654B6AE67AB27B2FFEBC7E7AC9D7F51C530A39FD76429934E2E6E18D8E8F92465FA7FACF79339E796EB7E62656F8AE10D3856997246C9DCC1A3BD2B9371B5A8CDA1C9BAB1DE0FA69EE99B6AF4F398AC85FD9FDE65CA192573078FF1AE4AD6FE6F68CA59316B59E92CA39FC7642D131714CDAA1D95FD71D2F6FFF89C8FCDDEFFA6BA057034339694D6EDD9D6F3DBF51FEE3FA16B7F4833BA3DC7E2CEB645060CF73C9F5FE2F8CA730F6C5D6F747B5201FB3FBDCDBFB072F8B60D9DBF5DFB5E5B53E7FE90A9A78633B36DB27674F62BE5B5995FF9FBFF6D5C61747B52C109A795D4B6EE0EFCDF868FF74F4B86F7FFA0119E178B2A322E7DEAEECD6B8C6ECFF124450070C0AC6565DECEFDA1AB5B77F9176EDFD835B8AD256035BA4D00E02DB0878AAB3256E6143A1ECEC8B2FEEAD9BF36EF37BA4DA9C8E4FDBF2AA7D0F110FB3F71CEB8BC267FEF2EFF37F7EDE859B4794D6779EB2EBFD14D0200E4143950519BB939B7D8F1607EA9F396077FB1BEC5E836A5A2A967FAB2FDDDE1AB5B770716EED8D85567A6F77F4955C6EA9C22C7C39E5CFB2FFF75D7E636A3DBD45B4915001C6EEA19BED3F6EF0D5CB2BBB967D2F64D5DD991B03E8F45B308945467B416943A5FF6E4D97FFB9F47B63DA9CB85E910ECFFF475EB134D851FBDB2F7EAADEB3A977DBAAABDF2D3D51D42CFFEAFAACF92950D999BCA6B33EF6B189F73DBF50B5EDFA5CBC5E933934F2D39A5A335F8A5DD5B7B26EDD8D4E5D5B3FF7DD519AD0565AE57B20BECBF7BE1C1AD8FE972E10448EA00E0603397965576B406AFD9BBD37FF2B60D9D55AAA78ADC1E6BC437C0BD31A7C8F15866B6ED17CFDDDFBC4565FD141FF67FFABAF589A68CE6759DB357BDB9EFDC6DEBBB266D5EDD5EA8FA56813BDB262BEB3277950E70BF5C3FDE7BB7AFC6FDECF50B5E37CF6AEE34377D516945E7FED035FB76FA4FDEB6B1B33A51EFFFDC62C7E35939F65F3C73EF96CD2AEB374ACA0400879BB9A4744028281B42C1486D30200704FDE1B2A03F52ECEF8EE4F77485B27B3AC3EECEFD21BB1090191E6BC0E5B6763A322C6D0EA7B6C7E6B4ECB03BB4CD569BD860B56B6BAC566DE5730F346F34FA3151EFB1FFD3D7AD4F34593F78A965444F57784CA0273234E80FD7FABB23E5DD1DA1ECAEFDA18CCEFD4147675BC8D6D116B44000595E5BD8EDB105333C567F86C7DA9591696D73B82C9B6D0E6DADDDA97DE4CAB4BE336C52EEFBD72F783D64F463A3DE99BEA8B4261C920DA150A436E48FD40403918A803F521CE88EE4F57485BCDD9DE18CAEFD21871080DB63F53BDDD62E6786A5D5EED25AEC0ECB0E9B53DB6CB3691BAC76B1C666D7563E735FF306A31F5322A46C00404444444767EA159544444494180C00888888D21003002222A234C400808888280D31002022224A430C00888888D21003002222A234C400808888280D31002022224A430C00888888D21003002222A234C400808888280D31002022224A430C00888888D21003002222A2346435BA01AA09212C002A00E402C83A4249B9C74C44444A84007400D80FA0FDA0B217C0662965D8C0B62927A49446B7A15F84101A8011008601187C501908C06160D3888828F5F801AC03F0C941E52300EF4B29234636ACBF922600104208004300CC8895A900BC86368A8888D25D2B80FF00783E5656C82419584D1D00C406FD2900CE0170328042635B444444744CBB003C0EE02F005E32733060CA0040085187E8A07F16804A839B434444D41F9F02B817C05FA494AB8D6ECCE14C1300C4BEED9F02E006004D063787888848A5D701DC02E031B3CC0A181E00C416F32D02F02D4417F4111111A5AA8F00FC10C043462F1E342C00880DFC6703B811D1D5FB444444E9E213003F02708F51818021018010623480DF0018A7FBC5898888CCE34D00974929DFD1FBC2BA66021442788510BF41F40173F02722A274370EC09B4288DF082174DDDAAEDB0C8010E21C003F0350A0CB0589888892CB6E00D74A29FFA2C7C5121E0008213201FC16D12D7D444444746CF702F88A94B22391174968002084180AE021007509BB08111151EA590D609194F2E3445D20616B008410E70378031CFC898888FAAA0EC01BB1B1342194070042084D087107803B0164A8AE9F8888284D6400B8530871476CEBBC524A6F0108211C88DEBB385359A5444444F40880B3A4947E55152A0B0084101E00FF00304D498544444474B017019C2AA5DCAFA23225018010A204C0BF0034C65D99626E870D1E971DD94E3BB25C3658355D531FD031B476F9B16AFB3EDDAF7B629307D53E87EED725A2BE094724EE7F7A2F3ABAF44D94E7B459100A47108A982265FFE13E00709294727BBC15C51D000821F201BC0C03D3F93AAC16D495E4A03ADF038FCB0E8FD31E1DF45D7658346154B3A817DEDFBC078FBCB31EDDC1906ED7CCCAB0E08EEBCB71EEFC3CDDAE49447DB361AB1F67DFB411AF7DD8A9EB754796E5E1D4E195B05B2CD8DBE5C7EE8E6EECEEE88996F6E8DF3B03FA7D5E1DC52700264B29F7C453495C01406C8FFFF300C6C6D388FEC872DA31C4978BA1A5B9185894CD6FF649ACB5CB8FBFBEB916EB77B5E97ADDC5B373F0DB6F5622C763D1F5BA44746C7F7EBC0557FE740BDABBC2BA5DD369B3E0B4E155682CCD3DEECF76054258B7673FDEDBD28235BBDA1031E64C9DB700CC88275740BF030021841DC0130066F7F7E27D959FE9C2D0D25C0C2DCD43655E1604BFDCA70C2981173FD98AA73EFE14611DA7DDCA0AEDB8EBFB559831364BB76B12D191EDDD1FC2977FB8190F3FA7EFADC19AFC2C2C1E59836C97BDCFBFDB1908E183E616BCD7DC82E6567D672B003C0360819432D09F5FEE570020841000EE03B0B43F17EDAB228F0BF386576188EFF8911925B7ADFB3A71DF1B9F60E7FE6EDDAE290470EDD945F8E165A5B0DB18551219E1B937DB71DEF73662EBAEA06ED7B4680227D695E28401254ABE50EEE9F4E3BDAD7BF1EEE6DD68ED52B658FF78EE07B05CF66330EF6F00700B80EBFBFC8B7DE471D931674805C6561742E3D7FDB4110C47F0C4079BF0CABAB8D7B8F4C988DA0CDC7B73351A6A9CBA5E97289DF9031237FE7A2B7E71DF4EE839935E98E5C2925135F065AB495763B159A159A2B7A22352E2E5B5DBF1EF8F37C31FD2E536C6AD52CA1BFAFA4B7D0E008410F3109DFA4FD888ECB45930ADAE0C536B7DB059786F3F5DADDABE0F0FBEB516ED3DFA7D2370DA35FCE4AA527C7549A16ED7244A571FAFEFC659DFDE880FD7EA37E3070013AA0B715243B992F1456802169B15E2085F52F77707F0D8071BF1FEE6B8D6EAF58644F456C03FFBF24B7D0A0084106500DE079090E5D3164D60C28062CC6E2887DB614BC42528C974F88378F0AD7558B96DAFAED79D3BD1833BBF5B85E23CBE0E89549312B8EDFE5DB8E1F6ADE809E8B7C52FD361C3C211D5185C94ADA43ECD6A81C57AFC45C46B77B6E2D1773760577B42039D160023A494CDBDFD855E070042082BA2490826F5AB69C7E176D870FEC43A54177812513D25B9D7D6EFC063EF6F4430ACDF8745BED78A3FDC548953A7EA7A4437514ADBBE2788F3BFB7094FBFAE24974DAFD5177B71E6886AB8EDD6B8EB1222F6ADBF0FDBCCC31189FF7CB215CFACDC92C8CFB157004C9352F66A9F625F02801F03E8F33D86DE28CECEC08593EB91EBE6BD573ABADDEDDDB8EF8D35D8B237A127647EC197CEC8C7CFAF2987DBC5DB5144F178F485565C72F3A76869D36F1FBDCDA261FE900A8CAF2A50529F66D160B1F53F88D8D3D1833FBCB4027B3A7A94B4E7086E91527EB3373FD8AB004008311AC09B48C0E1410DBE5C9CD5540B472FA65188C21189A7576CC6F3AB9B755D30545BE1C43D3757616C835BBF8B12A5888EAE08AEFED916FCF11F09BF177E8832AF1B4B46D5203F53C1974B0158AC9F2FF48B47873F883FFE7765A2BECC44008C9352BE73BC1F3C6E00103B81E83500E3D4B4ED73D3069762FEF02AEEE7A73EDBB87B3FEE7B630DF6E9B7D506568BC0F7BE5C821BCE2F668649A25E7AE3E34E9C7DD346ACDBA2DF7B550860DAC012CC1C5CAAE4BD2A340D169BE5880BFDFACB1F0AE3AE575763CD8E5665751EE44D0013A494C7BCD7D09B00E04B00FE9FC286C1A2092C1A331063AAB8D29AFAAF2718C6DFDE5D8F773FDDADEB75278FC8C45F7E508D2A5FDF938610A58B7044E2877FDC81FFF9C37684C2FA4DD7795D762C195583AA3C35C9BD2C560BB404CD508723120FBCB536519F615F9652FEEE583F70CC002096E7FF1300CA32F008015C38B901F52539AAAAA43467C479021E77F43C8173E6F13C01A2C36DD8EAC739376DC2AB1FEABB5EE7401E7F15B794FBB3D0AF3F2480273FD884173FD9AABAEABD00061FEBBC80E30500BF0770B1CA162D68ACC2B4C1A52AAB248A9E27F0C65AACDFADEF79024B4E8C9E27E0CDE21A162200B8EB89167CF527E6CDE3DF1B9AC5028B4DDFF7F473AB9AF1AF8F3E555DED1FA494971CED1F8F1A0008210602580D40D9B330A6AA104BC70D52551DD121A2E70934E3A98F37EB7A9E407951F43C81E963789E00A5AF64CCE3FF0542C06AB3401874B8DCDDAFAEC687CD2D2AAB0C03A89352AE3BD23F1E2B00F823800B55B5A2322F0B974E1FCA53FB28E18C384F40D3A2E709DC7C29CF13A0F4930A79FC352DB6BDCFC0B76F4F308C5F3CF33E5AD46E11FC9394F2A223FDC311030021440580750094A441F3663870D5AC46643999558DF4110C47F0F8079BF0AA01E709DCF7C36AD45733A705A5BE54CCE36FB4ADFB3A71FB731F221451962C280860A09472F3E1FF70B400E0D7002E5371659B45C3153386A33487FBA7497F469C27E07268F8E95565B87CB19AC4234466B4624337967F2B75F3F81BE9B5F53BF0C83BEB5556F91B29E5E587FFCF2F0400428812001B0138545C75E9B841DCEE478632EA3C81932666E3CEEF55A22897335F943AA4046E7F6017AEBF2D3DF2F81BE5DED7D7E0BDCDCAB607FA01544B290F99123D52087509140DFEE5B99918CDC19F0C96E9B0E1C2C9F53873F4005D4F97FCD7AB6D18B664251E7F49DF9D094489B27D4F10275DB91657FDEF165D07FFFA622FAE9E3E54C9E02F8480D56E33F5E00F000BC70C4041964B55750E44C7F6431C6906602D80812AAE78E9B4A11850A8265A235261777B37EE7D7D0D9AF7E9BB3FF9CB6714E0E75F2B4386D31CF71989FAEAEF2FB6E2E2FF49EF3CFE7A5BBD631FFEF0D24A55D5AD93521EB20DEF90004008D18468DADFB8D597E4E0A2131A545445A4543822F1EF159BF18201E709DC7B7335C634A859B844A487CEEE681EFF3FFC5DDF3CFEA5B13CFE0526CBE3AFB7DB9EFD009BD59D1930414AF9FA81FF38FCD93847C5153421307F78958AAA8894B36802F38655E2B269C39093A1E46E57AFACD9DC838917AEC68FFEB403EA16F81225CE9B2B3A3162F94A5D077F218069834A70E9E47A2583BFD03458EDB6A41CFC0160F6900A95D51D32C67F36032084B003D80620EEDCA6E3AA8BB078AC92BB08440965D47902278C8C9E275059C2F304C87CC211891FFD69077EF07BE6F137835F3DFB81AA93035B00F8A49401E0D0198013A160F0B75934CC19AA3462214A18A7CD82E5E36B7156532D5C3ADE1BFCEF7B1D18BE7425EEF9A7BE3B13888E67E3363FA65CBC06DFF9ED365D07FF116579B86ADA502583FF81857EA930F803C0EC86725555E5213AD60338340098ADA2F6C9834AD4A46424D2D1C88A025C3B67040614E8B768757F6718E77C672396DDB811ADEDFAE54D273A9ABB9E6841E3D255BA1EE2E3B459B074F4002C195503A782FCFB9A4583D5614BF8213E7A6AF0E5A234275355759F8DF50707003354D43CBA92DBFE283979331CF8CAB4A1983FBC52C919E2BD75FFD37B317CE94AFCE7DD76DDAE4974B07DFBC3587CC3069CFFBD4DBA1EE2539D9785ABA70D5573888F10B0DAAD49B5CABF2F4E54370BF0D958AF018010A210C090786BCDCB74A258516A46222308014CAF2BC3953387A350DD1EDCE3DAB23380195F59831B6EDF8A6048C7AD0994F69E7BB31DC396AEC043CFEA77888F451398DB50864B26D6299931D6340D36BBCDB0437CF430A434175E358B9687C4C6FCCF6600A641C11108437D6A8E6224325A694E26AE397104260E2CD1ED9A910870EB5D3B30FEBCD558B551E96120445FE00F485CF7CB66CCBE7C8DAE87F814643A71D9090D983A50CD213E169B1516BBB187F8E8A5B6C8ABA21A81E898FF5900A064FA7F6869DC6B08894CC366D170C6A81A5C744203321DFAA5F37DEF932E8C3E7B157EF390BE3B13287DACD8D08DF1E7AFC2CFEED1F7109FA6AA427C75EA102587F8084DC0CDBD4F930000200049444154EA48DEED7DFD31B858490000C4C6FC03CFDCC4786B733B6CA8CAF7C45B0D91E9D497E4E0BAB923D1A0E30C57B73F82CB6FDD8CF957ADC3CEBDFA7D3BA3D4262570DBFDBB30E6ECD5F8608D7E87F8643A6C387F7C2D4E1D5EA9241DB766B5C06AB799EE109F441B54E455326B82D898AF09213400838EF3C3C7D5E0CB51D53022D331EA3C817FBED286E14B57E289FFF23C018A8F5179FCEB8ABCB86ADA90B4CAE39F2819762BCAD4EC06182484D02C00AA005C1B6F6D738656E8BA688AC808E5B999682CCFC7A72DEDD8DF13D0E59A9DDD11FCF5DF7BB1B325841963B360B332D2A6BEF9FB8BAD9877E53A7CB44EBF6FFD368B8653865560FED00AD8150CD89A454BCB6FFD87DBD7E9C7C63DFBE3ADC60AE02E0B80260067C75593A661D19881BA6E9D22328ADB61C3D8EA224422129B5AE27E23F6DADBABBAF0C873AD98303C13BE021E314CC7D7D91DBD9574FD6D5BD1D5A3DFB7FE52AF1B174E188C5A1587C189D842BF34FDD67F384D13787BD32E15553D6501301FC0DC786AC9753B3175B04F4583889282260406157931B0D08BB5BBDAD013D467EF744B5B08773EDE02AB45605263266FBBD151BDB9A213275EBE16CFBEA95F7E890379FC978CAA51B2705668B18C7E29BCBDAFAFB25D0EFC77CD36842371AFDE7CDB02E03C0063E3A9A524DB8DB1D54C0044E927C7EDC0B8EA22ECEBF263475B972ED78C4480E7DE6AC78BEFB463C6180FBC59FC66449F0B47247EF8C71D38EFBB9BB0A755BFA37BBD2E3BCE1B3708632A0AA029884C2D560B2C366BDA4FF91F4E13022BB6ED455B77DCB720375A005C0AA0369E5A2AF3B230BC3C3FDEC6102525AB45C3F0B23C1464B9B076672B42F147E6BDF2E9F600EE7CBC0515C5760C1BC8F53714CDE37FF2D5EB71F7932DD0E96508209AC7FFBCF1B5C857717ADF813CFE69B4BDAFAF3E6ADE833D1D71E70AD9A50188FBE4852C871560F2324A73232B0A70DD9C91A829D06F3B6C5B4718677D7B23967F6B23DA3A789E403A631EFF342101A79AF510594A02008FC3867048BFA92622B3F2663870E9B46198A7F379027FFD77F43C8197DED5EFC39FCCC1C83CFE57318FBFEEC2A11032D43C4F591600D70188AB07475714A028D309210423374A7B4200D5F91E3494E460C3EEFDE80CE8131CB7758471F7932DE8F14B4C1D95C55D3969E0F9B7DA31E78AB578FDA34EDDAE69D104E6D497E18CC66AB8147CEB179A069BDD9AD279FC558984238884C2D8D2DA818D2D712FEEEC543303E08CAEF60C07439011FDB69A1099D967E7090C28D6ED9A910870CB9F77A0E9FCD558BD89E709A4AA40309AC77FD6656BD0BC4B9F7C144062F2F85BED56703BCBF1C94804E160F4CB84CA1980EF03886BBFC6F45A1F32ECD10645C21168168D2B378910FDB654EFCB45594E26D6EE6C4320AC4F80BC7D4F10773ED6825C8F15631BDCBA5C93F4B16243374EBA722D1E7DA155D7EB365515E2ECB103E155707A1FB7F7F58D9412A1836612F774FAB1627BDCA7376A1A80B8CF1774580FEDC4702004A9E709134426D7E0CBC5757347A2BE2447B76B76F54470D92D9B71F235EBB06B2FD7E8243B23F3F89F377E10F3F81B444A89F061B71115CD00382C00BE0620AEBD1B23CBF3907558D2071991D02C96B438A291A837EC560B46551620D369C7BA5D6D88E81424AFD9ECC7DD4FB6A0A1DA85DA8AF8B76991FE76B404B1E8FA0DB8E3C1DD0885F5FB725557E4C5054DB5F065C73F8BC4ED7DFD208FFC85BADD1FC43B5BF6C45B7BBB05C06500E2CAD7585F9C837CF7173F58A48C44830022FA4C796E268697E763534B3BDA753C4FE0BEA7F662D75E9E27906CFEFE622B4E621EFFB4140A068F389BBE655F273E8EFF16C06E0D40DC4B098FF621262312A14010BA1E384D94040AB35CB872E670CCA82BD375FDD3FF3DBC1BA3CE5A857757EB93B590FAAFB33B824B6EFE14A75FB75ED78C7EA55E37BE3A7508C657A9C9EE6AB1717B5F9FC9E8D8298F92CD695FB75FC555DA2D00CE0550164F2D655E37AAF38EB29940460301C18581448738709EC080C26CACD3F13C813DAD21DCF9580BEC368189C3799E8019BDB9A21373AE588B67DF601EFF7473E09EFFB1D6D1BDDFDC82ADAD7107F11B94CC001CEF5854292542FE2022DC2248F405030AB271DD9C91185951A0DB358321891B6EDF8A195F5983CD3BF4DB4646C7168E48DCFCC7ED9874E12758BB59C9B7BC5EF1BAECB864621DE6D49729C91F61E142BF7E89442208F98F3CED7FB07D5D4ADEB3ED16000B000C89A7168FD38EC6D2BCE3FE9C0C472000267C203A8CA1E7093CD682CA129E2760B48DDBFC38E59AF5B8EB0963F2F817308FBFA122A130C2BD9C057C61CD3674C59F60EC6D0B801100A6C4538BC36AC1B8CADE7D7B91110948C91708D1119464BB31B2B2005BF775605F973EDF00FD0189479E6FC5BA2D7ECC1CE781D3CEF7A6DEEE7EB205A75CB31EEB9AF5FBD6EFB459B070640D660EF6C1AA627B1F17FAF55B381842A497394224807FAD6856B18BE8EF1A80D5F1D672BC5B00878B8463D31CBC2540F4053907CE1318A6EF7902F7FE6B2F1A97ADC47FDFE379027AD9B73F8C25DFDC80F3BECB3CFEE948C6A6FC7B3BF80340474F10213563E76A0BA289802E89A79640288251E5F970F5F10510094700292134C1A891E8204200D5051ED497E460FDEEFD2AA6FB7AA5AD238CBB9E6C813F203185E70924D4813CFEAFE99CC7FFC43AE6F1379A94323AE51FEA7BD0B7B3BD1B6F6F8E3B070000DC6201D009E086786BCA71D951919BD9E7DF935222C2B5014447E471D931BEA6085D81109AF7E9F3CD5C4AE0E5F73BF0CF57DA30757416F2BDFC66A752202871C31D5B71E98F37637FA77EDFFA0B329DB8A0693086F97295E5F1B7D82CCCE3DF47D17BFDFDCF96FBFED616ACDBBD5F4553BEAE4929DB00EC88B7A6153BE2CB4B1D0E85B95380E8086C160D678E1E800B27D72BD99ED55BEFACEAC2A8B356E1B78FECD6ED9AA96EC5866E8C3B6F15FEF72F3B754D8FD2545588AF4E1D025F7646DC75094DC0EAE042BFBE3AB0C2BF3FDFFA0FF6E1D6BD2A9AB3434AD976A0073F8AB7B6CD7B3BE23EF6F4C0FEC7BEDE13214A070DBE5C5C3B47FFF3042EFDF1669CF2B575D8BD8FE709F49794C0ED0F308F7F3A3AB0E64DC519392D9D7E6C6B5392C4EB230038F08A7821DEDA225262559CB300074829110E8610EC09C4355542946AB29C365C744203CE1855A3E403BDB71E7FA90DC396ACC43F5F69D3ED9AA962474B10F3AE5A8B2B7FBA053D01FDBED8D4157971D5B421A82BF2C65DD781ED7D16056981D341A2C6B08FB72BF9F60FC4C67C65010000ACFCFFEDDD7978D5D59DC7F1F7B95908CA12C025800A0A0882808816C79DD62AB58ED4D6515AB7DA3A6AADD6B1CBB463ED62EB32FAD43A15473B566BDDEA3256AB45C4B180E2525764D1100890809184259095DCDCEDCC1FF70621262437F7DCDFFD25BFCFEB79AE68B8F77B8E8FF29CEF3DE7FCBEDF9A8C6B137F465BF6148B685740A4CDF1638773DDE94731728877AD7E376F8FF2E56BD7F2DDDB36D2D2AA3F8BDDF1DCAB754C3EBF94056F3A39B3ED9682BC10B3A78CE29219E39C1C1985F242E4F72BC0E842689712F104B148346BBBD88EB6FF21B5E61B6B2DC6987C603BD0493DDFEE29C80B71C3AC691466F99B8909194C288409194226A48E831258F18465C1871B79657595A767CA471C5AC463371DCAB4F1999F29F745CD2D09AEFBEDC7FCE15927B7B5BB6DC4E07D98337D8C93A23E90BCE8A7B3FE4E5848D8043661B18944A775FB5DA96D6EE5370B57B808D5080CB5D6C64200D6DA18B024D3A8D17882F22DD9DF22B489D423149118D1D648F27C255548C1266C72BB45A70612007921C397A78CE2CA538FA4789F7E9E8DBBAA22CC71DF2CE3F6876BD0BDDD3DBD5BDACCB40B4A3D5DFCDBEAF85F75D2443715FD74D1EF5336B9A56F13C927D6E2D1E43DB5686B847824462216CFFAE20F4EB7FF97A4D6FCE40E008031E6FBC01D99463E64C800BE73D211998671C78049FE451757A44F6B89C6F9EBB20A9655D57A3AEEA9D307F2F0AF4673F081859E8EEB37F184E5D6076BB8F1BE6A6271EFBE8114F72FE4BCA30FEBBC215B9A825E97A5ED0BA4C55F5F24EF7AF523AADD5C00FC81B5F6B7B067023016287711FDC263C732C9C39BCA22F2A96555B53CB7728367DD05018A07E671EF7F1CC29CD31D5496EB852A36B572D1CF2A7963B9B755148F3A6818B3278FA2C841511FF1AF8FAA77F0E8BB6B5D851B67AD5D0BBB250000C6987F00C7651A7DFF0145FCDBCC230905388B14C9A5BA96084F2E5D4F65AD77ED64012E3C7328FFFDE34318B46F7016A4875FA8E59ADB3FF6B4A84F51411EB3278FE2A883BA6EC226BD5B3C61B973F14A6A9B9DF48978CB5AFB4F6DFFD0FE80E71117236C6D0AF3EE06150F11C995E2FE855CEEB0BD6B773D3A7F3B53E694F2FAB2BEDF4F60F73AFE5E2EFE6D75FCB5F807C31BEB37BB5AFCA1DD1ADF7E076018B009C8F8306F60BF027E78DA94AC3F1120227BF7495D334F2E5DCFD6A6B067638642F0936F96F0CBCB475090DFF7760217BDDBC825BFA8A46A8B93BEECDD9217329C367E24A78C1DAEEABB01D11C89F19B852B5C1DE7458011D6DA5D9784F6589D53BF31DFC5488DAD515E5B9B71856111C9D0C8E27DB9E69449CC18DDBD96DD2E241270CB1F6B38FE5B65ACD9E85DE2916D91A8E547BFABE2B4ABD678BAF8EF3FA088AB4E9AC8A9E3B4F807C9CB65552EEFF2CCDF7DF187CF1E0100FCC9D568AFADABA1A935EA2A9C88F450415E88AF4C19CDC59F1BC7BE85DE35F779AF7427D3BEB18AFB9EF1F679F86C285D1FEEF575FCA5F7A86968E1DD0D4EFFDCFCA9FD0F4CFB128526F9FCC787C04417234E1A3E840B8E1DAB5A3D223ED1D41AE5E96515ACDEEC6D59DFB34F2EE6FE9F8D62FF21BDAFBBE0DC27B7F0EFBFFBC4D352BE03FA15F0B5A3463B29E52BBD8B051E787335EBB639AB20590A1C69DB2DF89F4900008C3117008FBA1A79E6E123387DC24857E144C4817F546CE1C5D28F897A5862FBC0A1053CF8CB517CE9F8C19E8D99899ADA2897DE58E969295F48D6F1FFDA51A33DEDFE28FEF172D9272C5AB3C965C80BADB58FB5FF616709401E50068C7535FA9CE963983A3298CF088BF8D596C6169E5CBADE5587B16EBBFABC03B8FDDA91F4EFE7DF4BC2CFBD5AC765BFDEC0B63AEFBA2016E4853873D2C11C37FA00CFC6147FF9A0AA96A796AE7719722D30C15AFB99CB041D260000C6986F03F7BB9A417E28C4E5274CE0600F9B978848D7E209CBFF957DC26BEBAA3D3DDB9E7858B29FC05187FBEB6CBBAFD4F197DE67C3F626EE7FB38C98DBD2C297596B1FE8E837F696001490AC0C38CAD52C06161570F5C913195414EC92A1227EB47E5B234F7DB09EFA16EF6EB71716186EFACE487E70E181847CB019F06E693317DC5041F94667CF5D77C9183865EC704E1B3FD2D39A0DE22FDB77B672CF92529A234E779C3690ACFCD7E16DFC4E13000063CCD780A75DCE66C4E07DB8F2C4233CED652E22DD138EC6F9EB8A4A96BB6B3BDA2D338F49F61338E880DC7C39E82B75FCA5770A47E3DCFBFA2AB634B6B80E7DAEB5F62F9DFDE65E13000063CC02E00C97333AA2A498AF4F1FA32440C4A73EA8AAE5B9151B688D7957E16EC8A03CEEFDC928CE3FDDDB3E22959B225CF8B30ACFEBF84F1D3994AF4C19AD3AFE01174F581E7A7B0DE55B9D5F347DC95A3B6B6F6FE84E02300E580938ED353A62F03E5C32639C8E03447CAAAE25C293EFAFA372BBB70BE345670EE3EE1F1FEC493F8147E6D772F56DAAE32FB9D11C89F1D8BB6BA970DFB3A315986CADDD6B83BF2E13000063CCAF811B1C4D6C978145055C74EC385D0C14F1296BE195B5D52C5CFD09710F7A9EB7193DA290477F7D28274C1D9095F83B1AE25C79EB069E7A794756E277E6D0610339EFE8C328EEAF2F3E41B7A97E278FBC534E5D76EEDCDC64ADFD59576FEA6E02D09FE42EC0180713DB437E28C4B9D30ED52382223E5695EA27B0CDC37E02792193EC2770C570F2F3DC5D8E5BFC5E2317FF5C75FC25779655D5F2CCF2CA6CD5E05847F2DB7F97170ABA95000018638E01DEC041A3A08ECC3C7C045F9C30521503457C2A1A4FF0C2471B79BBD2DB4E9FC74EDC97C76E3A94718764760A19895A7E7ACF27DCF1A8B7A57CF71F50C4F9471FC6C862ED74065DC25A5E2CADE2F57559EB9313014EB0D6BED79D37773B010030C67C0FF85D0F27D6A549C387F09529A354FD4AC4C756D5D4F1976515AE1F57DAAB7DFB87B8F3FB07F3AFE7ECD7A3CF97AE0F73C10D152C5BE36DC1A319A30FE0CB930ED68567616724C6E3EFAF63ADFBCB7EBBBBD65A7B5777DF9C560200608C79063827DD597557BFFC3C4E1A53C249634BD44A58C4A79A5AA33CFD4105ABB778DB4F60F629C97E02FB1577BF9FC0DD4F6DE147FFA53AFE921BD17882372B36F36A790D2DD1AC26CDCF5A6BBF9ACE077A920014031F00A3D3FA609A06F62BE00BE34772ECA8FD08E9D04CC49772D14FA06458010FFE6234B38E1FB4D7F7A98EBFE4523C61796FE35616AED9446338EB5D712B8169D6DABA743E94760200608C9906BC0A64BD7AC5FE038A38E388839834DCDB678345A47BB634B6F0C4D2F5547BDC4FE09AF393FD048A0A3FBB53A83AFE922B16585E55CBDF577F426DB32715251B8153ACB51FA4FBC11E250000C6982F00F3C9D2A5C0F60E19328093C79630EE80C13A1A10F199643F812A5E5B57E3793F813FDF7418530FEF0F24EBF87FFFCE8FB9EF19D5F1176F45E309566FA967E1EA4DD43478960C478033ADB50B7BF2E11E270000C6987F019E003C5B910BF2428CDD7F10134B8670444931FB16F6BEDEE2227D55AEFA09DC7CD5484E9A36808B7EEE7D1DFF93C70CE78B1354C73F889A2331CA6AEA28ADD941F9D6064F8FC2800430C75AFBBF3D0D90510200608CF90E704F46417A28640CA3860E6062C910260E2F66E83E4E8B158A480F84A3719E5D51C90A8FFB09784D75FC83696B539855353B28ADA963E38E264F77BCDAB9CA5A7B6F2601324E00008C31D70337671C2843038B0A185454C8A0A282D42BF9F703DB7EED5740BE1F5A8E8904C0D2AA6DBCF85115B184A7DF8A3C31FEC0C1CC9E3C8AFE05DA81EC4B6289048DAD511AC2511AC3511AC291D4AF511A5B23D4B74468C8FE85BEEEF8A9B5F6964C8338490060D74EC0DD78781C202222122009E0EA4CBFF9B7719600C0AE3B018FE2D1C540111191808800176672E6DF9ED30400763D1DF02C1E3C2228222212008DC0393DBDEDDF19E7DBF5A9099E42B23081888888F45C25C9E7FC9D2EFE90A5F3FA54418269247702444444247DCF92ACF09776919FEEC8DA853D6B6D5DAA2EF1B524CF2E444444A46B11928D7DBE9A6E79DF7438BF03D0E120C956C24F0063B23E98888848EFB58E64819F6EB5F4CD84278FECA5FE4526033701DE95E9121111E91D5A49AE9193BD58FCC1A31D803D0634661C301738C3D381454444FCE925E01A6B6DB997837A5EB4C75A5B6EAD9D059C0B6CF07A7C1111119FD8009C6BAD9DE5F5E20F39ACDA67ADFD0B300EB80C589BAB79888888786C2DC9B56F5C6A2DCC09CF8F003A9C843179C01CE07A60628EA7232222920DA5C02DC013D6DA78AE27E38B04A08D31C600670397025F4225854544A4778B002F020F02CF5B1F2DBABE4A0076678C19069C0F5C041C97E3E9888888A4E32DE011E0496B6D6DAE27D311DF2600BB33C68C25B933F079E064D467404444FCA51158022C22F94DDFF777DB7A4502B03B634C3E700C3033F59A0C94E474522222123435C04A6071EAF59EB53696DB29A5A7D725001D31C60C060E07C60313483E5D3094E44E41DB6B103000C8CBD1344544C4DFE24013D040F21B7DDB6B3B500E9401AB8135D6DAFA5C4DD2953E9100888888487A72560740444444724709808888480029011011110920250022222201A404404444248094008888880490120011119100520220222212404A00444444024809808888480029011011110920250022222201A40440444424809400888888049012001111910052022022221240F9ED7F608C09016702C701C7025381228FE7252222223D17069603EF026F01F3ADB589DDDF60ACB59FFE833163810781133D9CA488888864D7EBC0A5D6DAB56D3FD87504608CB98864B6A0C55F4444A46F3911589E5AEB81D40E80316622B014E897B3A989888848B6B502475B6B4B43C6987CE021B4F88B8888F475FD80878C31F979C085C077733C21111111F1C608605D089891EB9988888888A7668480E9B99E85888888786ABA015AD073FE22222241123680EDF26D222222D2A7A814B08888480029011011110920250022222201A40440444424809400888888049012001111910052022022221240F92E82BC71E37406F6CF73114A4444FC22124DBEC4571AC3714EB87D55C6719C2400070DEBC7E07D9C84121111BF680D41ABC9F52CA49DFA96B893383A021011110920250022222201A404404444248094008888880490120011119100520220222212404A00444444024809808888480029011011110920250022222201A404404444248094008888880490120011119100520220222212404A00444444024809808888480029011011110920250022222201A404404444248094008888880490120011119100520220222212404A00444444024809808888480029011011110920250022222201A404404444248094008888880490120011119100520220222212404A004444440248098088884800858078A6412231EB602A222222D29548DCC99A1B0F014D9946D95C1F713017111111E9CAE6FAA88B304D21A021D328D575AD0EE6222222BE62B5BBEB47D50D4E12808610D09869949A3AED008888F4395AFF7DA9C6CD0E40A39304A05A098088481FA40CC08FAADD1CBB3B4A0076E8084044A4CFD111802F553BDC01D89E6914ED008888F4410925007EE42801D81E02CA338D52A34B8022227D4F2291EB1948076ADC5C022C0F01659946A9D9A11D0011913E458BBF6F39BA0458160256671AA5A63E42E5D6B083F98888882FC49500F851656DABAB1D80D521608D8B482F2CDDE6228C8888F88176007CE98595F5AE42AD09596BEB819A4C23CDFBA0D6C17C4444C417E2195789972C98B7A2CE45981A6B6D7D5B33A09599467B676D03DB1A9D6C4B888848AEC59400F8CDB6A618EF5436BB08B5123EED06B838D368F18465C132ED028888F47A5AFC7D69C147F5C4DD3C9AB9181C2600A0630011913E41DBFFBEE468FB1FDA2500EFE1A022E02BA53BD8D9AAFF7144447AB5582CD7339076764612BCB226E3651A926BFD7B904A00ACB5316049A651C391040B3FDC9169181111C99544428F00FAD0C2B206C25127FF5D96A4D6FC5D3B00008B5C449EBBA0CA45181111C985A8BEFDFBD1DC459B5D85DAB5D6EF9E003CEF22F23BEB1A98A79A002222BD53544F73F9CDBC1575AE6EFFC36E6BFDAE04C05ABB1678C345F41B9FAE20A626122222BD4B3CAE06403E134B586E9CB7C955B837526B3DB0E70E00C0432E4628AF69E1E12519D7161211112F45F4EDDF6F1E79AB96F22DCE4AEDEFB1C6B74F009E025A5C8C72DB731BF4448088486F118FEBFCDF67764612FCE7826A57E15A48AEF1BBEC9100A4CA023FE762A4CDF511E6BEA40B812222BD42585D5DFD66EEE2CD6C76D3F807E0B9D41ABF4BFB1D0080075C8D367741155BDD4D5E4444B2211657F11F9FD9DA1463EEA22D2E437E666DFF4C0260ADFD3BF0BE8BD19AC271AE7BB81CAB3B252222FE156ECDF50C6437D6C2754F6DA4C9DD31FAFBA9B57D0F1DED0000DCE26AD4794BB771F3B395AEC28988884BD1A85AFFFACCCDF337B92CFB0B9DACE9C676F0F5DC1863808F80235C8D7EFF15133877C601AEC28988880B4DCD7AF4CF479E5EBA83CB1EAE7019721530C976B0D877B803907AE3AD2E6770F51FD7F07E85933AC62222E24224A2C5DF47DEDFD8CCD58F6F701DF6D68E167FE8640700C018930FAC060E73358B92C1852CFEF934860FE9E72AA48888F484B5D0B4135DD2F287EAFA2833EF28A3C6EDC5F9F5C0F8B6DAFFED757607A0AD41D0752E6752531F61CE5D1FD112D1799388484EB5B46AF1F789964882397F58E77AF107B8AEB3C51FF6920000586B9F07FEE67236CB373471E9EF5729091011C99570442D7F7DA22592E0D2872A585EB5D375E8BFA5D6F04E757A04B0EB0DC68C064A81FECEA6054C1D358027BE3749C70122225E8AC6A0C5596959C940757D94397F58978DC5BF059868ADADDCDB9BF6BA0300900A70B39B397D6AF9862666FEEA035D0C1411F14A3CAEC5DF27DEDFD8CCCC3BCAB2B1F803DCDCD5E20FDDD8010030C61402CB810999CF6B4F450521EEFED6E17A445044249B12169A75E9CF0F9E5EBA83AB1FDF40389A95A3F03260AAB5B6CBDACEDD4A00008C315380B781A2CCE6D6B11F9E75083F3D6734C66423BA8848805960E74E88EBEE552E599B2CF2F39B97B3D62D370CCCB0D6AEE8CE9BBB9D000018632E07FEA78713EBD25947EFC79D178F63FF4105D91A424424785AC2EAF497635B9B625CF7D446D715FEDABBC25A7B5F77DF9C560200608C791C9893EEACBA6B40511ED7CC3A886BCE38887DFAE5656B1811916008B742444DD972656724C1DCC59B99BB688BCBDAFE1D79C25AFBF5743ED093046020C96641E3D2FA609A0E1C5CC84F668FE2A2934BC80FE95C4044242D1608EB9B7FAEC4129687FF51CB6D2F55BB6CE9DB997260BAB536AD5BF569270000C6982381D781C1697F384DE34AFAF38B730FE5ACA3F7CBF65022227D43C2424B8BCEFC7364DE8A3A6E9CB789F22D9E3C71510F9C68ADFD30DD0FF628010030C69C0CBC44962E05B6F7B93183B866D6417CE1C8213A1A1011E94C3C0E3BC3BAEDEFB19D91040BCB1A98BB6833EF54367B356C1838C35ABBA4271FEE710200608C3907789A6ED41370A5A830C4A9138770D6B461CC3A6A18FB0DD48541111140457E3CB6AD29C6828FEA99B7A28E57D63466EBB1BECE248073ADB5CFF634404609008031E60AE0F71905E9A1BC9061C6D8419C75F47E9C396D18A3F7F764334244C47F74D9CF1395B5ADCC5F59CFBC9575BC5DD14C3C77DD14AFB4D666F4545EC609008031E63F805B320E94A192C185940C29A4A4B81FC38B0B193E24F96B497121C38BFB71E0E0420AF375A15044FA106B938B7F2CAB37CC032112B76CAE8F52DD10A5A63E4A757D84EAFA28D5F5516A523FCB42C39E9EB8DE5A7B6BA6419C2400B06B27E01E3C3C0E1011110990047055A6DFFCDB384B0060D79D803FE3D1C540111191800803DFC8E4CCBF3DA70900EC7A3AE0793C78445044442400EA81B37B7ADBBF33CEB7EB53133C91646102111111E9B97292CFF93B5DFC214BE7F5A98204D38127B2115F444424009E2059E12FED223FDD91B50B7BD6DAC6545DE22B489E5D88888848D7C2241BFB7C3DDDF2BEE9707E07A0C34192AD849F0426647D301111912C8F8DE60000016449444154DEAB0C38BFBB2D7D33E1C9237BA97F91A9C00D408B17638A8888F4222D24D7C8A95E2CFEE0D10EC01E031A331AB80BF8674F07161111F1A7BF01DFB3D6567A39A8E7457BACB595D6DAB381D9C07AAFC7171111F189F5C06C6BEDD95E2FFE90C3AA7DD6DAE781F1C0C5C0AA5CCD434444C463AB48AE7DE3536B614E787E04D0E1248C31C039C0F5241F1F141111E96BDE27D937E759EB83C5D71709C0EE8C31A701DF267944D03FC7D3111111C94418F82BF080B5F6EFB99ECCEE7C9700B431C60C06CE032E014EC8F174444444D2F106F010F094B5B63ED793E9886F1380DD1963C60267039F074E0606E676462222227B680496008B80E7ADB56B733C9F2EF58A046077C6987CE0186066EA351928C9E9A4444424686A8095C0E2D4EB3D6B6D2CB7534A4FAF4B003A923A2E389CE45305138071C050923B056DAF41C000202F47D31411117F8B034D4003C96FF46DAFED249BF29401AB81357EDDD64FC7FF0325C94ED8098327850000000049454E44AE426082', 1);

-- Testdaten fÃ¼r Table: Product
INSERT INTO tblproduct (szName, nEnergy, rPrice, nImageLink) VALUES 
('Quinoa Bowl with Avocado', 300, 6.99, 1),
('Grilled Chicken Breast', 201, 7.49, NULL),
('Vegan Wrap with Hummus', 363, 5.99, NULL),
('Salmon with Broccoli',  241, 8.49, NULL),
('Salad with Feta and Walnuts', 743, 5.49, NULL);

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

-- Testdaten fÃ¼r Table: ProductIngredient (Zuordnung von Zutaten zu Produkten mit Mengenangaben)
INSERT INTO tblproductingredient (nIngredientLink, nProductLink, nQuantity) VALUES 
(1, 1, 100),  -- Quinoa Bowl with Avocado -> 100g Quinoa
(2, 1, 50),   -- Quinoa Bowl with Avocado -> 50g Avocado
(3, 2, 200),  -- Grilled Chicken Breast -> 200g Chicken Breast
(4, 3, 80),   -- Vegan Wrap with Hummus -> 80g Hummus
(9, 3, 1),    -- Vegan Wrap with Hummus -> 1 Whole Wheat Wrap
(5, 4, 150),  -- Salmon with Broccoli -> 150g Salmon
(6, 4, 100),  -- Salmon with Broccoli -> 100g Broccoli
(7, 5, 50),   -- Salad with Feta and Walnuts -> 50g Feta Cheese
(8, 5, 30),   -- Salad with Feta and Walnuts -> 30g Walnuts
(10, 5, 10);  -- Salad with Feta and Walnuts -> 10ml Olive Oil


-- Testdaten fÃ¼r Table: ProductMenu (Zuordnung von Produkten zu MenÃ¼s mit Mengenangaben)
INSERT INTO tblproductmenu (nProductLink, nMenuLink, nQuantity) VALUES 
(1, 1, 1),  -- Low-Carb Menu -> 1x Quinoa Bowl with Avocado
(4, 1, 1),  -- Low-Carb Menu -> 1x Salmon with Broccoli
(2, 2, 1),  -- Protein Power Menu -> 1x Grilled Chicken Breast
(4, 2, 1),  -- Protein Power Menu -> 1x Salmon with Broccoli
(1, 3, 1),  -- Vegan Fit Menu -> 1x Quinoa Bowl with Avocado
(3, 3, 1);  -- Vegan Fit Menu -> 1x Vegan Wrap with Hummus

-- Fertig: 02_CreateTestData_tblMenuProductIngredient.sql

