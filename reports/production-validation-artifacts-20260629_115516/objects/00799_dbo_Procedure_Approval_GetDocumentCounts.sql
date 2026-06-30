-- ─── PROCEDURE→FUNCTION: approval_getdocumentcounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getdocumentcounts(integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getdocumentcounts(
    IN userno integer,
    IN boxtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF BoxType = 101 BEGIN /* 결재함 - 결재 */ THEN
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 200
			AND A.ArriveState = 200
		
	END;
	
	ELSIF BoxType = 103 BEGIN /* 결재함 - 합의 */ THEN
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 300
			AND A.ArriveState = 200
				
	END;
	
	ELSIF BoxType = 105 BEGIN /* 결재함 - 수신 */ THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 300 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 600
			AND A.ArriveState = 200
				
	END;
	
	ELSIF BoxType = 107 BEGIN /* 결재함 - 보류 */ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 500 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState <> 100
		
	END;
	
	ELSIF BoxType = 108 BEGIN /* 결재함 - 진행 */ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
		
	END;
	
	ELSIF BoxType = 201 BEGIN /* 기안함 - 진행 */ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 200 AND D.RegUserNo = approval_getdocumentcounts.userno
			
	END;
	
	ELSIF BoxType = 202 BEGIN /* 기안함 - 보류*/ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 500 AND D.RegUserNo = approval_getdocumentcounts.userno
		
	END;
	
	ELSIF BoxType = 203 BEGIN /* 기안함 - 반려 */ THEN
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 400 AND D.RegUserNo = approval_getdocumentcounts.userno
			
	END;
	
	ELSIF BoxType = 204 BEGIN /* 기안함 - 완료 */ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 300 AND D.RegUserNo = approval_getdocumentcounts.userno
		
	END;

	ELSIF BoxType = 301 BEGIN /* 종결함 - 완료 */ THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 300 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
			
	END;
	
	ELSIF BoxType = 302 BEGIN /* 종결함 - 반려*/ THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 400 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
			
	END;
	
	ELSIF BoxType = 403 BEGIN /* 문서수발신함 - 완료 */ THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 300 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 600
			AND A.ApprovalState = 200
			
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
