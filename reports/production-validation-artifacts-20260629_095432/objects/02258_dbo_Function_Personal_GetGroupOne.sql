-- ─── FUNCTION: personal_getgroupone ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getgroupone(integer, integer);
CREATE OR REPLACE FUNCTION public.personal_getgroupone(
    groupno integer,
    userno integer
) RETURNS TABLE(
    userno text,
    username text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		GroupNo,
		GroupName,
		Description,
		ShareType,
		DepartNo,
		CASE WHEN RegUserNo = personal_getgroupone.userno THEN 'Y' ELSE '' END ModYN
	FROM PersonalGroup
	WHERE GroupNo = personal_getgroupone.groupno
	
	RETURN QUERY
	SELECT
		UserNo,
		public."COMNGetUserName"(UserNo) AS UserName
	FROM PersonalGroupUser
	WHERE GroupNo = personal_getgroupone.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
