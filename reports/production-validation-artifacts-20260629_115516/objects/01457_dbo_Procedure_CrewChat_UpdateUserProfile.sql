-- ─── PROCEDURE→FUNCTION: crewchat_updateuserprofile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_updateuserprofile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserprofile(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserprofile.userno) > 0 THEN;
		UPDATE CrewChat_UserProfiles SET StateMessage=StateMessage
		WHERE UserNo = crewchat_updateuserprofile.userno
	END IF;
	ELSE;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType)
		VALUES (UserNo, '', StateMessage,0)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
