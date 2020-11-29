DELIMITER $$
drop procedure if exists `validate_json`$$
CREATE DEFINER=`private`@`%` PROCEDURE `validate_json`(in schema_name varchar(60), in json_data json)
begin
    declare var_schema text;
    select SQL_CALC_FOUND_ROWS json_schema into var_schema from json_schemas where name = schema_name;
    if found_rows() = 0 then
        signal sqlstate '45004' set message_text = 'Schema has not been found';
    end if;
    if not json_schema_valid(var_schema, json_data) then
        signal sqlstate '45005' set message_text = 'Invalid JSON data';
    end if;
end$$
DELIMITER ;
