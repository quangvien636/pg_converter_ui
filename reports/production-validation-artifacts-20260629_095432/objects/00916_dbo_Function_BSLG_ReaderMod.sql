-- ─── FUNCTION: bslg_readermod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_readermod(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_readermod(
    regid character varying,
    readerid character varying,
    regdate character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    chk integer;
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT Chk = Count(*)
	 FROM BSLG_Reader 
	WHERE ReaderId = bslg_readermod.readerid
	AND   RegDate  = bslg_readermod.regdate
	
	IF Chk = 0
	BEGIN;
		INSERT INTO BSLG_Reader (RegId, ReaderId, RegDate, ReadDate)
			VALUES (RegID, ReaderID, RegDate, NOW())
	END
	ELSE
	BEGIN;
		UPDATE BSLG_Reader 
			SET ReadDate = NOW()
		WHERE ReaderId = bslg_readermod.readerid
		AND   RegDate  = bslg_readermod.regdate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
