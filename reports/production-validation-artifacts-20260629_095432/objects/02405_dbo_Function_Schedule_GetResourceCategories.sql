-- ─── FUNCTION: schedule_getresourcecategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcecategories(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcecategories(
    enabled boolean
) RETURNS TABLE(
    categoryno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    enabled text
)
AS $function$
BEGIN


	IF Enabled = TRUE BEGIN

		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Enabled
		FROM ScheduleResourceCategories
		WHERE Enabled = TRUE
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Enabled
		FROM ScheduleResourceCategories
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
