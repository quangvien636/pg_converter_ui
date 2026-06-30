-- ─── FUNCTION: voteitemreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteitemreg(integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemreg(
    parentid integer,
    title character varying,
    type integer,
    cnt integer,
    selectoption integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	INSERT INTO VOTEItem
		(ParentID
		,Title
		,Type
		,Cnt
		,SelectOption)
	VALUES
		(ParentID
		,Title
		,Type
		,Cnt
		,SelectOption)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
