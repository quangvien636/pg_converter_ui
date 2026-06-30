-- ─── PROCEDURE→FUNCTION: approval_getapproximatedocuments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getapproximatedocuments(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getapproximatedocuments(
    IN userno integer,
    IN boxtype integer,
    IN listcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF BoxType = 100 THEN
	
		RETURN QUERY
		SELECT TOP (ListCount) * FROM (
		
			-- 결재
			SELECT 1 AS ApprovalType, D.DocumentNo, D.Title, D.FileType, D.RegDepartName AS DepartName, D.RegUserName AS UserName, A2.ArriveDate AS ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 200 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ApprovalType = 200 AND A.ArriveState = 200

			-- 합의
			UNION ALL
			SELECT 2, D.DocumentNo, D.Title, D.FileType, D.RegDepartName, D.RegUserName, A2.ArriveDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 200 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ApprovalType = 300 AND A.ArriveState = 200
			
			-- 수신
			UNION ALL
			SELECT 3, D.DocumentNo, D.Title, D.FileType, D.RegDepartName, D.RegUserName, A2.ArriveDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 300 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ApprovalType = 600 AND A.ArriveState = 200

			-- 보류
			UNION ALL
			SELECT 4, D.DocumentNo, D.Title, D.FileType, D.RegDepartName, D.RegUserName, A2.ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 500 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ArriveState <> 100
			
		) AS T
		ORDER BY T.ApprovalDate ASC
		
	END IF;
	
	ELSIF BoxType = 200 THEN
	
		RETURN QUERY
		SELECT TOP (ListCount) * FROM (
	
			-- 진행
			SELECT 7 AS ApprovalType, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, A.UserName,
				D.RegDate AS ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.ApproverNo = D.CurrentAppNo
			WHERE D.State = 200 AND D.RegUserNo = approval_getapproximatedocuments.userno
			
			-- 보류
			UNION ALL
			SELECT 4, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, A.UserName,
				D.RegDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.ApproverNo = D.CurrentAppNo
			WHERE D.State = 500 AND D.RegUserNo = approval_getapproximatedocuments.userno
			
			-- 반려
			UNION ALL
			SELECT 6, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, A.UserName,
				D.RegDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.ApproverNo = D.CurrentAppNo
			WHERE D.State = 400 AND D.RegUserNo = approval_getapproximatedocuments.userno
			
			-- 완료
			UNION ALL
			SELECT 5, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, A.UserName,
				D.RegDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.ApproverNo = D.CurrentAppNo
			WHERE D.State = 300 AND D.RegUserNo = approval_getapproximatedocuments.userno
		
		) AS T
		ORDER BY T.ApprovalDate DESC
		
	END IF;
	
	ELSIF BoxType = 300 THEN
		
		RETURN QUERY
		SELECT TOP (ListCount) * FROM (
		
			-- 완료
			SELECT 5 AS ApprovalType, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, D.RegUserName AS UserName,
				A2.ApprovalDate AS ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 300 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ArriveState = 300
			
			-- 반려
			UNION ALL
			SELECT 6, D.DocumentNo, D.Title, D.FileType, D.RegDepartName,
				D.RegUserName, A2.ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo
			WHERE D.State = 400 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ArriveState = 300
		
		) AS T
		ORDER BY T.ApprovalDate DESC
	END IF;
	
	ELSIF BoxType = 400 THEN
		
		RETURN QUERY
		SELECT TOP (ListCount) * FROM (
		
			-- 완료
			SELECT 5 AS ApprovalType, D.DocumentNo, D.Title, D.FileType,
				D.RegDepartName AS DepartName, D.RegUserName AS UserName,
				A.ApprovalDate AS ApprovalDate
			FROM Approval_Documents D
			LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
			WHERE D.State = 300 AND A.UserNo = approval_getapproximatedocuments.userno AND A.ApprovalType = 600
				AND A.ApprovalState = 200
				
		) AS T
		ORDER BY T.ApprovalDate DESC
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
