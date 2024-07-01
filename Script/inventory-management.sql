CREATE DATABASE Inventory_Management;

USE Inventory_Management;

CREATE TABLE inventory(
	product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255),
    current_stock VARCHAR(255),
    sales_lastmonth INT,
    reorder_level INT,
    supplier_id INT,
    purchase_price DECIMAL(10, 2),
    selling_price DECIMAL(10, 2),
    last_restock_date DATE
);

INSERT INTO inventory (product_id, product_name, category, current_stock, sales_lastmonth, reorder_level, supplier_id, purchase_price, selling_price, last_restock_date) VALUES
(1, 'Widget A', 'Widgets', 150, 30, 50, 1, 20.50, 45.99, '2024-01-15'),
(2, 'Gadget B', 'Gadgets', 200, 60, 75, 2, 15.00, 35.50, '2024-02-20'),
(3, 'Thingamajig C', 'Thingamajigs', 80, 10, 20, 3, 12.75, 25.00, '2024-01-25'),
(4, 'Doohickey D', 'Doohickeys', 300, 50, 100, 4, 18.00, 40.00, '2024-02-10'),
(5, 'Whatchamacallit E', 'Whatchamacallits', 500, 120, 150, 5, 25.50, 55.00, '2024-03-05'),
(6, 'Widget F', 'Widgets', 700, 200, 250, 6, 30.00, 65.00, '2024-04-01'),
(7, 'Gadget G', 'Gadgets', 90, 15, 25, 7, 17.50, 37.50, '2024-01-18'),
(8, 'Thingamajig H', 'Thingamajigs', 120, 20, 30, 8, 10.25, 22.00, '2024-02-28'),
(9, 'Doohickey I', 'Doohickeys', 400, 70, 90, 9, 22.00, 48.00, '2024-03-15'),
(10, 'Whatchamacallit J', 'Whatchamacallits', 350, 80, 100, 10, 28.50, 60.00, '2024-01-20'),
(11, 'Widget K', 'Widgets', 150, 25, 35, 11, 16.50, 35.00, '2024-02-12'),
(12, 'Gadget L', 'Gadgets', 250, 40, 60, 12, 13.00, 30.00, '2024-03-10'),
(13, 'Thingamajig M', 'Thingamajigs', 300, 55, 70, 13, 14.75, 32.00, '2024-04-05'),
(14, 'Doohickey N', 'Doohickeys', 600, 100, 120, 14, 21.00, 45.00, '2024-01-25'),
(15, 'Whatchamacallit O', 'Whatchamacallits', 450, 90, 110, 15, 26.50, 55.50, '2024-02-18'),
(16, 'Widget P', 'Widgets', 120, 15, 25, 16, 18.50, 40.00, '2024-03-25'),
(17, 'Gadget Q', 'Gadgets', 350, 70, 90, 17, 20.00, 50.00, '2024-01-30'),
(18, 'Thingamajig R', 'Thingamajigs', 400, 60, 80, 18, 23.25, 52.00, '2024-02-20'),
(19, 'Doohickey S', 'Doohickeys', 250, 40, 55, 19, 19.50, 43.00, '2024-03-28'),
(20, 'Whatchamacallit T', 'Whatchamacallits', 550, 110, 130, 20, 27.50, 60.00, '2024-01-15'),
(21, 'Widget U', 'Widgets', 180, 20, 30, 21, 22.00, 48.00, '2024-02-10'),
(22, 'Gadget V', 'Gadgets', 230, 50, 60, 22, 14.00, 35.00, '2024-01-20');


SELECT category, SUM(current_stock) AS total_stock
FROM inventory
GROUP BY category;

-- Fast-moving products
SELECT product_name, sales_lastmonth
FROM inventory
WHERE sales_lastmonth > 50
ORDER BY sales_lastmonth DESC;

-- Slow-moving products
SELECT product_name, sales_lastmonth
FROM inventory
WHERE sales_lastmonth < 10
ORDER BY sales_lastmonth ASC;

SELECT product_name, current_stock, sales_lastmonth,
	   (current_stock - sales_lastmonth) AS predicted_stock_next_month
FROM inventory;

DELIMITER $$

CREATE PROCEDURE update_inventory(IN p_product_id INT, IN p_sold_units INT)
BEGIN
    DECLARE current_stock INT;
    DECLARE reorder_level INT;

    -- Fetch current stock and reorder level
    SELECT i.current_stock, i.reorder_level INTO current_stock, reorder_level
    FROM inventory i
    WHERE i.product_id = p_product_id;

    -- Update the current stock
    UPDATE inventory
    SET current_stock = current_stock - p_sold_units
    WHERE product_id = p_product_id;

    -- Check if the current stock is below the reorder level
    IF current_stock < reorder_level THEN
        -- Logic for reordering, e.g., insert a reorder request in a reorder table
        -- Add the necessary code for reordering here
        INSERT INTO reorder_requests (product_id, requested_quantity, request_date)
        VALUES (p_product_id, reorder_level - current_stock, NOW());
    END IF;
END $$

DELIMITER ;

SELECT * FROM inventory;