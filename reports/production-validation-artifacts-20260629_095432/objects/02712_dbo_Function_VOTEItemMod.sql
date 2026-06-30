-- ─── FUNCTION: voteitemmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteitemmod(integer, integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemmod(
    id integer,
    parentid integer,
    title character varying,
    type integer,
    cnt integer,
    selectoption integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEItem
	SET  Title = voteitemmod.title
		,Type = voteitemmod.type
		,Cnt = voteitemmod.cnt
		,SelectOption = voteitemmod.selectoption
	WHERE ParentID = voteitemmod.parentid AND ID = voteitemmod.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
