-- ─── PROCEDURE→FUNCTION: crewchat_updateuserprofileversion ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_updateuserprofileversion(integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserprofileversion(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserprofileversion.userno) > 0 THEN;
		UPDATE CrewChat_UserProfiles SET PCVersion=Version
		WHERE UserNo = crewchat_updateuserprofileversion.userno
	END IF;
	ELSE;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType,PCVersion)
		VALUES (UserNo, '', '',0,Version)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
