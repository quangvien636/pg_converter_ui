-- ─── FUNCTION: crewchat_updateuserprofile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateuserprofile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserprofile(
    userno integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserprofile.userno) > 0
	BEGIN;
		UPDATE CrewChat_UserProfiles SET StateMessage=StateMessage
		WHERE UserNo = crewchat_updateuserprofile.userno
	END
	ELSE
	BEGIN;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType)
		VALUES (UserNo, '', StateMessage,0)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
