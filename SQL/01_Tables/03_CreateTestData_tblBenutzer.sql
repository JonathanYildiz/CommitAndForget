USE dbcommitandforget;

-- Testdaten für tblBenutzer einfügen
INSERT INTO tblBenutzer (szName, szStrasse, nHausnummer, szPostleitzahl, szWohnort, szMail, szPasswort, blsAdmin) 
VALUES 
('Max Mustermann', 'Hauptstraße', 12, '12345', 'Berlin', 'max@example.com', 'passwort123', 1),
('Anna Beispiel', 'Nebenstraße', 5, '54321', 'Hamburg', 'anna@example.com', 'geheim123', 0),
('Lukas Meyer', 'Dorfstraße', 33, '67890', 'München', 'lukas@example.com', 'securepass', 0),
('Lisa Schmidt', 'Bahnhofstraße', 21, '11111', 'Köln', 'lisa@example.com', 'meinPasswort', 0),
('Tom Bauer', 'Ringstraße', 7, '22222', 'Frankfurt', 'tom@example.com', 'passwort321', 1);
