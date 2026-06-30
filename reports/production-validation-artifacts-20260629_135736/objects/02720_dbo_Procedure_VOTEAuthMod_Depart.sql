-- ─── PROCEDURE→FUNCTION: voteauthmod_depart ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteauthmod_depart(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod_depart(
    IN departno integer,
    IN isfullauth integer,
    IN isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	IsFullAuth := voteauthmod_depart.isfullauth, IsRegMod = voteauthmod_depart.isregmod, ModDate = NOW();
	WHERE DepartNo = voteauthmod_depart.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
