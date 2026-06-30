-- ─── FUNCTION: sns_getgroupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getgroupinfo(integer);
CREATE OR REPLACE FUNCTION public.sns_getgroupinfo(
    groupno integer
) RETURNS TABLE(
    groupno text,
    groupname text,
    makeuserno text,
    grouptype text,
    regdate text,
    opentype text,
    enabled text,
    departno text
)
AS $function$
BEGIN


	
	RETURN QUERY
	SELECT GroupNo,GroupName,MakeUserNo,GroupType,RegDate,OpenType,Enabled,DepartNo 
	FROM SnsGroups WHERE GroupNo = sns_getgroupinfo.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
