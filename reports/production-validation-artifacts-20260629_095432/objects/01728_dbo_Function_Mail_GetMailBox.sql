-- ─── FUNCTION: mail_getmailbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailbox(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailbox(
    boxno bigint
) RETURNS TABLE(
    col1 text,
    issent text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    issent boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		BoxNo			BIGINT,
		UserNo			INT,
		Name			NVARCHAR(50),
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

	WHILE (ParentNo != -1 AND ParentNo != 1 AND ParentNo != 0) BEGIN

		SELECT ParentNo = ParentNo FROM Mail_MailBoxs WHERE BoxNo = ParentNo

	END


	IF (ParentNo = -1) BEGIN
	
		IF (SortNo = 3 AND SortNo = 4) BEGIN
		
			SET IsSent = TRUE
		
		END
		
		ELSE SET IsSent = FALSE
	
	END
	
	ELSE IF (ParentNo = 0) SET IsSent = FALSE
	ELSE IF (ParentNo = 1) SET IsSent = TRUE

	RETURN QUERY
	SELECT /* TOP 1 */ *, IsSent AS IsSent
	FROM TempTable;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
