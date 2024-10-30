-- Listar los usuarios que cumplen anios hoy con mas de 1500 ventas en enero 2020
SELECT C.first_name, C.last_name, COUNT(O.order_id) AS total_sales
FROM Customer C
JOIN Order O ON C.cus_id = O.customer_id
JOIN OrderItem OI ON O.order_id = OI.order_id
WHERE 
    EXTRACT(MONTH FROM C.birth_date) = EXTRACT(MONTH FROM CURRENT_DATE) 
    AND EXTRACT(DAY FROM C.birth_date) = EXTRACT(DAY FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM O.order_date) = 2020
    AND EXTRACT(MONTH FROM O.order_date) = 1
GROUP BY C.cus_id, C.first_name, C.last_name
HAVING COUNT(O.order_id) > 1500;

-- Top 5 de usuarios que mas vendieron en cada mes de 2020 en la categoria Celulares
SELECT 
    EXTRACT(YEAR FROM O.order_date) AS year,
    EXTRACT(MONTH FROM O.order_date) AS month,
    C.first_name,
    C.last_name,
    COUNT(O.order_id) AS sales_count,
    SUM(OI.quantity) AS total_items_sold,
    SUM(OI.quantity * OI.item_price) AS total_revenue
FROM Customer C
JOIN Order O ON C.cus_id = O.customer_id
JOIN OrderItem OI ON O.order_id = OI.order_id
JOIN Item I ON OI.item_id = I.item_id
JOIN Category Cat ON I.category_id = Cat.category_id
WHERE 
    EXTRACT(YEAR FROM O.order_date) = 2020
    AND Cat.name = 'Celulares'
GROUP BY year, month, C.cus_id, C.first_name, C.last_name
ORDER BY year, month, total_revenue DESC
LIMIT 5;

--Poblar una nueva tabla con el precio y estado de los items a fin del dia
--Primero creamos una tabla que contenga el status y precio del item al final del dia. Para que la tabla sea reprocesable guardaremos la fecha de registro
CREATE TABLE DailyItemStatus (
    item_id INT,
    record_date DATE,
    price DECIMAL,
    status ENUM('active', 'inactive'),
    PRIMARY KEY (item_id, record_date)
);
--Cambiamos el delimitador para indicar que finaliza el paso y no confundirlos dentro de la consulta
DELIMITER //

CREATE PROCEDURE PopulateDailyItemStatus(IN target_date DATE)
BEGIN
    REPLACE INTO DailyItemStatus (item_id, record_date, price, status)
    SELECT 
        item_id,
        target_date,
        price,
        status
    FROM 
        Item;
END //

DELIMITER ;
