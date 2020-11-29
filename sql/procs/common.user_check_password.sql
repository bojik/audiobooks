DELIMITER $$
drop procedure `user_check_password`$$
CREATE PROCEDURE `user_check_password`(in user_password varchar(255))
begin
    if length(user_password) < 6 then
        signal sqlstate '45002' set message_text = 'Password is too short';
    end if;
    if user_password not regexp '[0-9]+' or user_password not regexp '[A-Z]+' collate utf8mb4_bin then
        signal sqlstate '45003' set message_text = 'Password is too simple. Expected at least one digit and one capital letter';
    end if;
end$$
DELIMITER ;
