-- ─── FUNCTION: work_insertworkgroupperson ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkgroupperson(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroupperson(
    groupno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkGroupPersons(GroupNo, UserNo)
	VALUES(GroupNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
