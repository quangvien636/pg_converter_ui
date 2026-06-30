-- ─── FUNCTION: dday_updatetagnoofgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updatetagnoofgroup(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.dday_updatetagnoofgroup(
    groupno bigint,
    moddate timestamp without time zone,
    tagno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Groups SET
		ModDate = dday_updatetagnoofgroup.moddate,
		TagNo = dday_updatetagnoofgroup.tagno
	WHERE GroupNo = dday_updatetagnoofgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
