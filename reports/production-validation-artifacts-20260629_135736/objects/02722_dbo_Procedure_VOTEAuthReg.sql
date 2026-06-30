-- ─── PROCEDURE→FUNCTION: voteauthreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteauthreg(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthreg(
    IN userno integer,
    IN isfullauth integer,
    IN isregmod integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO VOTEAuthority(UserNo, IsFullAuth, IsRegMod, RegDate, ModDate)
	VALUES (UserNo, IsFullAuth, IsRegMod, NOW(), NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
