-- ─── FUNCTION: sns_getgroupuserinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getgroupuserinfo();
CREATE OR REPLACE FUNCTION public.sns_getgroupuserinfo(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT COUNT(*)
	FROM SnsGroupUsers G
	INNER JOIN Organization_Users U ON U.UserNo = G.UserNo
	WHERE G.GroupNo = GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
