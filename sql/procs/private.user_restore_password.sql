DELIMITER $$
drop procedure if exists user_restore_password$$
CREATE DEFINER=`private`@`%` PROCEDURE `user_restore_password`(in user_login varchar(255), in recovery_code varchar(8), in plain_new_password varchar(255), out user_id int)
begin
    declare err_incorrect_user_login_or_recovery_code condition for sqlstate '45008';
    declare v_salt, v_encrypted_new_password varchar(64);
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
end$$
DELIMITER ;
