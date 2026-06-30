-- ─── PROCEDURE→FUNCTION: mail_getsharemailboxs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.mail_getsharemailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getsharemailboxs(
    IN userno integer
) RETURNS SETOF record
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
	 



	Len := LEN(DepartNos);
	Pos := 0;
	WHILE (STRPOS(DepartNos, Pos, ';') - Pos) > 0 LOOP

		Val := SUBSTRING(DepartNos, Pos, (STRPOS(DepartNos, Pos, ';') - Pos));;
		INSERT INTO Departs SELECT Val
		Pos := STRPOS(DepartNos, Pos, ';') + 1;
	END LOOP;

	IF Pos <= Len THEN

		Val := SUBSTRING(DepartNos, Pos, (Len + 1) - Pos);;
		INSERT INTO Departs SELECT Val
	    
	END IF;
	
	
	
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
