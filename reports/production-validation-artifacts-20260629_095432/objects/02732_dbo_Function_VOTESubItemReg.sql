-- ─── FUNCTION: votesubitemreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.votesubitemreg(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.votesubitemreg(
    parentid integer,
    masterid integer,
    title character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	INSERT INTO VOTESubItem
		(ParentID
		,MasterID
		,Title)
		VALUES
		(ParentID
		,MasterID
		,Title)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
