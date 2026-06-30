-- ─── FUNCTION: center_getnotificationdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getnotificationdata();
CREATE OR REPLACE FUNCTION public.center_getnotificationdata(
) RETURNS TABLE(
    col1 text,
    devicetype text,
    modulename text,
    projectid text,
    devicekey text,
    jsondata text,
    regdate text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT NotificationNo, DeviceType, ModuleName, ProjectID, DeviceKey, JsonData, RegDate FROM Center_NotificationData;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
