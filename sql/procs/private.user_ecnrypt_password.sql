DELIMITER $$
drop procedure if exists user_encrypt_password$$
CREATE DEFINER=`private`@`%` PROCEDURE `user_encrypt_password`(in plain_password varchar(255), in password_salt varchar(64), out encrypted_password varchar(64))
begin
    set encrypted_password = sha2(concat(plain_password, password_salt), 256);
end$$
DELIMITER ;
