-- ─── FUNCTION: votequestionnairelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.votequestionnairelist(integer);
CREATE OR REPLACE FUNCTION public.votequestionnairelist(
    id integer
) RETURNS TABLE(
    masterid text,
    no text,
    type text,
    name text
)
AS $function$
BEGIN


	-- List
	RETURN QUERY
	SELECT MasterID
	,No
	,Type
	,Name
	FROM public."VOTEQuestionnaire"
	WHERE MasterID = votequestionnairelist.id
	ORDER BY MasterID, Type, No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
