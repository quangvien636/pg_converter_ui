-- ─── FUNCTION: crewchat_updateuserprofileversion ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateuserprofileversion(integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserprofileversion(
    userno integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserprofileversion.userno) > 0
	BEGIN;
		UPDATE CrewChat_UserProfiles SET PCVersion=Version
		WHERE UserNo = crewchat_updateuserprofileversion.userno
	END
	ELSE
	BEGIN;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType,PCVersion)
		VALUES (UserNo, '', '',0,Version)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
