-- ─── FUNCTION: work_updateworkgrouplock ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateworkgrouplock(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateworkgrouplock(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone,
    islock boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkGroups SET
		ModUserNo = work_updateworkgrouplock.moduserno,
		ModDate = work_updateworkgrouplock.moddate,
		IsLock = work_updateworkgrouplock.islock
	WHERE GroupNo = work_updateworkgrouplock.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
