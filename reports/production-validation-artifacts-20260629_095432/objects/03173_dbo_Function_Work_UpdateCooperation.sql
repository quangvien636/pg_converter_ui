-- ─── FUNCTION: work_updatecooperation ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatecooperation(integer, integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.work_updatecooperation(
    cooperationno integer,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying
) RETURNS void
AS $function$
BEGIN


	update Work_Cooperation
	set ModUserNo = work_updatecooperation.moduserno
	,ModDate = work_updatecooperation.moddate
	,Title = work_updatecooperation.title
	,Content =Content
	WHERE CooperationNo = work_updatecooperation.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
