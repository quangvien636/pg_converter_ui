-- ─── FUNCTION: drive_moveupcommon ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_moveupcommon(bigint, integer);
CREATE OR REPLACE FUNCTION public.drive_moveupcommon(
    p_fno bigint,
    p_uno integer
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
AS $function$
BEGIN
	
	with name_tree as 
		(
 			SELECT d.DepartNo, d.ParentNo
			FROM Organization_Departments d
			WHERE d.DepartNo IN (
				SELECT b.DepartNo FROM Organization_BelongToDepartment  b
				WHERE b.UserNo = drive_moveupcommon.p_uno
			)
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.DepartNo = P.ParentNo  
			AND C.DepartNo<>C.ParentNo 
		),
	 cte As
	 (
		SELECT F.FolderNo
				,F.sort
				,ROW_NUMBER() OVER (ORDER BY COALESCE(f.Sort,0) ASC, f.DateModified ASC) AS RN
		FROM Drive_CommonFolders  CF
		INNER JOIN Drive_Folders  F ON F.FolderNo = CF.FolderNo
		WHERE CF.FolderNo IN (
			SELECT SFCF.FolderNo FROM Drive_SharingForCommonFolders SFCF
			WHERE SFCF.DepartNo IN (SELECT DepartNo FROM name_tree) OR UserNo = drive_moveupcommon.p_uno
		)
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Drive_Folders set Sort = Sort - 1.01 Where FolderNo =  drive_moveupcommon.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
