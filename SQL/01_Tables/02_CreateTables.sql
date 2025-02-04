USE dbcommitandforget;

-- Prüfen, ob die Tabelle tblBenutzer existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblBenutzer (
    nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName NVARCHAR(200) NOT NULL,
    szStrasse NVARCHAR(200) NOT NULL,
    nHausnummer INT NOT NULL,
    szPostleitzahl NVARCHAR(200) NOT NULL,
    szWohnort NVARCHAR(200) NOT NULL,
    szMail NVARCHAR(200) UNIQUE NOT NULL,
    szPasswort NVARCHAR(200) NOT NULL,
    bIsAdmin BIT DEFAULT 0
);
-- Prüfen, ob die Tabelle tblBild existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblBild (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    vbBild  LONGBLOB NOT NULL, 
    bFreigeschaltet BIT DEFAULT 0,
    dtErstelldatum DATE NOT NULL DEFAULT (CURDATE()),
    bContestGewonnen BIT DEFAULT 0
);

-- Prüfen, ob die Tabelle tblRating existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblRating (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    nRating INT NOT NULL,
    nBenutzerLink INT NOT NULL,
    nBildLink INT NOT NULL,
    
-- Fremdschlüssel-Definition
 CONSTRAINT fk_tblRating_Benutzer 
        FOREIGN KEY (nBenutzerLink) 
        REFERENCES tblBenutzer(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

CONSTRAINT fk_tblRating_Bild 
        FOREIGN KEY (nBildLink) 
        REFERENCES tblBild(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
); 

-- Prüfen, ob die Tabelle tblRechnung existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblRechnung (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    nRechnungsnummer INT NOT NULL,
    bBezahlt BIT DEFAULT 0,
    szBezahlart NVARCHAR(200) NOT NULL
);

-- Prüfen, ob die Tabelle tblBestellung existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblBestellung (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    dtBestelldatum  DATE NOT NULL DEFAULT (CURDATE()),
    nBenutzerLink INT NOT NULL,
    nRechnungLink INT NOT NULL,
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblBestellung_Benutzer 
        FOREIGN KEY (nBenutzerLink) 
        REFERENCES tblBenutzer(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

CONSTRAINT fk_tblBestellung_Rechnung 
        FOREIGN KEY (nRechnungLink) 
        REFERENCES tblRechnung(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Prüfen, ob die Tabelle tblProdukt existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblProdukt (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName  NVARCHAR(200) NOT NULL,
    rPreis DECIMAL(5,2) NOT NULL,
    nBildLink INT NOT NULL,
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblProdukt_Bild 
        FOREIGN KEY (nBildLink) 
        REFERENCES tblBild(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Prüfen, ob die Tabelle tblBestellungProdukt existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblBestellungPtodukt (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    nBestellungsLink INT NOT NULL,
    nProduktLink INT NOT NULL,
    nMenge INT NOT NULL,
    
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblBestellungProdukt_Bestellung 
        FOREIGN KEY (nBestellungsLink) 
        REFERENCES tblBestellung(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

CONSTRAINT fk_tblBestellungProdukt_Produkt 
        FOREIGN KEY (nProduktLink) 
        REFERENCES tblProdukt(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Prüfen, ob die Tabelle tblMenu existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblMenu (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName NVARCHAR(200) NOT NULL,
    rPreis DECIMAL(5,2) NOT NULL,
    nBildLink INT NOT NULL,
    
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblMenu_Bild
        FOREIGN KEY (nBildLink) 
        REFERENCES tblBild(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Prüfen, ob die Tabelle tblProduktMenu existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblProduktMenu (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    nProduktLink INT NOT NULL,
    nMenuLink INT NOT NULL,
    nMenge INT NOT NULL,
    
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblProduktMenu_Produkt 
        FOREIGN KEY (nProduktLink) 
        REFERENCES tblProdukt(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

CONSTRAINT fk_tblProduktMenu_Menu 
        FOREIGN KEY (nMenuLink) 
        REFERENCES tblMenu(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Prüfen, ob die Tabelle tblZutat existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblZutat (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    szName NVARCHAR(200) NOT NULL
);

-- Prüfen, ob die Tabelle tblProduktZutat existiert, falls nicht, dann erstellen
CREATE TABLE IF NOT EXISTS tblProduktZutat (
	nKey INT AUTO_INCREMENT PRIMARY KEY,
    nZutatLink  INT NOT NULL,
    nProduktLink INT NOT NULL,
    nMenge INT NOT NULL,
    
    
    -- Fremdschlüssel-Definition
 CONSTRAINT fk_tblProduktZutat_Zutat
        FOREIGN KEY (nZutatLink) 
        REFERENCES tblZutat(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

CONSTRAINT fk_tblProduktZutat_Produkt 
        FOREIGN KEY (nProduktLink) 
        REFERENCES tblProdukt(nKey) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);