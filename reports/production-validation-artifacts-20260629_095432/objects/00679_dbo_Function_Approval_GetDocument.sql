-- ─── FUNCTION: approval_getdocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getdocument(integer);
CREATE OR REPLACE FUNCTION public.approval_getdocument(
    documentno integer
) RETURNS TABLE(
    attachno text,
    filename text,
    filelength text,
    description text
)
AS $function$
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
