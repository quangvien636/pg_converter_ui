-- ─── PROCEDURE→FUNCTION: approval_getdocument ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getdocument(integer);
CREATE OR REPLACE FUNCTION public.approval_getdocument(
    IN documentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, FileType, FormNo, State, CurrentAppNo
	FROM Approval_Documents
	WHERE DocumentNo = approval_getdocument.documentno

	RETURN QUERY
	SELECT ApproverNo, UserNo, UserName, PositionName, DepartName,
		Depth, ArriveState, ArriveDate, ApprovalType, ApprovalState, ApprovalDate, Opinion
	FROM Approval_Approvers
	WHERE DocumentNo = approval_getdocument.documentno
	
	RETURN QUERY
	SELECT AttachNo, FileName, FileLength, Description
	FROM Approval_Attachments
	WHERE DocumentNo = approval_getdocument.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
