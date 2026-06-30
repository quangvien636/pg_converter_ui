-- ─── PROCEDURE→FUNCTION: crewchat_insertpcsession ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertpcsession(integer, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_insertpcsession(
    IN userno integer,
    IN deviceno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    newsessionnumber character varying;
    myid uuid;
    sessionno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	myid := NEWID();
_NEWID:

	NewSessionNumber := CONVERT(char(32), SUBSTRING(REPLACE(myid, '-', ''), 1, 32));
	SessionNo := (SELECT SessionNo FROM CrewChat_PCSessions;
	WHERE SessionID = NewSessionNumber)
	
	IF SessionNo IS NULL THEN
		--값이 중복되지 않으므로 INSERT INTO 합니다.;
		INSERT INTO CrewChat_PCSessions (UserNo, SessionID, DeviceNo)
		VALUES (UserNo, NewSessionNumber, DeviceNo)
		
		SessionNo := lastval();
	END IF;
	
	ELSE BEGIN
		--값이 중복되므로 다시 _NEWID 루프로 이동합니다.
		GOTO _NEWID
	
	END;
	
	RETURN QUERY
	SELECT SessionNo, UserNo, SessionID, DeviceNo
	FROM CrewChat_PCSessions
	WHERE SessionNo = SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
