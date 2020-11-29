DELIMITER $$
drop procedure if exists user_check_login;
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
end$$
DELIMITER ;

