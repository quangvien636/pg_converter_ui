-- ─── PROCEDURE→FUNCTION: board_updatestatusapproval ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updatestatusapproval(bigint, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_updatestatusapproval(
    IN contentno bigint,
    IN type character varying,
    IN errortype character varying,
    IN persontype character varying,
    IN applyto character varying,
    IN designno character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Board_Contents SET
		Type = board_updatestatusapproval.type,
		ErrorType = board_updatestatusapproval.errortype,
		PersonType = board_updatestatusapproval.persontype,
		ApplyTo=board_updatestatusapproval.applyto,
		DesignNo = board_updatestatusapproval.designno,
		Purpose=Purpose
	WHERE ContentNo = board_updatestatusapproval.contentno;

	--SELECT IsAlarm
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
