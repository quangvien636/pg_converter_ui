-- ─── PROCEDURE→FUNCTION: voteitemdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.voteitemdel(integer);
CREATE OR REPLACE FUNCTION public.voteitemdel(
    IN id integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTEItem WHERE ID = voteitemdel.id;
	DELETE FROM VOTESubItem WHERE ParentID = voteitemdel.id;
	DELETE FROM VOTEResult WHERE ParentID = voteitemdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
