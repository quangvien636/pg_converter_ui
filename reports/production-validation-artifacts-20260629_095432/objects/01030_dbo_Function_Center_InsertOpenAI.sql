-- ─── FUNCTION: center_insertopenai ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertopenai(integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertopenai(
    userno integer,
    type integer
) RETURNS TABLE(
    no text
)
AS $function$
DECLARE
    no bigint;
BEGIN


	INSERT INTO Center_OpenAI(UserNo,Type,Messages,Date)
	VALUES(UserNo, Type, Messages,NOW())
	

	SET No = lastval()
	
	RETURN QUERY
	SELECT No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
