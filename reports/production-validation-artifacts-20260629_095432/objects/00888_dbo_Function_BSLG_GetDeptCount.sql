-- ─── FUNCTION: bslg_getdeptcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdeptcount(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdeptcount(
    userid character varying,
    deptid character varying,
    sdate character varying,
    edate character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

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
