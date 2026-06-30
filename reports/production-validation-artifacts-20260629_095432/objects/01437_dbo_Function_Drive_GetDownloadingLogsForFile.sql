-- ─── FUNCTION: drive_getdownloadinglogsforfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getdownloadinglogsforfile(bigint);
CREATE OR REPLACE FUNCTION public.drive_getdownloadinglogsforfile(
    fileno bigint
) RETURNS TABLE(
    logno text,
    fileno text,
    userno text,
    datedownloaded text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LogNo, FileNo, UserNo, DateDownloaded
	FROM Drive_DownloadingLogsForFile
	WHERE FileNo = drive_getdownloadinglogsforfile.fileno
	ORDER BY LogNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
