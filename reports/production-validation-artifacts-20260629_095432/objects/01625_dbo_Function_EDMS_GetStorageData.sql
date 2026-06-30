-- ─── FUNCTION: edms_getstoragedata ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getstoragedata(bigint, integer, bigint);
CREATE OR REPLACE FUNCTION public.edms_getstoragedata(
    docid bigint,
    divid integer,
    folderid bigint
) RETURNS TABLE(
    id text,
    name text,
    col3 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF((FolderId IS NULL) OR (FolderId = ''))
		RETURN QUERY
		SELECT
			/* TOP 1 */
			COALESCE(result.Name, '') AS Name
		FROM
		(
			SELECT
				b.ID,
				b.ItemNm1 AS Name,
				(
					SELECT
						COUNT(d.ID)
					FROM 
						EDMSDocFolder c
					INNER JOIN 
						edmstreeitem d
					ON 
						c.FolderID = d.ID
					WHERE 
						c.DocID = edms_getstoragedata.docid
						AND d.DivID = edms_getstoragedata.divid
				) AS idx
			FROM
				EDMSDocFolder a
			INNER JOIN
				EDMSTreeItem b
			ON
				a.FolderId = b.ID
			WHERE 
				DocID = edms_getstoragedata.docid
				AND b.DivId = edms_getstoragedata.divid
		) result
	ELSE
		RETURN QUERY
		SELECT
			result.ID,
			COALESCE(result.Name, '') AS Name
		FROM
		(
			SELECT
				b.ID,
				b.ItemNm1 AS Name,
				(
					SELECT
						COUNT(d.ID)
					FROM 
						EDMSDocFolder c
					INNER JOIN 
						edmstreeitem d
					ON 
						c.FolderID = d.ID
					WHERE 
						c.DocID = edms_getstoragedata.docid
						AND d.DivID = edms_getstoragedata.divid
				) AS idx
			FROM
				EDMSDocFolder a
			INNER JOIN
				EDMSTreeItem b
			ON
				a.FolderId = b.ID
			WHERE 
				DocID = edms_getstoragedata.docid
				AND b.DivId = edms_getstoragedata.divid
		) result
		WHERE
			result.ID = edms_getstoragedata.folderid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
