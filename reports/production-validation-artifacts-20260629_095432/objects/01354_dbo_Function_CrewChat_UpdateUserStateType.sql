-- ─── FUNCTION: crewchat_updateuserstatetype ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateuserstatetype(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateuserstatetype(
    userno integer,
    statetype integer
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM CrewChat_UserProfiles WHERE UserNo = crewchat_updateuserstatetype.userno) > 0
	BEGIN;
		UPDATE CrewChat_UserProfiles SET StateType=crewchat_updateuserstatetype.statetype
		WHERE UserNo = crewchat_updateuserstatetype.userno
	END
	ELSE
	BEGIN;
		INSERT INTO CrewChat_UserProfiles (UserNo,NickName,StateMessage,StateType)
		VALUES (UserNo, '', '',StateType)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
