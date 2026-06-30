-- ─── PROCEDURE→FUNCTION: strategic_getprenextcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.strategic_getprenextcontent(integer, integer);
CREATE OR REPLACE FUNCTION public.strategic_getprenextcontent(
    IN contentno integer,
    IN boardno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	,
	ContentNo bigint,
	BoardNo int,
	BoardName nvarchar(200),
	ModUserNo int,
	ModUserName nvarchar(200),
	ModPositionNo int,
	ModPositionName nvarchar(200),
	ModDepartNo int,
	ModDepartName nvarchar(200),
	RegDate datetime,
	Title nvarchar(500),
	TitleEffect int,
	GroupNo bigint,
	Depth int,
	OrderNo int,
	HeadNo int,
	IsNotice bit,
	IsFile bit,
	FileCount int,
	ReplyCount int,
	RecommendedCount int,
	ViewedCount int,
	HeadName nvarchar(200),
	IsRecommended bit,
	IsAlarm bit
	)

	insert into tempTable
	RETURN QUERY
	SELECT /* TOP 1 */ '0', BC.ContentNo,BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
		BC.ModPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
		 BC.ModDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
		BC.RegDate,
		-- BC.ModDate,
		  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
		  -- BC.Content,
		   BC.IsFile, BC.FileCount,
		BC.ReplyCount, 
		BC.RecommendedCount,
		 BC.ViewedCount,
		 --, BC.StartDate, BC.EndDate,
		
		COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

		--,BC.RegUserNo, 
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		--BC.RegPositionNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		-- BC.RegDepartNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
	FROM Strategic_Contents BC
	LEFT JOIN Strategic_Heads BH ON BH.HeadNo = BC.HeadNo	
	WHERE BC.ContentNo < strategic_getprenextcontent.contentno and BC.BoardNo = strategic_getprenextcontent.boardno
	order by BC.ContentNo desc


	insert into tempTable
	RETURN QUERY
	SELECT /* TOP 1 */ '1', BC.ContentNo, BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
		BC.ModPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
		 BC.ModDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
		BC.RegDate,
		-- BC.ModDate,
		  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
		  -- BC.Content,
		   BC.IsFile, BC.FileCount,
		BC.ReplyCount, 
		BC.RecommendedCount,
		 BC.ViewedCount,
		 --, BC.StartDate, BC.EndDate,
		
		COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

		--,BC.RegUserNo, 
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		--BC.RegPositionNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		-- BC.RegDepartNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
	FROM Strategic_Contents BC
	LEFT JOIN Strategic_Heads BH ON BH.HeadNo = BC.HeadNo	
	WHERE BC.ContentNo > strategic_getprenextcontent.contentno and BC.BoardNo = strategic_getprenextcontent.boardno
	order by BC.ContentNo asc

	RETURN QUERY
	select * from tempTable;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
