-- Testdaten für Table: Menu
INSERT INTO tblmenu (szName, rPrice) VALUES 
('Low-Carb Menu', 8.99),
('Protein Power Menu', 10.50),
('Vegan Fit Menu', 9.75);

-- Testdaten für Table: Product
INSERT INTO tblproduct (szName, nEnergy, rPrice, nImageLink) VALUES 
('Quinoa Bowl with Avocado', 300, 6.99, 1),
('Grilled Chicken Breast', 201, 7.49, NULL),
('Vegan Wrap with Hummus', 363, 5.99, NULL),
('Salmon with Broccoli',  241, 8.49, NULL),
('Salad with Feta and Walnuts', 743, 5.49, NULL);

-- Testdaten für Table: Ingredient
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

-- Testdaten für Table: ProductIngredient (Zuordnung von Zutaten zu Produkten mit Mengenangaben)
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


-- Testdaten für Table: ProductMenu (Zuordnung von Produkten zu Menüs mit Mengenangaben)
INSERT INTO tblproductmenu (nProductLink, nMenuLink, nQuantity) VALUES 
(1, 1, 1),  -- Low-Carb Menu -> 1x Quinoa Bowl with Avocado
(4, 1, 1),  -- Low-Carb Menu -> 1x Salmon with Broccoli
(2, 2, 1),  -- Protein Power Menu -> 1x Grilled Chicken Breast
(4, 2, 1),  -- Protein Power Menu -> 1x Salmon with Broccoli
(1, 3, 1),  -- Vegan Fit Menu -> 1x Quinoa Bowl with Avocado
(3, 3, 1);  -- Vegan Fit Menu -> 1x Vegan Wrap with Hummus
