DELIMITER $$
drop procedure if exists user_register$$
CREATE DEFINER=`private`@`%` PROCEDURE `user_register`(in user_login varchar(255), in user_password varchar(255), in user_data json, out user_id int)
begin
    declare err_login_already_exists condition for sqlstate '45001';
    declare v_public_name varchar(255);
    declare v_registration_method_id int;
    declare v_encrypted_password, v_salt varchar(64);
    set user_id = null;
    select SQL_CALC_FOUND_ROWS users_id from private.user_identity_data where login = user_login;
    if found_rows() > 0 then 
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
    select user_id;
    insert into private.user_identity_data(users_id, login, password_hash, password_salt)
        values(user_id, user_login, v_encrypted_password, v_salt);
    commit;
end$$
DELIMITER ;

