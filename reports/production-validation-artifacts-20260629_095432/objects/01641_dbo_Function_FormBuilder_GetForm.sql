-- ─── FUNCTION: formbuilder_getform ───────────────────────────────
DROP FUNCTION IF EXISTS public.formbuilder_getform(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.formbuilder_getform(
    currentpage integer,
    itemsperpage integer,
    categoryid integer
) RETURNS TABLE(
    num text,
    id text,
    categoryid text,
    seqno text,
    name text,
    storeperiod text,
    erptype text,
    content text,
    width text,
    height text,
    regdate text
)
AS $function$
BEGIN


	IF Keyword <> ''
	BEGIN
		SET Keyword = '%' || Keyword || '%';
	END;

	-- EAPPTreeItem
	WITH Items AS 
	(
		SELECT ParentID, ID
		FROM EAPPTreeItem
		WHERE (CASE WHEN CategoryID > 0 AND ID = formbuilder_getform.categoryid THEN 1 WHEN CategoryID = 0 THEN 1 ELSE 0 END) = 1
		UNION ALL
		SELECT A.ParentID, A.ID
		FROM EAPPTreeItem A
		INNER JOIN Items B ON (A.ID = B.ParentID)
		WHERE (CASE WHEN CategoryID = 0 THEN 0 ELSE 1 END) = 1
	)

	RETURN QUERY
	SELECT * INTO #Categories FROM Items

	IF CategoryID = 0
	BEGIN;
		INSERT INTO #Categories VALUES (0, 0)
	END

	-- 조회갯수

	SELECT TotalCnt = COUNT(*)
	FROM EAPPForm A
	JOIN #Categories B ON (A.CategoryID = B.ID)
	WHERE IsDelete = '0' AND
	(
		CASE WHEN Keyword = '' THEN Keyword
		ELSE Name END
	) ILIKE Keyword
	RETURN QUERY
	SELECT TotalCnt AS Cnt
	
	IF ItemsPerPage = 0
	BEGIN
		SET ItemsPerPage = TotalCnt
	END

	-- 목록
	RETURN QUERY
	SELECT Num, ID, SeqNo, Name, StorePeriod, ErpType,Content, Width, Height, RegDate
	FROM
	(
		SELECT ROW_NUMBER() OVER ( ORDER BY SeqNo ASC) AS Num,
		A.ID, B.ID AS CategoryID, SeqNo, Name, StorePeriod, ErpType, Content, Width, Height, RegDate
		FROM EAPPForm A
		JOIN #Categories B ON (A.CategoryID = B.ID)
		WHERE IsDelete = '0' AND
		(
			CASE WHEN Keyword = '' THEN Keyword
			ELSE Name END
		) ILIKE Keyword
	) R
	WHERE R.Num BETWEEN ((CurrentPage - 1) * ItemsPerPage + 1) AND (CurrentPage * ItemsPerPage)

	DROP TABLE #Categories;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
