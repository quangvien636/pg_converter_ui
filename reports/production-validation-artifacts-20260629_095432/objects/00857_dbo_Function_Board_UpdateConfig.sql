-- ─── FUNCTION: board_updateconfig ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateconfig(integer, character varying);
CREATE OR REPLACE FUNCTION public.board_updateconfig(
    userno integer,
    configkey character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    temp integer;
BEGIN


	SELECT Temp = ConfigNo
	FROM Board_Config
	WHERE ConfigKey = board_updateconfig.configkey

	IF (Temp > 0)
	BEGIN;
		UPDATE Board_Config SET ConfigValue=ConfigValue,LastestDate=NOW(),UserNo= board_updateconfig.userno WHERE ConfigNo=Temp;
	END
	ELSE
	BEGIN;
		INSERT INTO Board_Config(ConfigKey,ConfigValue,UserNo,LastestDate) VALUES (ConfigKey,ConfigValue,UserNo,NOW())
		SET Temp= lastval()
	END

	RETURN QUERY
	SELECT Temp;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
