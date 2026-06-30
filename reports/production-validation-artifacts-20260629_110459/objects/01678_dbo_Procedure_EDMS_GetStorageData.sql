-- ─── PROCEDURE→FUNCTION: edms_getstoragedata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.edms_getstoragedata(bigint, integer, bigint);
CREATE OR REPLACE FUNCTION public.edms_getstoragedata(
    IN docid bigint,
    IN divid integer,
    IN folderid bigint
) RETURNS SETOF record
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
