-- ─── FUNCTION: work_getcooperation ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperation(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getcooperation(
    groupno integer,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	select COALESCE(ReferenceNo,0) as ReferenceNo,A.CooperationNo,A.GroupNo,A.RegUserNo,B.Name,A.RegDate,A.ModUserNo,
	A.ModDate,A.Title,A.Content ,C.ReadDate,
	(select count(ReferenceNo) from Work_CooperationReference where CooperationNo = A.CooperationNo) as ReadCount,
	(select count(FileNo) from Work_CooperationFiles where CooperationNo = A.CooperationNo) as FileCount
	,COALESCE(ViewBool,0) as ViewBool
	from Work_Cooperation A
	join Organization_Users B
	on A.RegUserNo = B.UserNo
	left join Work_CooperationReference C
	on A.CooperationNo = C.CooperationNo and C.UserNo = work_getcooperation.userno
	where A.groupno = work_getcooperation.groupno
	order by A.RegDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
