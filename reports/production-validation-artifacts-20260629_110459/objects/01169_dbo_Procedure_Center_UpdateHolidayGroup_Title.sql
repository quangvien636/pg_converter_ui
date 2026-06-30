-- ─── PROCEDURE→FUNCTION: center_updateholidaygroup_title ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateholidaygroup_title(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_updateholidaygroup_title(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_HolidayGroups SET
		ModUserNo = center_updateholidaygroup_title.moduserno,
		ModDate = center_updateholidaygroup_title.moddate,
		Title = Title
	WHERE GroupNo = center_updateholidaygroup_title.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
