-- ─── FUNCTION: schedule_gettodogroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodogroups(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodogroups(
    userno integer
) RETURNS TABLE(
    groupno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT S.GroupNo, RegUserNo, RegDate, ModUserNo, ModDate, Name
	FROM ScheduleToDoGroups S
	WHERE RegUserNo = schedule_gettodogroups.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
