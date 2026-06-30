-- ─── PROCEDURE→FUNCTION: noticesyn_getnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getnotice(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getnotice(
    IN noticeno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SELECT ReadDate FROM NoticeSyn_References (NOLOCK THEN
		WHERE NoticeNo = noticesyn_getnotice.noticeno AND UserNo = noticesyn_getnotice.userno) IS NULL BEGIN
	
		UPDATE NoticeSyn_References
		ReadDate := NOW();
		WHERE NoticeNo = noticesyn_getnotice.noticeno AND UserNo = noticesyn_getnotice.userno
		
		UPDATE Notices
		CurrentViews := CurrentViews + 1;
		WHERE NoticeNo = noticesyn_getnotice.noticeno
		
	END;
	
	RETURN QUERY
	SELECT N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		N.Content, N.StartDate, N.EndDate,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt,
		N.TypeNo,TP.Name as TypeName
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	Left JOIN NoticeSyn_Type TP ON TP.TypeNo = N.TypeNo
	WHERE N.NoticeNo = noticesyn_getnotice.noticeno

END;
RETURN QUERY
select * from NoticeSyn_Type;
-------------------------------/////////////////////////////////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
