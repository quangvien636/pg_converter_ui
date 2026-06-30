-- ─── PROCEDURE→FUNCTION: schedule_getresourcebuygroupscount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getresourcebuygroupscount(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcebuygroupscount(
    IN categoryno integer,
    IN searchmode integer DEFAULT 0,
    IN searchtext character varying DEFAULT '',
    IN searchtext2 character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF SearchMode = 0 -- 전체 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
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
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroupscount.categoryno)
			AND (
				AA.ResourceName ILIKE '%' || SearchText || '%' OR
				AA.CompanyName ILIKE '%' || SearchText || '%' OR
				AA.MainManagerName ILIKE '%' || SearchText || '%'
				)			
		) A
	END IF;
	ELSIF SearchMode = 1 -- 자원명 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
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
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroupscount.categoryno)
			AND AA.ResourceName ILIKE '%' || SearchText || '%'			
		) A
	END IF;
	ELSIF SearchMode = 2 -- 구입업체 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
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
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroupscount.categoryno)
			AND AA.CompanyName ILIKE '%' || SearchText || '%'
							
		) A
	END IF;
	ELSIF SearchMode = 3 -- 구입일 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
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
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroupscount.categoryno)
			AND AA.BuyDate BETWEEN CONVERT(DATE, SearchText) AND CONVERT(DATE,SearchText2)
		
		) A
	END IF;
	
	ELSIF SearchMode = 4 -- 자원관리자 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
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
			WHERE (CategoryNo = 0 OR AA.CategoryNo = schedule_getresourcebuygroupscount.categoryno)
			AND AA.MainManagerName ILIKE '%' || SearchText || '%'
		) A
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
