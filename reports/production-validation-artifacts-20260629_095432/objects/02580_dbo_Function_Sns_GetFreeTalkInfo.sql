-- ─── FUNCTION: sns_getfreetalkinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getfreetalkinfo();
CREATE OR REPLACE FUNCTION public.sns_getfreetalkinfo(
) RETURNS TABLE(
    groupno text,
    groupname text,
    grouptype text,
    opentype text,
    col5 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT G.GroupNo, G.GroupName, G.GroupType, G.OpenType,
	(SELECT COUNT(*) FROM SnsMessageChk AS M WHERE M.GroupNo = G.GroupNo AND M.IsCheck = FALSE AND M.UserNo=UserNo) AS NoReadCnt
	FROM SnsGroups AS G
	WHERE GroupType=101 AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
