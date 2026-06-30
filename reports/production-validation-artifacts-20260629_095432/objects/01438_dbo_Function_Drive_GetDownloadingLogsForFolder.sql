-- ─── FUNCTION: drive_getdownloadinglogsforfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getdownloadinglogsforfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getdownloadinglogsforfolder(
    folderno bigint
) RETURNS TABLE(
    logno text,
    folderno text,
    userno text,
    datedownloaded text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LogNo, FolderNo, UserNo, DateDownloaded
	FROM Drive_DownloadingLogsForFolder
	WHERE FolderNo = drive_getdownloadinglogsforfolder.folderno
	ORDER BY LogNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
