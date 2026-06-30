-- ─── PROCEDURE→FUNCTION: log_insertaccesslogdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.log_insertaccesslogdata(character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.log_insertaccesslogdata(
    IN clientip character varying,
    IN userno integer,
    IN accmodule character varying,
    IN accmoduleno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	INSERT INTO AccessLog (ClientIP, UserNo, AccModuleNo, AccModule, UserName)
	VALUES (ClientIP, UserNo, AccModuleNo, AccModule, (SELECT Name FROM Organization_Users WHERE UserNo=log_insertaccesslogdata.userno AND Enabled = TRUE));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
