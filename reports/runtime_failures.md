# Runtime failures

## `board_getallboardcontentsbyboardlist`

- Input: `0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getallboardcontentsbyboardlist"(0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `22012`
- Error: division by zero
- Stack context: PL/pgSQL function board_getallboardcontentsbyboardlist(integer,character varying,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 115 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallboardcontentsbyboardlist(_userno integer, _boardlist character varying, _sortcolumn integer, _isascending boolean, _countperpage integer, _currentpageindex integer, _languagesign character varying, _filtertype integer, _fromdate timestamp without time zone, _todate timestamp without time zone, _typeeff integer DEFAULT 0, _isalarm boolean DEFAULT false, _isadmin boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _query character varying;
    _stralow character varying;
    _strwritealow character varying;
    _departno integer;
    _totalitemcount integer;
    _totalpagecount integer;
    _startrownum integer;
    _endrownum integer;
    _ishead boolean;
    _isnotice boolean;
    _isrecommend boolean;
    _recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	_Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	_strAlow := '';
	_strWriteAlow := '';
	IF _IsAdmin = FALSE THEN
		_strAlow := ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo ';
		_strWriteAlow := '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(_UserNo AS text) || ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF _SortColumn <= 1 THEN
	    _query := COALESCE(_query, '') || COALESCE(('RegDate '), '');
	ELSIF _SortColumn = 2 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF _SortColumn = 3 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(BB.Name) '), '');
	ELSIF _SortColumn = 4 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF _SortColumn = 5 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF _SortColumn  = 6 THEN
	    _query := COALESCE(_query, '') || COALESCE(('ViewedCount '), '');
	ELSIF _SortColumn = 7 THEN
	    _query := COALESCE(_query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF _IsAscending = TRUE THEN
	    _query := COALESCE(_query, '') || COALESCE(('ASC '), '');
	ELSE
	    _query := COALESCE(_query, '') || COALESCE(('DESC '), '');
	END IF;


	_query := COALESCE(_query, '') || COALESCE((', OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	_query := COALESCE(_query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || _strAlow || '
WHERE  ' || _strWriteAlow || ' BB.Enabled = TRUE AND  BC.Enabled = TRUE
AND  ''' || _BoardList || ''' ILIKE ( ''%,'' || CAST(BB.BoardNo AS text) || '',%'') '), '');
	_query := COALESCE(_query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(_ToDate AS text) || '''  '), '');

	_query := COALESCE(_query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(_ToDate AS text) || ''' ) > 0 ) '), '');

	IF _TypeEff > 0 THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF _IsAlarm = TRUE THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
    IF _FilterType <> 100 THEN
		_query := COALESCE(_query, '') || COALESCE(('AND BC.RegUserNo <> ' || CAST(_UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(_UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;

	IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = board_getallboardcontentsbyboardlist._userno), 0) <> 1 THEN

		_query := COALESCE(_query, '') || COALESCE(('		AND (RegDepartNo = ' || CAST(_DepartNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(_DepartNo AS text) || '))'), '');
	END IF;

	/*
	 * 게시글 검색 시작
	 */
	CREATE TEMP TABLE _SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	EXECUTE 'INSERT INTO _SearchResult ' || _query;
	/*
	 * 페이징 계산
	 */






	_TotalItemCount := (SELECT COUNT(*) FROM _SearchResult);
	_TotalPageCount := _TotalItemCount / _CountPerPage;
	IF _TotalPageCount % _CountPerPage > 0 THEN
	    _TotalPageCount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	_StartRowNum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_EndRowNum := board_getallboardcontentsbyboardlist._currentpageindex * _CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE _TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO _ishead, _isnotice, _isrecommend, _recommendeddisplaycount FROM Board_Boards;


	INSERT INTO _TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
		WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum
		ORDER BY T.RowNum ASC;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getallboardcontentsbyboardlist._userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM _TempTable As BC;
	RETURN QUERY
	SELECT _TotalItemCount AS TotalContentCount, _TotalPageCount AS TotalPageCount, _CurrentPageIndex AS CurrentPageIndex;
END;
$function$

```
</details>

## `board_getboardcontents`

