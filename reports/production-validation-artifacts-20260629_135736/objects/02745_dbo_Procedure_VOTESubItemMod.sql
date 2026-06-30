-- ─── PROCEDURE→FUNCTION: votesubitemmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votesubitemmod(bigint, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.votesubitemmod(
    IN id bigint,
    IN parentid integer,
    IN masterid integer,
    IN title character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTESubItem
	SET Title = votesubitemmod.title
	WHERE MasterID = votesubitemmod.masterid AND ParentID = votesubitemmod.parentid AND ID = votesubitemmod.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
