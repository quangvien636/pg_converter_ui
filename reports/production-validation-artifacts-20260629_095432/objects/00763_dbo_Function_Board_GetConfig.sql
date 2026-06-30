-- ─── FUNCTION: board_getconfig ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getconfig();
CREATE OR REPLACE FUNCTION public.board_getconfig(
) RETURNS TABLE(
    configno serial,
    configkey character varying(50),
    configvalue character varying(500),
    userno integer,
    lastestdate timestamp without time zone
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM Board_Config
	WHERE ConfigKey = ConfigKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
