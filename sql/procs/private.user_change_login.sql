DELIMITER $$
drop procedure if exists `user_change_login`$$
CREATE DEFINER=`private`@`%` PROCEDURE `user_change_login`(in old_user_login varchar(255), in plain_user_password varchar(255), in new_user_login varchar(255), out user_id int)
begin
    declare err_login_already_registered condition for sqlstate '45001';
    select sql_calc_found_rows users_id into user_id from user_identity_data where login = new_user_login;
    if found_rows() then
        signal err_login_already_registered set message_text = 'Login already registered';
    end if;
    call user_check_login(old_user_login, plain_user_password, user_id);
    update user_identity_data set login = new_user_login where users_id = user_id;
end$$
DELIMITER ;
