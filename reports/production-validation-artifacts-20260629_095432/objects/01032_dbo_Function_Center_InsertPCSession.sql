-- ─── FUNCTION: center_insertpcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertpcsession(integer);
CREATE OR REPLACE FUNCTION public.center_insertpcsession(
    userno integer
) RETURNS TABLE(
    sessionno text,
    sessionid text
)
AS $function$
DECLARE
    sessionno bigint;
BEGIN


	INSERT INTO Center_PCSessions (UserNo, SessionID)
	VALUES (UserNo, REPLACE(NEWID(), '-', ''))
	

	SET SessionNo = lastval()
	
	RETURN QUERY
	SELECT SessionNo, SessionID
	FROM Center_PCSessions
	WHERE SessionNo = SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
