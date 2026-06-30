-- ─── FUNCTION: sourcecontrol_getsourcecontrolbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.sourcecontrol_getsourcecontrolbyuser(integer, boolean);
CREATE OR REPLACE FUNCTION public.sourcecontrol_getsourcecontrolbyuser(
    userno integer DEFAULT 70,
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	WITH ProjectHistory AS(
		SELECT P.Id AS ProjectId,P.Name,PH.Version,P.CreateDate AS ProjectCreateDate,PH.Id AS ProjectHistoryId,PH.CreateDate AS ProjectHistoryCreateDate ,DH.Id AS DatabaseHistoryId,DH.CreateDate AS DataBaseHistoryCreateDate,
		DH.Type AS DatabaseType
		From SourceControl_Project P
		LEFT JOIN SourceControl_ProjectHistory PH ON PH.ProjectId=P.Id AND COALESCE(PH.IsLastVersion,TRUE)=TRUE
		LEFT JOIN SourceControl_DatabaseHistory DH ON DH.ProjectHistoryId=PH.Id AND COALESCE(DH.IsLastVersion,TRUE)=TRUE
		LEFT JOIN SourceControl_ProjectOwner PO ON PO.ProjectId=P.Id
		WHERE    IsAdmin=TRUE OR PO.UserNo=sourcecontrol_getsourcecontrolbyuser.userno 

	),
	CompanyHistory AS (
		SELECT C.Id AS CompanyId,CH.Id AS CompanyHistoryId,C.Website,C.DatabaseType,
		C.IpAddress,
		C.CreateDate AS CompanyCreateDate,CH.ProjectHistoryId,CH.CreateDate AS CompanyHistoryCreateDate,CH.DatabaseHistoryId,DH.CreateDate AS DataBaseHistoryCreateDate
		FROM SourceControl_Company C
		LEFT JOIN SourceControl_CompanyHistory CH ON CH.CompanyId=C.Id
		LEFT JOIN SourceControl_DataBaseHistory DH ON DH.Id=CH.DataBaseHistoryId
		WHERE C.Disable = FALSE AND	COALESCE(CH.IsLastVersion,TRUE) = TRUE
	),
	Total AS 
	(	SELECT  Count(*) AS TotalCount 
		FROM CompanyHistory C, ProjectHistory P
		WHERE COALESCE(C.ProjectHistoryId,0)<>COALESCE(P.ProjectHistoryId,0) OR COALESCE(C.DatabaseHistoryId,0)<>COALESCE(P.DatabaseHistoryId,0)
	)
	RETURN QUERY
	SELECT  (SELECT /* /* TOP 1 */ */ TotalCount FROM Total) AS TotalCount, 
	C.CompanyId, C.Website,P.ProjectHistoryId,P.Name AS ProjectName,C.IpAddress,P.ProjectId,C.DatabaseType,
	(P.ProjectCreateDate::date - COALESCE(P.ProjectHistoryCreateDate::date), COALESCE(C.CompanyHistoryCreateDate,NOW())) AS ProjectDayUpdated,
	(P.ProjectCreateDate::date - COALESCE(P.DataBaseHistoryCreateDate::date), COALESCE(C.DataBaseHistoryCreateDate,NOW())) AS DataBaseDayUpdated
	FROM CompanyHistory C
	LEFT JOIN ProjectHistory P ON C.CompanyId>0
	WHERE COALESCE(C.ProjectHistoryId,0)<>COALESCE(P.ProjectHistoryId,0) OR COALESCE(C.DatabaseHistoryId,0)<>COALESCE(P.DatabaseHistoryId,0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
