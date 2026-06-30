-- ─── PROCEDURE→FUNCTION: bslg_getdeptcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdeptcount(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdeptcount(
    IN userid character varying,
    IN deptid character varying,
    IN sdate character varying,
    IN edate character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	

			RETURN QUERY
			SELECT	COUNT(A.UserID)
			FROM	BSLG_Log A
			inner join CMONUsers B
			on A.UserID = B.UserId
			inner join CMONOrgan C
			on B.OrgCd1 = C.OrgCd
			inner join CMONCommCd D
			on B.PosFg1 = D.commcd
			where
			(RegDate >= bslg_getdeptcount.sdate AND RegDate <=  bslg_getdeptcount.edate )
			AND		Plot is null 
			AND		B.UseYn = 'Y'
			AND		C.OrgCd = bslg_getdeptcount.deptid
			AND		D.ClassCd = 'C001'
			
			group by D.Commcd,A.UserID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
