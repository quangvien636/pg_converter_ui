-- ─── FUNCTION: voteauthmod_departno ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteauthmod_departno(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod_departno(
    departno integer,
    isfullauth integer,
    isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	SET IsFullAuth = voteauthmod_departno.isfullauth, IsRegMod = voteauthmod_departno.isregmod, ModDate = NOW() 
	WHERE DepartNo = voteauthmod_departno.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
