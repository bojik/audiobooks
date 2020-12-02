-- MySQL dump 10.13  Distrib 8.0.22, for Linux (x86_64)
--
-- Host: localhost    Database: private
-- ------------------------------------------------------
-- Server version	8.0.22
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'private'
--
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_change_login`(in old_user_login varchar(255), in plain_user_password varchar(255), in new_user_login varchar(255))
begin
    declare err_login_already_registered condition for sqlstate '45001';
    declare user_id int;
	declare exit handler for err_login_already_registered, sqlstate '45006'
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;    
    select users_id into user_id from user_identity_data where login = new_user_login;
    if user_id is not null then
        signal err_login_already_registered set message_text = 'Login already registered';
    end if;
    call user_check_login(old_user_login, plain_user_password, user_id);
    update user_identity_data set login = new_user_login where users_id = user_id;
    call common.success(json_object('user_id', user_id));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_check_login`(in user_login varchar(255), in plain_passsword varchar(255), out user_id int)
begin
declare err_invalid_login_or_password condition for sqlstate '45006';
declare v_salt, v_encrypted_password varchar(64);
select sql_calc_found_rows
    password_salt
into v_salt from
    user_identity_data uid
    join users.users u on (u.id = uid.users_id)
where
    login = user_login and u.user_statuses_id = 2;

if found_rows() = 0 then
	signal err_invalid_login_or_password set message_text = 'Login has not been found';
end if;

call private.user_encrypt_password(plain_passsword, v_salt, v_encrypted_password);

select sql_calc_found_rows
    users_id
into user_id from
    user_identity_data
where
    login = user_login
        and password_hash = v_encrypted_password;

if found_rows() = 0 then
	signal err_invalid_login_or_password set message_text = 'Invalid password';
end if;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_create_recovery_code`(in user_login varchar(255))
begin
    declare err_user_has_not_been_found condition for sqlstate '45007';
    declare v_user_id int;
    declare code varchar(8);
    declare exit handler for err_user_has_not_been_found
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;
    select users_id into v_user_id from user_identity_data where login = user_login;
    if v_user_id is null then
        signal err_user_has_not_been_found set message_text = 'User has not been found';
    end if;
    start transaction;
    call common.create_random_string(8, code);
    delete from password_recovery_codes where users_id = v_user_id;
    insert into password_recovery_codes(users_id, code, expired_at) values(v_user_id, code, now() + interval 24 hour );
    commit;
    call common.success(json_object('code', code));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_encrypt_password`(in plain_password varchar(255), in password_salt varchar(64), out encrypted_password varchar(64))
begin
    set encrypted_password = sha2(concat(plain_password, password_salt), 256);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_login`(in user_login varchar(255), in plain_password varchar(255))
begin
declare err_invalid_login_or_password condition for sqlstate '45006';
declare exit handler for err_invalid_login_or_password
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;
	call user_check_login(user_login, plain_password, @user_id);
    call common.success(json_object("user_id", @user_id));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_register`(in user_login varchar(255), in user_password varchar(255), in user_data json)
begin
    declare err_login_already_exists condition for sqlstate '45001';
    declare v_public_name varchar(255);
    declare v_registration_method_id int;
    declare user_id int;
    declare v_encrypted_password, v_salt varchar(64);
    declare exit handler for err_login_already_exists, sqlstate '45002', sqlstate '45003'
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;
    set user_id = null;
    select count(users_id) into @user_count from private.user_identity_data where login = user_login;
    if @user_count > 0 then 
        signal err_login_already_exists set message_text = 'Login has been already registered';
    end if;
    call common.user_check_password(user_password);
    call common.validate_json('user_register', user_data);
    set v_public_name = user_data ->> '$.public_name';
    set v_registration_method_id = user_data ->> '$.registration_methods_id';
    start transaction;
    insert into users.users(public_name, last_loggedin_at, registration_methods_id, user_statuses_id)
        values(v_public_name, null, v_registration_method_id, 2);
    set user_id := last_insert_id();
    set v_salt := sha2(unix_timestamp(now(6)), 256);
    call private.user_encrypt_password(user_password, v_salt, v_encrypted_password);
    insert into private.user_identity_data(users_id, login, password_hash, password_salt)
        values(user_id, user_login, v_encrypted_password, v_salt);
    commit;
    call common.success(json_object('user_id', user_id));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_restore_password`(in user_login varchar(255), in recovery_code varchar(8), in plain_new_password varchar(255))
begin
    declare err_incorrect_user_login_or_recovery_code condition for sqlstate '45008';
    declare v_salt, v_encrypted_new_password varchar(64);
    declare user_id int;
	declare exit handler for err_incorrect_user_login_or_recovery_code, sqlstate '45002', sqlstate '45003'
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;    
    set user_id = null;
    call common.user_check_password(plain_new_password);
    select uid.users_id into user_id from user_identity_data uid join password_recovery_codes prc on (uid.users_id = prc.users_id)
        where uid.login = user_login and prc.code = recovery_code and prc.expired_at > now();
    if user_id is null then
        signal err_incorrect_user_login_or_recovery_code set message_text = 'Incorrect login or password recovery code';
    end if;
    start transaction;
    set v_salt = sha2(unix_timestamp(now(6)), 256);
    call user_encrypt_password(plain_new_password, v_salt, v_encrypted_new_password);
    update user_identity_data set password_hash = v_encrypted_new_password, password_salt = v_salt where users_id = user_id;
    delete from password_recovery_codes where users_id = user_id;
    commit;
    call common.success(json_object('user_id', user_id));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`private`@`%` PROCEDURE `user_update_password`(in user_login varchar(255), in plain_old_password varchar(255), in plain_new_password varchar(255))
begin
    declare v_salt, v_encrypted_new_password varchar(64);
    declare user_id int;
	declare exit handler for sqlstate '45006', sqlstate '45002', sqlstate '45003'
		begin
			GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
				@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            call common.error(@sqlstate, @text, @errno);
		end;    
    call common.user_check_password(plain_new_password);
    call user_check_login(user_login, plain_old_password, user_id);
    set v_salt = sha2(unix_timestamp(now(6)), 256);
    call user_encrypt_password(plain_new_password, v_salt, v_encrypted_new_password);
    update user_identity_data set password_hash = v_encrypted_new_password, password_salt = v_salt where users_id = user_id;
    call common.success(json_object('user_id', user_id));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-02 22:01:17
