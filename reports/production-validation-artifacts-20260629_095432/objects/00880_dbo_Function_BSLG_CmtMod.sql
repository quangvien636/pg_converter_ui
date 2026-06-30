-- ─── FUNCTION: bslg_cmtmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_cmtmod(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_cmtmod(
    userid character varying,
    targetid character varying,
    regdate character varying,
    content character varying,
    orgcd character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    chk character varying;
BEGIN
   if orgcd is null
    set orgcd=''

	INSERT INTO BSLG_Comment

	VALUES(Content, TargetID, UserID, RegDate, Flag, convert(char(10), NOW(), 120),orgcd)

	/*

	SELECT Chk = count(ID)
	
	FROM 	BSLG_Comment

	WHERE  TargetID = bslg_cmtmod.targetid AND WriterID = bslg_cmtmod.userid AND RegDate=bslg_cmtmod.regdate AND ID > 0

	IF Chk > 0
		BEGIN;
			UPDATE BSLG_Comment

			SET 	Content = bslg_cmtmod.content

			WHERE  TargetID = bslg_cmtmod.targetid AND WriterID = bslg_cmtmod.userid AND RegDate=bslg_cmtmod.regdate AND ID > 0
		END
	ELSE
		BEGIN;
			INSERT INTO BSLG_Comment

			VALUES(Content, TargetID, UserID, RegDate, Flag, convert(char(10), NOW(), 120))
		END

	*/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
