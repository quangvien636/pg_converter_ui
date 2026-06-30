-- ─── FUNCTION: drive_getpemissioncommonfoldersbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getpemissioncommonfoldersbyuser(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_getpemissioncommonfoldersbyuser(
    p_uno bigint,
    p_dno bigint
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN




		DepartNo INT
	);

	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = drive_getpemissioncommonfoldersbyuser.p_uno or  DepartNo = drive_getpemissioncommonfoldersbyuser.p_dno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) ;
	insert into DepartNos
	RETURN QUERY
	select DepartNo from name_tree

	RETURN QUERY
	SELECT SharingNo, FolderNo, UserNo, DepartNo
	FROM Drive_PemissionCommonFolders
	WHERE UserNo = drive_getpemissioncommonfoldersbyuser.p_uno Or DepartNo in(SELECT DepartNo FROM DepartNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
