-- ─── FUNCTION: bslg_mainlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_mainlist(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_mainlist(
    userid character varying,
    lang character varying,
    where character varying
) RETURNS TABLE(
    userid text,
    regdate text,
    content1 text,
    content2 text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text,
    col10 text,
    col11 text,
    col12 text,
    col13 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    sql character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	SET sql = ' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; '
	SET sql = sql || ' SELECT /* TOP 5 */ bl.UserID, RegDate, Content1, Content2, att1, att2, att3, att4, att5, COALESCE(Title, ''제목'') Title '
	SET sql = sql || ' , CASE ''' || Lang || ''' When ''1'' Then cu.UserNm1 '
	SET sql = sql || '						 When ''2'' Then cu.UserNm2 '
	SET sql = sql || '						 When ''3'' Then cu.UserNm3 '
	SET sql = sql || '	  ELSE cu.UserNm1 '
	SET sql = sql || '	  END As UserNm '
	SET sql = sql || ' , public."CMONGetOrganNm"(cu.OrgCd1, ''' || Lang || ''') As OrgNm '
	SET sql = sql || ' , public."CMONGetCommCdNm"(''C001'', cu.PosFg1, ''' || Lang || ''')  as PosNm '
	SET sql = sql || ' FROM	BSLG_SpAuthInfo bls, CMONUsers cu, BSLG_Log bl '
	SET sql = sql || ' WHERE bls.UserID = ''' || UserID || ''' '
	SET sql = sql || ' AND   bl.UserID  = cu.UserID '
	SET sql = sql || ' AND   ( ' || Where || ' ) '
	SET sql = sql || ' ORDER BY RegDate DESC '
	
	--PRINT(sql)	
	EXEC(sql);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
