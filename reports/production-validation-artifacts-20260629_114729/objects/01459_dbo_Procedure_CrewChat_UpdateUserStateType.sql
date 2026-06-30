-- ─── PROCEDURE→FUNCTION: crewchat_updateuserstatetype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_updateuserstatetype(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserstatetype(
    IN userno integer,
    IN statetype integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserstatetype.userno) > 0 THEN;
		UPDATE CrewChat_UserProfiles SET StateType=crewchat_updateuserstatetype.statetype
		WHERE UserNo = crewchat_updateuserstatetype.userno
	END IF;
	ELSE;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType)
		VALUES (UserNo, '', '',StateType)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
