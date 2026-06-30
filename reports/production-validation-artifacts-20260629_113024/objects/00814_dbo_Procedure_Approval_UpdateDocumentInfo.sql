-- ─── PROCEDURE→FUNCTION: approval_updatedocumentinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_updatedocumentinfo(integer, integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_updatedocumentinfo(
    IN documentno integer,
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN state integer,
    IN currentappno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE ApprovalDocuments SET Title = approval_updatedocumentinfo.title, State = approval_updatedocumentinfo.state,
		CurrentAppNo = approval_updatedocumentinfo.currentappno
	WHERE DocumentNo = approval_updatedocumentinfo.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
