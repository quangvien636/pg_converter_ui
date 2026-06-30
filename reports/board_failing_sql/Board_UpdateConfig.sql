-- ─── PROCEDURE→FUNCTION: board_updateconfig ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updateconfig(integer, character varying);
CREATE OR REPLACE FUNCTION public.board_updateconfig(
    IN userno integer,
    IN configkey character varying
) RETURNS SETOF integer
AS $function$
DECLARE
    temp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT ConfigNo INTO temp FROM Board_Config

	WHERE ConfigKey = board_updateconfig.configkey;

	IF Temp > 0 THEN
		UPDATE Board_Config SET ConfigValue=ConfigValue,LastestDate=NOW(),UserNo= board_updateconfig.userno WHERE ConfigNo=Temp;
	ELSE
		INSERT INTO Board_Config(ConfigKey,ConfigValue,UserNo,LastestDate) VALUES (ConfigKey,ConfigValue,UserNo,NOW());;
		Temp := lastval();
	END IF;

	RETURN QUERY
	SELECT Temp;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.