-- ─── FUNCTION: center_insertpcsession_all ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertpcsession_all(integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.center_insertpcsession_all(
    userno integer,
    sessionid character varying,
    deviceno bigint
) RETURNS TABLE(
    sessionno text
)
AS $function$
DECLARE
    sessionno bigint;
BEGIN


	INSERT INTO Center_PCSessions (UserNo, SessionID)
	VALUES (UserNo, SessionID)
	

	SET SessionNo = lastval()
	
	RETURN QUERY
	SELECT SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
