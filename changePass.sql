DROP PROCEDURE IF EXISTS changePass;
DELIMITER $$
CREATE PROCEDURE changePass(IN password VARCHAR(20))
BEGIN
	DECLARE x1 VARCHAR(16) DEFAULT "";
	DECLARE x2 VARCHAR(16) DEFAULT "";
	DECLARE cp CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME LIKE '%_users';
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	DECLARE table_not_found FOR 1051;
	DECLARE EXIT HANDLER FOR table_not_found SELECT 'Table Not FOUND';
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQL EXCEPTION INVOKED';

	OPEN cp;
	read_loop: LOOP
		SET done = FALSE;
		FETCH cp INTO x1, x2;
		IF done THEN
		LEAVE read_loop;
		END IF;
		SET @db = x1;
		SET @tble = x2;
		SET @pw = password;

		SET @query = CONCAT('UPDATE ', @db, '.', @tble, ' SET user_pass = MD5(', @pw, ') WHERE user_login LIKE "%admin%"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END LOOP;
	CLOSE cp;
END $$

DELIMITER ;

CALL changePass('Alpha123');