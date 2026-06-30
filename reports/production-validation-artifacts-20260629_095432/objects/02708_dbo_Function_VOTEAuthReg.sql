-- ─── FUNCTION: voteauthreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteauthreg(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthreg(
    userno integer,
    isfullauth integer,
    isregmod integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO VOTEAuthority(UserNo, IsFullAuth, IsRegMod, RegDate, ModDate)
	VALUES (UserNo, IsFullAuth, IsRegMod, NOW(), NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
