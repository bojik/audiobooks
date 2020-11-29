DELIMITER $$
drop procedure if exists user_update_password;
CREATE DEFINER=`private`@`%` PROCEDURE `user_update_password`(in user_login varchar(255), in plain_old_password varchar(255), in plain_new_password varchar(255), out user_id int)
begin
    declare v_salt, v_encrypted_new_password varchar(64);
    call common.user_check_password(plain_new_password);
    call user_check_login(user_login, plain_old_password, user_id);
    set v_salt = sha2(unix_timestamp(now(6)), 256);
    call user_encrypt_password(plain_new_password, v_salt, v_encrypted_new_password);
    update user_identity_data set password_hash = v_encrypted_new_password, password_salt = v_salt where users_id = user_id;
end$$
DELIMITER ;
