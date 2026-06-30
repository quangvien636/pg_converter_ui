-- ─── FUNCTION: drive_insertdownloadinglogforfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertdownloadinglogforfolder(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.drive_insertdownloadinglogforfolder(
    folderno bigint,
    userno integer,
    datedownloaded timestamp without time zone
) RETURNS TABLE(
    logno text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	INSERT INTO Drive_DownloadingLogsForFolder (FolderNo, UserNo, DateDownloaded)
	VALUES (FolderNo, UserNo, DateDownloaded)


	SET LogNo = lastval()

	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
