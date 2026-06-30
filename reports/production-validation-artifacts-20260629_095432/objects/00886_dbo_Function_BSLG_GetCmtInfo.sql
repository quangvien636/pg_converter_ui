-- ─── FUNCTION: bslg_getcmtinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getcmtinfo(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getcmtinfo(
    targetid character varying,
    langindex character varying,
    orgcd character varying,
    startdate character varying,
    enddate character varying
) RETURNS TABLE(
    id text,
    content text,
    targetid text,
    writerid text,
    regdate text,
    status text,
    username text,
    writerdate text,
    orgnm text,
    posnm text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	RETURN QUERY
	select ID
		, Content
		, TargetID
		, WriterID
		, RegDate
		, Status 
		, U.Name as UserName
		, WriterDate 
		, D.Name as OrgNm
		, P.Name as PosNm
	from BSLG_Comment C
	INNER JOIN Organization_Users U on C.WriterID = U.UserID
	INNER JOIN Organization_BelongToDepartment B on B.UserNo = U.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE C.Status = Flag AND C.TargetID = bslg_getcmtinfo.targetid
	AND ( RegDate >= bslg_getcmtinfo.startdate AND RegDate <= bslg_getcmtinfo.enddate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
