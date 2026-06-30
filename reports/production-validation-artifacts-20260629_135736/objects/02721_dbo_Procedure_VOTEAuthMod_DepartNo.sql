-- ─── PROCEDURE→FUNCTION: voteauthmod_departno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteauthmod_departno(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod_departno(
    IN departno integer,
    IN isfullauth integer,
    IN isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	IsFullAuth := voteauthmod_departno.isfullauth, IsRegMod = voteauthmod_departno.isregmod, ModDate = NOW();
	WHERE DepartNo = voteauthmod_departno.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
