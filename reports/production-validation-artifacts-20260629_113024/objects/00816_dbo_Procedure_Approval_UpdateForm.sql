-- ─── PROCEDURE→FUNCTION: approval_updateform ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_updateform(integer, integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_updateform(
    IN formno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN categoryno integer,
    IN filetype integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Approval_Forms SET
		ModUserNo = approval_updateform.moduserno,
		ModDate = approval_updateform.moddate,
		Name = approval_updateform.name,
		CategoryNo = approval_updateform.categoryno,
		FileType = approval_updateform.filetype,
		Description = Description
	WHERE FormNo = approval_updateform.formno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
