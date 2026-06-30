-- ─── PROCEDURE→FUNCTION: main_updateusersettings_firstprojectcode ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_updateusersettings_firstprojectcode(integer);
CREATE OR REPLACE FUNCTION public.main_updateusersettings_firstprojectcode(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_UserSettings SET FirstProjectCode = FirstProjectCode;
	--WHERE UserNo = UserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
