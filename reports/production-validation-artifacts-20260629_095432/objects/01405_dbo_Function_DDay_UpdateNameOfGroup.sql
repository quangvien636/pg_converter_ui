-- ─── FUNCTION: dday_updatenameofgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updatenameofgroup(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.dday_updatenameofgroup(
    groupno bigint,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Groups SET
		ModDate = dday_updatenameofgroup.moddate,
		Name = Name
	WHERE GroupNo = dday_updatenameofgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
