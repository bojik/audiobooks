DELIMITER $$
drop procedure user_create_recovery_code$$
CREATE DEFINER=`private`@`%` PROCEDURE `user_create_recovery_code`(in user_login varchar(255), out code varchar(8))
begin
    declare err_user_has_not_been_found condition for sqlstate '45007';
    declare v_user_id int;
select 
    users_id
into v_user_id from
    user_identity_data
where
    login = user_login;
if v_user_id is null then
	signal err_user_has_not_been_found set message_text = 'User has not been found';
end if;
start transaction;
    call common.create_random_string(8, code);
	delete from password_recovery_codes 
	where
		users_id = v_user_id;
		insert into password_recovery_codes(users_id, code, expired_at) values(v_user_id, code, now() + interval 24 hour );
commit;
end$$
DELIMITER ;
