-- ─── PROCEDURE→FUNCTION: voteauthmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteauthmod(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod(
    IN userno integer,
    IN isfullauth integer,
    IN isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	IsFullAuth := voteauthmod.isfullauth, IsRegMod = voteauthmod.isregmod, ModDate = NOW();
	WHERE UserNo = voteauthmod.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
