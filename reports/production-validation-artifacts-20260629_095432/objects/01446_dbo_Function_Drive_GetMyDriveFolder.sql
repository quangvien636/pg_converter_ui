-- ─── FUNCTION: drive_getmydrivefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getmydrivefolder(integer);
CREATE OR REPLACE FUNCTION public.drive_getmydrivefolder(
    userno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Drive_Folders WHERE UserNo = drive_getmydrivefolder.userno AND ParentNo = -1) = 0 BEGIN

		INSERT INTO Drive_Folders (UserNo, DateCreated, DateModified, Name, Length, ParentNo, IsDeleted)
		VALUES (UserNo, GETUTCDATE(), GETUTCDATE(), 'my', 0, -1, 0)

	END;

	WITH cte AS 
	 (
		  SELECT FolderNo, ParentNo
		  FROM Drive_Folders a
		  WHERE FolderNo = (SELECT /* TOP 1 */ FolderNo
							FROM Drive_Folders 
							WHERE UserNo = drive_getmydrivefolder.userno AND ParentNo = -1)
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo -- AND IsDeleted = FALSE
	  ) 
	select * into #tam2 from cte

	SELECT FolderNo, UserNo, DateCreated, DateModified, Name
	, Length = COALESCE((select SUM(Length) from Drive_Files
	where FolderNo in ( select FolderNo from #tam2)),0)
	, ParentNo, IsDeleted
	FROM Drive_Folders WHERE UserNo = drive_getmydrivefolder.userno AND ParentNo = -1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
