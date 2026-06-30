-- ─── PROCEDURE→FUNCTION: bslg_mainlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.bslg_mainlist(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_mainlist(
    IN userid character varying,
    IN lang character varying,
    IN where character varying
) RETURNS SETOF record
AS $function$
DECLARE
    sql character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	sql := ' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; ';
	sql := sql || ' SELECT /* TOP 5 */ bl.UserID, RegDate, Content1, Content2, att1, att2, att3, att4, att5, COALESCE(Title, ''제목'') Title ';
	sql := sql || ' , CASE ''' || Lang || ''' When ''1'' Then cu.UserNm1 ';
	sql := sql || '						 When ''2'' Then cu.UserNm2 ';
	sql := sql || '						 When ''3'' Then cu.UserNm3 ';
	sql := sql || '	  ELSE cu.UserNm1 ';
	sql := sql || '	  END As UserNm ';
	sql := sql || ' , public."CMONGetOrganNm"(cu.OrgCd1, ''' || Lang || ''') As OrgNm ';
	sql := sql || ' , public."CMONGetCommCdNm"(''C001'', cu.PosFg1, ''' || Lang || ''')  as PosNm ';
	sql := sql || ' FROM	BSLG_SpAuthInfo bls, CMONUsers cu, BSLG_Log bl ';
	sql := sql || ' WHERE bls.UserID = ''' || UserID || ''' ';
	sql := sql || ' AND   bl.UserID  = cu.UserID ';
	sql := sql || ' AND   ( ' || Where || ' ) ';
	sql := sql || ' ORDER BY RegDate DESC ';
	--PRINT(sql)	
	EXECUTE (sql);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
