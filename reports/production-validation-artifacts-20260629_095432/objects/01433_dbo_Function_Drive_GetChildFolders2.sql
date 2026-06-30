-- ─── FUNCTION: drive_getchildfolders2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getchildfolders2(bigint);
CREATE OR REPLACE FUNCTION public.drive_getchildfolders2(
    folderno bigint
) RETURNS void
AS $function$
BEGIN


	SELECT R.FolderNo, R.UserNo, R.DateCreated, R.DateModified, R.Name, R.Length, R.ParentNo, R.IsDeleted,R.Sort
	, COALESCE(r.Note,'') Note 
	, public."Drive_CountFiles"(R.FolderNo) as FileCount
	into #tam
	FROM Drive_Folders  R
	WHERE R.ParentNo = drive_getchildfolders2.folderno AND R.IsDeleted = FALSE

	SELECT R.*,
		CASE
			WHEN (SELECT COUNT(*) FROM Drive_SharingForFolders WHERE FolderNo = R.FolderNo) = 0 THEN FALSE
			ELSE TRUE
		END AS IsShared
	FROM #tam AS R ORDER BY COALESCE(R.Sort,0) ASC, R.DateModified ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
