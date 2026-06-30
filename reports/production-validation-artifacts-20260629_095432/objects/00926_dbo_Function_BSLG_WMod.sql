-- ─── FUNCTION: bslg_wmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_wmod(character varying, character varying, text);
CREATE OR REPLACE FUNCTION public.bslg_wmod(
    userid character varying,
    date character varying,
    content text
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    chk character varying;
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

	SELECT Chk = bslg_wmod.userid FROM BSLG_WLog WHERE UserID = bslg_wmod.userid AND RegDate=bslg_wmod.date

	IF UserID = Chk
		BEGIN;
			UPDATE BSLG_WLog SET Content=bslg_wmod.content 
			WHERE  UserID = bslg_wmod.userid AND RegDate=bslg_wmod.date
		END
	ELSE
		BEGIN;
			INSERT INTO BSLG_WLog(UserID, RegDate, Content)
			VALUES(UserID, Date, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
