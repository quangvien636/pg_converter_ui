-- ─── FUNCTION: voteauthmod_depart ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteauthmod_depart(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod_depart(
    departno integer,
    isfullauth integer,
    isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	SET IsFullAuth = voteauthmod_depart.isfullauth, IsRegMod = voteauthmod_depart.isregmod, ModDate = NOW() 
	WHERE DepartNo = voteauthmod_depart.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
