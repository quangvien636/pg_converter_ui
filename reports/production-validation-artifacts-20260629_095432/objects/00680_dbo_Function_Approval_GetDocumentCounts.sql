-- ─── FUNCTION: approval_getdocumentcounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getdocumentcounts(integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getdocumentcounts(
    userno integer,
    boxtype integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF BoxType = 101 BEGIN /* 결재함 - 결재 */
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 200
			AND A.ArriveState = 200
		
	END
	
	ELSE IF BoxType = 103 BEGIN /* 결재함 - 합의 */
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 300
			AND A.ArriveState = 200
				
	END
	
	ELSE IF BoxType = 105 BEGIN /* 결재함 - 수신 */
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 300 AND A.UserNo = approval_getdocumentcounts.userno AND A.ApprovalType = 600
			AND A.ArriveState = 200
				
	END
	
	ELSE IF BoxType = 107 BEGIN /* 결재함 - 보류 */

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 500 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState <> 100
		
	END
	
	ELSE IF BoxType = 108 BEGIN /* 결재함 - 진행 */

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 200 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
		
	END
	
	ELSE IF BoxType = 201 BEGIN /* 기안함 - 진행 */

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 200 AND D.RegUserNo = approval_getdocumentcounts.userno
			
	END
	
	ELSE IF BoxType = 202 BEGIN /* 기안함 - 보류*/

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 500 AND D.RegUserNo = approval_getdocumentcounts.userno
		
	END
	
	ELSE IF BoxType = 203 BEGIN /* 기안함 - 반려 */
		
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 400 AND D.RegUserNo = approval_getdocumentcounts.userno
			
	END
	
	ELSE IF BoxType = 204 BEGIN /* 기안함 - 완료 */

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		WHERE D.State = 300 AND D.RegUserNo = approval_getdocumentcounts.userno
		
	END

	ELSE IF BoxType = 301 BEGIN /* 종결함 - 완료 */
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 300 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
			
	END
	
	ELSE IF BoxType = 302 BEGIN /* 종결함 - 반려*/

		RETURN QUERY
		SELECT COUNT(*)
		FROM Approval_Documents D
		LEFT JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo
		WHERE D.State = 400 AND A.UserNo = approval_getdocumentcounts.userno AND A.ArriveState = 300
			
	END
	
	ELSE IF BoxType = 403 BEGIN /* 문서수발신함 - 완료 */
	
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
