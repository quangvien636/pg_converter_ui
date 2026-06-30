-- ─── PROCEDURE→FUNCTION: approval_insertapprover ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_insertapprover(bigint, integer, integer, integer, timestamp without time zone, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.approval_insertapprover(
    IN documentno bigint,
    IN userno integer,
    IN depth integer,
    IN arrivestate integer,
    IN arrivedate timestamp without time zone,
    IN approvaltype integer,
    IN approvalstate integer,
    IN approvaldate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    username character varying;
    positionname character varying;
    departname character varying;
    approverno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SELECT U.Name, P.Name INTO username, positionname FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = approval_insertapprover.userno
	
	INSERT INTO Approval_Approvers
	VALUES(DocumentNo, UserNo, UserName, PositionName, DepartName,
		Depth, ArriveState, ArriveDate,
		ApprovalType, ApprovalState, ApprovalDate, Opinion)
	

	ApproverNo := lastval();
	RETURN QUERY
	SELECT ApproverNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
