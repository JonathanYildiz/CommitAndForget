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
