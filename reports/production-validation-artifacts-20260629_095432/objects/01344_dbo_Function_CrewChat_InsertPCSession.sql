-- ─── FUNCTION: crewchat_insertpcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertpcsession(integer, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_insertpcsession(
    userno integer,
    deviceno bigint
) RETURNS TABLE(
    sessionno text,
    userno text,
    sessionid text,
    deviceno text
)
AS $function$
DECLARE
    newsessionnumber character varying;
    myid uuid;
    sessionno bigint;
BEGIN




	SET myid = NEWID()
	
_NEWID:

	SET NewSessionNumber = CONVERT(char(32), SUBSTRING(REPLACE(myid, '-', ''), 1, 32))

	SET SessionNo = (SELECT SessionNo FROM CrewChat_PCSessions 
	WHERE SessionID = NewSessionNumber)
	
	IF (SessionNo IS NULL) BEGIN
		--값이 중복되지 않으므로 INSERT INTO 합니다.;
		INSERT INTO CrewChat_PCSessions (UserNo, SessionID, DeviceNo)
		VALUES (UserNo, NewSessionNumber, DeviceNo)
		
		SET SessionNo = lastval()
	
	END
	
	ELSE BEGIN
		--값이 중복되므로 다시 _NEWID 루프로 이동합니다.
		GOTO _NEWID
	
	END
	
	RETURN QUERY
	SELECT SessionNo, UserNo, SessionID, DeviceNo
	FROM CrewChat_PCSessions
	WHERE SessionNo = SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
