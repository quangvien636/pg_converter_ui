-- ─── FUNCTION: voteresultreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteresultreg(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.voteresultreg(
    masterid integer,
    parentid integer,
    type integer,
    result character varying,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN




	INSERT INTO VOTEResult
		(MasterID
		,ParentID
		,Type
		,UserNo
		,Result
		,PollDate)
	VALUES
		(MasterID
		,ParentID
		,Type
		,UserNo
		,Result
		,Now)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
