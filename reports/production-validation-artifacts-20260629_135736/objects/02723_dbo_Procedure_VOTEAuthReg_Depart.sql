-- ─── PROCEDURE→FUNCTION: voteauthreg_depart ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteauthreg_depart(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthreg_depart(
    IN departno integer,
    IN isfullauth integer,
    IN isregmod integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO VOTEAuthority(UserNo, IsFullAuth, IsRegMod, RegDate, ModDate,DepartNo)
	VALUES (0, IsFullAuth, IsRegMod, NOW(), NOW(),DepartNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
