USE sloppyjoes;

-- Quey to know how much orders have been served by the staff.
SELECT
	staff_id,
    COUNT(order_id) AS orders_served
FROM customer_orders
GROUP BY staff_id;


-- Since, we need to access this query on a regular basis, so instead of writing this query ober and over again, we can store it as a procedure and call it out when needed.
DELIMITER //
CREATE PROCEDURE sp_staffOrdersServed()
BEGIN
	SELECT
	staff_id,
    COUNT(order_id) AS orders_served
FROM customer_orders
GROUP BY staff_id;
END//

-- Change the delimiter back to ";"
DELIMITER ;

-- That's how we can call a procedure.
CALL sp_staffOrdersServed;

-- If we need to drop(delete) the procdure, we can use the below query.
DROP PROCEDURE IF EXISTS sp_staffOrdersServed;

-- Creating triggers, that automatically updates inventory table when there is a sale. Also, updates orders table when staff completes more orders.

USE thriftshop;

SELECT * FROM inventory;

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON customer_purchases
FOR EACH ROW
	UPDATE inventory
    SET number_in_stock = number_in_stock - 1
WHERE inventory_id = NEW.inventory_id;


INSERT INTO customer_purchases VALUES
(13,NULL,3,NULL),
(14,NULL,4,NULL);

INSERT INTO customer_purchases VALUES
(13,NULL,3,NULL),
(13,NULL,3,NULL);

USE sloppyjoes;
SELECT * FROM staff;
SELECT * FROM customer_orders;

CREATE TRIGGER NewOrdesUpdateOrdersServed
AFTER INSERT ON customer_orders
FOR EACH ROW
	UPDATE staff
    SET orders_served = orders_served + 1
WHERE staff_id = NEW.staff_id;

INSERT INTO customer_orders VALUES
(25,1,10.98),
(26,2,5.99),
(27,2,7.99),
(28,2,12.97);

DROP TRIGGER IF EXISTS NewOrdesUpdateOrdersServed;