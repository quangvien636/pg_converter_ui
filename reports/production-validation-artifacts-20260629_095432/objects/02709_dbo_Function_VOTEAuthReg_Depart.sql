-- ─── FUNCTION: voteauthreg_depart ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteauthreg_depart(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthreg_depart(
    departno integer,
    isfullauth integer,
    isregmod integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO VOTEAuthority(UserNo, IsFullAuth, IsRegMod, RegDate, ModDate,DepartNo)
	VALUES (0, IsFullAuth, IsRegMod, NOW(), NOW(),DepartNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
