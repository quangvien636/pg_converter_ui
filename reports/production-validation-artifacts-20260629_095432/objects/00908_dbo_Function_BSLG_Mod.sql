-- ─── FUNCTION: bslg_mod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_mod(character varying, character varying, text, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_mod(
    userid character varying,
    date character varying,
    content text,
    title character varying,
    plot character varying,
    orgcd character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    chk character varying;
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF Plot is null
		BEGIN		
			SELECT Chk = bslg_mod.userid FROM BSLG_Log WHERE UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot is null and OrgCd =bslg_mod.orgcd
		END
	ELSE
		BEGIN
			SELECT Chk = bslg_mod.userid FROM BSLG_Log WHERE UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot = bslg_mod.plot and OrgCd =bslg_mod.orgcd
		END		
		
	IF Plot is null
		BEGIN
			IF UserID = Chk 
				BEGIN;
					UPDATE BSLG_Log SET Content1=bslg_mod.content , Title=bslg_mod.title,OrgCd=bslg_mod.orgcd
					WHERE  UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot is null
				END
			ELSE
				BEGIN;
					INSERT INTO BSLG_Log(UserID, RegDate, Content1, Content2, Title,orgcd)
					VALUES(UserID, Date, Content, '', Title,orgcd)
				END
		END
	ELSE
		BEGIN
			IF UserID = Chk
				BEGIN;
					UPDATE BSLG_Log SET Content1=bslg_mod.content , Title=bslg_mod.title
					WHERE  UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot = bslg_mod.plot and OrgCd=bslg_mod.orgcd
				END
			ELSE
				BEGIN;
					INSERT INTO BSLG_Log(UserID, RegDate, Content1, Content2, Title, Plot,Orgcd)
					VALUES(UserID, Date, Content, '', Title,Plot,orgcd)
				END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
