-- ─── PROCEDURE→FUNCTION: board_updateboardcontent_enabledforuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcontent_enabledforuser(bigint, timestamp without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_enabledforuser(
    IN contentno bigint,
    IN moddate timestamp without time zone,
    IN enabled boolean,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_enabledforuser.moddate,
		Enabled = board_updateboardcontent_enabledforuser.enabled
	WHERE ContentNo = board_updateboardcontent_enabledforuser.contentno AND RegUserNo = board_updateboardcontent_enabledforuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
