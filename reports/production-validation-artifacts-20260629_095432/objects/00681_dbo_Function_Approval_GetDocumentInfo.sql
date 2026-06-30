-- ─── FUNCTION: approval_getdocumentinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getdocumentinfo(integer);
CREATE OR REPLACE FUNCTION public.approval_getdocumentinfo(
    documentno integer
) RETURNS TABLE(
    approverno text,
    userno text,
    username text,
    positionname text,
    departname text,
    depth text,
    arrivestate text,
    arrivedate text,
    approvaltype text,
    approvalstate text,
    approvaldate text,
    opinion text
)
AS $function$
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
