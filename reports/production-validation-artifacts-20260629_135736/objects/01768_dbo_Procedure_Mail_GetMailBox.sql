-- ─── PROCEDURE→FUNCTION: mail_getmailbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_getmailbox(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailbox(
    IN boxno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    issent boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	,
		ParentNo		BIGINT,
		SortNo			INT,
		ModDate			DATETIME,
		TotalCount		INT,
		UnReadCount		INT,
		IsShare			BIT
	)

	INSERT INTO TempTable
	RETURN QUERY
	SELECT * FROM Mail_MailBoxs WHERE BoxNo = mail_getmailbox.boxno


	RETURN QUERY
	SELECT /* TOP 1 */ ParentNo = ParentNo, SortNo = SortNo FROM TempTable

	WHILE ParentNo != -1 AND ParentNo != 1 AND ParentNo != 0 LOOP

		SELECT ParentNo INTO parentno FROM Mail_MailBoxs WHERE BoxNo = ParentNo

	END LOOP;


	IF ParentNo = -1 THEN
	
		IF SortNo = 3 AND SortNo = 4 THEN
		
			IsSent := 1;
		END IF;
		
		ELSE SET IsSent = FALSE
	
	END IF;
	
	ELSIF (ParentNo = 0) SET IsSent = FALSE THEN
	ELSIF (ParentNo = 1) SET IsSent = TRUE THEN

	RETURN QUERY
	SELECT /* TOP 1 */ *, IsSent AS IsSent
	FROM TempTable;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
