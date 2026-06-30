-- ─── FUNCTION: approval_insertapprover ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertapprover(bigint, integer, integer, integer, timestamp without time zone, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.approval_insertapprover(
    documentno bigint,
    userno integer,
    depth integer,
    arrivestate integer,
    arrivedate timestamp without time zone,
    approvaltype integer,
    approvalstate integer,
    approvaldate timestamp without time zone
) RETURNS TABLE(
    name text,
    name text,
    name text
)
AS $function$
DECLARE
    username character varying;
    positionname character varying;
    departname character varying;
    approverno bigint;
BEGIN





	SELECT UserName = U.Name, PositionName = P.Name,
		DepartName = D.Name
	FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = approval_insertapprover.userno
	
	INSERT INTO Approval_Approvers
	VALUES(DocumentNo, UserNo, UserName, PositionName, DepartName,
		Depth, ArriveState, ArriveDate,
		ApprovalType, ApprovalState, ApprovalDate, Opinion)
	

	SET ApproverNo = lastval()
	
	RETURN QUERY
	SELECT ApproverNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
