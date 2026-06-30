-- ─── FUNCTION: voteauthmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteauthmod(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthmod(
    userno integer,
    isfullauth integer,
    isregmod integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEAuthority 
	SET IsFullAuth = voteauthmod.isfullauth, IsRegMod = voteauthmod.isregmod, ModDate = NOW() 
	WHERE UserNo = voteauthmod.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
