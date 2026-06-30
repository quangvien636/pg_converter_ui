-- ─── PROCEDURE→FUNCTION: drive_countfilefromforderno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.drive_countfilefromforderno(bigint);
CREATE OR REPLACE FUNCTION public.drive_countfilefromforderno(
    IN folderno bigint
) RETURNS void
AS $function$
BEGIN


	WITH cte AS 
	 (
		  CREATE TEMP TABLE tam AS SELECT FolderNo, ParentNo, Name
		  FROM Drive_Folders a
		  WHERE FolderNo = drive_countfilefromforderno.folderno
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo, a.Name
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo  AND IsDeleted = FALSE
	  )
	 -- select FolderNo FROM cte where  FolderNo != FolderNo

	  select count(1) as CountFile from Drive_Files where IsDeleted = FALSE and FolderNo in (select FolderNo from  cte t);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
