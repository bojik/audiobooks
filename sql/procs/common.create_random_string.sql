DELIMITER $$
drop procedure if exists `create_random_string`$$
CREATE PROCEDURE `create_random_string`(in length smallint(3), out code varchar(100))
begin
    declare v_i smallint(3) default 0;
    declare v_allowed_chars varchar(255) default 'qazxswedcvfrtgbnhyujmikolp0123456789';
    set code = '';
    while (v_i < length) do
        set code = CONCAT(code, substring(v_allowed_chars, FLOOR(RAND() * LENGTH(v_allowed_chars) + 1), 1));
        set v_i = v_i + 1;
    end while;
end$$
DELIMITER ;
