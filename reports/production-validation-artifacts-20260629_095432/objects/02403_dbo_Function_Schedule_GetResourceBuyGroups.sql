-- ─── FUNCTION: schedule_getresourcebuygroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcebuygroups(integer, integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcebuygroups(
    categoryno integer,
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1,
    searchmode integer DEFAULT 0,
    searchtext character varying DEFAULT '',
    searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF SearchMode = 0 -- 전체
	BEGIN
		RETURN QUERY
		SELECT 
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY AA.BuyGroupNo DESC) AS RowNum,
				AA.*
			FROM
			(
				SELECT
					G.BuyGroupNo,
					(SELECT /* TOP 1 */ Name FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS ResourceName,
					(SELECT /* TOP 1 */ CategoryNo FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS CategoryNo,
					G.BuyQty,
					G.BuyAmount,
					G.CompanyName,
					G.BuyDate,
					G.RegDate,
					G.MainManagerNo,
					public."COMNGetUserName"(G.MainManagerNo) As MainManagerName
				FROM ScheduleResourcesBuyGroup G
			) AA
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroups.categoryno)
			AND (
				AA.ResourceName ILIKE '%' || SearchText || '%' OR
				AA.CompanyName ILIKE '%' || SearchText || '%' OR
				AA.MainManagerName ILIKE '%' || SearchText || '%'
				)			
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 1 -- 자원명
	BEGIN
		RETURN QUERY
		SELECT 
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY AA.BuyGroupNo DESC) AS RowNum,
				AA.*
			FROM
			(
				SELECT
					G.BuyGroupNo,
					(SELECT /* TOP 1 */ Name FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS ResourceName,
					(SELECT /* TOP 1 */ CategoryNo FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS CategoryNo,
					G.BuyQty,
					G.BuyAmount,
					G.CompanyName,
					G.BuyDate,
					G.RegDate,
					G.MainManagerNo,
					public."COMNGetUserName"(G.MainManagerNo) As MainManagerName
				FROM ScheduleResourcesBuyGroup G
			) AA
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroups.categoryno)
			AND AA.ResourceName ILIKE '%' || SearchText || '%'			
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize) 
	END
	ELSE IF SearchMode = 2 -- 구입업체
	BEGIN
		RETURN QUERY
		SELECT 
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY AA.BuyGroupNo DESC) AS RowNum,
				AA.*
			FROM
			(
				SELECT
					G.BuyGroupNo,
					(SELECT /* TOP 1 */ Name FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS ResourceName,
					(SELECT /* TOP 1 */ CategoryNo FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS CategoryNo,
					G.BuyQty,
					G.BuyAmount,
					G.CompanyName,
					G.BuyDate,
					G.RegDate,
					G.MainManagerNo,
					public."COMNGetUserName"(G.MainManagerNo) As MainManagerName
				FROM ScheduleResourcesBuyGroup G
			) AA
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroups.categoryno)
			AND AA.CompanyName ILIKE '%' || SearchText || '%'
							
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize) 
	END
	ELSE IF SearchMode = 3 -- 구입일
	BEGIN
		RETURN QUERY
		SELECT 
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY AA.BuyGroupNo DESC) AS RowNum,
				AA.*
			FROM
			(
				SELECT
					G.BuyGroupNo,
					(SELECT /* TOP 1 */ Name FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS ResourceName,
					(SELECT /* TOP 1 */ CategoryNo FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS CategoryNo,
					G.BuyQty,
					G.BuyAmount,
					G.CompanyName,
					G.BuyDate,
					G.RegDate,
					G.MainManagerNo,
					public."COMNGetUserName"(G.MainManagerNo) As MainManagerName
				FROM ScheduleResourcesBuyGroup G
			) AA
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroups.categoryno)
			AND AA.BuyDate BETWEEN CONVERT(DATE, SearchText) AND CONVERT(DATE,SearchText2)
		
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize) 
	END
	
	ELSE IF SearchMode = 4 -- 자원관리자
	BEGIN
		RETURN QUERY
		SELECT 
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY AA.BuyGroupNo DESC) AS RowNum,
				AA.*
			FROM
			(
				SELECT
					G.BuyGroupNo,
					(SELECT /* TOP 1 */ Name FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS ResourceName,
					(SELECT /* TOP 1 */ CategoryNo FROM ScheduleResources R WHERE R.BuyGroupNo = G.BuyGroupNo) AS CategoryNo,
					G.BuyQty,
					G.BuyAmount,
					G.CompanyName,
					G.BuyDate,
					G.RegDate,
					G.MainManagerNo,
					public."COMNGetUserName"(G.MainManagerNo) As MainManagerName
				FROM ScheduleResourcesBuyGroup G
			) AA
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroups.categoryno)
			AND AA.MainManagerName ILIKE '%' || SearchText || '%'
		
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize) 
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
