-- ─── FUNCTION: log_insertaccesslogdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.log_insertaccesslogdata(character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.log_insertaccesslogdata(
    clientip character varying,
    userno integer,
    accmodule character varying,
    accmoduleno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	INSERT INTO AccessLog (ClientIP, UserNo, AccModuleNo, AccModule, UserName)
	VALUES (ClientIP, UserNo, AccModuleNo, AccModule, (SELECT Name FROM Organization_Users WHERE UserNo=log_insertaccesslogdata.userno AND Enabled = TRUE));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
