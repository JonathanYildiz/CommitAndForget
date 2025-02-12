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

