-- ─── PROCEDURE→FUNCTION: votesubitemdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votesubitemdel(bigint);
CREATE OR REPLACE FUNCTION public.votesubitemdel(
    IN id bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTESubItem WHERE ID = votesubitemdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
