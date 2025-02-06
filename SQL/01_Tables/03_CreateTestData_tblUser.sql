USE dbcommitandforget;

-- Testdaten für tblBenutzer einfügen
INSERT INTO tbluser (szFirstName, szLastName, szStreet, szHouseNumber, szPostalCode, szCity, szEmail, szPassword, bIsAdmin) 
VALUES 
('Max', 'Mustermann', 'Hauptstraße', '12', '12345', 'Berlin', 'max@example.com', 'passwort123', 1),
('Anna',  'Beispiel', 'Nebenstraße', '5A', '54321', 'Hamburg', 'anna@example.com', 'geheim123', 0),
('Lukas', 'Meyer', 'Dorfstraße', '33A', '67890', 'München', 'lukas@example.com', 'securepass', 0),
('Lisa',  'Schmidt', 'Bahnhofstraße', '33B', '11111', 'Köln', 'lisa@example.com', 'meinPasswort', 0),
('Tom',  'Bauer', 'Ringstraße', '7S', '22222', 'Frankfurt', 'tom@example.com', 'passwort321', 1);
