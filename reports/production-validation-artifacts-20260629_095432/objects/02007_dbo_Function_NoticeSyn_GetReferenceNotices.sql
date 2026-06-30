-- ─── FUNCTION: noticesyn_getreferencenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getreferencenotices(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getreferencenotices(
    noticeno integer
) RETURNS TABLE(
    department text,
    position text,
    name text,
    readdate text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT Department, Position, Name, ReadDate
	FROM public."NoticeSynReference"
	WHERE NoticeNo = noticesyn_getreferencenotices.noticeno ORDER BY ReadDate ASC
	
	
END;
------------------------------------ ---------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
