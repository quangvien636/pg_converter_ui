-- ─── FUNCTION: main_updateusersettings_firstprojectcode ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updateusersettings_firstprojectcode(integer);
CREATE OR REPLACE FUNCTION public.main_updateusersettings_firstprojectcode(
    userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_UserSettings SET FirstProjectCode = FirstProjectCode;
	--WHERE UserNo = UserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
