DROP PROCEDURE IF EXISTS list;
DELIMITER $$
CREATE PROCEDURE list()
BEGIN
	DECLARE a1 VARCHAR(16) DEFAULT "";
	DECLARE b1 VARCHAR(16) DEFAULT "";
	DECLARE a2 VARCHAR(16) DEFAULT "";
	DECLARE c1 CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME LIKE '%_options';
	DECLARE c2 CURSOR FOR SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME LIKE '%_users';
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQL EXCEPTION INVOKED';
	DECLARE table_not_found FOR 1051;
	DECLARE EXIT HANDLER FOR table_not_found SELECT 'Table Not FOUND';
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	SELECT IFNULL(table_schema, 'Total') "Database", DBCount FROM (SELECT COUNT(1) DBCount, table_schema FROM information_schema.tables where table_schema IN ('wordpress','%press','word%') GROUP BY table_schema WITH ROLLUP) A;
	SELECT COUNT(*) AS WORDPRESS_DB_COUNT FROM information_schema.SCHEMATA WHERE SCHEMA_NAME LIKE '%word%' OR SCHEMA_NAME LIKE '%press%';
	
	OPEN c1;
	OPEN c2;
	
	read_loop: LOOP
		SET DONE = FALSE;
		FETCH c1 INTO a1, b1;
		FETCH c2 INTO a2;
		IF DONE THEN
		LEAVE read_loop;
		END IF;
		SET @db = a1;
		SET @tble1 = b1;
		SET @tble2 = b2;

		SET @query1 = CONCAT('SELECT OPTION_VALUE FROM ', @db, '.', @tble1, ' WHERE OPTION_NAME = "home"');
		SET @query2 = CONCAT('SELECT OPTION_VALUE FROM ', @db, '.', @tble1, ' WHERE OPTION_NAME = "%admin_email%"');
		SET @query3 = CONCAT('SELECT USER_LOGIN FROM ', @db, '.', @tble2);
		
		PREPARE stmt1 FROM @query1;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

		PREPARE stmt2 FROM @query2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;

		PREPARE stmt3 FROM @query3;
		EXECUTE stmt3;
		DEALLOCATE PREPARE stmt3;

	END LOOP;
	CLOSE c1;
	CLOSE c2;
END $$

DELIMITER ;

CALL list();