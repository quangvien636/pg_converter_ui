-- ─── PROCEDURE→FUNCTION: formbuilder_getform ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.formbuilder_getform(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.formbuilder_getform(
    IN currentpage integer,
    IN itemsperpage integer,
    IN categoryid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Keyword <> '' THEN
		Keyword := '%' || Keyword || '%';
	END IF;

	-- EAPPTreeItem
	WITH Items AS 
	(
		CREATE TEMP TABLE Categories AS SELECT ParentID, ID
		FROM EAPPTreeItem
		WHERE (CASE WHEN CategoryID > 0 AND ID = formbuilder_getform.categoryid THEN 1 WHEN CategoryID = 0 THEN 1 ELSE 0 END) = 1
		UNION ALL
		SELECT A.ParentID, A.ID
		FROM EAPPTreeItem A
		INNER JOIN Items B ON (A.ID = B.ParentID)
		WHERE (CASE WHEN CategoryID = 0 THEN 0 ELSE 1 END) = 1
	)

	RETURN QUERY
	SELECT * FROM Items

	IF CategoryID = 0 THEN;
		INSERT INTO Categories VALUES (0, 0)
	END IF;

	-- 조회갯수

	SELECT  INTO  FROM EAPPForm A
	JOIN Categories B ON (A.CategoryID = B.ID)
	WHERE IsDelete = '0' AND
	(
		CASE WHEN Keyword = '' THEN Keyword
		ELSE Name END
	) ILIKE Keyword
	RETURN QUERY
	SELECT TotalCnt AS Cnt
	
	IF ItemsPerPage = 0 THEN
		ItemsPerPage := TotalCnt;
	END IF;

	-- 목록
	RETURN QUERY
	SELECT Num, ID, SeqNo, Name, StorePeriod, ErpType,Content, Width, Height, RegDate
	FROM
	(
		SELECT ROW_NUMBER() OVER ( ORDER BY SeqNo ASC) AS Num,
		A.ID, B.ID AS CategoryID, SeqNo, Name, StorePeriod, ErpType, Content, Width, Height, RegDate
		FROM EAPPForm A
		JOIN Categories B ON (A.CategoryID = B.ID)
		WHERE IsDelete = '0' AND
		(
			CASE WHEN Keyword = '' THEN Keyword
			ELSE Name END
		) ILIKE Keyword
	) R
	WHERE R.Num BETWEEN ((CurrentPage - 1) * ItemsPerPage + 1) AND (CurrentPage * ItemsPerPage)

	DROP TABLE Categories;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
