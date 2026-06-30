-- ─── PROCEDURE→FUNCTION: voteitemmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteitemmod(integer, integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemmod(
    IN id integer,
    IN parentid integer,
    IN title character varying,
    IN type integer,
    IN cnt integer,
    IN selectoption integer
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