- Input: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getboardcontents"(0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42601`
- Error: syntax error at or near "$1"
- Stack context: PL/pgSQL function board_getboardcontents(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 121 at EXECUTE statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcontents(_userno integer DEFAULT 70, _boardno integer DEFAULT 53, _sortcolumn integer DEFAULT 1, _isascending boolean DEFAULT false, _countperpage integer DEFAULT 1, _currentpageindex integer DEFAULT 10, _languagesign character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2019-01-01 19:20:19.717'::timestamp without time zone, _typeeff integer DEFAULT 0, _isalarm boolean DEFAULT false, _isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _query character varying;
    _stralow character varying;
    _strwritealow character varying;
    _totalitemcount integer;
    _totalpagecount integer;
    _startrownum integer;
    _endrownum integer;
    _ishead boolean;
    _isnotice boolean;
    _isrecommend boolean;
    _recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


/*
	 * 쿼리 조합 시작
	 */


	_query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	_stralow := '';
	_strwritealow := '';
	IF _IsAdmin = FALSE THEN
		_stralow := ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		_strwritealow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(_UserNo AS text) || ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF _SortColumn <= 1 THEN
	    _query := COALESCE(_query, '') || COALESCE(('(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '), '');
	ELSIF _SortColumn = 2 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF _SortColumn = 3 THEN
	    _query := COALESCE(_query, '') || COALESCE(('RegDate '), '');
	ELSIF _SortColumn = 4 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF _SortColumn = 5 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF _SortColumn  = 6 THEN
	    _query := COALESCE(_query, '') || COALESCE(('ViewedCount '), '');
	ELSIF _SortColumn = 7 THEN
	    _query := COALESCE(_query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF _IsAscending = TRUE THEN
	    _query := COALESCE(_query, '') || COALESCE(('ASC '), '');
	-- Nghiem edit 2018-09-20 change DESC -> ASC
	ELSE
	    _query := COALESCE(_query, '') || COALESCE(('DESC '), '');
	END IF;


	_query := COALESCE(_query, '') || COALESCE((', BC.LevelRand || CAST(BC.ContentNo As text) ASC, OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	_query := COALESCE(_query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents BC   INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || _strAlow || '
WHERE  ' || _strWriteAlow || '  BC.BoardNo = BoardNo AND BC.Enabled = TRUE '), '');

	_query := COALESCE(_query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(_ToDate AS text) || '''  '), '');

	_query := COALESCE(_query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(_ToDate AS text) || ''' ) > 0 ) '), '');

	IF _TypeEff > 0 THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF _IsAlarm = TRUE THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF _FilterType <> 100 THEN
		_query := COALESCE(_query, '') || COALESCE(('AND BC.RegUserNo <> ' || CAST(_UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(_UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;


	IF _IsAdmin = FALSE THEN

		--SET Query +=' AND BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (' || CAST(UserNo AS text) || ') DP ON DP.DepartNo= BS1.DepartNo)'

	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 );
		_query := COALESCE(_query, '') || COALESCE(('  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR ( BC.RegUserNo = ' || CAST(_UserNo AS text) || ') OR (BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (' || CAST(_UserNo AS text) || ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CAST(_UserNo  AS text) || ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'), '');
		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CAST(UserNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	--END
	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CAST(DepartNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	END IF;

	/*
	 * 게시글 검색 시작
	 */

	 RAISE NOTICE '%', _Query;
	CREATE TEMP TABLE _SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	_Query := regexp_replace(_Query, '\yBoardNo\y', '$1', 'gi');
	EXECUTE 'INSERT INTO _SearchResult ' || _Query USING _BoardNo;
	/*
	 * 페이징 계산
	 */






	_totalitemcount := (SELECT COUNT(*) FROM _SearchResult);
	_totalpagecount := _TotalItemCount / _CountPerPage;
	IF _TotalItemCount % _CountPerPage > 0 THEN
	    _totalpagecount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _totalpagecount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	_startrownum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_endrownum := board_getboardcontents._currentpageindex * _CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE _TempTable (
		RN INT,
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO _ishead, _isnotice, _isrecommend, _recommendeddisplaycount FROM Board_Boards WHERE BoardNo = board_getboardcontents._boardno;


	IF _IsHead = TRUE THEN

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
			 BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents._boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents._boardno AND BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents._boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents._boardno AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents._boardno) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE;


	ELSE

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents._boardno AND BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents._boardno AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE;


	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboardcontents._userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM _TempTable As BC ORDER BY RN ASC;
	RETURN QUERY
	SELECT _TotalItemCount AS TotalContentCount, _TotalPageCount AS TotalPageCount, _CurrentPageIndex AS CurrentPageIndex;


	--/*
	-- * 쿼리 조합 시작
	-- */

	--DECLARE Query NVARCHAR(2000)
	--SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	--DECLARE strAlow NVARCHAR(2000)
	--DECLARE strWriteAlow NVARCHAR(2000)
	--SET strAlow = ''
	--SET strWriteAlow = ''
	--if (IsAdmin = FALSE)
	--BEGIN
	--	SET strAlow = ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo '
	--	SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(UserNo AS text) || ' )) AND '
	--END

	--/*
	-- * 정렬 컬럼
	-- */

	--IF (SortColumn <= 1) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	--ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	--ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	--ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	--ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	--/*
	-- * 정렬 내림차순 여부
	-- */

	--IF (IsAscending = TRUE) SET Query += 'ASC '
	--ELSE SET Query += 'DESC '


	--SET Query += ', OrderNo ASC'



	--/*
	-- * WHERE 조합 시작
	-- */

	--SET Query +=
	--	') RowNum, ContentNo, Content ' ||
	--	'FROM Board_Contents BC
	--		' || strAlow || '
	--		WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND Enabled = TRUE '

	--SET Query +=  ' AND ( BC.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(ToDate AS text) || '''  '

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(ToDate AS text) || ''' ) > 0 ) '

	--IF (TypeEff > 0)
	--BEGIN
	--	SET Query += ' AND BC.TitleEffect <> 2 '
	--END
	--IF (IsAlarm = TRUE)
	--BEGIN
	--	SET Query += ' AND BC.IsAlarm = TRUE '
	--END
	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CAST(UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CAST(DepartNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	--END

	--/*
	-- * 게시글 검색 시작
	-- */

	--DECLARE SearchResult TABLE (
	--	RowNum		BIGINT,
	--	ContentNo	BIGINT,
	--	Content text
	--)

	--INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL Query,
	--	'BoardNo AS INT',
	--	BoardNo



	--/*
	-- * 페이징 계산
	-- */

	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	----IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage



	--/*
	-- *
	-- */

	--DECLARE TempTable TABLE (
	--	ContentNo			BIGINT,
	--	Content				text,
	--	ModUserNo			INT,
	--	ModUserName			NVARCHAR(100),
	--	ModDepartNo			INT,
	--	ModDepartName		NVARCHAR(100),
	--	RegDate				DATETIME,
	--	Title				NVARCHAR(200),
	--	TitleEffect			INT,
	--	GroupNo				BIGINT,
	--	Depth				INT,
	--	OrderNo				INT,
	--	HeadNo				INT,
	--	IsNotice			BIT,
	--	IsFile				BIT,
	--	ReplyCount			INT,
	--	RecommendedCount	INT,
	--	ViewedCount			INT,

	--	HeadName			NVARCHAR(100),
	--	IsRecommended		BIT,
	--	ModPositionNo		INT,
	--	ModPositionName		nvarchar(100),
	--	FileCount			INT,
	--	BoardNo				INT,
	--	BoardName			nvarchar(100),
	--	RegUserNo			INT,
	--	RegUserName			NVARCHAR(100),
	--	RegPositionNo		INT,
	--	RegPositionName		nvarchar(100),
	--	RegDepartNo			INT,
	--	RegDepartName		NVARCHAR(100),
	--	IsAlarm				BIT
	--)

	--DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
	--DECLARE RecommendedDisplayCount INT

	--SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	--FROM Board_Boards WHERE BoardNo = BoardNo

	--IF (IsHead = TRUE) BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo,( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--		 BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm

	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.IsNotice = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--ELSE BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.IsNotice = TRUE AND BC.Enabled = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	--SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$

```
</details>

## `board_getboardcontents_bk20181227`

- Input: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getboardcontents_bk20181227"(0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42601`
- Error: syntax error at or near "$1"
- Stack context: PL/pgSQL function board_getboardcontents_bk20181227(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 121 at EXECUTE statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcontents_bk20181227(_userno integer DEFAULT 70, _boardno integer DEFAULT 53, _sortcolumn integer DEFAULT 1, _isascending boolean DEFAULT true, _countperpage integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _languagesign character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 1, _fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, _typeeff integer DEFAULT 0, _isalarm boolean DEFAULT false, _isadmin boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _query character varying;
    _stralow character varying;
    _strwritealow character varying;
    _totalitemcount integer;
    _totalpagecount integer;
    _startrownum integer;
    _endrownum integer;
    _ishead boolean;
    _isnotice boolean;
    _isrecommend boolean;
    _recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


/*
	 * 쿼리 조합 시작
	 */


	_query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	_stralow := '';
	_strwritealow := '';
	IF _IsAdmin = FALSE THEN
		_stralow := ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		_strwritealow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(_UserNo AS text) || ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF _SortColumn <= 1 THEN
	    _query := COALESCE(_query, '') || COALESCE(('(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '), '');
	ELSIF _SortColumn = 2 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF _SortColumn = 3 THEN
	    _query := COALESCE(_query, '') || COALESCE(('RegDate '), '');
	ELSIF _SortColumn = 4 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF _SortColumn = 5 THEN
	    _query := COALESCE(_query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF _SortColumn  = 6 THEN
	    _query := COALESCE(_query, '') || COALESCE(('ViewedCount '), '');
	ELSIF _SortColumn = 7 THEN
	    _query := COALESCE(_query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF _IsAscending = TRUE THEN
	    _query := COALESCE(_query, '') || COALESCE(('ASC '), '');
	-- Nghiem edit 2018-09-20 change DESC -> ASC
	ELSE
	    _query := COALESCE(_query, '') || COALESCE(('DESC '), '');
	END IF;


	_query := COALESCE(_query, '') || COALESCE((', BC.LevelRand || CAST(BC.ContentNo As text) ASC, OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	_query := COALESCE(_query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents BC   INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || _strAlow || '
WHERE  ' || _strWriteAlow || '  BC.BoardNo = BoardNo AND BC.Enabled = TRUE '), '');

	_query := COALESCE(_query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(_ToDate AS text) || '''  '), '');

	_query := COALESCE(_query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(_FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(_ToDate AS text) || ''' ) > 0 ) '), '');

	IF _TypeEff > 0 THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF _IsAlarm = TRUE THEN
		_query := COALESCE(_query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF _FilterType <> 100 THEN
		_query := COALESCE(_query, '') || COALESCE(('AND BC.RegUserNo <> ' || CAST(_UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(_UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;


	IF _IsAdmin = FALSE THEN

		--SET Query +=' AND BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (' || CAST(UserNo AS text) || ') DP ON DP.DepartNo= BS1.DepartNo)'

	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 );
		_query := COALESCE(_query, '') || COALESCE(('  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR ( BC.RegUserNo = ' || CAST(_UserNo AS text) || ') OR (BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (' || CAST(_UserNo AS text) || ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CAST(_UserNo  AS text) || ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'), '');
		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CAST(UserNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	--END
	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CAST(DepartNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	END IF;

	/*
	 * 게시글 검색 시작
	 */

	 RAISE NOTICE '%', _Query;
	CREATE TEMP TABLE _SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	_Query := regexp_replace(_Query, '\yBoardNo\y', '$1', 'gi');
	EXECUTE 'INSERT INTO _SearchResult ' || _Query USING _BoardNo;
	/*
	 * 페이징 계산
	 */






	_totalitemcount := (SELECT COUNT(*) FROM _SearchResult);
	_totalpagecount := _TotalItemCount / _CountPerPage;
	IF _TotalItemCount % _CountPerPage > 0 THEN
	    _totalpagecount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _totalpagecount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	_startrownum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_endrownum := board_getboardcontents_bk20181227._currentpageindex * _CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE _TempTable (
		RN INT,
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO _ishead, _isnotice, _isrecommend, _recommendeddisplaycount FROM Board_Boards WHERE BoardNo = board_getboardcontents_bk20181227._boardno;


	IF _IsHead = TRUE THEN

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
			 BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227._boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227._boardno AND BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227._boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227._boardno AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227._boardno) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE;


	ELSE

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227._boardno AND BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227._boardno AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when _LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE;


	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboardcontents_bk20181227._userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM _TempTable As BC ORDER BY RN ASC;
	RETURN QUERY
	SELECT _TotalItemCount AS TotalContentCount, _TotalPageCount AS TotalPageCount, _CurrentPageIndex AS CurrentPageIndex;


	--/*
	-- * 쿼리 조합 시작
	-- */

	--DECLARE Query NVARCHAR(2000)
	--SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	--DECLARE strAlow NVARCHAR(2000)
	--DECLARE strWriteAlow NVARCHAR(2000)
	--SET strAlow = ''
	--SET strWriteAlow = ''
	--if (IsAdmin = FALSE)
	--BEGIN
	--	SET strAlow = ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo '
	--	SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(UserNo AS text) || ' )) AND '
	--END

	--/*
	-- * 정렬 컬럼
	-- */

	--IF (SortColumn <= 1) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	--ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	--ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	--ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	--ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	--/*
	-- * 정렬 내림차순 여부
	-- */

	--IF (IsAscending = TRUE) SET Query += 'ASC '
	--ELSE SET Query += 'DESC '


	--SET Query += ', OrderNo ASC'



	--/*
	-- * WHERE 조합 시작
	-- */

	--SET Query +=
	--	') RowNum, ContentNo, Content ' ||
	--	'FROM Board_Contents BC
	--		' || strAlow || '
	--		WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND Enabled = TRUE '

	--SET Query +=  ' AND ( BC.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(ToDate AS text) || '''  '

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(ToDate AS text) || ''' ) > 0 ) '

	--IF (TypeEff > 0)
	--BEGIN
	--	SET Query += ' AND BC.TitleEffect <> 2 '
	--END
	--IF (IsAlarm = TRUE)
	--BEGIN
	--	SET Query += ' AND BC.IsAlarm = TRUE '
	--END
	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CAST(UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CAST(DepartNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
	--END

	--/*
	-- * 게시글 검색 시작
	-- */

	--DECLARE SearchResult TABLE (
	--	RowNum		BIGINT,
	--	ContentNo	BIGINT,
	--	Content text
	--)

	--INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL Query,
	--	'BoardNo AS INT',
	--	BoardNo



	--/*
	-- * 페이징 계산
	-- */

	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	----IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage



	--/*
	-- *
	-- */

	--DECLARE TempTable TABLE (
	--	ContentNo			BIGINT,
	--	Content				text,
	--	ModUserNo			INT,
	--	ModUserName			NVARCHAR(100),
	--	ModDepartNo			INT,
	--	ModDepartName		NVARCHAR(100),
	--	RegDate				DATETIME,
	--	Title				NVARCHAR(200),
	--	TitleEffect			INT,
	--	GroupNo				BIGINT,
	--	Depth				INT,
	--	OrderNo				INT,
	--	HeadNo				INT,
	--	IsNotice			BIT,
	--	IsFile				BIT,
	--	ReplyCount			INT,
	--	RecommendedCount	INT,
	--	ViewedCount			INT,

	--	HeadName			NVARCHAR(100),
	--	IsRecommended		BIT,
	--	ModPositionNo		INT,
	--	ModPositionName		nvarchar(100),
	--	FileCount			INT,
	--	BoardNo				INT,
	--	BoardName			nvarchar(100),
	--	RegUserNo			INT,
	--	RegUserName			NVARCHAR(100),
	--	RegPositionNo		INT,
	--	RegPositionName		nvarchar(100),
	--	RegDepartNo			INT,
	--	RegDepartName		NVARCHAR(100),
	--	IsAlarm				BIT
	--)

	--DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
	--DECLARE RecommendedDisplayCount INT

	--SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	--FROM Board_Boards WHERE BoardNo = BoardNo

	--IF (IsHead = TRUE) BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo,( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--		 BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm

	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.IsNotice = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--ELSE BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.IsNotice = TRUE AND BC.Enabled = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	--SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$

```
</details>

## `board_gettreesubmenu_v2_json`

- Input: `0::integer, false, ''::character varying, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_gettreesubmenu_v2_json"(0::integer, false, ''::character varying, 0::integer, 0::integer);`
- SQLSTATE: `42883`
- Error: function parsejson(character varying) does not exist
- Stack context: PL/pgSQL function board_gettreesubmenu_v2_json(integer,boolean,character varying,integer,integer) line 13 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu_v2_json(_userno integer DEFAULT 222, _isadmin boolean DEFAULT false, _langcode character varying DEFAULT 'EN'::character varying, _selectedboardno integer DEFAULT 0, _selectedfolderno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _json character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


DROP TABLE IF EXISTS T;
DROP TABLE IF EXISTS O;
DROP TABLE IF EXISTS BL;

    -- Step 1: Build flat tree data
    CREATE TEMP TABLE T ON COMMIT DROP AS WITH
    DEPARTPERMISSION AS (
        SELECT ItemNo, AllowValue, AllowAccessNo, ItemType,
               ROW_NUMBER() OVER(PARTITION BY ItemNo, UserNo, ItemType ORDER BY ItemNo ASC) AS Rn
        FROM Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE OB.UserNo = board_gettreesubmenu_v2_json._userno AND OB.IsDefault = TRUE
    ),
    History AS (
        SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY BH.UserNo, BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
        FROM Board_HistoryFolder BH WHERE BH.UserNo = board_gettreesubmenu_v2_json._userno
    ),
    FOLDER AS (
        SELECT BF.*, COALESCE(BH.IsOpen, TRUE) AS IsOpen
        FROM Board_Folders BF
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenu_v2_json._userno
        LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo AND BH.RowNum = 1
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1 AND D.Rn = 1
        WHERE BF.Enabled = TRUE
          AND (_IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
    ),
    BOARD AS (
        SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.FolderNo, B.SortNo,
               B.Enabled, B.ViewMode, B.SpecType,
               (SELECT COUNT(*) FROM Board_Contents BC
                WHERE '2020-12-31'::timestamp < BC.RegDate
                  AND BC.BoardNo = B.BoardNo AND BC.Enabled = TRUE
                  AND BC.RegUserNo <> board_gettreesubmenu_v2_json._userno
                  AND BC.ContentNo NOT IN (SELECT BV.ContentNo FROM Board_ViewedLogs BV WHERE BV.UserNo = board_gettreesubmenu_v2_json._userno)
                  AND (_IsAdmin = TRUE OR BA.AllowValue = 7 OR D.AllowValue = 7
                       OR ((BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(_UserNo, 2)) OR B.SpecType = 1)
                           AND (
                               BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1
                                                INNER JOIN public."organization_belongtodepartment" DP
                                                ON DP.DepartNo = BS1.DepartNo AND DP.UserNo = board_gettreesubmenu_v2_json._userno)
                               OR BC.ContentNo IN (SELECT BSS1.ContentNo FROM Board_Sharers BSS1
                                                   WHERE BSS1.ContentNo = BC.ContentNo AND BSS1.UserNo = board_gettreesubmenu_v2_json._userno)
                               OR BC.IsShareAll = TRUE
                           )))
               ) AS CountContent
        FROM Board_Boards B
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenu_v2_json._userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2 AND D.Rn = 1
        WHERE B.Enabled = TRUE
          AND (_IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
    ),
    TREESUB AS (
        SELECT COALESCE(CASE WHEN STRPOS(F.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = board_gettreesubmenu_v2_json._langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'EN')))
                      ELSE F.Name END, '') AS Name,
               F.FolderNo AS No, F.ModUserNo, F.ModDate, F.Name AS JsonName,
               F.ParentNo, F.SortNo,
               TRUE AS IsFolder, F.IsOpen,
               CAST(0 AS BIGINT) AS CountContent, 0 AS ViewMode
        FROM FOLDER F
        UNION ALL
        SELECT COALESCE(CASE WHEN STRPOS(B.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = board_gettreesubmenu_v2_json._langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'EN')))
                      ELSE B.Name END, '') AS Name,
               B.BoardNo AS No, B.ModUserNo, B.ModDate, B.Name AS JsonName,
               B.FolderNo AS ParentNo, B.SortNo,
               FALSE AS IsFolder, FALSE AS IsOpen,
               CAST(B.CountContent AS BIGINT) AS CountContent, B.ViewMode
        FROM BOARD B
    )
    SELECT Name, No, ModUserNo, JsonName, ParentNo, SortNo,
        IsFolder, IsOpen, CountContent, ViewMode,
        CAST(CASE WHEN IsFolder = TRUE AND No = board_gettreesubmenu_v2_json._selectedfolderno THEN 1
                  WHEN IsFolder = FALSE AND No = board_gettreesubmenu_v2_json._selectedboardno  THEN 1
                  ELSE 0 END AS BIT) AS IsSelected FROM TREESUB;

    -- Step 2: Pre-compute boardlist per folder (separate step â€” SQL 2008 R2 no nested FOR XML);;
    RETURN QUERY
    SELECT f.No AS FolderNo,
           STUFF(array_to_string(ARRAY(
               SELECT ',' || CAST(b.No AS text)
               FROM T b
               WHERE b.ParentNo = f.No AND b.IsFolder = FALSE
               ORDER BY b.SortNo DESC), ''), 1, 1, '') AS Boardlist
    INTO BL
    FROM T f WHERE f.IsFolder = TRUE;

    -- Step 3: Depth-first ordering
    --         Path component = (10000000 - SortNo) so higher SortNo â†’ smaller value â†’ sorts first
    CREATE TEMP TABLE O ON COMMIT DROP AS WITH RECURSIVE DFS AS (
        SELECT No, IsFolder,
               CAST(RIGHT('0000000' || CAST(10000000 - SortNo AS text), 7) AS text) AS SortPath
        FROM T WHERE ParentNo = 0
        UNION ALL
        SELECT t.No, t.IsFolder,
               d.SortPath || '|' || RIGHT('0000000' || CAST(10000000 - t.SortNo AS text), 7)
        FROM T t INNER JOIN DFS d ON t.ParentNo = d.No AND d.IsFolder = TRUE
    )
    SELECT No, IsFolder, SortPath FROM DFS;

    -- Step 4: Build JSON array using FOR XML PATH (SQL 2008 R2 compatible);


    _json := (COALESCE(array_to_string(ARRAY(
SELECT
',' || '{"id":"' || CASE WHEN t.IsFolder = TRUE THEN 'f' ELSE 'b' END || CAST(t.No AS text) || '",' || '"parent":"' || CASE WHEN t.ParentNo=0 THEN '#' ELSE 'f' || CAST(t.ParentNo AS text) END || '",' || '"text":"' || REPLACE(REPLACE(
CASE WHEN t.IsFolder = FALSE AND t.CountContent>0
THEN t.Name || ' <span class=''submenu_board_content_count''>' || CAST(t.CountContent AS text) || '</span>'
ELSE t.Name END,
'\', '\\'), '"', '\"') || '",' || '"icon":"' || CASE WHEN t.IsFolder = TRUE THEN 'fa fa-folder' ELSE 'fa fa-file-o' END || '",' || '"li_attr":{"type":"' || CASE WHEN t.IsFolder = TRUE THEN '0' ELSE CAST(t.ViewMode AS text) END || '","RegUserNo":' || CAST(t.ModUserNo AS text) || '},' || '"data":{' || '"title":"' || REPLACE(REPLACE(COALESCE(t.Name,''), '\','\\'), '"','\"') || '",' || '"boardlist":' || CASE WHEN t.IsFolder = TRUE
THEN '"' || COALESCE(bl.Boardlist, '') || '"'
ELSE 'null' END || ',' || '"jsonName":"' || REPLACE(REPLACE(COALESCE(t.JsonName,''), '\','\\'), '"','\"') || '"' || '},' || '"state":' || CASE WHEN t.IsFolder = TRUE AND NOT EXISTS (SELECT 1 FROM T c WHERE c.ParentNo=t.No)
THEN 'null'
ELSE '{"opened":' || CASE WHEN t.IsFolder = FALSE THEN 'true'
WHEN t.IsOpen = TRUE   THEN 'true'
ELSE 'false' END || ',"disabled":false,"selected":' || CASE WHEN t.IsSelected = TRUE THEN 'true' ELSE 'false' END || '}'
END || '}'
FROM T t
INNER JOIN O o  ON t.No = o.No AND t.IsFolder = o.IsFolder
LEFT  JOIN BL bl ON t.IsFolder = TRUE AND bl.FolderNo = t.No
ORDER BY o.SortPath), ''), ''));


















    RETURN QUERY
    SELECT '[' || STUFF(COALESCE(_Json, ''), 1, 1, '') || ']' AS JsonData;

    DROP TABLE IF EXISTS T;
    DROP TABLE IF EXISTS O;
    DROP TABLE IF EXISTS BL;
END;
$function$

```
</details>

## `board_insertnotificationservice`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- Generated SQL: `SELECT "public"."board_insertnotificationservice"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE);`
- SQLSTATE: `42601`
- Error: query has no destination for result data
- Stack context: PL/pgSQL function board_insertnotificationservice(integer,character varying,integer,integer,character varying,character varying,date,date,character varying,character varying,boolean,xml,date) line 18 at SQL statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertnotificationservice(_companyno integer, _projectcode character varying, _connectionkey integer, _senduserno integer, _recipientuserno character varying, _recipientdepartno character varying, _startdate date, _enddate date, _repeattype character varying, _repeatoptions character varying, _state boolean, _xmldetail xml, _execution date DEFAULT NULL::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    _notificationno integer;
    _dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare


	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
	values (_CompanyNo, _ProjectCode, _Connectionkey, _SendUserNo,_RecipientUserNo,_RecipientDepartNo,_StartDate,_StartDate,_RepeatType,_RepeatOptions,_State,_Execution);

	-- get Notification ID
	-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE
SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE;

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select _NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF EXISTS tb;
	DROP TABLE IF EXISTS tb2;
END;
$function$

```
</details>

## `board_mobile_search`

- Input: `''::character varying, 0::integer, false, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_mobile_search"(''::character varying, 0::integer, false, 0::integer, 0::integer);`
- SQLSTATE: `42601`
- Error: syntax error at or near "DESC"
- Stack context: PL/pgSQL function board_mobile_search(character varying,integer,boolean,integer,integer) line 64 at EXECUTE statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_mobile_search(_searchtext character varying, _sortcolumn integer, _isascending boolean, _countperpage integer, _currentpageindex integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _query character varying;
    _totalitemcount integer;
    _totalpagecount integer;
    _startrownum integer;
    _endrownum integer;
    _ishead boolean;
    _isnotice boolean;
    _isrecommend boolean;
    _recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	_Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	/*
	 * 정렬 컬럼
	 */

	IF _SortColumn = 1 THEN
	    _query := COALESCE(_query, '') || COALESCE(('GroupNo '), '');
	END IF;



	/*
	 * 정렬 내림차순 여부
	 */

	IF _IsAscending = TRUE THEN
	    _query := COALESCE(_query, '') || COALESCE(('ASC '), '');
	ELSE
	    _query := COALESCE(_query, '') || COALESCE(('DESC '), '');
	END IF;


	_query := COALESCE(_query, '') || COALESCE((', OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	_query := COALESCE(_query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents WHERE (Title ILIKE ''%' || _SearchText || '%'' OR ModUserName ILIKE ''%' || _SearchText || '%'') AND  Enabled = TRUE '), '');
		RAISE NOTICE '%', _Query;

	/*
	 * 게시글 검색 시작
	 */

	CREATE TEMP TABLE _SearchResult (
		RowNum		BIGINT,

		ContentNo	BIGINT,
		Content		text
	) ON COMMIT DROP;
	EXECUTE 'INSERT INTO _SearchResult ' || _query;
	/*
	 * 페이징 계산
	 */






	_TotalItemCount := (SELECT COUNT(*) FROM _SearchResult);
	_TotalPageCount := _TotalItemCount / _CountPerPage;
	IF _TotalPageCount % _CountPerPage > 0 THEN
	    _TotalPageCount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _TotalPageCount := 1;
	END IF;
	IF _CurrentPageIndex > _TotalPageCount THEN
	    _CurrentPageIndex := _TotalPageCount;
	END IF;

	_StartRowNum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_EndRowNum := board_mobile_search._currentpageindex * _CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE _TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO _ishead, _isnotice, _isrecommend, _recommendeddisplaycount FROM Board_Boards;


	IF _IsHead = TRUE THEN

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;


	ELSE

		IF _IsNotice = TRUE THEN

			INSERT INTO _TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF _IsRecommend = TRUE AND _RecommendedDisplayCount > 0 THEN

			INSERT INTO _TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO _TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM _SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		WHERE T.RowNum BETWEEN _StartRowNum AND _EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;

	END IF;

	RETURN QUERY
	SELECT * FROM _TempTable;
	RETURN QUERY
	SELECT _TotalItemCount AS TotalContentCount, _TotalPageCount AS TotalPageCount, _CurrentPageIndex AS CurrentPageIndex;
END;
$function$

```
</details>

## `board_setshare`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_setshare"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying = integer
- Stack context: PL/pgSQL function board_setshare(integer,integer,integer,character varying,character varying) line 7 at IF
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_setshare(_contentno integer, _departno integer, _userno integer, _ischild character varying, _mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF _Mode = 0 THEN


		_DepartName := public."comngetdepartname"(_DepartNo);
		IF (select count(*) from Board_Sharers b where b.ContentNo = board_setshare._contentno and b.DepartNo=board_setshare._departno and b.Userno=board_setshare._userno)=0 THEN
		INSERT INTO Board_Sharers(ContentNo,DepartNo,DepartName,IsChild,UserNo)
		VALUES(_ContentNo,_DepartNo,_DepartName,_IsChild,_UserNo);
		END IF;
	ELSE
		DELETE FROM Board_Sharers WHERE ContentNo = board_setshare._contentno;
	END IF;

	RETURN QUERY
	SELECT 0;
END;
$function$

```
</details>

## `board_updatenotificationservice`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- Generated SQL: `SELECT "public"."board_updatenotificationservice"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE);`
- SQLSTATE: `42601`
- Error: query has no destination for result data
- Stack context: PL/pgSQL function board_updatenotificationservice(integer,character varying,integer,integer,character varying,character varying,date,date,character varying,character varying,boolean,xml,date) line 13 at SQL statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatenotificationservice(_companyno integer, _projectcode character varying, _connectionkey integer, _senduserno integer, _recipientuserno character varying, _recipientdepartno character varying, _startdate date, _enddate date, _repeattype character varying, _repeatoptions character varying, _state boolean, _xmldetail xml, _execution date DEFAULT NULL::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    _notificationno integer;
    _dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID
	-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE
SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE;

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select _NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF EXISTS tb;
	DROP TABLE IF EXISTS tb2;
END;
$function$

```
</details>

## `contact_insertsharegroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contact_insertsharegroup"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `23502`
- Error: null value in column "moduserno" violates not-null constraint
- Stack context: SQL statement "INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo, Sort,RegDate,IsDelete) 	VALUES (_ShareName, _ParentNo, _UserNo, _Sort+1,NOW(),'FALSE')" PL/pgSQL function contact_insertsharegroup(integer,character varying,integer) line 13 at SQL statement
- Root cause: Dummy input or generated SQL violates a NOT NULL constraint
- Proposed fix: Use a source-valid fixture before treating this as a converter defect.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contact_insertsharegroup(_userno integer, _sharename character varying, _parentno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _sort integer;
    _groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO _sort FROM Contact_ShareGroup
	WHERE  ParentNo = contact_insertsharegroup._parentno
	ORDER BY Sort DESC;

	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo, Sort,RegDate,IsDelete)
	VALUES (_ShareName, _ParentNo, _UserNo, _Sort+1,NOW(),'FALSE');

	_GroupNo := lastval();
	RETURN QUERY
	SELECT _GroupNo AS GroupNo;
END;
$function$

```
</details>

## `contacts_getcontactscount`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getcontactscount"(0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42703`
- Error: column "p_reguserno" does not exist
- Stack context: PL/pgSQL function contacts_getcontactscount(integer,character varying,character varying,character varying,character varying,integer,character varying) line 81 at EXECUTE statement
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactscount(_reguserno integer, _ts character varying, _te character varying, _search character varying, _searchmode character varying, _groupno integer, _mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _pagingqry character varying;
    _countqry character varying;
    _param character varying;
    _searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	_PagingQry := 'SELECT count(*) cnt FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq,Name,Memo FROM ContactsUser';

	_CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser';
	_PARAM := 'P_RegUserNo INT,;
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

	IF _GroupNo > 0 THEN
		_pagingqry := COALESCE(_pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		_countqry := COALESCE(_countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF _TS = '' AND _TE = '' THEN
			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo) PagingTable'), '');
			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo'), '');
			END IF;
		ELSE
			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND
Name BETWEEN P_TS AND P_TE) PagingTable'), '');
			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;
	ELSE

		_pagingqry := COALESCE(_pagingqry, '') || COALESCE((' '), '');
		_countqry := COALESCE(_countqry, '') || COALESCE((' '), '');

		IF _Search = '' THEN
			_SearchTxt := '';
		ELSE
			IF _SearchMode = '0' THEN
				_SearchTxt := ' AND Name ILIKE ''%' || _Search || '%''';
			ELSIF _SearchMode = '1' THEN
				_SearchTxt := '';
			ELSIF _SearchMode = '2' THEN
				_SearchTxt := '';
			ELSE
				_SearchTxt := ' AND Memo ILIKE ''%' || _Search || '%''';
			END IF;
		END IF;

		IF _TS = '' AND _TE = '' THEN
			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || _SearchTxt || ') PagingTable'), '');
			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || _SearchTxt), '');
			END IF;
		ELSE
			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || _SearchTxt || ') PagingTable'), '');
			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || _SearchTxt), '');
			END IF;
		END IF;
	END IF;

	IF _Mode = '0' THEN
		EXECUTE _PagingQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	ELSE
		EXECUTE _CountQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	END IF;
END;
$function$

```
</details>

## `contacts_getcontactslist`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getcontactslist"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42703`
- Error: column "p_reguserno" does not exist
- Stack context: PL/pgSQL function contacts_getcontactslist(integer,integer,integer,character varying,character varying,character varying,character varying,integer,character varying) line 87 at EXECUTE statement
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactslist(_reguserno integer, _sidx integer, _eidx integer, _ts character varying, _te character varying, _search character varying, _searchmode character varying, _groupno integer, _mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _pagingqry character varying;
    _countqry character varying;
    _param character varying;
    _searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	_PagingQry := 'SELECT ROWNUM, Seq, Name, Memo FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, Name, Memo FROM ContactsUser ';

	_CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser ';
	_PARAM := 'P_RegUserNo INT,;
	P_Sidx INT,
	P_Eidx INT,
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

		_pagingqry := COALESCE(_pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		_countqry := COALESCE(_countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF _TS = '' AND _TE = '' THEN
			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."getchildgroup"(P_RegUserNo,P_GroupNo))) PagingTable
WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."getchildgroup"(P_RegUserNo,P_GroupNo))'), '');
			END IF;
		ELSE

			IF _Mode = '0' THEN
				_pagingqry := COALESCE(_pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."getchildgroup"(P_RegUserNo,P_GroupNo)) AND
Name BETWEEN P_TS AND P_TE) PagingTable WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				_countqry := COALESCE(_countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."getchildgroup"(P_RegUserNo,P_GroupNo)) AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;



		IF _Search = '' THEN
			_SearchTxt := '';
		ELSE
			IF _SearchMode = '0' THEN
				_SearchTxt := ' AND Name ILIKE ''%' || _Search || '%''';
			ELSIF _SearchMode = '1' THEN
				_SearchTxt := ' AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '2' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '3' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '4' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '5' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '6' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSEq FROM ContactsGroupUser WHERE;
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE ''%' || _Search || '%''))';

			ELSIF _SearchMode = '7' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsGroup WHERE RegDate ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '8' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || _Search || '%'')';
			ELSIF _SearchMode = '9' THEN
				_SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || _Search || '%'')';
			END IF;
		END IF;

		_pagingqry := COALESCE(_pagingqry, '') || COALESCE((_SearchTxt), '');
		_countqry := COALESCE(_countqry, '') || COALESCE((_SearchTxt), '');


	IF _Mode = '0' THEN
		EXECUTE _PagingQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	ELSE
		EXECUTE _CountQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	END IF;
END;
$function$

```
</details>

## `contacts_getgroupbyuser`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getgroupbyuser"(0::integer, 0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint, "column_10" character);`
- SQLSTATE: `23502`
- Error: null value in column "sort" violates not-null constraint
- Stack context: SQL statement "INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn) 	VALUES (_GrpName, _ParentNo, _UserNo, _Sort+1,NOW(),'0','Y')" PL/pgSQL function contacts_insertgroup(integer,character varying,integer) line 13 at SQL statement SQL statement "SELECT contacts_insertgroup(_RegUserNo,'임시 그룹',0)" PL/pgSQL function contacts_getgroupbyuser(integer,integer) line 7 at PERFORM
- Root cause: Dummy input or generated SQL violates a NOT NULL constraint
- Proposed fix: Use a source-valid fixture before treating this as a converter defect.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getgroupbyuser(_reguserno integer DEFAULT NULL::integer, _userseq integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 IF (SELECT COUNT(*) FROM ContactsGroup  WHERE RegUserNo=contacts_getgroupbyuser._reguserno AND UseYn='Y')<=0 THEN
	PERFORM contacts_insertgroup(_RegUserNo,'임시 그룹',0);
 END IF;


	RETURN QUERY
	SELECT distinct c.GroupNo, c.GroupName, c.RegUserNo, c.RegDate, c.Memo, c.ParentGNo, c.Sort, c.IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser Cc
		INNER JOIN ContactsUser U ON U.Seq = Cc.UserSeq AND U.UseYn='Y'
		WHERE Cc.GroupNo = c.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup c
	left join ContactsGroupUser g on c.groupno=g.groupno
	WHERE c.RegUserNo=contacts_getgroupbyuser._reguserno AND c.UseYn='Y' --and --g.userseq=UserSeq
	 ORDER BY c.Sort;
END;
$function$

```
</details>

## `contacts_insertgroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contacts_insertgroup"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `23502`
- Error: null value in column "sort" violates not-null constraint
- Stack context: SQL statement "INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn) 	VALUES (_GrpName, _ParentNo, _UserNo, _Sort+1,NOW(),'0','Y')" PL/pgSQL function contacts_insertgroup(integer,character varying,integer) line 13 at SQL statement
- Root cause: Dummy input or generated SQL violates a NOT NULL constraint
- Proposed fix: Use a source-valid fixture before treating this as a converter defect.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertgroup(_userno integer, _grpname character varying, _parentno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _sort integer;
    _groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO _sort FROM ContactsGroup
	WHERE RegUserNo = contacts_insertgroup._userno AND ParentGNo = contacts_insertgroup._parentno
	ORDER BY Sort DESC;

	INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
	VALUES (_GrpName, _ParentNo, _UserNo, _Sort+1,NOW(),'0','Y');

	_GroupNo := lastval();
	RETURN QUERY
	SELECT _GroupNo AS GroupNo;
END;
$function$

```
</details>

## `contacts_insertpublicgroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_insertpublicgroup"(0::integer, ''::character varying, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `23502`
- Error: null value in column "sort" violates not-null constraint
- Stack context: SQL statement "INSERT INTO Contact_PublicGroup (PublicGroupName, ParentNo, RegUserNo, Sort,ModUserNo) 	VALUES (_GroupName, _ParentNo, _UserNo, _Sort+1,_UserNo)" PL/pgSQL function contacts_insertpublicgroup(integer,character varying,integer) line 11 at SQL statement
- Root cause: Dummy input or generated SQL violates a NOT NULL constraint
- Proposed fix: Use a source-valid fixture before treating this as a converter defect.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertpublicgroup(_userno integer DEFAULT 70, _groupname character varying DEFAULT '{"KO":"Public 001","EN":"Public 001","VN":"Public 001","CH":"Public 001","JP":"Public 001"}'::character varying, _parentno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO _sort FROM Contact_PublicGroup
	WHERE ParentNo = contacts_insertpublicgroup._parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_PublicGroup (PublicGroupName, ParentNo, RegUserNo, Sort,ModUserNo)
	VALUES (_GroupName, _ParentNo, _UserNo, _Sort+1,_UserNo);
	RETURN QUERY
	SELECT CAST(lastval() AS INT) AS PublicGroupNo;
END;
$function$

```
</details>

## `contacts_insertsharegroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_insertsharegroup"(0::integer, ''::character varying, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `23502`
- Error: null value in column "sort" violates not-null constraint
- Stack context: SQL statement "INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo,ModUserNo, Sort) 	VALUES (_ShareGroupName, _ParentNo, _UserNo,_UserNo, _Sort+1)" PL/pgSQL function contacts_insertsharegroup(integer,character varying,integer) line 11 at SQL statement
- Root cause: Dummy input or generated SQL violates a NOT NULL constraint
- Proposed fix: Use a source-valid fixture before treating this as a converter defect.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertsharegroup(_userno integer DEFAULT 70, _sharegroupname character varying DEFAULT '{\"KO\":\"Share 001\",\"EN\":\"Share 001\",\"VN\":\"Share 001\",\"CH\":\"Share 001\",\"JP\":\"Share 001\"}'::character varying, _parentno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO _sort FROM Contact_ShareGroup
	WHERE ParentNo = contacts_insertsharegroup._parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo,ModUserNo, Sort)
	VALUES (_ShareGroupName, _ParentNo, _UserNo,_UserNo, _Sort+1);
	RETURN QUERY
	SELECT CAST(lastval() AS INT) ShareGroupNo;
END;
$function$

```
</details>

## `contacts_insertuserforexcel`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_insertuserforexcel"(0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying);`
- SQLSTATE: `42883`
- Error: function contacts_insertlistgroupcontact(integer, character varying) does not exist
- Stack context: PL/pgSQL function contacts_insertuserforexcel(integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,timestamp without time zone,timestamp without time zone,character varying) line 15 at PERFORM
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertuserforexcel(_reguserno integer, _lastname character varying, _firstname character varying, _callname character varying, _phonenum character varying, _companynum character varying, _homenum character varying, _faxnum character varying, _company character varying, _position character varying, _depart character varying, _email character varying, _companyzip1 character varying, _companyzip2 character varying, _companyaddr character varying, _homezip1 character varying, _homezip2 character varying, _homeaddr character varying, _homepage character varying, _memo character varying, _grouplist character varying, _regday timestamp without time zone, _modday timestamp without time zone, _share character varying DEFAULT '100'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _userno integer;
    _isphonedef character varying;
    _isaddrdef character varying;
    _defvalue character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


-- ??? ????.;
INSERT INTO ContactsUser (FirstName, LastName, CallName,Memo, RegUserNo, RegDate,ModDate, UseYn,Share)
VALUES (_FirstName, _LastName, _CallName,_Memo, _RegUserNo, _RegDay,_ModDay, 'Y',_Share);
_UserNo := lastval();
PERFORM contacts_insertlistgroupcontact(_UserNo,_Grouplist);
-- ?? ??.
--INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate)
--VALUES (GroupNo, UserNo, RegUserNo ,NOW())

-- ???? ??(0:???1:?2:??3:FAX)
-- ?? ???? ??.
IF _PhoneNum != '' THEN
	IF _IsPhoneDef = '0' THEN
		_IsPhoneDef := '1';
		_DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, 0, '???', _PhoneNum, _DefValue ,NOW());
END IF;

-- ? ???? ??.
IF _HomeNum != '' THEN
	_DefValue := '0';
	IF _IsPhoneDef = '0' THEN
		_IsPhoneDef := '1';
		_DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, 1, '?', _HomeNum, _DefValue ,NOW());
END IF;

-- ?? ???? ??.
IF _CompanyNum != '' THEN
	_DefValue := '0';
	IF _IsPhoneDef = '0' THEN
		_IsPhoneDef := '1';
		_DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, 2, '??', _CompanyNum, _DefValue ,NOW());
END IF;

-- ???? ??.
IF _FaxNum != '' THEN
	_DefValue := '0';
	IF _IsPhoneDef = '0' THEN
		_IsPhoneDef := '1';
		_DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, 3, 'FAX', _FaxNum, _DefValue ,NOW());
END IF;

-- ??/??/?? ??.
IF _Company != '' OR _Depart != '' OR _Position != '' THEN
	INSERT INTO ContactsCompany (RegUserNo, UserSeq, Company, Depart, Position, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, _Company, _Depart, _Position, '1' ,NOW());
END IF;

-- ?? ??.
IF _Email != '' THEN
	INSERT INTO ContactsEmail (RegUserNo, UserSeq, Value, IsDefault, RegDate)
	VALUES (_RegUserNo, _UserNo, _Email, '1' ,NOW());
END IF;
-- ????(0:??1:?)
-- ????
IF _CompanyZip1 != '' OR _CompanyZip2 != '' OR _CompanyAddr != '' THEN
	_DefValue := '0';
	IF _IsAddrDef = '0' THEN
		_IsAddrDef := '1';
		_DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(_RegUserNo, _UserNo, 0, '??', _CompanyZip1, _CompanyZip2, _CompanyAddr, _DefValue ,NOW());
END IF;

-- ???
IF _HomeZip1 != '' OR _HomeZip2 != '' OR _HomeAddr != '' THEN
	_DefValue := '0';
	IF _IsAddrDef = '0' THEN
		_IsAddrDef := '1';
		_DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(_RegUserNo, _UserNo, 1, '?', _HomeZip1, _HomeZip2, _HomeAddr, _DefValue ,NOW());
END IF;

-- ???? ??(0:????1:???2:??)
IF _HomePage != '' THEN
	_DefValue := '0';
	IF _IsAddrDef = '0' THEN
		_IsAddrDef := '1';
		_DefValue := '1';
	END IF;
	INSERT INTO ContactsHomepage
	(RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES
	(_RegUserNo, _UserNo, 0, '????', _HomePage, _DefValue ,NOW());
END IF;

RETURN QUERY
SELECT _UserNo;
END;
$function$

```
</details>

## `contacts_saveaddressinfo`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_saveaddressinfo"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42804`
- Error: column "moddate" is of type timestamp without time zone but expression is of type integer
- Stack context: PL/pgSQL function contacts_saveaddressinfo(integer,integer,integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,integer,character varying) line 101 at SQL statement
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_saveaddressinfo(_seq integer, _userno integer, _listgroup integer, _firstname character varying DEFAULT ''::character varying, _lastname character varying DEFAULT ''::character varying, _callname character varying DEFAULT ''::character varying, _telinfo character varying DEFAULT ''::character varying, _emailinfo character varying DEFAULT ''::character varying, _companyinfo character varying DEFAULT ''::character varying, _addressinfo character varying DEFAULT ''::character varying, _homepageinfo character varying DEFAULT ''::character varying, _snsinfo character varying DEFAULT ''::character varying, _groupinfo character varying DEFAULT ''::character varying, _memo character varying DEFAULT ''::character varying, _share character varying DEFAULT ''::character varying, _important integer DEFAULT 0, _photo character varying DEFAULT ''::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _chktelinfo character varying;
    _temptel character varying;
    _telisdefault integer;
    _teltype smallint;
    _teltypename character varying;
    _telvalue character varying;
    _telcnt integer;
    _chkemailinfo character varying;
    _tempemail character varying;
    _emailisdefault integer;
    _emailvalue character varying;
    _emailcnt integer;
    _chkcompanyinfo character varying;
    _tempcompany character varying;
    _companyisdefault integer;
    _companyname character varying;
    _depart character varying;
    _position character varying;
    _companycnt integer;
    _chkaddrinfo character varying;
    _tempaddr character varying;
    _addrisdefault integer;
    _addrtype smallint;
    _addrtypename character varying;
    _addrzipcode1 character varying;
    _addrzipcode2 character varying;
    _address character varying;
    _addrcnt integer;
    _chkhomeinfo character varying;
    _temphome character varying;
    _homeisdefault integer;
    _hometype smallint;
    _hometypename character varying;
    _homevalue character varying;
    _homecnt integer;
    _chksnsinfo character varying;
    _tempsns character varying;
    _snsisdefault integer;
    _snstype smallint;
    _snstypename character varying;
    _snsvalue character varying;
    _snscnt integer;
    _chkgroupinfo character varying;
    _groupcnt integer;
    _groupno integer;
    _chktelinfoup character varying;
    _temptelup character varying;
    _telisdefaultup integer;
    _teltypeup smallint;
    _teltypenameup character varying;
    _telvalueup character varying;
    _telcntup integer;
    _chkemailinfoup character varying;
    _tempemailup character varying;
    _emailisdefaultup integer;
    _emailvalueup character varying;
    _emailcntup integer;
    _chkcompanyinfoup character varying;
    _tempcompanyup character varying;
    _companyisdefaultup integer;
    _companynameup character varying;
    _departup character varying;
    _positionup character varying;
    _companycntup integer;
    _chkaddrinfoup character varying;
    _tempaddrup character varying;
    _addrisdefaultup integer;
    _addrtypeup smallint;
    _addrtypenameup character varying;
    _addrzipcode1up character varying;
    _addrzipcode2up character varying;
    _addressup character varying;
    _addrcntup integer;
    _chkhomeinfoup character varying;
    _temphomeup character varying;
    _homeisdefaultup integer;
    _hometypeup smallint;
    _hometypenameup character varying;
    _homevalueup character varying;
    _homecntup integer;
    _chksnsinfoup character varying;
    _tempsnsup character varying;
    _snsisdefaultup integer;
    _snstypeup smallint;
    _snstypenameup character varying;
    _snsvalueup character varying;
    _snscntup integer;
    _chkgroupinfoup character varying;
    _groupcntup integer;
    _groupnoup integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF _Seq = 0 THEN

		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		INSERT INTO ContactsUser
		(
			FirstName,
			LastName,
			CallName,
			Memo,
			Share,
			Important,
			Photo,
			UseYn,
			RegUserNo,
			RegDate,
			ModDate
		)
		VALUES
		(
			_FirstName,
			_LastName,
			_CallName,
			_Memo,
			_Share,
			_Important,
			_Photo,
			'Y',
			_UserNo,
			NOW(),
			_UserNo
		);
		_Seq := lastval();
		-- ===========================================
		PERFORM contacts_insertlistgroupcontact(_Seq,_Listgroup);

		-- ============================================
		-- 전화번호
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE _tabNumber (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkTelInfo := REPLACE(_TelInfo,',','');
		IF LENGTH(_ChkTelInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			_TelInfo := contacts_saveaddressinfo._telinfo || '$';
			-- Row 분리
			WHILE STRPOS(_TelInfo, '$') > 0 LOOP

				_TempTel := SUBSTRING(_TelInfo,0,STRPOS(_TelInfo, '$'));
				--SELECT TempTel AS TempTel






				-- Column 분리
				WHILE STRPOS(_TempTel, ',') > 0 LOOP

					IF _TelCnt = 0 THEN
						--SET TelIsDefault = SUBSTRING(TempTel,0,STRPOS(TempTel, ','));
						_TelIsDefault := 1;
					ELSIF _TelCnt = 1 THEN
						_TelType := SUBSTRING(_TempTel,0,STRPOS(_TempTel, ','));
					ELSIF _TelCnt = 2 THEN
						_TelTypeName := SUBSTRING(_TempTel,0,STRPOS(_TempTel, ','));
					END IF;
					_TelCnt := _TelCnt + 1;
					_TempTel := SUBSTRING(_TempTel,STRPOS(_TempTel, ',')+1,LENGTH(_TempTel));
				END LOOP;
				_TelValue := _TempTel;
				-- 임시테이블에 저장;
				INSERT INTO _tabNumber
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_TelIsDefault,
					_TelType,
					_TelTypeName,
					_TelValue
				);
				_TelInfo := SUBSTRING(_TelInfo,STRPOS(_TelInfo, '$')+1,LENGTH(_TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabNumber;
		ELSE
			DELETE FROM ContactsNumber WHERE RegUserNo = contacts_saveaddressinfo._userno AND UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE _tabEmail (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		_ChkEmailInfo := REPLACE(_EmailInfo,',','');
		IF LENGTH(_ChkEmailInfo) > 0 THEN
			_EmailInfo := contacts_saveaddressinfo._emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(_EmailInfo, '$') > 0 LOOP

				_TempEmail := SUBSTRING(_EmailInfo,0,STRPOS(_EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempEmail, ',') > 0 LOOP
					IF _EmailCnt = 0 THEN
						_EmailIsDefault := SUBSTRING(_TempEmail,0,STRPOS(_TempEmail, ','));
					END IF;
					_EmailCnt := _EmailCnt + 1;
					_TempEmail := SUBSTRING(_TempEmail,STRPOS(_TempEmail, ',')+1,LENGTH(_TempEmail));
				END LOOP;
				_EmailValue := _TempEmail;
				INSERT INTO _tabEmail
				(
					IsDefault,
					Value
				)
				VALUES
				(
					_EmailIsDefault,
					_EmailValue
				);
				_EmailInfo := SUBSTRING(_EmailInfo,STRPOS(_EmailInfo, '$')+1,LENGTH(_EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Value, IsDefault, NOW(), NOW() FROM _tabEmail;
		ELSE
			DELETE FROM ContactsEmail WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE _tabCompany (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		_ChkCompanyInfo := REPLACE(_CompanyInfo,',','');
		IF LENGTH(_ChkCompanyInfo) > 0 THEN
			_CompanyInfo := contacts_saveaddressinfo._companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(_CompanyInfo, '$') > 0 LOOP

				_TempCompany := SUBSTRING(_CompanyInfo,0,STRPOS(_CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempCompany, ',') > 0 LOOP
					IF _CompanyCnt = 0 THEN
						_CompanyIsDefault := SUBSTRING(_TempCompany,0,STRPOS(_TempCompany, ','));
					ELSIF _CompanyCnt = 1 THEN
						_CompanyName := SUBSTRING(_TempCompany,0,STRPOS(_TempCompany, ','));
					ELSIF _CompanyCnt = 2 THEN
						_Depart := SUBSTRING(_TempCompany,0,STRPOS(_TempCompany, ','));
					END IF;
					_CompanyCnt := _CompanyCnt + 1;
					_TempCompany := SUBSTRING(_TempCompany,STRPOS(_TempCompany, ',')+1,LENGTH(_TempCompany));
				END LOOP;
				_Position := _TempCompany;
				INSERT INTO _tabCompany
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					_CompanyIsDefault,
					_CompanyName,
					_Depart,
					_Position
				);
				_CompanyInfo := SUBSTRING(_CompanyInfo,STRPOS(_CompanyInfo, '$')+1,LENGTH(_CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM _tabCompany;
		ELSE
			DELETE FROM ContactsCompany WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE _tabAddr (IsDefault CHAR(1), Type smallint, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500)) ON COMMIT DROP;



		_ChkAddrInfo := REPLACE(_AddressInfo,',','');
		IF LENGTH(_ChkAddrInfo) > 0 THEN
			_AddressInfo := contacts_saveaddressinfo._addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(_AddressInfo, '$') > 0 LOOP

				_TempAddr := SUBSTRING(_AddressInfo,0,STRPOS(_AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempAddr, ',') > 0 LOOP
					IF _AddrCnt = 0 THEN
						_AddrIsDefault := SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ','));
					ELSIF _AddrCnt = 1 THEN
						_AddrType := SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ','));
					ELSIF _AddrCnt = 2 THEN
						_AddrTypeName := SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ','));
					ELSIF _AddrCnt = 3 THEN
						_AddrZipCode1 := SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ','));
					ELSIF _AddrCnt = 4 THEN
						_AddrZipCode2 := SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ','));
					END IF;
					_AddrCnt := _AddrCnt + 1;
					_TempAddr := SUBSTRING(_TempAddr,STRPOS(_TempAddr, ',')+1,LENGTH(_TempAddr));
				END LOOP;
				_Address := _TempAddr;
				INSERT INTO _tabAddr
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address
				)
				VALUES
				(
					_AddrIsDefault,
					_AddrType,
					_AddrTypeName,
					_AddrZipCode1,
					_AddrZipCode2,
					_Address
				);
				_AddressInfo := SUBSTRING(_AddressInfo,STRPOS(_AddressInfo, '$')+1,LENGTH(_AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW() FROM _tabAddr;
		ELSE
			DELETE FROM ContactsAddress WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE _tabHome (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkHomeInfo := REPLACE(_HomepageInfo,',','');
		IF LENGTH(_ChkHomeInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			_HomepageInfo := contacts_saveaddressinfo._homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(_HomepageInfo, '$') > 0 LOOP

				_TempHome := SUBSTRING(_HomepageInfo,0,STRPOS(_HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempHome, ',') > 0 LOOP

					IF _HomeCnt = 0 THEN
						_HomeIsDefault := SUBSTRING(_TempHome,0,STRPOS(_TempHome, ','));
					ELSIF _HomeCnt = 1 THEN
						_HomeType := SUBSTRING(_TempHome,0,STRPOS(_TempHome, ','));
					ELSIF _HomeCnt = 2 THEN
						_HomeTypeName := SUBSTRING(_TempHome,0,STRPOS(_TempHome, ','));
					END IF;
					_HomeCnt := _HomeCnt + 1;
					_TempHome := SUBSTRING(_TempHome,STRPOS(_TempHome, ',')+1,LENGTH(_TempHome));
				END LOOP;
				_HomeValue := _TempHome;
				-- 임시테이블에 저장;
				INSERT INTO _tabHome
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_HomeIsDefault,
					_HomeType,
					_HomeTypeName,
					_HomeValue
				);
				_HomepageInfo := SUBSTRING(_HomepageInfo,STRPOS(_HomepageInfo, '$')+1,LENGTH(_HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabHome;
		ELSE
			DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_saveaddressinfo._userno AND UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE _tabSns (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkSnsInfo := REPLACE(_SnsInfo,',','');
		IF LENGTH(_ChkSnsInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			_SnsInfo := contacts_saveaddressinfo._snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(_SnsInfo, '$') > 0 LOOP

				_TempSns := SUBSTRING(_SnsInfo,0,STRPOS(_SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempSns, ',') > 0 LOOP

					IF _SnsCnt = 0 THEN
						_SnsIsDefault := SUBSTRING(_TempSns,0,STRPOS(_TempSns, ','));
					ELSIF _SnsCnt = 1 THEN
						_SnsType := SUBSTRING(_TempSns,0,STRPOS(_TempSns, ','));
					ELSIF _SnsCnt = 2 THEN
						_SnsTypeName := SUBSTRING(_TempSns,0,STRPOS(_TempSns, ','));
					END IF;
					_SnsCnt := _SnsCnt + 1;
					_TempSns := SUBSTRING(_TempSns,STRPOS(_TempSns, ',')+1,LENGTH(_TempSns));
				END LOOP;
				_SnsValue := _TempSns;
				-- 임시테이블에 저장;
				INSERT INTO _tabSns
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_SnsIsDefault,
					_SnsType,
					_SnsTypeName,
					_SnsValue
				);
				_SnsInfo := SUBSTRING(_SnsInfo,STRPOS(_SnsInfo, '$')+1,LENGTH(_SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabSns;
		ELSE
			DELETE FROM ContactsSns WHERE RegUserNo = contacts_saveaddressinfo._userno AND UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE _tabGroup (GroupNo INT, UserSeq INT) ON COMMIT DROP;



		_ChkGroupInfo := REPLACE(_GroupInfo,',','');
		IF LENGTH(_ChkGroupInfo) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo._seq;
			-- 정보가 존재하면 끝에 , 추가;
			_GroupInfo := contacts_saveaddressinfo._groupinfo || ',';
			WHILE STRPOS(_GroupInfo, ',') > 0 LOOP
				_GroupNo := SUBSTRING(_GroupInfo,0,STRPOS(_GroupInfo, ','));
				INSERT INTO _tabGroup
				(
					GroupNo,
					UserSeq
				)
				VALUES
				(
					_GroupNo,
					_Seq
				);

				_GroupCnt := _GroupCnt + 1;
				_GroupInfo := SUBSTRING(_GroupInfo,STRPOS(_GroupInfo, ',')+1,LENGTH(_GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, _UserNo, NOW(), NOW() FROM _tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo._seq;
		END IF;

		IF 0 <> 0 THEN

		END IF;

	ELSE

		-- ============================================
		-- 수정전에 히스토리 저장 처리
		-- ============================================
		PERFORM contacts_savecontactshistory(_UserNo, _Seq, 'UPD');
		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		UPDATE ContactsUser
		SET
			FirstName = contacts_saveaddressinfo._firstname,
			LastName = contacts_saveaddressinfo._lastname,
			CallName = contacts_saveaddressinfo._callname,
			Memo = contacts_saveaddressinfo._memo,
			Share = contacts_saveaddressinfo._share,
			Photo = contacts_saveaddressinfo._photo,
			Important = contacts_saveaddressinfo._important,
			ModDate = NOW()
		WHERE Seq = contacts_saveaddressinfo._seq;

		CREATE TEMP TABLE _tabNumberUp (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkTelInfoUp := REPLACE(_TelInfo,',','');
		DELETE FROM ContactsNumber WHERE RegUserNo = contacts_saveaddressinfo._userno AND UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkTelInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			_TelInfo := contacts_saveaddressinfo._telinfo || '$';
			-- Row 분리
			WHILE STRPOS(_TelInfo, '$') > 0 LOOP

				_TempTelUp := SUBSTRING(_TelInfo,0,STRPOS(_TelInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempTelUp, ',') > 0 LOOP

					IF _TelCntUp = 0 THEN
						_TelIsDefaultUp := SUBSTRING(_TempTelUp,0,STRPOS(_TempTelUp, ','));
					ELSIF _TelCntUp = 1 THEN
						_TelTypeUp := SUBSTRING(_TempTelUp,0,STRPOS(_TempTelUp, ','));
					ELSIF _TelCntUp = 2 THEN
						_TelTypeNameUp := SUBSTRING(_TempTelUp,0,STRPOS(_TempTelUp, ','));
					END IF;
					_TelCntUp := _TelCntUp + 1;
					_TempTelUp := SUBSTRING(_TempTelUp,STRPOS(_TempTelUp, ',')+1,LENGTH(_TempTelUp));
				END LOOP;
				_TelValueUp := _TempTelUp;
				-- 임시테이블에 저장;
				INSERT INTO _tabNumberUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_TelIsDefaultUp,
					_TelTypeUp,
					_TelTypeNameUp,
					_TelValueUp
				);
				_TelInfo := SUBSTRING(_TelInfo,STRPOS(_TelInfo, '$')+1,LENGTH(_TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabNumberUp;
		END IF;

		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE _tabEmailUp (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		_ChkEmailInfoUp := REPLACE(_EmailInfo,',','');
		DELETE FROM ContactsEmail WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkEmailInfoUp) > 0 THEN
			_EmailInfo := contacts_saveaddressinfo._emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(_EmailInfo, '$') > 0 LOOP

				_TempEmailUp := SUBSTRING(_EmailInfo,0,STRPOS(_EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempEmailUp, ',') > 0 LOOP
					IF _EmailCntUp = 0 THEN
						_EmailIsDefaultUp := SUBSTRING(_TempEmailUp,0,STRPOS(_TempEmailUp, ','));
					END IF;
					_EmailCntUp := _EmailCntUp + 1;
					_TempEmailUp := SUBSTRING(_TempEmailUp,STRPOS(_TempEmailUp, ',')+1,LENGTH(_TempEmailUp));
				END LOOP;
				_EmailValueUp := _TempEmailUp;
				INSERT INTO _tabEmailUp
				(
					IsDefault,
					Value
				)
				VALUES
				(
					_EmailIsDefaultUp,
					_EmailValueUp
				);
				_EmailInfo := SUBSTRING(_EmailInfo,STRPOS(_EmailInfo, '$')+1,LENGTH(_EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Value, IsDefault, NOW(), NOW() FROM _tabEmailUp;
		END IF;

		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE _tabCompanyUp (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		_ChkCompanyInfoUp := REPLACE(_CompanyInfo,',','');
		DELETE FROM ContactsCompany WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkCompanyInfoUp) > 0 THEN
			_CompanyInfo := contacts_saveaddressinfo._companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(_CompanyInfo, '$') > 0 LOOP

				_TempCompanyUp := SUBSTRING(_CompanyInfo,0,STRPOS(_CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempCompanyUp, ',') > 0 LOOP
					IF _CompanyCntUp = 0 THEN
						_CompanyIsDefaultUp := SUBSTRING(_TempCompanyUp,0,STRPOS(_TempCompanyUp, ','));
					ELSIF _CompanyCntUp = 1 THEN
						_CompanyNameUp := SUBSTRING(_TempCompanyUp,0,STRPOS(_TempCompanyUp, ','));
					ELSIF _CompanyCntUp = 2 THEN
						_DepartUp := SUBSTRING(_TempCompanyUp,0,STRPOS(_TempCompanyUp, ','));
					END IF;
					_CompanyCntUp := _CompanyCntUp + 1;
					_TempCompanyUp := SUBSTRING(_TempCompanyUp,STRPOS(_TempCompanyUp, ',')+1,LENGTH(_TempCompanyUp));
				END LOOP;
				_PositionUp := _TempCompanyUp;
				INSERT INTO _tabCompanyUp
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					_CompanyIsDefaultUp,
					_CompanyNameUp,
					_DepartUp,
					_PositionUp
				);
				_CompanyInfo := SUBSTRING(_CompanyInfo,STRPOS(_CompanyInfo, '$')+1,LENGTH(_CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM _tabCompanyUp;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE _tabAddrUp (IsDefault CHAR(1), Type smallint, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500)) ON COMMIT DROP;



		_ChkAddrInfoUp := REPLACE(_AddressInfo,',','');
		DELETE FROM ContactsAddress WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkAddrInfoUp) > 0 THEN
			_AddressInfo := contacts_saveaddressinfo._addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(_AddressInfo, '$') > 0 LOOP

				_TempAddrUp := SUBSTRING(_AddressInfo,0,STRPOS(_AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempAddrUp, ',') > 0 LOOP
					IF _AddrCntUp = 0 THEN
						_AddrIsDefaultUp := SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ','));
					ELSIF _AddrCntUp = 1 THEN
						_AddrTypeUp := SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ','));
					ELSIF _AddrCntUp = 2 THEN
						_AddrTypeNameUp := SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ','));
					ELSIF _AddrCntUp = 3 THEN
						_AddrZipCode1Up := SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ','));
					ELSIF _AddrCntUp = 4 THEN
						_AddrZipCode2Up := SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ','));
					END IF;
					_AddrCntUp := _AddrCntUp + 1;
					_TempAddrUp := SUBSTRING(_TempAddrUp,STRPOS(_TempAddrUp, ',')+1,LENGTH(_TempAddrUp));
				END LOOP;
				_AddressUp := _TempAddrUp;
				INSERT INTO _tabAddrUp
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address
				)
				VALUES
				(
					_AddrIsDefaultUp,
					_AddrTypeUp,
					_AddrTypeNameUp,
					_AddrZipCode1Up,
					_AddrZipCode2Up,
					_AddressUp
				);
				_AddressInfo := SUBSTRING(_AddressInfo,STRPOS(_AddressInfo, '$')+1,LENGTH(_AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW() FROM _tabAddrUp;
		END IF;

		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE _tabHomeUp (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkHomeInfoUp := REPLACE(_HomepageInfo,',','');
		DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_saveaddressinfo._userno And UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkHomeInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			_HomepageInfo := contacts_saveaddressinfo._homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(_HomepageInfo, '$') > 0 LOOP

				_TempHomeUp := SUBSTRING(_HomepageInfo,0,STRPOS(_HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempHomeUp, ',') > 0 LOOP

					IF _HomeCntUp = 0 THEN
						_HomeIsDefaultUp := SUBSTRING(_TempHomeUp,0,STRPOS(_TempHomeUp, ','));
					ELSIF _HomeCntUp = 1 THEN
						_HomeTypeUp := SUBSTRING(_TempHomeUp,0,STRPOS(_TempHomeUp, ','));
					ELSIF _HomeCntUp = 2 THEN
						_HomeTypeNameUp := SUBSTRING(_TempHomeUp,0,STRPOS(_TempHomeUp, ','));
					END IF;
					_HomeCntUp := _HomeCntUp + 1;
					_TempHomeUp := SUBSTRING(_TempHomeUp,STRPOS(_TempHomeUp, ',')+1,LENGTH(_TempHomeUp));
				END LOOP;
				_HomeValueUp := _TempHomeUp;
				-- 임시테이블에 저장;
				INSERT INTO _tabHomeUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_HomeIsDefaultUp,
					_HomeTypeUp,
					_HomeTypeNameUp,
					_HomeValueUp
				);
				_HomepageInfo := SUBSTRING(_HomepageInfo,STRPOS(_HomepageInfo, '$')+1,LENGTH(_HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabHomeUp;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE _tabSnsUp (IsDefault CHAR(1), Type smallint, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		_ChkSnsInfoUp := REPLACE(_SnsInfo,',','');
		DELETE FROM ContactsSns WHERE RegUserNo = contacts_saveaddressinfo._userno AND UserSeq = contacts_saveaddressinfo._seq;

		IF LENGTH(_ChkSnsInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			_SnsInfo := contacts_saveaddressinfo._snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(_SnsInfo, '$') > 0 LOOP

				_TempSnsUp := SUBSTRING(_SnsInfo,0,STRPOS(_SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(_TempSnsUp, ',') > 0 LOOP

					IF _SnsCntUp = 0 THEN
						_SnsIsDefaultUp := SUBSTRING(_TempSnsUp,0,STRPOS(_TempSnsUp, ','));
					ELSIF _SnsCntUp = 1 THEN
						_SnsTypeUp := SUBSTRING(_TempSnsUp,0,STRPOS(_TempSnsUp, ','));
					ELSIF _SnsCntUp = 2 THEN
						_SnsTypeNameUp := SUBSTRING(_TempSnsUp,0,STRPOS(_TempSnsUp, ','));
					END IF;
					_SnsCntUp := _SnsCntUp + 1;
					_TempSnsUp := SUBSTRING(_TempSnsUp,STRPOS(_TempSnsUp, ',')+1,LENGTH(_TempSnsUp));
				END LOOP;
				_SnsValueUp := _TempSnsUp;
				-- 임시테이블에 저장;
				INSERT INTO _tabSnsUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					_SnsIsDefaultUp,
					_SnsTypeUp,
					_SnsTypeNameUp,
					_SnsValueUp
				);
				_SnsInfo := SUBSTRING(_SnsInfo,STRPOS(_SnsInfo, '$')+1,LENGTH(_SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT _UserNo, _Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM _tabSnsUp;
		END IF;

		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE _tabGroupUp (GroupNo INT, UserSeq INT) ON COMMIT DROP;



		_ChkGroupInfoUp := REPLACE(_GroupInfo,',','');
		IF LENGTH(_ChkGroupInfoUp) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo._seq;
			-- 정보가 존재하면 끝에 , 추가;
			_GroupInfo := contacts_saveaddressinfo._groupinfo || ',';
			WHILE STRPOS(_GroupInfo, ',') > 0 LOOP
				_GroupNoUp := SUBSTRING(_GroupInfo,0,STRPOS(_GroupInfo, ','));
				INSERT INTO _tabGroup
				(
					GroupNo,
					UserSeq
				)
				VALUES
				(
					_GroupNoUp,
					_Seq
				);

				_GroupCntUp := _GroupCntUp + 1;
				_GroupInfo := SUBSTRING(_GroupInfo,STRPOS(_GroupInfo, ',')+1,LENGTH(_GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, _UserNo, NOW(), NOW() FROM _tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo._seq;
		END IF;
		IF 0 <> 0 THEN

		END IF;

	END IF;

	RETURN QUERY
	Select _Seq;
END;
$function$

```
</details>

## `contacts_setcontactsrestore`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_setcontactsrestore"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: integer = character varying
- Stack context: PL/pgSQL function contacts_setcontactsrestore(integer,character varying,character varying) line 4 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactsrestore(_reguserno integer, _userno character varying, _groupno character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y' WHERE Seq=contacts_setcontactsrestore._userno AND RegUserNo=contacts_setcontactsrestore._reguserno;
	UPDATE ContactsGroupUser SET GroupNo=contacts_setcontactsrestore._groupno WHERE UserSeq=contacts_setcontactsrestore._userno AND RegUserNo=contacts_setcontactsrestore._reguserno;
END;
$function$

```
</details>

## `contacts_setcontactsuser`

- Input: `''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contacts_setcontactsuser"(''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer);`
- SQLSTATE: `42804`
- Error: column "groupno" is of type integer but expression is of type character varying
- Stack context: PL/pgSQL function contacts_setcontactsuser(character varying,character varying,character varying,integer,character varying,character varying,character varying,character varying,integer) line 25 at SQL statement
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactsuser(_lastname character varying, _firstname character varying, _nicname character varying, _reguserno integer, _memo character varying, _userpic character varying, _groupno character varying, _share character varying, _seq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF _Seq = 0 THEN
		INSERT INTO ContactsUser(LastName, FirstName, CallName, RegUserNo, Memo, Photo, RegDate, ModDate, CheckDate, Share, UseYn, Important)
		VALUES(_LastName,_FirstName,_NicName,_RegUserNo,_Memo,_UserPic, NOW(), NOW(), NOW(), _Share, 'Y', 0);
		_RTN := lastval();
	ELSE
		UPDATE ContactsUser SET FirstName=contacts_setcontactsuser._firstname, LastName=contacts_setcontactsuser._lastname,CallName=contacts_setcontactsuser._nicname,Memo=contacts_setcontactsuser._memo, RegDate = NOW(), Share=contacts_setcontactsuser._share WHERE Seq=contacts_setcontactsuser._seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_setcontactsuser._reguserno AND UserSeq=contacts_setcontactsuser._seq;
		_RTN := contacts_setcontactsuser._seq;
	END IF;

	CREATE TEMP TABLE _tab (GroupNo INT, UserSeq INT,RegUserNo INT) ON COMMIT DROP;
	WHILE STRPOS(_GroupNo, ',') > 0 LOOP
		INSERT INTO _tab(GroupNo,UserSeq,RegUserNo)
		VALUES (SUBSTRING(_GroupNo,0,STRPOS(_GroupNo, ',')),_RTN,_RegUserNo);
		_GroupNo := SUBSTRING(_GroupNo,STRPOS(_GroupNo, ',')+1,LENGTH(_GroupNo));
	END LOOP;

	INSERT INTO _tab VALUES (_GroupNo,_RTN,_RegUserNo);
	INSERT INTO ContactsGroupUser
	(GroupNo,UserSeq,RegUserNo,RegDate,ModDate)
	SELECT GroupNo, UserSeq, RegUserNo, NOW(), NOW() FROM _tab;

	RETURN QUERY
	SELECT _RTN;
END;
$function$

```
</details>

## `contacts_setshare`

- Input: `0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_setshare"(0::integer, 0::integer, ''::character varying, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying = integer
- Stack context: PL/pgSQL function contacts_setshare(integer,integer,character varying,character varying) line 7 at IF
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setshare(_seq integer, _departno integer, _ischild character varying, _mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    _departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF _Mode = 0 THEN

		_DepartName := public."comngetdepartname"(_DepartNo);
		IF (select count(*) from ContactsSharers where Seq=contacts_setshare._seq and DepartNo= contacts_setshare._departno )=0 THEN
			INSERT INTO ContactsSharers(Seq,DepartNo,DepartName,IsChild)
			VALUES(_Seq,_DepartNo,_DepartName,_IsChild);
		END IF;

	ELSE
		DELETE FROM ContactsSharers WHERE Seq = contacts_setshare._seq;
	END IF;

	RETURN QUERY
	SELECT 0;
END;
$function$

```
</details>

## `contacts_updateandroiddevice_notificationoptions`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updateandroiddevice_notificationoptions"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42P01`
- Error: relation "_androiddevices" does not exist
- Stack context: PL/pgSQL function contacts_updateandroiddevice_notificationoptions(integer,character varying,character varying) line 5 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updateandroiddevice_notificationoptions(_userno integer DEFAULT 70, _deviceid character varying DEFAULT 'cQXYrFi-zgI:APA91bFO_-wi3QTdAe11ZOORe4FKXLHTqNDzxRMlEaciOT2ArI1Jht1-Z8jd2uaQ32i3mk5HdCPF4CN_pQTZJrPQ7_wbZsVvVEPaJ2_AfT9h9UMokm-UaJQ'::character varying, _notificationoptions character varying DEFAULT '{\"enabled\": true,\"sound\": true,\"vibrate\": true,\"notitime\": false,\"starttime\": \"08:00\",\"endtime\": \"18:00\"}'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE _AndroidDevices SET
		NotificationOptions = contacts_updateandroiddevice_notificationoptions._notificationoptions
	WHERE UserNo = contacts_updateandroiddevice_notificationoptions._userno AND DeviceID = contacts_updateandroiddevice_notificationoptions._deviceid;
END;
$function$

```
</details>

## `contacts_updatecontactsuser`

- Input: `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updatecontactsuser"(0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42804`
- Error: column "groupno" is of type integer but expression is of type character varying
- Stack context: PL/pgSQL function contacts_updatecontactsuser(integer,integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying) line 16 at SQL statement
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatecontactsuser(_reguserno integer, _userseq integer, _memo character varying, _share character varying, _groupno character varying, _company character varying, _zipcode1 character varying, _zipcode2 character varying, _address character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_updatecontactsuser._userseq;

	UPDATE ContactsUser SET Memo = contacts_updatecontactsuser._memo, RegDate = NOW(), Share = contacts_updatecontactsuser._share
		WHERE RegUserNo = contacts_updatecontactsuser._reguserno AND Seq = contacts_updatecontactsuser._userseq;

	CREATE TEMP TABLE _tab (GroupNo INT,ContactsUser INT,RegUserNo INT) ON COMMIT DROP;
	WHILE STRPOS(_GroupNo, ',') > 0 LOOP
		INSERT INTO _tab(GroupNo,ContactsUser,RegUserNo)
		VALUES (SUBSTRING(_GroupNo,0,STRPOS(_GroupNo, ',')),_UserSeq,_RegUserNo);
		_GroupNo := SUBSTRING(_GroupNo,STRPOS(_GroupNo, ',')+1,LENGTH(_GroupNo));
	END LOOP;

	INSERT INTO _tab VALUES (_GroupNo,_UserSeq,_RegUserNo);
	INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate) SELECT *,NOW() FROM _tab;

	UPDATE ContactsCompany SET Company = contacts_updatecontactsuser._company WHERE RegUserNo = contacts_updatecontactsuser._reguserno AND UserSeq = contacts_updatecontactsuser._userseq;

	UPDATE ContactsAddress SET ZipCode1 = contacts_updatecontactsuser._zipcode1, ZipCode2 = contacts_updatecontactsuser._zipcode2, Address = contacts_updatecontactsuser._address WHERE RegUserNo = contacts_updatecontactsuser._reguserno AND UserSeq = contacts_updatecontactsuser._userseq;
END;
$function$

```
</details>

