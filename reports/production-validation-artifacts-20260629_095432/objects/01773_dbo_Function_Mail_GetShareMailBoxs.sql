-- ─── FUNCTION: mail_getsharemailboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsharemailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getsharemailboxs(
    userno integer
) RETURNS TABLE(
    departno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    departs table (
		departno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 자신이 속한 부서 목록
	 */
	 



	SET Len = LEN(DepartNos)
	SET Pos = 0

	WHILE ((STRPOS(DepartNos, Pos, ';') - Pos) > 0) BEGIN

		SET Val = SUBSTRING(DepartNos, Pos, (STRPOS(DepartNos, Pos, ';') - Pos));
		INSERT INTO Departs SELECT Val
		SET Pos = STRPOS(DepartNos, Pos, ';') + 1
		    
	END

	IF Pos <= Len BEGIN

		SET Val = SUBSTRING(DepartNos, Pos, (Len + 1) - Pos);
		INSERT INTO Departs SELECT Val
	    
	END
	
	
	
	/*
	 * 자신이 속한 부서의 상위 부서 목록
	 */
	 
	RETURN QUERY
	SELECT * FROM Mail_MailBoxs
	WHERE BoxNo IN (
		SELECT BoxNo FROM Mail_MailBoxSharers
		WHERE (UserNo = mail_getsharemailboxs.userno OR DepartNo IN (SELECT DepartNo FROM Departs)) AND RegUserNo != mail_getsharemailboxs.userno
	)
	ORDER BY Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
