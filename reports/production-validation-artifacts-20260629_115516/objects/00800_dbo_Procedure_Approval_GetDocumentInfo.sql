-- ─── PROCEDURE→FUNCTION: approval_getdocumentinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getdocumentinfo(integer);
CREATE OR REPLACE FUNCTION public.approval_getdocumentinfo(
    IN documentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DocumentNo,
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, FileType, State, CurrentAppNo
	FROM ApprovalDocuments
	WHERE DocumentNo = approval_getdocumentinfo.documentno

	RETURN QUERY
	SELECT A.ApproverNo, A.UserNo, A.UserName, A.PositionName, A.DepartName,
		A.Depth, A.ArriveState, A.ArriveDate,
		A.ApprovalType, A.ApprovalState, ApprovalDate,
		A.Opinion
	FROM Approvers A
	LEFT JOIN Users U ON U.UserNo = A.UserNo
	LEFT JOIN BelongToDepartment B ON B.UserNo = A.UserNo
	LEFT JOIN Positions P ON P.PositionNo = B.PositionNo
	WHERE A.DocumentNo = approval_getdocumentinfo.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
