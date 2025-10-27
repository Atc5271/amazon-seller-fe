-- MySQL-compatible sellers and sales schema + sample data (random-ish)
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS sellers;

CREATE TABLE sellers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  region VARCHAR(50)
);

CREATE TABLE sales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  seller_id INT,
  date DATE,
  quantity INT,
  price DECIMAL(10,2),
  returned BOOLEAN,
  FOREIGN KEY (seller_id) REFERENCES sellers(id)
);

INSERT INTO sellers (name, region) VALUES
('TechZone', 'North America'),
('GadgetHub', 'Europe'),
('EcoMart', 'Asia');

-- Insert ~100 rows per seller. MySQL doesn't have generate_series; use a simple procedure to populate.
DELIMITER $$
DROP PROCEDURE IF EXISTS seed_sales$$
CREATE PROCEDURE seed_sales()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE sid INT;
  WHILE i <= 100 DO
    SET sid = 1;
    WHILE sid <= 3 DO
      INSERT INTO sales (seller_id, date, quantity, price, returned)
      VALUES (
        sid,
        DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*30) DAY),
        FLOOR(RAND()*5)+1,
        ROUND(RAND()*100+20,2),
        (RAND() < 0.1)
      );
      SET sid = sid + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

CALL seed_sales();

-- Clean up: drop procedure
DROP PROCEDURE IF EXISTS seed_sales;
