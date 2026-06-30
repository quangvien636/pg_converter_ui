-- ─── FUNCTION: drive_movedown ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_movedown();
CREATE OR REPLACE FUNCTION public.drive_movedown(
) RETURNS TABLE(
    folderno bigserial,
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    name character varying(255),
    length bigint,
    parentno bigint,
    isdeleted boolean,
    sort double precision,
    note character varying(500)
)
AS $function$
BEGIN


	With cte As
	(
		SELECT FolderNo,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, DateModified ASC) AS RN
		FROM Drive_Folders where ParentNo = parentid AND IsDeleted = FALSE
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Drive_Folders set Sort = Sort + 1.01 Where FolderNo =  p_Fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
