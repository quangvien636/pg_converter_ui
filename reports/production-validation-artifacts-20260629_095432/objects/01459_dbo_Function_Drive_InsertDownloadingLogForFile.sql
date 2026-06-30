-- ─── FUNCTION: drive_insertdownloadinglogforfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertdownloadinglogforfile(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.drive_insertdownloadinglogforfile(
    fileno bigint,
    userno integer,
    datedownloaded timestamp without time zone
) RETURNS TABLE(
    logno text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	INSERT INTO Drive_DownloadingLogsForFile (FileNo, UserNo, DateDownloaded)
	VALUES (FileNo, UserNo, DateDownloaded)


	SET LogNo = lastval()

	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
