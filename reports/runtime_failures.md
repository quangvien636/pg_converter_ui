# Runtime failures

## `board_authority_select`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_authority_select"(0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_authority_select(integer) line 53 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_authority_select(_user_no integer)
 RETURNS TABLE(id integer, userno integer, name character varying, moduserno integer, menutitle character varying, authority character varying, departmentid integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _rowindex integer;
    _maxindex integer;
    _departno integer;
    _parentno integer;
BEGIN


		CREATE TEMP TABLE _ListOfDepartNos (
			DepartNo	INT
		) ON COMMIT DROP;

		CREATE TEMP TABLE _BelongToDepartments (
			RowNum		serial,
			DepartNo	INT,
			ParentNo	INT
		) ON COMMIT DROP;

		INSERT INTO _BelongToDepartments
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = board_authority_select._user_no
		);


		_RowIndex := 1;
		_MaxIndex := (SELECT MAX(RowNum) FROM _BelongToDepartments);
		WHILE _RowIndex <= _MaxIndex LOOP

			SELECT DepartNo, ParentNo INTO _departno, _parentno FROM _BelongToDepartments

			WHERE RowNum = _RowIndex;

			INSERT INTO _ListOfDepartNos
			SELECT _DepartNo;

			WHILE _ParentNo != 0 LOOP

				SELECT DepartNo, ParentNo INTO _departno, _parentno FROM Organization_Departments
				WHERE DepartNo = _ParentNo;

				INSERT INTO _ListOfDepartNos
				SELECT _DepartNo;

			END LOOP;

			_RowIndex := _RowIndex + 1;
		END LOOP;

RETURN QUERY
SELECT  bu.USERGROUP_ID AS "Id",
		bu.USER_NO AS "UserNo",
		CASE
		  WHEN bu.USER_NO >0  THEN ou.Name
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Name" ,
		ou.ModUserNo,
		(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   (Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority,
		bu.DEPARTMENT_ID AS "DepartmentId"

   --ou.UserNo,
   --ou.Name,
   --ou.ModUserNo,
   --(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   --(Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority
  FROM
  Board_UserByGroup bu LEFT JOIN
	  Organization_Users ou
	  on ou.UserNo = bu.USER_NO inner join Board_AuthoGroup ag on bu.AUTH_GRP_ID=ag.AUTH_GRP_ID

	  LEFT JOIN Organization_Departments od on od.DepartNo=bu.DEPARTMENT_ID
  where (UserNo=board_authority_select._user_no OR DEPARTMENT_ID IN (SELECT DepartNo FROM _ListOfDepartNos)) and MENU_ID=(Select MENU_IDX From Board_Menu Where MENU_ID='MAIN')
  AND NOT (bu.USER_NO >0 AND ou.UserNo Is null)
  ORDER BY ag.AUTH_GRP_ID ASC;
END;
$function$

```
</details>

## `board_getallboardcontents`

- Input: `0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getallboardcontents"(0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false, 0::integer, ''::character varying);`
- SQLSTATE: `42703`
- Error: column "month" does not exist
- Stack context: PL/pgSQL function board_getallboardcontents(integer,integer,boolean,integer,integer,character varying,integer,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean,integer,character varying) line 6 at RETURN QUERY
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallboardcontents(_userno integer DEFAULT 70, _sortcolumn integer DEFAULT 1, _isascending boolean DEFAULT false, _countperpage integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _languagesign character varying DEFAULT 'KO'::character varying, _filtertype integer DEFAULT 100, _viewmode integer DEFAULT (-1), _fromdate timestamp without time zone DEFAULT '2000-01-01 00:00:00'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2028-11-29 11:09:58.86'::timestamp without time zone, _typeeff integer DEFAULT 1, _isalarm boolean DEFAULT false, _isadmin boolean DEFAULT true, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, fileurl text, isfile boolean, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, viewedcount integer, regdatetostring character, rootid bigint, titleeffect integer, isdelete boolean, isreaded boolean, total integer, replycount integer, boardtype integer, regdate timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
WITH PERMISSION AS (
	Select *
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getallboardcontents._userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getallboardcontents._userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo ,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getallboardcontents._userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getallboardcontents._userno),
TMP AS (
	SELECT BC.*,T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getallboardcontents._languagesign ELSE B.Name END AS BoardName ,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS') as RegDateToString,
	CASE WHEN BV.ContentNo IS NOT NULL THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RegDate DESC) AS RowNumber,
	B.ViewMode AS BoardType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getallboardcontents._userno THEN TRUE ELSE FALSE END AS IsDelete
	FROM BOARD_CONTENTS BC
	LEFT JOIN (SELECT *,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo  AND S.Rn=1
	WHERE
	--(BC.BoardNo=BoardNo OR   (BoardNo =0 AND B.ViewMode=2)) AND
	BC.Enabled = TRUE AND BC.RegDate>=board_getallboardcontents._fromdate AND BC.RegDate<=board_getallboardcontents._todate
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND  TitleEffect=board_getallboardcontents._typeeff
	AND  (_IsAlarm = FALSE OR (BC.IsAlarm = board_getallboardcontents._isalarm AND _IsAlarm = TRUE  AND COALESCE(BC.StartDate,NOW())<= NOW() AND COALESCE(BC.EndDate,DATEADD(month, 1, NOW()))>= NOW()  ))
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getallboardcontents._userno OR  ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)  AND B.SpecType=0) OR D.AllowAccessNo IS NOT NULL OR((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))
	AND (COALESCE(_SearchValue,'')='' OR
		 CASE _SearchType
			WHEN 1 THEN BC.Title
			WHEN 2 THEN OD.Name
			WHEN 3 THEN OU.Name
			ELSE BC.Title
		END ILIKE '%' || _SearchValue || '%')


) ,

Total AS (Select count(*) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
T.ViewedCount ,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
R.ReplyCount,
T.BoardType,
T.RegDate
FROM TMP T
LEFT JOIN Total c ON c.Total>0
--LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo


INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE --(T.IsShareAll = TRUE OR IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL )  AND
T.RowNumber>(_CurrentPageIndex-1)*_CountPerPage AND T.RowNumber<=board_getallboardcontents._currentpageindex*_CountPerPage
ORDER BY T.RootId DESC,T.ContentNo ASC;
--	/*
--	 * 쿼리 조합 시작
--	 */

--	DECLARE Query NVARCHAR(2000)
--	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '
--	DECLARE strAlow NVARCHAR(2000)
--	DECLARE strWriteAlow NVARCHAR(2000)
--	SET strAlow = ''
--	SET strWriteAlow = ''
--	if (IsAdmin = FALSE)
--	BEGIN
--		SET strAlow = ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo
--		  LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo
--		  LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(UserNo AS text) || ',1)) AE ON BC.BoardNo=AE.BoardNo '
--		SET strWriteAlow = '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(UserNo AS text) || ' )) AND '
--	END
--	/*
--	 * 정렬 컬럼
--	 */

--	IF (SortColumn <= 1) SET Query += '(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '
--	ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
--	ELSE IF (SortColumn = 3) SET Query += 'LTRIM(BB.Name) '
--	ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
--	ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
--	ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
--	ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '
--	/*
--	 * 정렬 내림차순 여부
--	 */

--	IF (IsAscending = TRUE) SET Query += 'ASC '
--	ELSE SET Query += 'DESC '


--	SET Query += ', BC.LevelRand + CAST(BC.ContentNo As text) ASC, OrderNo ASC'



--	/*
--	 * WHERE 조합 시작
--	 */

--	SET Query +=
--		') RowNum, BC.ContentNo, BC.Content ' ||
--		'FROM Board_Contents BC INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo ' || strAlow || 'WHERE ' || strWriteAlow || ' BB.Enabled = TRUE AND  BC.Enabled = TRUE AND ( BC.ViewMode=' || CAST(ViewMode AS text) || ' OR ' || CAST(ViewMode AS text) || '< 0) '

--	SET Query +=  ' AND ( BC.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BC.RegDate <= ''' || CAST(ToDate AS text) || '''  '

--	SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CAST(FromDate AS text) || ''' AND BR.RegDate <= ''' || CAST(ToDate AS text) || ''' ) > 0 ) '

--	IF (TypeEff > 0)
--	BEGIN
--		SET Query += ' AND BC.TitleEffect <> 2 '
--	END

--	IF (IsAlarm = TRUE)
--	BEGIN
--		SET Query += ' AND BC.IsAlarm = TRUE '
--	END

--    IF (FilterType <> 100)
--	BEGIN
--		SET Query += 'AND BC.RegUserNo <> ' || CAST(UserNo AS text) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CAST(UserNo AS text) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
--	END

--	if (IsAdmin = FALSE)  BEGIN


--	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
--	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 )
--		SET Query +=  '  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR  ( BC.RegUserNo = ' || CAST(UserNo AS text) || ') OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_getdepartmentsbyuser" (' || CAST(UserNo AS text) || ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
--where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CAST(UserNo  AS text) || ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'
--		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
--		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CAST(UserNo AS text) || ' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CAST(DepartNo AS text) || '))'
--	END
--	/*
--	 * 게시글 검색 시작
--	 */
--	DECLARE SearchResult TABLE (
--		RowNum		BIGINT,
--		ContentNo	BIGINT,
--		Content text
--	)
--	PRINT 'Nghiem la ai vay ta' || Query
--	INSERT INTO SearchResult
--	EXEC SP_EXECUTESQL Query



--	/*
--	 * 페이징 계산
--	 */

--	DECLARE TotalItemCount INT
--	DECLARE TotalPageCount INT
--	DECLARE StartRowNum INT
--	DECLARE EndRowNum INT

--	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
--	SET TotalPageCount = TotalItemCount / CountPerPage

--	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
--	IF (TotalPageCount = 0) SET TotalPageCount = 1
--	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

--	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
--	SET EndRowNum = CurrentPageIndex * CountPerPage



--	/*
--	 *
--	 */

--	DECLARE TempTable TABLE (
--		RowNum BIGINT,
--		ContentNo			BIGINT,
--		Content				text,
--		ModUserNo			INT,
--		ModUserName			NVARCHAR(100),
--		ModDepartNo			INT,
--		ModDepartName		NVARCHAR(100),
--		RegDate				DATETIME,
--		Title				NVARCHAR(200),
--		TitleEffect			INT,
--		GroupNo				BIGINT,
--		Depth				INT,
--		OrderNo				INT,
--		HeadNo				INT,
--		IsNotice			BIT,
--		IsFile				BIT,
--		ReplyCount			INT,
--		RecommendedCount	INT,
--		ViewedCount			INT,

--		HeadName			NVARCHAR(100),
--		IsRecommended		BIT,
--		ModPositionNo		INT,
--		ModPositionName		nvarchar(100),
--		FileCount			INT,
--		BoardNo				INT,
--		BoardName			nvarchar(100),
--		RegUserNo			INT,
--		RegUserName			NVARCHAR(100),
--		RegPositionNo		INT,
--		RegPositionName		nvarchar(100),
--		RegDepartNo			INT,
--		RegDepartName		NVARCHAR(100),
--		IsAlarm				BIT
--	)

--	DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
--	DECLARE RecommendedDisplayCount INT

--	SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
--	FROM Board_Boards

--	INSERT INTO TempTable
--		SELECT T.RowNum, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE( ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
--			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

--			BC.RegUserNo,
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
--		BC.RegPositionNo,
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
--		 BC.RegDepartNo,
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
--		,BC.IsAlarm
--		FROM SearchResult T
--		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum


--	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount, (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC ORDER BY RowNum ASC
--	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$

```
</details>

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

## `board_getallboardwidget`

- Input: `''::character varying, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getallboardwidget"(''::character varying, 0::integer, false);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getallboardwidget(character varying,integer,boolean) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallboardwidget(_langcode character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 6656, _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	WITH DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Board_DepartAllowAccess BD
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE BD.ItemType=2 AND OB.UserNo=board_getallboardwidget._userno AND OB.IsDefault= TRUE
)
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_getallboardwidget._langcode,B.Name::json->>'KO') ELSE B.Name END,'') AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.UserNo=board_getallboardwidget._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE W.IsDelete = FALSE  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
	ORDER BY W.Sort DESC;
END;
$function$

```
</details>

## `board_getandroiddeviceofusersbydepartment`

- Input: `''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getandroiddeviceofusersbydepartment"(''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: function fn_getchilddepartnobydepartno(character varying, character varying) does not exist
- Stack context: PL/pgSQL function board_getandroiddeviceofusersbydepartment(character varying,character varying,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getandroiddeviceofusersbydepartment(_listdepartno character varying, _delimiter character varying, _listuserno character varying)
 RETURNS TABLE(deviceid character varying, osversion character varying, notificationoptions character varying, timezoneoffset integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_AndroidDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (SELECT unnest(string_to_array(_ListUserNo, _Delimiter))::integer)
	UNION
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_AndroidDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (select o.UserNo
from Organization_BelongToDepartment o
inner join Organization_Departments d on o.departno=d.departno
--inner join Organization_Users u on u.userno=o.userno
where  o.departno in (select * from FN_GetChildDepartNoByDepartNo(_ListDepartNo,_Delimiter))
--and u.Enabled = TRUE
);
END;
$function$

```
</details>

## `board_getboardbyuserno`

- Input: `0::integer, false, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getboardbyuserno"(0::integer, false, 0::integer, 0::integer, false);`
- SQLSTATE: `42883`
- Error: operator does not exist: ~ boolean
- Stack context: PL/pgSQL function board_getboardbyuserno(integer,boolean,integer,integer,boolean) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardbyuserno(_userno integer DEFAULT 6656, _isdisabled boolean DEFAULT false, _viewmode integer DEFAULT (-1), _displaytypeno integer DEFAULT (-1), _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name character varying, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, enabled boolean, viewmode integer, spectype integer, countcontent integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getboardbyuserno._userno AND OB.IsDefault= TRUE
)
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
				B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled,B.ViewMode,B.SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE
					And BC.RegUserNo <> board_getboardbyuserno._userno
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_getboardbyuserno._userno)
					And (_IsAdmin = TRUE OR BA.AllowValue=7 OR
					(  (BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(_UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_belongtodepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_getboardbyuserno._userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboardbyuserno._userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getboardbyuserno._userno
			LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
			WHERE (ViewMode=board_getboardbyuserno._viewmode OR _ViewMode < 0) And (DisplayTypeNo=board_getboardbyuserno._displaytypeno OR _DisplayTypeNo < 0)  AND  B.Enabled = ~_IsDisabled  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
			ORDER BY SortNo DESC;
END;
$function$

```
</details>

## `board_getboardcommunitywidget`

- Input: `''::character varying, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getboardcommunitywidget"(''::character varying, 0::integer, false);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getboardcommunitywidget(character varying,integer,boolean) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcommunitywidget(_langcode character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 6656, _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getboardcommunitywidget._userno AND OB.IsDefault= TRUE
)
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_getboardcommunitywidget._langcode,B.Name::json->>board_getboardcommunitywidget._langcode) ELSE B.Name END,'') AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getboardcommunitywidget._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE W.IsDelete = FALSE AND W.Type=2  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
	ORDER BY W.Sort DESC;
END;
$function$

```
</details>

## `board_getboardcontentinfo`

- Input: `0::bigint, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getboardcontentinfo"(0::bigint, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getboardcontentinfo(bigint,character varying) line 17 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcontentinfo(_contentno bigint DEFAULT 4780, _languagesign character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(boardno integer, moduserno integer, boardname text, modusername character varying, modpositionno integer, modpositionname character varying, moddepartno integer, moddepartname character varying, regdate timestamp without time zone, moddate timestamp without time zone, title character varying, titleeffect integer, groupno bigint, depth integer, orderno integer, headno integer, isnotice boolean, content text, isfile boolean, filecount integer, replycount integer, recommendedcount integer, viewedcount integer, startdate timestamp without time zone, enddate timestamp without time zone, headname character varying, isrecommended boolean, reguserno integer, regusername character varying, regpositionno integer, regpositionname character varying, regdepartno integer, regdepartname character varying, isalarm boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

--DECLARE ShareDepart AS text;
--DECLARE ShareUser AS text;
--SET ShareDepart= STUFF((SELECT ';' || DepartName
--               FROM Board_Sharers
--              WHERE ContentNo=ContentNo AND (UserNo IS NULL OR UserNo=0)
--		   FOR XML PATH(''), TYPE).value('.','text'), 1, 1, '');
--SET ShareUser =  STUFF((SELECT ';' || OU.Name
--               FROM Board_Sharers  BS
--			   LEFT JOIN ORGANIZATION_USERS OU ON OU.UserNo=BS.UserNo
--              WHERE ContentNo=ContentNo AND BS.UserNo IS NOT NULL AND BS.UserNo<>0
--		   FOR XML PATH(''), TYPE).value('.','text'), 1, 1, '');;

	RETURN QUERY
	SELECT BC.BoardNo, BC.ModUserNo,
		CASE WHEN STRPOS(BB.Name, '{')>0 THEN BB.Name::json->>'EN' ELSE BB.Name END  AS BoardName,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(OU.Name_EN,OU.Name) ELSE OU.Name END AS ModUserName,
		BC.ModPositionNo,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(OP.Name_EN ,OP.Name) ELSE OP.Name  END AS ModPositionName,
		BC.ModDepartNo,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(OD.Name_EN ,OD.Name) ELSE  OD.Name  END AS ModDepartName,
		BC.RegDate, BC.ModDate, BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice, BC.Content, BC.IsFile, BC.FileCount,
		BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount, BC.StartDate, BC.EndDate,
		COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended,

		BC.RegUserNo,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(GOU.Name_EN,GOU.Name) ELSE GOU.Name END AS RegUserName,
		BC.RegPositionNo,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(GOP.Name_EN ,OP.Name) ELSE GOP.Name  END AS RegPositionName,
		BC.RegDepartNo,
		CASE WHEN _LanguageSign = 'EN' THEN COALESCE(GOD.Name_EN ,GOD.Name) ELSE  GOD.Name  END AS RegDepartName
		,BC.IsAlarm
		--,ShareDepart+ShareUser AS ShareList
	FROM Board_Contents BC
	LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	LEFT JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.ModUserNo AND OU.Enabled = TRUE
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.ModPositionNo  AND OP.Enabled = TRUE
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.ModPositionNo  AND OD.Enabled = TRUE
	LEFT JOIN Organization_Users GOU ON GOU.UserNo = BC.RegUserNo AND GOU.Enabled = TRUE
	LEFT JOIN Organization_Positions GOP ON GOP.PositionNo = BC.RegPositionNo  AND GOP.Enabled = TRUE
	LEFT JOIN Organization_Departments GOD ON GOD.DepartNo = BC.RegDepartNo  AND GOD.Enabled = TRUE

	WHERE ContentNo = board_getboardcontentinfo._contentno;
END;
$function$

```
</details>

## `board_getboardcontents`

- Input: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getboardcontents"(0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42601`
- Error: syntax error at or near "LEFT"
- Stack context: PL/pgSQL function board_getboardcontents(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 120 at EXECUTE statement
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


	_Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	_strAlow := '';
	_strWriteAlow := '';
	IF _IsAdmin = FALSE THEN
		_strAlow := ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo;
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		_strWriteAlow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(_UserNo AS text) || ' )) AND ';
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

	EXECUTE format('INSERT INTO _SearchResult ' || _Query, _BoardNo);
	/*
	 * 페이징 계산
	 */






	_TotalItemCount := (SELECT COUNT(*) FROM _SearchResult);
	_TotalPageCount := _TotalItemCount / _CountPerPage;
	IF _TotalItemCount % _CountPerPage > 0 THEN
	    _TotalPageCount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	_StartRowNum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_EndRowNum := board_getboardcontents._currentpageindex * _CountPerPage;
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
- Error: syntax error at or near "LEFT"
- Stack context: PL/pgSQL function board_getboardcontents_bk20181227(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 120 at EXECUTE statement
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


	_Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	_strAlow := '';
	_strWriteAlow := '';
	IF _IsAdmin = FALSE THEN
		_strAlow := ' LEFT JOIN (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',2)) AC ON BC.BoardNo=AC.BoardNo;
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."board_getboardallow"(' || CAST(_UserNo AS text) || ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		_strWriteAlow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CAST(_UserNo AS text) || ' )) AND ';
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

	EXECUTE format('INSERT INTO _SearchResult ' || _Query, _BoardNo);
	/*
	 * 페이징 계산
	 */






	_TotalItemCount := (SELECT COUNT(*) FROM _SearchResult);
	_TotalPageCount := _TotalItemCount / _CountPerPage;
	IF _TotalItemCount % _CountPerPage > 0 THEN
	    _TotalPageCount := _TotalPageCount + 1;
	END IF;
	IF _TotalPageCount = 0 THEN
	    _TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	_StartRowNum := ((_CurrentPageIndex - 1) * _CountPerPage) + 1;
	_EndRowNum := board_getboardcontents_bk20181227._currentpageindex * _CountPerPage;
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

## `board_getboards`

- Input: `0::integer, false, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getboards"(0::integer, false, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "user_depart" does not exist
- Stack context: PL/pgSQL function board_getboards(integer,boolean,integer,integer,boolean) line 6 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboards(_userno integer DEFAULT 70, _isdisabled boolean DEFAULT false, _viewmode integer DEFAULT (-1), _displaytypeno integer DEFAULT (-1), _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name character varying, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, enabled boolean, viewmode integer, spectype integer, countcontent integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


    RETURN QUERY
    WITH

    -- ----------------------------------------------------------------
    -- 1 Táº¥t cáº£ phÃ²ng ban cá»§a user â€” gá»“m cáº£ dept cha trong hierarchy
    --     Anchor  : dept trá»±c tiáº¿p tá»« Organization_BelongToDepartment
    --     Recursive: leo ngÆ°á»£c ParentNo Ä‘áº¿n root (ParentNo=0)
    --     Fix v1  : v1 chá»‰ query Organization_BelongToDepartment (dept trá»±c tiáº¿p)
    --               â†’ bá» sÃ³t dept cha â†’ share check sai
    --     Replaces: Organization_GetDepartmentsByUser(UserNo)
    -- ----------------------------------------------------------------
    USER_DEPART AS (
        -- Anchor: dept trá»±c tiáº¿p
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_BelongToDepartment      OBD
        INNER JOIN Organization_Departments OD ON OD.DepartNo = OBD.DepartNo
        WHERE  OBD.UserNo = board_getboards._userno

        UNION ALL

        -- Recursive: dept cha
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_Departments OD
        INNER JOIN USER_DEPART                   UD ON OD.DepartNo = UD.ParentNo
        WHERE  UD.ParentNo <> 0
    ),

    -- ----------------------------------------------------------------
    -- 2 Board user cÃ³ quyá»n Ä‘á»c trá»±c tiáº¿p (AllowValue bit 2)
    -- ----------------------------------------------------------------
    PERM_BOARD_DIRECT AS (
        SELECT A.ItemNo AS BoardNo
        FROM   Board_AllowAccess A
        WHERE  A.UserNo     = board_getboards._userno
          AND  A.ItemType   = 2
          AND  (A.AllowValue & 2) > 0
    ),

    -- ----------------------------------------------------------------
    -- 3 Folder cÃ³ quyá»n Ä‘á»c + toÃ n bá»™ sub-folder con chÃ¡u
    --     Anchor  : folder user cÃ³ AllowValue bit 2 â€” ItemType=1
    --     Recursive: má»Ÿ rá»™ng xuá»‘ng folder con qua ParentNo
    -- ----------------------------------------------------------------
    PERMITTED_FOLDER_TREE AS (
        -- Anchor: folder cÃ³ quyá»n trá»±c tiáº¿p
        SELECT BF.FolderNo, BF.ParentNo
        FROM   Board_AllowAccess               A
        INNER JOIN Board_Folders      BF ON BF.FolderNo = A.ItemNo
        WHERE  A.UserNo     = board_getboards._userno
          AND  A.ItemType   = 1
          AND  (A.AllowValue & 2) > 0
          AND  BF.Enabled = TRUE

        UNION ALL

        -- Recursive: folder con
        SELECT F.FolderNo, F.ParentNo
        FROM   Board_Folders F
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON F.ParentNo = PFT.FolderNo
        WHERE  F.Enabled = TRUE
    ),

    -- ----------------------------------------------------------------
    -- 4 Board trong folder (hoáº·c sub-folder) Ä‘Æ°á»£c phÃ©p Ä‘á»c
    -- ----------------------------------------------------------------
    PERM_BOARD_FOLDER AS (
        SELECT DISTINCT B.BoardNo
        FROM   Board_Boards B
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON PFT.FolderNo = B.FolderNo
    ),

    -- ----------------------------------------------------------------
    -- 5 Tá»•ng há»£p: board user Ä‘Æ°á»£c phÃ©p Ä‘á»c (trá»±c tiáº¿p + qua folder)
    -- ----------------------------------------------------------------
    PERM_BOARD AS (
        SELECT BoardNo FROM PERM_BOARD_DIRECT
        UNION
        SELECT BoardNo FROM PERM_BOARD_FOLDER
    ),

    -- ----------------------------------------------------------------
    -- 6 Contents user Ä‘Ã£ Ä‘á»c
    -- ----------------------------------------------------------------
    VIEWED AS (
        SELECT ContentNo
        FROM   Board_ViewedLogs
        WHERE  UserNo = board_getboards._userno
    ),

    -- ----------------------------------------------------------------
    -- 7 Contents shared vá»›i user (dept trá»±c tiáº¿p + toÃ n bá»™ dept cha)
    --     Fix v1: v1 chá»‰ check dept trá»±c tiáº¿p â†’ miss share vá»›i dept cha
    -- ----------------------------------------------------------------
    SHARED AS (
        SELECT DISTINCT BS.ContentNo
        FROM   Board_Sharers BS
        WHERE  BS.UserNo   = board_getboards._userno
           OR  BS.DepartNo IN (SELECT DISTINCT DepartNo FROM USER_DEPART)
    ),

    -- ----------------------------------------------------------------
    -- 8 Sá»‘ content chÆ°a Ä‘á»c â€” ADMIN path
    -- ----------------------------------------------------------------
    COUNT_ADMIN AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    NOT EXISTS (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
        GROUP BY BC.BoardNo
    ),

    -- ----------------------------------------------------------------
    -- 9 Sá»‘ content chÆ°a Ä‘á»c â€” USER path (permission + share)
    -- ----------------------------------------------------------------
    COUNT_USER AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    BC.BoardNo  IN (SELECT BoardNo FROM PERM_BOARD)
          AND    NOT EXISTS  (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
          AND    (
                      BC.ContentNo IN (SELECT ContentNo FROM SHARED)
                   OR NOT EXISTS (SELECT 1 FROM Board_Sharers BS2 WHERE BS2.ContentNo = BC.ContentNo)
                 )
        GROUP BY BC.BoardNo
    )

    -- ----------------------------------------------------------------
    -- 10 Káº¿t quáº£ cuá»‘i
    -- ----------------------------------------------------------------
    SELECT
        B.BoardNo,
        B.ModUserNo,
        B.ModDate,
        B.Name,
        B.Description,
        B.FolderNo,
        B.DisplayTypeNo,
        B.SortNo,
        B.IsReply,
        B.IsHead,
        B.IsNotice,
        B.IsRecommend,
        B.RecommendedDisplayCount,
        B.Enabled,
        B.ViewMode,
        B.SpecType,
        COALESCE(
            CASE WHEN _IsAdmin = TRUE THEN CA.UnreadCount
                                   ELSE CU.UnreadCount
            END,
            0
        ) AS CountContent
    FROM  Board_Boards B
    LEFT JOIN COUNT_ADMIN CA ON CA.BoardNo = B.BoardNo
    LEFT JOIN COUNT_USER  CU ON CU.BoardNo = B.BoardNo
    WHERE  (_IsDisabled = TRUE OR B.Enabled = TRUE)
      AND  (B.ViewMode      = board_getboards._viewmode      OR _ViewMode      < 0)
      AND  (B.DisplayTypeNo = board_getboards._displaytypeno OR _DisplayTypeNo < 0)
    ORDER BY B.SortNo ASC, B.BoardNo ASC;
END;
$function$

```
</details>

## `board_getboards_bk`

- Input: `0::integer, false, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getboards_bk"(0::integer, false, 0::integer, 0::integer, false);`
- SQLSTATE: `42883`
- Error: function public.organization_getdepartmentsbyuser(integer) does not exist
- Stack context: PL/pgSQL function board_getboards_bk(integer,boolean,integer,integer,boolean) line 35 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboards_bk(_userno integer DEFAULT 70, _isdisabled boolean DEFAULT false, _viewmode integer DEFAULT (-1), _displaytypeno integer DEFAULT (-1), _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name character varying, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, enabled boolean, viewmode integer, spectype integer, countcontent integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	IF _IsDisabled = TRUE THEN
	   IF _IsAdmin = FALSE THEN
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC
				WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE-- And BC.RegUserNo <> UserNo
					And BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(  _UserNo ,2))
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk._userno)
					AND ((BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_getdepartmentsbyuser"(_UserNo) DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboards_bk._userno)) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )  ) As CountContent
			FROM Board_Boards
			WHERE (ViewMode=board_getboards_bk._viewmode OR _ViewMode < 0) And (DisplayTypeNo=board_getboards_bk._displaytypeno OR _DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC;
	   ELSE
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC  WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE-- And BC.RegUserNo <> UserNo
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk._userno) ) As CountContent
			FROM Board_Boards
			WHERE (ViewMode=board_getboards_bk._viewmode OR _ViewMode < 0) And (DisplayTypeNo=board_getboards_bk._displaytypeno OR _DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC;
	   END IF;



	ELSE
		IF _IsAdmin = FALSE THEN
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC
				WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE --And BC.RegUserNo <> UserNo
					And BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(  _UserNo ,2))
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk._userno)
					AND ((BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_getdepartmentsbyuser"(_UserNo) DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboards_bk._userno)) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) ) ) As CountContent
			FROM Board_Boards
			WHERE Enabled = TRUE AND (ViewMode=board_getboards_bk._viewmode  OR _ViewMode < 0) And (DisplayTypeNo=board_getboards_bk._displaytypeno OR _DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC;
	   ELSE
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents
					WHERE  Board_Contents.BoardNo = Board_Boards.BoardNo AND Enabled = TRUE
						--And Board_Contents.RegUserNo <> UserNo
						And Board_Contents.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk._userno)) As CountContent
			FROM Board_Boards
			WHERE Enabled = TRUE AND (ViewMode=board_getboards_bk._viewmode  OR _ViewMode < 0) And (DisplayTypeNo=board_getboards_bk._displaytypeno OR _DisplayTypeNo < 0)
			ORDER BY SortNo ASC,BoardNo ASC;
	   END IF;
	END IF;
END;
$function$

```
</details>

## `board_getboards_improved`

- Input: `0::integer, false, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getboards_improved"(0::integer, false, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "user_depart" does not exist
- Stack context: PL/pgSQL function board_getboards_improved(integer,boolean,integer,integer,boolean) line 6 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboards_improved(_userno integer DEFAULT 70, _isdisabled boolean DEFAULT false, _viewmode integer DEFAULT (-1), _displaytypeno integer DEFAULT (-1), _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name character varying, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, enabled boolean, viewmode integer, spectype integer, countcontent integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


    RETURN QUERY
    WITH

    -- ----------------------------------------------------------------
    -- 1 Táº¥t cáº£ phÃ²ng ban cá»§a user â€” gá»“m cáº£ dept cha trong hierarchy
    --     Anchor  : dept trá»±c tiáº¿p tá»« Organization_BelongToDepartment
    --     Recursive: leo ngÆ°á»£c ParentNo Ä‘áº¿n root (ParentNo=0)
    --     Fix v1  : v1 chá»‰ query Organization_BelongToDepartment (dept trá»±c tiáº¿p)
    --               â†’ bá» sÃ³t dept cha â†’ share check sai
    --     Replaces: Organization_GetDepartmentsByUser(UserNo)
    -- ----------------------------------------------------------------
    USER_DEPART AS (
        -- Anchor: dept trá»±c tiáº¿p
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_BelongToDepartment      OBD
        INNER JOIN Organization_Departments OD ON OD.DepartNo = OBD.DepartNo
        WHERE  OBD.UserNo = board_getboards_improved._userno

        UNION ALL

        -- Recursive: dept cha
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_Departments OD
        INNER JOIN USER_DEPART                   UD ON OD.DepartNo = UD.ParentNo
        WHERE  UD.ParentNo <> 0
    ),

    -- ----------------------------------------------------------------
    -- 2 Board user cÃ³ quyá»n Ä‘á»c trá»±c tiáº¿p (AllowValue bit 2)
    -- ----------------------------------------------------------------
    PERM_BOARD_DIRECT AS (
        SELECT A.ItemNo AS BoardNo
        FROM   Board_AllowAccess A
        WHERE  A.UserNo     = board_getboards_improved._userno
          AND  A.ItemType   = 2
          AND  (A.AllowValue & 2) > 0
    ),

    -- ----------------------------------------------------------------
    -- 3 Folder cÃ³ quyá»n Ä‘á»c + toÃ n bá»™ sub-folder con chÃ¡u
    --     Anchor  : folder user cÃ³ AllowValue bit 2 â€” ItemType=1
    --     Recursive: má»Ÿ rá»™ng xuá»‘ng folder con qua ParentNo
    -- ----------------------------------------------------------------
    PERMITTED_FOLDER_TREE AS (
        -- Anchor: folder cÃ³ quyá»n trá»±c tiáº¿p
        SELECT BF.FolderNo, BF.ParentNo
        FROM   Board_AllowAccess               A
        INNER JOIN Board_Folders      BF ON BF.FolderNo = A.ItemNo
        WHERE  A.UserNo     = board_getboards_improved._userno
          AND  A.ItemType   = 1
          AND  (A.AllowValue & 2) > 0
          AND  BF.Enabled = TRUE

        UNION ALL

        -- Recursive: folder con
        SELECT F.FolderNo, F.ParentNo
        FROM   Board_Folders F
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON F.ParentNo = PFT.FolderNo
        WHERE  F.Enabled = TRUE
    ),

    -- ----------------------------------------------------------------
    -- 4 Board trong folder (hoáº·c sub-folder) Ä‘Æ°á»£c phÃ©p Ä‘á»c
    -- ----------------------------------------------------------------
    PERM_BOARD_FOLDER AS (
        SELECT DISTINCT B.BoardNo
        FROM   Board_Boards B
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON PFT.FolderNo = B.FolderNo
    ),

    -- ----------------------------------------------------------------
    -- 5 Tá»•ng há»£p: board user Ä‘Æ°á»£c phÃ©p Ä‘á»c (trá»±c tiáº¿p + qua folder)
    -- ----------------------------------------------------------------
    PERM_BOARD AS (
        SELECT BoardNo FROM PERM_BOARD_DIRECT
        UNION
        SELECT BoardNo FROM PERM_BOARD_FOLDER
    ),

    -- ----------------------------------------------------------------
    -- 6 Contents user Ä‘Ã£ Ä‘á»c
    -- ----------------------------------------------------------------
    VIEWED AS (
        SELECT ContentNo
        FROM   Board_ViewedLogs
        WHERE  UserNo = board_getboards_improved._userno
    ),

    -- ----------------------------------------------------------------
    -- 7 Contents shared vá»›i user (dept trá»±c tiáº¿p + toÃ n bá»™ dept cha)
    --     Fix v1: v1 chá»‰ check dept trá»±c tiáº¿p â†’ miss share vá»›i dept cha
    -- ----------------------------------------------------------------
    SHARED AS (
        SELECT DISTINCT BS.ContentNo
        FROM   Board_Sharers BS
        WHERE  BS.UserNo   = board_getboards_improved._userno
           OR  BS.DepartNo IN (SELECT DISTINCT DepartNo FROM USER_DEPART)
    ),

    -- ----------------------------------------------------------------
    -- 8 Sá»‘ content chÆ°a Ä‘á»c â€” ADMIN path
    -- ----------------------------------------------------------------
    COUNT_ADMIN AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    NOT EXISTS (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
        GROUP BY BC.BoardNo
    ),

    -- ----------------------------------------------------------------
    -- 9 Sá»‘ content chÆ°a Ä‘á»c â€” USER path (permission + share)
    -- ----------------------------------------------------------------
    COUNT_USER AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    BC.BoardNo  IN (SELECT BoardNo FROM PERM_BOARD)
          AND    NOT EXISTS  (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
          AND    (
                      BC.ContentNo IN (SELECT ContentNo FROM SHARED)
                   OR NOT EXISTS (SELECT 1 FROM Board_Sharers BS2 WHERE BS2.ContentNo = BC.ContentNo)
                 )
        GROUP BY BC.BoardNo
    )

    -- ----------------------------------------------------------------
    -- 10 Káº¿t quáº£ cuá»‘i
    -- ----------------------------------------------------------------
    SELECT
        B.BoardNo,
        B.ModUserNo,
        B.ModDate,
        B.Name,
        B.Description,
        B.FolderNo,
        B.DisplayTypeNo,
        B.SortNo,
        B.IsReply,
        B.IsHead,
        B.IsNotice,
        B.IsRecommend,
        B.RecommendedDisplayCount,
        B.Enabled,
        B.ViewMode,
        B.SpecType,
        COALESCE(
            CASE WHEN _IsAdmin = TRUE THEN CA.UnreadCount
                                   ELSE CU.UnreadCount
            END,
            0
        ) AS CountContent
    FROM  Board_Boards B
    LEFT JOIN COUNT_ADMIN CA ON CA.BoardNo = B.BoardNo
    LEFT JOIN COUNT_USER  CU ON CU.BoardNo = B.BoardNo
    WHERE  (_IsDisabled = TRUE OR B.Enabled = TRUE)
      AND  (B.ViewMode      = board_getboards_improved._viewmode      OR _ViewMode      < 0)
      AND  (B.DisplayTypeNo = board_getboards_improved._displaytypeno OR _DisplayTypeNo < 0)
    ORDER BY B.SortNo ASC, B.BoardNo ASC;
END;
$function$

```
</details>

## `board_getcurrentmanagerlist`

- Input: ``
- Generated SQL: `SELECT * FROM "public"."board_getcurrentmanagerlist"();`
- SQLSTATE: `42883`
- Error: function public.uf_departmentname(integer) does not exist
- Stack context: PL/pgSQL function board_getcurrentmanagerlist() line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getcurrentmanagerlist()
 RETURNS TABLE(id integer, userno integer, username character varying, groupname character varying, department character varying, departmentid integer, date timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	select
		bg.USERGROUP_ID AS "Id",
		bg.USER_NO AS "UserNo",
		CASE
		  WHEN bg.USER_NO >0  THEN us.Name
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "UserName" ,
		ag.AUTH_GRP_NM AS "GroupName",
		CASE
		  WHEN bg.USER_NO >0  THEN public."uf_departmentname" (bg.USER_NO)
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Department" ,
		bg.DEPARTMENT_ID AS "DepartmentId",
		convert(datetime, bg.DTS_INSERT, 111) AS "Date"
	from
	Board_UserByGroup bg LEFT JOIN
	  Organization_Users us
	  on us.UserNo = bg.USER_NO inner join Board_AuthoGroup ag on bg.AUTH_GRP_ID=ag.AUTH_GRP_ID

	  LEFT JOIN Organization_Departments od on od.DepartNo=bg.DEPARTMENT_ID
	  where ag.AUTH_GRP_NM <>'Super Admin'
	  AND NOT (bg.USER_NO >0 AND us.UserNo Is null);
END;
$function$

```
</details>

## `board_getfolderbyuserno`

- Input: `0::integer, false, false`
- Generated SQL: `SELECT * FROM "public"."board_getfolderbyuserno"(0::integer, false, false);`
- SQLSTATE: `42P01`
- Error: relation "folder" does not exist
- Stack context: PL/pgSQL function board_getfolderbyuserno(integer,boolean,boolean) line 6 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getfolderbyuserno(_userno integer DEFAULT 70, _isdisabled boolean DEFAULT false, _isadmin boolean DEFAULT true)
 RETURNS TABLE(folderno integer, moduserno integer, moddate timestamp without time zone, name character varying, parentno integer, sortno integer, enabled boolean, levelrand character varying, spectype integer, isopen boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=1 AND OB.UserNo=board_getfolderbyuserno._userno AND OB.IsDefault= TRUE
),
PARENTS AS (
	SELECT BF.*
	FROM  Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getfolderbyuserno._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo
	WHERE  BF.ParentNo = 0 AND  BF.Enabled = TRUE AND (_IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0)
	ORDER BY SortNo ASC,FolderNo ASC),
CHILDRENTS AS (
	SELECT BF.*
	FROM  Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getfolderbyuserno._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo
	WHERE  BF.ParentNo >0 AND  BF.Enabled = TRUE  AND (_IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0)
	ORDER BY SortNo ASC,FolderNo ASC),
FOLDER AS
(
    SELECT     T.FolderNo  ,T.ModUserNo,T.ModDate, T.Name, T.ParentNo, T.SortNo, T.Enabled, T.LevelRand,T.SpecType
    FROM       PARENTS T
    UNION ALL
    SELECT     C.FolderNo, C.ModUserNo, C.ModDate, C.Name, C.ParentNo, C.SortNo, C.Enabled, C.LevelRand,C.SpecType
    FROM       CHILDRENTS C
    INNER JOIN FOLDER F ON F.FolderNo = C.ParentNo AND C.Enabled=~_IsDisabled
),
History AS (
	SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
	FROM Board_HistoryFolder BH WHERE BH.UserNo=board_getfolderbyuserno._userno
)
SELECT F.* ,COALESCE(BH.IsOpen, TRUE) AS IsOpen
FROM FOLDER F
LEFT JOIN History BH ON  F.FolderNo=BH.FolderNo AND BH.RowNum=1
ORDER BY F.ParentNo ASC, F.SortNo DESC;
END;
$function$

```
</details>

## `board_getfolders`

- Input: `false, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getfolders"(false, 0::integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: ~ boolean
- Stack context: PL/pgSQL function board_getfolders(boolean,integer) line 8 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getfolders(_isdisabled boolean DEFAULT false, _userno integer DEFAULT 74)
 RETURNS TABLE(folderno integer, moduserno integer, moddate timestamp without time zone, name character varying, parentno integer, sortno integer, enabled boolean, levelrand character varying, spectype integer, isopen boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	--IF (IsDisabled = TRUE) BEGIN

		RETURN QUERY
		WITH  History AS (
				SELECT *, ROW_NUMBER() OVER (PARTITION BY  UserNo,FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder WHERE UserNo=board_getfolders._userno
			)
		SELECT BF.FolderNo, BF.ModUserNo, BF.ModDate, BF.Name, BF.ParentNo, BF.SortNo, BF.Enabled, COALESCE(BF.LevelRand,',') AS LevelRand,BF.SpecType,COALESCE(BH.IsOpen, TRUE) AS IsOpen
		FROM Board_Folders BF
		LEFT JOIN History BH ON BH.UserNo=board_getfolders._userno AND BF.FolderNo=BH.FolderNo AND BH.RowNum=1
		WHERE Enabled = ~_IsDisabled
		ORDER BY BF.SortNo ASC,BF.FolderNo ASC;

	--END

	--ELSE BEGIN

	--	SELECT BF.FolderNo, BF.ModUserNo, BF.ModDate, BF.Name, BF.ParentNo, BF.SortNo, BF.Enabled, COALESCE(BF.LevelRand,',') AS LevelRand,BF.SpecType,COALESCE(BH.IsOpen, TRUE) AS IsOpen
	--	FROM Board_Folders BF
	--    LEFT JOIN Board_HistoryFolder BH ON BH.UserNo=UserNo AND BF.FolderNo=BH.FolderNo
	--	WHERE Enabled = TRUE
	--	ORDER BY BF.SortNo ASC,BF.FolderNo ASC

	--END
END;
$function$

```
</details>

## `board_getiosdeviceofusersbydepartment`

- Input: `''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getiosdeviceofusersbydepartment"(''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: function fn_getchilddepartnobydepartno(character varying, character varying) does not exist
- Stack context: PL/pgSQL function board_getiosdeviceofusersbydepartment(character varying,character varying,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getiosdeviceofusersbydepartment(_listdepartno character varying, _delimiter character varying, _listuserno character varying)
 RETURNS TABLE(deviceid character varying, osversion character varying, notificationoptions character varying, timezoneoffset integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (SELECT unnest(string_to_array(_ListUserNo, _Delimiter))::integer)
	UNION
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (select o.UserNo
from Organization_BelongToDepartment o
inner join Organization_Departments d on o.departno=d.departno
--inner join Organization_Users u on u.userno=o.userno
where  o.departno in (select * from FN_GetChildDepartNoByDepartNo(_ListDepartNo,_Delimiter))
--and u.Enabled = TRUE
);
END;
$function$

```
</details>

## `board_getlistboardcontent`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontent"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontent(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean,character varying) line 9 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontent(_userno integer DEFAULT 70, _boardno integer DEFAULT 1094, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 15, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2000-07-08 00:00:01'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2026-07-09 00:00:01'::timestamp without time zone, _isadmin boolean DEFAULT true, _titleeffect boolean DEFAULT false, _mgdepartment character varying DEFAULT ''::character varying)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, fileurl text, filename character varying, thumbnailfileurl text, isfile boolean, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, viewedcount integer, regdatetostring character varying, rootid bigint, titleeffect integer, isdelete boolean, isreaded boolean, total integer, replycount integer, boardtype integer, regdate timestamp without time zone, moddate timestamp without time zone, isnotice boolean, type character varying, errortype character varying, persontype character varying, visitdate timestamp without time zone, visitcompletedate timestamp without time zone, constructionname character varying, daydateview integer, applyto character varying, mailrecipientno text, mailrecipientname text, important boolean, designno character varying, private boolean, reguserno integer, purpose character varying, recommendedcount integer, isrecommendpublic boolean, rownumber bigint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


    _SearchValue := COALESCE(LTRIM(RTRIM(_SearchValue)),  '');
    _MgDepartment := COALESCE(LTRIM(RTRIM(_MgDepartment)), '');
    _SortColumn := COALESCE(LTRIM(RTRIM(_SortColumn)),   '');
    RETURN QUERY
    WITH
    PERMISSION AS (
        SELECT ItemNo, AllowValue, AllowAccessNo
        FROM   Board_AllowAccess
        WHERE  ItemType = 2 AND UserNo = board_getlistboardcontent._userno AND AllowValue > 0
    ),
    DEPARTPERMISSION AS (
        SELECT BD.ItemNo, BD.AllowValue, BD.AllowAccessNo
        FROM   Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE  BD.ItemType = 2 AND OB.UserNo = board_getlistboardcontent._userno
          AND  OB.IsDefault = TRUE AND BD.AllowValue > 0
    ),
    USER_DEPART AS (
        SELECT U.UserNo, OB.DepartNo
        FROM   Organization_Users U
        INNER JOIN Organization_BelongToDepartment OB ON OB.UserNo = U.UserNo
        WHERE  U.UserNo = board_getlistboardcontent._userno AND U.Enabled = TRUE
    ),
    SHARE AS (
        SELECT DISTINCT BS.ContentNo FROM Board_Sharers BS
        INNER JOIN USER_DEPART UD ON BS.UserNo   = UD.UserNo
        UNION
        SELECT DISTINCT BS.ContentNo FROM Board_Sharers BS
        INNER JOIN USER_DEPART UD ON BS.DepartNo = UD.DepartNo
    ),
    PERMISSION_BOARD AS (
        SELECT B.BoardNo, B.Name, B.ViewMode, B.SpecType
        FROM   Board_Boards B
        LEFT JOIN PERMISSION       P ON P.ItemNo = B.BoardNo
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo
        WHERE  (B.BoardNo = board_getlistboardcontent._boardno OR _BoardNo = 0)
          AND  (_IsAdmin = TRUE OR P.AllowValue > 0 OR D.AllowValue > 0 OR B.SpecType = 1)
    ),
    VIEWED AS (
        SELECT DISTINCT ContentNo FROM Board_ViewedLogs WHERE UserNo = board_getlistboardcontent._userno
    ),
    TMP AS (
        SELECT
            BC.BoardNo, BC.ContentNo, BC.Title, BC.IsFile, BC.ViewedCount, BC.RootId,
            BC.TitleEffect, BC.RegDate, BC.ModDate, BC.IsNotice, BC.RegUserNo,
            CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent._langcode ELSE B.Name END AS BoardName,
            CASE _LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
            CASE _LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
            CASE _LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
            SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) AS RegDateToString,
            CASE WHEN '2020-12-31'::timestamp>BC.RegDate OR BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent._userno
                 THEN TRUE ELSE FALSE END AS IsReaded,
            ROW_NUMBER() OVER (ORDER BY
                CASE WHEN _SortType=0 AND _SortColumn=''         THEN BC.RootId    END DESC,
                CASE WHEN _SortType=0 AND _SortColumn=''         THEN BC.HeadNo    END ASC,
                CASE WHEN _SortType=0 AND _SortColumn=''         THEN BC.ContentNo END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.IsNotice  END DESC,
                CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.RootId    END DESC,
                CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.HeadNo    END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.ContentNo END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='TITLE'      THEN BC.Title       END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='REGDATE'    THEN BC.RegDate     END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='VIEWED'     THEN BC.ViewedCount END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='TYPE'       THEN BC.Type        END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='ERRORTYPE'  THEN BC.ErrorType   END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='PERSONTYPE' THEN BC.PersonType  END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent._langcode ELSE B.Name END END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN CASE _LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
                CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN CASE _LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
                CASE WHEN _SortType=1 AND _SortColumn='TITLE'      THEN BC.Title       END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='REGDATE'    THEN BC.RegDate     END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='VIEWED'     THEN BC.ViewedCount END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='TYPE'       THEN BC.Type        END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='ERRORTYPE'  THEN BC.ErrorType   END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='PERSONTYPE' THEN BC.PersonType  END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent._langcode ELSE B.Name END END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN CASE _LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
                CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN CASE _LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC
            ) AS RowNum,
            COUNT(*) OVER () AS TotalRows,
            B.ViewMode AS BoardType, B.SpecType,
            CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent._userno
                 THEN TRUE ELSE FALSE END AS IsDelete,
            BC.Type, BC.ErrorType, BC.PersonType, BC.VisitDate, BC.VisitCompleteDate,
            BC.ConstructionName, BC.ApplyTo, BC.MailRecipientNo, BC.MailRecipientName,
            CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date) END AS DayDateView,
            BC.Important, BC.DesignNo, BC.Private, BC.Purpose, BC.RecommendedCount, BC.IsRecommendPublic,
            BC.IsShareAll
        FROM    Board_Contents BC
        INNER JOIN PERMISSION_BOARD  B  ON B.BoardNo     = BC.BoardNo
        LEFT  JOIN Organization_Users       OU ON OU.UserNo     = BC.RegUserNo
        LEFT  JOIN Organization_Positions   OP ON OP.PositionNo = BC.RegPositionNo
        LEFT  JOIN Organization_Departments OD ON OD.DepartNo   = BC.RegDepartNO
        LEFT  JOIN VIEWED                   BV ON BV.ContentNo  = BC.ContentNo
        LEFT  JOIN PERMISSION               P  ON  P.ItemNo     = BC.BoardNo
        LEFT  JOIN DEPARTPERMISSION         D  ON  D.ItemNo     = BC.BoardNo
        LEFT  JOIN SHARE                    S  ON  S.ContentNo  = BC.ContentNo
        WHERE  (BC.BoardNo = board_getlistboardcontent._boardno OR (_BoardNo = 0 AND B.ViewMode >= 2))
          AND  BC.Enabled = TRUE
          AND  BC.RegDate       >= board_getlistboardcontent._fromdate
          AND  BC.RegDate       <= board_getlistboardcontent._todate
          AND  (_FilterType = 100 OR (_FilterType = 1 AND BV.ContentNo IS NULL))
          AND  (_TitleEffect = 1 OR (_TitleEffect = 0 AND TitleEffect = 0))
          AND  (_MgDepartment   = '' OR _MgDepartment = BC.PersonType)
          AND  (_SearchValue = ''
                OR (_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=3 AND BC.Type             =    board_getlistboardcontent._searchvalue)
                OR (_SearchType=4 AND BC.Type             ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=5 AND BC.ErrorType        ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=6 AND BC.ApplyTo          ILIKE '%' || _SearchValue || '%')
                OR (_SearchType=7 AND BC.ConstructionName ILIKE '%' || _SearchValue || '%'))
          AND  (_IsAdmin = TRUE OR BC.RegUserNo = board_getlistboardcontent._userno OR P.AllowValue = 7 OR D.AllowValue = 7
                OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL) AND B.SpecType=0 AND (BC.IsShareAll = TRUE OR S.ContentNo IS NOT NULL))
                OR ((BC.IsShareAll = TRUE OR S.ContentNo IS NOT NULL) AND B.SpecType=1))
    )
    SELECT
        T.BoardNo, T.ContentNo, T.Title,
        COALESCE(F.Url,'')                                                                AS FileUrl,
        F.Name                                                                          AS FileName,
        REPLACE(REPLACE(COALESCE(F.Url,''),'/Attach/','/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
        T.IsFile, T.BoardName, T.RegUserName, T.RegPositionName, T.RegDepartName,
        COALESCE(VL.ViewedCount, 0)                                                       AS ViewedCount,
        T.RegDateToString, T.RootId, T.TitleEffect, T.IsDelete, T.IsReaded,
        T.TotalRows                                                                     AS Total,
        COALESCE(R.ReplyCount, 0)                                                         AS ReplyCount,
        T.BoardType, T.RegDate, T.ModDate, T.IsNotice,
        CASE WHEN _BoardNo<>0 THEN T.Type              ELSE NULL END AS Type,
        CASE WHEN _BoardNo<>0 THEN T.ErrorType         ELSE NULL END AS ErrorType,
        CASE WHEN _BoardNo<>0 THEN T.PersonType        ELSE NULL END AS PersonType,
        CASE WHEN _BoardNo<>0 THEN T.VisitDate         ELSE NULL END AS VisitDate,
        CASE WHEN _BoardNo<>0 THEN T.VisitCompleteDate ELSE NULL END AS VisitCompleteDate,
        CASE WHEN _BoardNo<>0 THEN T.ConstructionName  ELSE NULL END AS ConstructionName,
        CASE WHEN _BoardNo<>0 THEN T.DayDateView       ELSE NULL END AS DayDateView,
        CASE WHEN _BoardNo<>0 THEN T.ApplyTo           ELSE NULL END AS ApplyTo,
        CASE WHEN _BoardNo<>0 THEN T.MailRecipientNo   ELSE NULL END AS MailRecipientNo,
        CASE WHEN _BoardNo<>0 THEN T.MailRecipientName ELSE NULL END AS MailRecipientName,
        CASE WHEN _BoardNo<>0 THEN T.Important         ELSE NULL END AS Important,
        CASE WHEN _BoardNo<>0 THEN T.DesignNo          ELSE NULL END AS DesignNo,
        CASE WHEN _BoardNo<>0 THEN T.Private           ELSE NULL END AS Private,
        CASE WHEN _BoardNo<>0 THEN T.RegUserNo         ELSE NULL END AS RegUserNo,
        CASE WHEN _BoardNo<>0 THEN T.Purpose           ELSE NULL END AS Purpose,
        CASE WHEN _BoardNo<>0 THEN T.RecommendedCount  ELSE NULL END AS RecommendedCount,
        CASE WHEN _BoardNo<>0 THEN T.IsRecommendPublic ELSE NULL END AS IsRecommendPublic,
        COALESCE(T.TotalRows,0) - T.RowNum + 1                                            AS RowNumber
    FROM TMP T
    LEFT JOIN LATERAL (
        SELECT COUNT(DISTINCT BV.UserNo) AS ViewedCount
        FROM   Board_ViewedLogs BV
        WHERE  BV.ContentNo = T.ContentNo
          AND  (   T.SpecType      = 1
                OR T.IsShareAll    = TRUE
                OR BV.UserNo      = T.RegUserNo
                OR EXISTS (
                    SELECT 1 FROM Board_Sharers BS
                    WHERE  BS.ContentNo = T.ContentNo
                      AND  (   BS.UserNo   IN (SELECT UserNo   FROM USER_DEPART)
                            OR BS.DepartNo IN (SELECT DepartNo FROM USER_DEPART))
                ))
    ) VL ON TRUE
    LEFT JOIN LATERAL (
        SELECT COUNT(ReplyNo) AS ReplyCount
        FROM   Board_Replies
        WHERE  ContentNo = T.ContentNo
    ) R ON TRUE
    LEFT JOIN LATERAL (
        SELECT Url, Name
        FROM   Board_Files
        WHERE  ContentNo = T.ContentNo
        ORDER BY ContentNo
    ) F ON TRUE
    WHERE  T.RowNum >  (_CurentPage - 1) * _PageSize
      AND  T.RowNum <= board_getlistboardcontent._curentpage       * _PageSize
    ORDER BY T.RowNum;
END;
$function$

```
</details>

## `board_getlistboardcontent_bk`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontent_bk"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontent_bk(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean,character varying) line 6 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontent_bk(_userno integer DEFAULT 70, _boardno integer DEFAULT 1094, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 15, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2000-07-08 00:00:01'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2026-07-09 00:00:01'::timestamp without time zone, _isadmin boolean DEFAULT true, _titleeffect boolean DEFAULT false, _mgdepartment character varying DEFAULT ''::character varying)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, fileurl text, filename character varying, thumbnailfileurl text, isfile boolean, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, viewedcount integer, regdatetostring character varying, rootid bigint, titleeffect integer, isdelete boolean, isreaded boolean, total bigint, replycount integer, boardtype integer, regdate timestamp without time zone, moddate timestamp without time zone, isnotice boolean, rownumber bigint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

IF _BoardNo=0 THEN
RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontent_bk._userno AND AllowValue>0
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontent_bk._userno AND OB.IsDefault= TRUE AND BD.AllowValue>0
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontent_bk._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
--REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
--	FROM Board_Contents BC
--	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
--	WHERE (BC.BoardNo=BoardNo OR  BoardNo =0 ) AND BC.Enabled = TRUE
--	GROUP BY BC.ContentNo
--	),
PERMISSION_BOARD AS (SELECT B.BoardNo, B.Name,B.ViewMode,B.SpecType
	FROM Board_Boards B
	LEFT JOIN PERMISSION P ON P.ItemNo=B.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE (B.BoardNo=board_getlistboardcontent_bk._boardno OR  _BoardNo =0 ) AND ( _IsAdmin = TRUE   OR P.AllowValue >0 OR  D.AllowValue >0 OR B.SpecType=1
	)
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getlistboardcontent_bk._userno),
VIEWEDLIST AS (
	SELECT DISTINCT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM (SELECT DISTINCT ContentNo,UserNo FROM Board_ViewedLogs)  BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	INNER JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo AND S.Rn=1
	WHERE  BB.SpecType=1 OR  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,BC.ModDate,BC.IsNotice,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent_bk._userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TYPE' THEN  BC.Type END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='ERRORTYPE' THEN  BC.ErrorType END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='PERSONTYPE' THEN  BC.PersonType END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='TYPE' THEN  BC.Type END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='ERRORTYPE' THEN  BC.ErrorType END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='PERSONTYPE' THEN  BC.PersonType END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent_bk._userno THEN TRUE ELSE FALSE END AS IsDelete

	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	INNER JOIN PERMISSION_BOARD B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo AND S.Rn=1
	WHERE (BC.BoardNo=board_getlistboardcontent_bk._boardno OR   (_BoardNo =0 AND B.ViewMode>=2))

	AND BC.Enabled = TRUE
	AND BC.RegDate>=board_getlistboardcontent_bk._fromdate
	AND BC.RegDate<=board_getlistboardcontent_bk._todate
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(_MgDepartment,'')='' OR _MgDepartment=BC.PersonType)
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontent_bk._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=7 AND BC.ConstructionName ILIKE '%' || _SearchValue || '%')
			)
		-- CASE SearchType
		--	WHEN 0 THEN BC.Title
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END
		--	WHEN 3 THEN BC.Type
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--END ILIKE '%' || SearchValue || '%')
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontent_bk._userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
COALESCE(F.Url,'') AS FileUrl,
F.Name AS FileName,
REPLACE(REPLACE(COALESCE(F.Url,''), '/Attach/', '/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
T.BoardType,
T.RegDate,
T.ModDate,
	T.IsNotice,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(_CurentPage-1)*_PageSize AND T.RowNumber<=board_getlistboardcontent_bk._curentpage*_PageSize
ORDER BY T.RowNumber;

ELSE
RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontent_bk._userno AND AllowValue>0
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontent_bk._userno AND OB.IsDefault= TRUE AND BD.AllowValue>0
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontent_bk._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
--REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
--	FROM Board_Contents BC
--	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
--	WHERE (BC.BoardNo=BoardNo OR  BoardNo =0 ) AND BC.Enabled = TRUE
--	GROUP BY BC.ContentNo
--	),
PERMISSION_BOARD AS (SELECT B.BoardNo, B.Name,B.ViewMode,B.SpecType
	FROM Board_Boards B
	LEFT JOIN PERMISSION P ON P.ItemNo=B.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE (B.BoardNo=board_getlistboardcontent_bk._boardno OR  _BoardNo =0 ) AND ( _IsAdmin = TRUE   OR P.AllowValue >0 OR  D.AllowValue >0 OR B.SpecType=1
	)
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getlistboardcontent_bk._userno),
VIEWEDLIST AS (
	SELECT DISTINCT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM (SELECT DISTINCT ContentNo,UserNo FROM Board_ViewedLogs)  BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	INNER JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo AND S.Rn=1
	WHERE  BB.SpecType=1 OR  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,BC.ModDate,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent_bk._userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TYPE' THEN  BC.Type END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='ERRORTYPE' THEN  BC.ErrorType END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='PERSONTYPE' THEN  BC.PersonType END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_bk._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='TYPE' THEN  BC.Type END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='ERRORTYPE' THEN  BC.ErrorType END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='PERSONTYPE' THEN  BC.PersonType END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent_bk._userno THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	BC.MailRecipientNo,
	BC.MailRecipientName,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
	BC.Important,
	BC.DesignNo,
	BC.RegUserNo,
	BC.Private,
	BC.IsNotice,
	BC.Purpose,
	BC.RecommendedCount,
	BC.IsRecommendPublic
	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	INNER JOIN PERMISSION_BOARD B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo AND S.Rn=1
	WHERE (BC.BoardNo=board_getlistboardcontent_bk._boardno OR   (_BoardNo =0 AND B.ViewMode>=2))

	AND BC.Enabled = TRUE
	AND BC.RegDate>=board_getlistboardcontent_bk._fromdate
	AND BC.RegDate<=board_getlistboardcontent_bk._todate
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(_MgDepartment,'')='' OR _MgDepartment=BC.PersonType)
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND  BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontent_bk._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=7 AND BC.ConstructionName ILIKE '%' || _SearchValue || '%')
			)
		-- CASE SearchType
		--	WHEN 0 THEN BC.Title
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END
		--	WHEN 3 THEN BC.Type
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--END ILIKE '%' || SearchValue || '%')
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontent_bk._userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
COALESCE(F.Url,'') AS FileUrl,
F.Name AS FileName,
REPLACE(REPLACE(COALESCE(F.Url,''), '/Attach/', '/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
T.BoardType,
T.RegDate,
T.ModDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	T.MailRecipientNo,
	T.MailRecipientName,
	T.Important,
	T.DesignNo,
	T.Private,
	T.RegUserNo,
	T.IsNotice,
	T.Purpose,
	T.RecommendedCount,
	T.IsRecommendPublic,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(_CurentPage-1)*_PageSize AND T.RowNumber<=board_getlistboardcontent_bk._curentpage*_PageSize
ORDER BY T.RowNumber;
END IF;


--LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R  ON R.ContentNo=T.ContentNo
END;
$function$

```
</details>

## `board_getlistboardcontent_search`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontent_search"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontent_search(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean) line 8 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontent_search(_userno integer DEFAULT 70, _boardno integer DEFAULT 1087, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 10, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2015-07-08 00:00:01'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2022-07-09 00:00:01'::timestamp without time zone, _isadmin boolean DEFAULT false, _titleeffect boolean DEFAULT true)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, content text, fileurl text, isfile boolean, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, viewedcount integer, regdatetostring character varying, rootid bigint, titleeffect integer, isdelete boolean, isreaded boolean, total bigint, replycount integer, boardtype integer, regdate timestamp without time zone, type character varying, errortype character varying, persontype character varying, visitdate timestamp without time zone, visitcompletedate timestamp without time zone, constructionname character varying, daydateview integer, applyto character varying, rownumber bigint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _query character varying;
BEGIN


RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontent_search._userno
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontent_search._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontent_search._boardno OR  _BoardNo =0 ) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getlistboardcontent_search._userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title, BC.Content ,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_search._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent_search._userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_search._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontent_search._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent_search._userno THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView
	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontent_search._boardno OR   (_BoardNo =0 AND B.ViewMode=2))

	AND BC.Enabled = TRUE
	AND BC.RegDate>=board_getlistboardcontent_search._fromdate
	AND BC.RegDate<=board_getlistboardcontent_search._todate
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontent_search._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			)
		-- CASE SearchType
		--	WHEN 0 THEN BC.Title
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END
		--	WHEN 3 THEN BC.Type
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--END ILIKE '%' || SearchValue || '%')
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontent_search._userno OR  (P.AllowAccessNo IS NOT NULL AND B.SpecType=0) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.Content,
F.Url AS FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
T.BoardType,
T.RegDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(_CurentPage-1)*_PageSize AND T.RowNumber<=board_getlistboardcontent_search._curentpage*_PageSize
ORDER BY T.RowNumber;
--	CASE WHEN SortType=0 AND SortColumn='' THEN T.RootId END DESC,
--	CASE WHEN SortType=0 AND SortColumn='' THEN  T.ContentNo END ASC,
--	CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  T.Title END ASC,
--	CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  T.BoardName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  T.RegUserName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  T.RegDepartName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN  T.RegDateToString END ASC,
--	CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  T.ViewedCount END ASC,
--	CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  T.Title END DESC,
--	CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  T.BoardName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN  T.RegUserName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  T.RegDepartName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  T.RegDateToString END DESC,
--	CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  T.ViewedCount END DESC


--LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R  ON R.ContentNo=T.ContentNo
END;
$function$

```
</details>

## `board_getlistboardcontentbyfolder`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontentbyfolder"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontentbyfolder(integer,character varying,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontentbyfolder(_userno integer DEFAULT 70, _boardlist character varying DEFAULT ',1159,1158,1157'::character varying, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 10, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2022-09-30 19:20:19.717'::timestamp without time zone, _isadmin boolean DEFAULT true, _titleeffect boolean DEFAULT false, _mgdepartment character varying DEFAULT ''::character varying)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, fileurl text, isfile boolean, viewedcount integer, regdatetostring text, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, rootid bigint, isdelete boolean, isreaded boolean, titleeffect integer, total integer, replycount integer, boardtype integer, regdate timestamp without time zone, moddate timestamp without time zone, type character varying, errortype character varying, persontype character varying, visitdate timestamp without time zone, visitcompletedate timestamp without time zone, constructionname character varying, daydateview integer, applyto character varying, mailrecipientno text, mailrecipientname text, important boolean, designno character varying, private boolean, isnotice boolean, reguserno integer, purpose character varying, rownumber bigint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontentbyfolder._userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontentbyfolder._userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontentbyfolder._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
PERMISSION_BOARD AS (SELECT B.BoardNo, B.Name,B.ViewMode,B.SpecType
	FROM Board_Boards B
	LEFT JOIN PERMISSION P ON P.ItemNo=B.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE B.BoardNo  IN (SELECT unnest(string_to_array(_BoardList, ','))::integer)  AND ( _IsAdmin = TRUE   OR   P.AllowValue >0 OR  D.AllowValue >0 OR B.SpecType=1 )
	),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo IN (SELECT unnest(string_to_array(_BoardList, ','))::integer)) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (
	SELECT DISTINCT UserNo,ContentNo
	FROM Board_ViewedLogs
	WHERE UserNo=board_getlistboardcontentbyfolder._userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
)
,TMP AS (
	SELECT BC.ContentNo,BC.BoardNo,BC.Title,BC.IsFile,BC.ViewedCount,BC.RegDate,BC.ModDate,BC.RootId,BC.TitleEffect,T.Url AS FileUrl,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontentbyfolder._userno) THEN TRUE ELSE FALSE END AS IsReaded ,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentbyfolder._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentbyfolder._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentbyfolder._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
	) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	BC.MailRecipientNo,
	BC.MailRecipientName,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
	BC.Important,
	BC.DesignNo,
	BC.RegUserNo,
	BC.Private,
	BC.IsNotice,
	BC.Purpose
	FROM BOARD_CONTENTS BC
	LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	INNER JOIN PERMISSION_BOARD B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	--LEFT JOIN Organization_BelongToDepartment OB ON OB.UserNo=OU.UserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo And S.Rn=1
	WHERE (BC.BoardNo IN (SELECT unnest(string_to_array(_BoardList, ','))::integer)) AND BC.Enabled = TRUE AND BC.RegDate>=board_getlistboardcontentbyfolder._fromdate AND BC.RegDate<=board_getlistboardcontentbyfolder._todate
	AND B.ViewMode>=2
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND BC.TitleEffect=0))
	AND (COALESCE(_MgDepartment,'')='' OR _MgDepartment=BC.PersonType)
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontentbyfolder._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=7 AND BC.ConstructionName ILIKE '%' || _SearchValue || '%')
			)
		-- CASE SearchType
		--	WHEN 0 THEN BC.Title
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END
		--	WHEN 3 THEN BC.Type
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--END ILIKE '%' || SearchValue || '%')
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontentbyfolder._userno OR P.AllowValue=7 OR D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND  B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)AND  B.SpecType=1))
) ,
Total AS (Select count(*) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
F.Url AS FileUrl,
--T.FileUrl,
T.IsFile,
--T.ViewedCount ,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
CONVERT(text, T.RegDate, 120) as RegDateToString,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
T.RootId,
T.IsDelete ,
T.IsReaded,
T.TitleEffect,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
--R.ReplyCount,
T.BoardType,
T.RegDate,
T.ModDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	T.MailRecipientNo,
	T.MailRecipientName,
	T.Important,
	T.DesignNo,
	T.Private,
		T.IsNotice,
	T.RegUserNo,
	T.Purpose,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(_CurentPage-1)*_PageSize AND T.RowNumber<=board_getlistboardcontentbyfolder._curentpage*_PageSize
ORDER BY T.RowNumber;
END;
$function$

```
</details>

## `board_getlistboardcontentsearch`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontentsearch"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontentsearch(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean,character varying) line 8 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontentsearch(_userno integer DEFAULT 70, _boardno integer DEFAULT 1087, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 10, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2015-07-08 00:00:01'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2022-07-09 00:00:01'::timestamp without time zone, _isadmin boolean DEFAULT false, _titleeffect boolean DEFAULT true, _mgdepartment character varying DEFAULT ''::character varying)
 RETURNS TABLE(boardno integer, contentno bigint, title character varying, content text, fileurl text, isfile boolean, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, viewedcount integer, regdatetostring character varying, rootid bigint, titleeffect integer, isdelete boolean, isreaded boolean, total bigint, replycount integer, boardtype integer, regdate timestamp without time zone, type character varying, errortype character varying, persontype character varying, visitdate timestamp without time zone, visitcompletedate timestamp without time zone, constructionname character varying, daydateview integer, applyto character varying, rownumber bigint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _query character varying;
BEGIN


RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontentsearch._userno
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontentsearch._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontentsearch._boardno OR  _BoardNo =0 ) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getlistboardcontentsearch._userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title, BC.Content ,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentsearch._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontentsearch._userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentsearch._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontentsearch._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN _IsAdmin = TRUE OR P.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontentsearch._userno THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView
	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontentsearch._boardno OR   (_BoardNo =0 AND B.ViewMode=2))

	AND BC.Enabled = TRUE
	AND BC.RegDate>=board_getlistboardcontentsearch._fromdate
	AND BC.RegDate<=board_getlistboardcontentsearch._todate
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(_MgDepartment,'')='' OR _MgDepartment=BC.PersonType)
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontentsearch._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			)
		-- CASE SearchType
		--	WHEN 0 THEN BC.Title
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END
		--	WHEN 3 THEN BC.Type
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END
		--END ILIKE '%' || SearchValue || '%')
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontentsearch._userno OR  (P.AllowAccessNo IS NOT NULL AND B.SpecType=0) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.Content,
F.Url AS FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
T.BoardType,
T.RegDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(_CurentPage-1)*_PageSize AND T.RowNumber<=board_getlistboardcontentsearch._curentpage*_PageSize
ORDER BY T.RowNumber;
--	CASE WHEN SortType=0 AND SortColumn='' THEN T.RootId END DESC,
--	CASE WHEN SortType=0 AND SortColumn='' THEN  T.ContentNo END ASC,
--	CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  T.Title END ASC,
--	CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  T.BoardName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  T.RegUserName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  T.RegDepartName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN  T.RegDateToString END ASC,
--	CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  T.ViewedCount END ASC,
--	CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  T.Title END DESC,
--	CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  T.BoardName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN  T.RegUserName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  T.RegDepartName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  T.RegDateToString END DESC,
--	CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  T.ViewedCount END DESC


--LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R  ON R.ContentNo=T.ContentNo
END;
$function$

```
</details>

## `board_getlistboardcontenttoexcel`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistboardcontenttoexcel"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, false, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: boolean = integer
- Stack context: PL/pgSQL function board_getlistboardcontenttoexcel(integer,character varying,integer,integer,character varying,integer,integer,character varying,character varying,integer,timestamp without time zone,timestamp without time zone,boolean,boolean,character varying,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistboardcontenttoexcel(_userno integer DEFAULT 70, _boardlist character varying DEFAULT ',0'::character varying, _curentpage integer DEFAULT 1, _pagesize integer DEFAULT 10, _langcode character varying DEFAULT 'EN'::character varying, _filtertype integer DEFAULT 100, _searchtype integer DEFAULT 0, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _sorttype integer DEFAULT 0, _fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, _todate timestamp without time zone DEFAULT '2033-09-30 19:20:19.717'::timestamp without time zone, _isadmin boolean DEFAULT true, _titleeffect boolean DEFAULT false, _mgdepartment character varying DEFAULT ''::character varying, _contentnos character varying DEFAULT ''::character varying)
 RETURNS TABLE(rownumber bigint, title character varying, content text, boardname text, regusername character varying, regpositionname character varying, regdepartname character varying, regdate timestamp without time zone, moddate timestamp without time zone, viewedcount integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getlistboardcontenttoexcel._userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontenttoexcel._userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontenttoexcel._userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
VIEWED AS (
	SELECT DISTINCT UserNo,ContentNo
	FROM Board_ViewedLogs
	WHERE UserNo=board_getlistboardcontenttoexcel._userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
)
,TMP AS (
	SELECT BC.ContentNo, BC.Title,BC.ViewedCount,BC.RegDate,BC.ModDate,BC.RootId,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontenttoexcel._userno) THEN TRUE ELSE FALSE END AS IsReaded ,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontenttoexcel._langcode ELSE B.Name END AS BoardName ,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontenttoexcel._langcode ELSE B.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGUSER' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN _SortType=0 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN _SortType=1 AND _SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistboardcontenttoexcel._langcode ELSE B.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGUSER' THEN   CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='DEPART' THEN  CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN _SortType=1 AND _SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
	) AS RowNumber,


	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
	BC.Content
	FROM BOARD_CONTENTS BC
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	--LEFT JOIN Organization_BelongToDepartment OB ON OB.UserNo=OU.UserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo And S.Rn=1
	WHERE (0 IN (SELECT unnest(string_to_array(_BoardList, ','))::integer) OR BC.BoardNo IN (SELECT unnest(string_to_array(_BoardList, ','))::integer)) AND BC.Enabled = TRUE AND BC.RegDate>=board_getlistboardcontenttoexcel._fromdate AND BC.RegDate<=board_getlistboardcontenttoexcel._todate
	AND B.ViewMode>=2
	AND (_FilterType=100 OR (_FilterType=1 AND BV.ContentNo IS NULL))
	AND (_TitleEffect=1 OR (_TitleEffect=0 AND BC.TitleEffect=0))
	AND (COALESCE(_MgDepartment,'')='' OR _MgDepartment=BC.PersonType)
	AND (COALESCE(_SearchValue,'')=''
			OR(_SearchType=0 AND BC.Title ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=1 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=2 AND CASE _LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=3 AND BC.Type= board_getlistboardcontenttoexcel._searchvalue)
			OR(_SearchType=4 AND BC.Type ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=5 AND BC.ErrorType ILIKE '%' || _SearchValue || '%')
			OR(_SearchType=6 AND BC.ApplyTo ILIKE '%' || _SearchValue || '%')
			)
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontenttoexcel._userno OR P.AllowValue=7 OR D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND  B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)AND  B.SpecType=1))
	AND (COALESCE(_ContentNos,'')=''  OR BC.ContentNo IN (SELECT unnest(string_to_array(_ContentNos, ','))::integer))
) ,
Total AS (Select count(*) as ToTal FROM TMP)
SELECT
c.Total -T.RowNumber +1 AS RowNumber,
T.Title,
COALESCE(T.Content,'') AS Content ,
COALESCE(T.BoardName,'') AS BoardName ,
(T.RegUserName || ' - ' || T.RegPositionName) AS  RegUserName,
COALESCE(T.RegPositionName,'') AS RegPositionName ,
COALESCE(T.RegDepartName,'') AS RegDepartName ,
T.RegDate,
T.ModDate,
COALESCE(VL.ViewedCount,0) AS ViewedCount

FROM TMP T
LEFT JOIN Total c ON c.Total>0
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
ORDER BY T.RowNumber;
END;
$function$

```
</details>

## `board_getlistcommentsetting`

- Input: `''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistcommentsetting"(''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getlistcommentsetting(character varying) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistcommentsetting(_langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getlistcommentsetting._langcode ELSE B.Name END AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_CommentSetting W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE
	ORDER BY RegDate DESC;
END;
$function$

```
</details>

## `board_getlistnoticepermission`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getlistnoticepermission"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getlistnoticepermission(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying) line 9 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistnoticepermission(_itemno integer DEFAULT 25, _applicationno integer DEFAULT 7, _departno integer DEFAULT 1, _positionno integer DEFAULT 0, _languagecode character varying DEFAULT 'EN'::character varying, _pagenumber integer DEFAULT 1, _pagesize integer DEFAULT 10, _searchvalue character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying)
 RETURNS TABLE(total integer, name character varying, userid character varying, userno integer, departno integer, positionno integer, departname character varying, positionname character varying, isadmin boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _total bigint;
BEGIN


	_Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH RECURSIVE RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistnoticepermission._departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER (PARTITION BY U.Enabled  ORDER BY
					CASE WHEN  _SortColumn='' THEN  CASE _LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END ASC,
					CASE WHEN  _SortColumn='USERNAME' THEN  CASE _LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END DESC
		) AS RowNum ,
			U.Name,
            U.UserId,
			U.UserNo,
			OB.DepartNo,
			OB.PositionNo,
			CASE WHEN _LanguageCode='EN' THEN OD.Name_EN WHEN _LanguageCode='VN' THEN OD.Name_VN WHEN _LanguageCode='CH' THEN OD.Name_CH WHEN _LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
			CASE WHEN _LanguageCode='EN' THEN OP.NAME_EN WHEN _LanguageCode='VN' THEN OP.Name_VN WHEN _LanguageCode='CH' THEN OP.Name_CH WHEN _LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
			CAST( CASE WHEN UP.AllowValue>0 THEN 1  ELSE 0 END AS BIT) AS IsAdmin
		FROM ORGANIZATION_USERS U
		LEFT JOIN Board_NoticePermission UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistnoticepermission._applicationno
		WHERE  (_DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistnoticepermission._positionno OR _PositionNo=0) AND U.Enabled = TRUE AND (U.UserID ILIKE '%' || _SearchValue || '%' OR U.Name ILIKE '%' || _SearchValue || '%'  )
	)

	SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin
	FROM USERS U--,TOTAL T
	WHERE  U.RowNum >board_getlistnoticepermission._pagesize*(_PageNumber-1) AND U.RowNum <=board_getlistnoticepermission._pagesize*_PageNumber;
END;
$function$

```
</details>

## `board_getlistuserpermission`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getlistuserpermission"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "rootdeparts" does not exist
- Stack context: PL/pgSQL function board_getlistuserpermission(integer,integer,integer,integer,integer,character varying,integer,integer,boolean) line 14 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistuserpermission(_itemno integer DEFAULT 25, _itemtype integer DEFAULT 1, _applicationno integer DEFAULT 7, _departno integer DEFAULT 1, _positionno integer DEFAULT 0, _languagecode character varying DEFAULT 'EN'::character varying, _pagenumber integer DEFAULT 1, _pagesize integer DEFAULT 10, _ispermission boolean DEFAULT true)
 RETURNS TABLE(total integer, name character varying, userid character varying, userno integer, departno integer, positionno integer, departname character varying, positionname character varying, isadmin boolean, isread boolean, iswrite boolean, disableadmin boolean, disableread boolean, disablewrite boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _total bigint;
BEGIN


	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo);
	_Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	UserPermistions as (
		SELECT DISTINCT BA.UserNo,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
		FROM Board_AllowAccess BA
		--LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
		WHERE BA.ItemNo=board_getlistuserpermission._itemno AND BA.ItemType=board_getlistuserpermission._itemtype
	),
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistuserpermission._departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
			U.Name,
            U.UserId,
			U.UserNo,
			OB.DepartNo,
			OB.PositionNo,
			CASE WHEN _LanguageCode='EN' THEN OD.Name_EN WHEN _LanguageCode='VN' THEN OD.Name_VN WHEN _LanguageCode='CH' THEN OD.Name_CH WHEN _LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
			CASE WHEN _LanguageCode='EN' THEN OP.NAME_EN WHEN _LanguageCode='VN' THEN OP.Name_VN WHEN _LanguageCode='CH' THEN OP.Name_CH WHEN _LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite ,
			CASE WHEN _IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE  WHEN UP.DisableAdmin IS NOT NULL THEN  UP.DisableAdmin ELSE FALSE END AS DisableAdmin,
			CASE WHEN _IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE WHEN UP.DisableRead IS NOT NULL THEN  UP.DisableRead ELSE FALSE END AS DisableRead,
			CASE WHEN _IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE  WHEN UP.DisableWrite IS NOT NULL THEN  UP.DisableWrite ELSE FALSE END AS DisableWrite
			FROM ORGANIZATION_USERS U
		LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistuserpermission._applicationno
		WHERE (_DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistuserpermission._positionno OR _PositionNo=0) AND U.Enabled = TRUE
	)--,
	--TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin,U.IsRead,U.IsWrite,U.DisableAdmin,U.DisableRead,U.DisableWrite
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableAdmin ELSE  TRUE  END AS DisableAdmin,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableRead ELSE TRUE END AS DisableRead,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableWrite ELSE TRUE END AS DisableWrite
	FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	WHERE U.RowNum >board_getlistuserpermission._pagesize*(_PageNumber-1) AND U.RowNum <=board_getlistuserpermission._pagesize*_PageNumber;

	--SET NOCOUNT ON;
	--DECLARE Total BIGINT;
	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo)
	--SET Total =(SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	--WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	--UserPermistions as (
	--	SELECT DISTINCT BA.UserNo,
	--	CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
	--	CASE WHEN UP.AllowValue%2=0 THEN TRUE ELSE FALSE END AS DisableAdmin ,
	--	CASE WHEN BA.AllowValue%2<>0 OR UP.AllowValue=2  THEN TRUE ELSE FALSE END AS DisableWrite ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
	--	FROM Board_AllowAccess BA
	--	LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
	--	WHERE BA.ItemNo=ItemNo AND BA.ItemType=ItemType
	--),
	--RootDeparts AS (
	--	  SELECT *
	--	  FROM Organization_Departments
	--	  WHERE DepartNo = DepartNo
	--	  UNION ALL
	--	  SELECT OD.*
	--	  FROM Organization_Departments OD
	--	  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	-- ),
	-- USERS AS(
	--	SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
	--		U.Name,
 --           U.UserId,
	--		U.UserNo,
	--		OB.DepartNo,
	--		OB.PositionNo,
	--		CASE WHEN LanguageCode='EN' THEN OD.Name_EN WHEN LanguageCode='VN' THEN OD.Name_VN WHEN LanguageCode='CH' THEN OD.Name_CH WHEN LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
	--		CASE WHEN LanguageCode='EN' THEN OP.NAME_EN WHEN LanguageCode='VN' THEN OP.Name_VN WHEN LanguageCode='CH' THEN OP.Name_CH WHEN LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableAdmin IS NOT NULL THEN  UP.DisableAdmin ELSE FALSE END AS DisableAdmin,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableRead IS NOT NULL THEN  UP.DisableRead ELSE FALSE END AS DisableRead,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableWrite IS NOT NULL THEN  UP.DisableWrite ELSE FALSE END AS DisableWrite
	--		FROM ORGANIZATION_USERS U
	--	LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
	--	INNER JOIN ORGANIZATION_BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.IsDefault = TRUE
	--	INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
	--	INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
	--	LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
	--	LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=ApplicationNo
	--	WHERE (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=PositionNo OR PositionNo=0) AND U.Enabled = TRUE
	--)--,
	----TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	--SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin,U.IsRead,U.IsWrite,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableAdmin ELSE  TRUE  END AS DisableAdmin,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableRead ELSE TRUE END AS DisableRead,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableWrite ELSE TRUE END AS DisableWrite
	--FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	--WHERE U.RowNum >PageSize*(PageNumber-1) AND U.RowNum <=PageSize*PageNumber
END;
$function$

```
</details>

## `board_getlistuserpermissiontoexcel`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getlistuserpermissiontoexcel"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "rootdeparts" does not exist
- Stack context: PL/pgSQL function board_getlistuserpermissiontoexcel(integer,integer,integer,integer,integer,character varying,integer,integer,boolean) line 14 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistuserpermissiontoexcel(_itemno integer DEFAULT 25, _itemtype integer DEFAULT 1, _applicationno integer DEFAULT 7, _departno integer DEFAULT 1, _positionno integer DEFAULT 0, _languagecode character varying DEFAULT 'EN'::character varying, _pagenumber integer DEFAULT 1, _pagesize integer DEFAULT 10, _ispermission boolean DEFAULT true)
 RETURNS TABLE(userid character varying, username character varying, admin boolean, write boolean, read boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _total bigint;
BEGIN


	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo);
	_Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	UserPermistions as (
		SELECT DISTINCT BA.UserNo,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
		FROM Board_AllowAccess BA
		--LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
		WHERE BA.ItemNo=board_getlistuserpermissiontoexcel._itemno AND BA.ItemType=board_getlistuserpermissiontoexcel._itemtype
	),
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistuserpermissiontoexcel._departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
			U.Name,
            U.UserId,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
			CASE WHEN _IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite
			FROM ORGANIZATION_USERS U
		LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistuserpermissiontoexcel._applicationno
		WHERE (_DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistuserpermissiontoexcel._positionno OR _PositionNo=0) AND U.Enabled = TRUE
	)--,
	--TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	SELECT U.UserId,U.Name AS UserName,U.IsAdmin AS "Admin" ,U.IsWrite As Write ,U.IsRead AS "Read"
	FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	WHERE U.RowNum >board_getlistuserpermissiontoexcel._pagesize*(_PageNumber-1) AND U.RowNum <=board_getlistuserpermissiontoexcel._pagesize*_PageNumber;
END;
$function$

```
</details>

## `board_getmultiwidget`

- Input: `''::character varying, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getmultiwidget"(''::character varying, 0::integer, false);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getmultiwidget(character varying,integer,boolean) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getmultiwidget(_langcode character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 6656, _isadmin boolean DEFAULT false)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	WITH DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Board_DepartAllowAccess BD
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE BD.ItemType=2 AND OB.UserNo=board_getmultiwidget._userno AND OB.IsDefault= TRUE
)
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_getmultiwidget._langcode,B.Name::json->>board_getmultiwidget._langcode) ELSE B.Name END,'') AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_MultiBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.UserNo=board_getmultiwidget._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE W.IsDelete = FALSE  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
	ORDER BY W.Sort DESC;
END;
$function$

```
</details>

## `board_getnewboardwidget`

- Input: `''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getnewboardwidget"(''::character varying, 0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getnewboardwidget(character varying,integer) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getnewboardwidget(_langcode character varying DEFAULT 'EN'::character varying, _type integer DEFAULT 1)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getnewboardwidget._langcode ELSE B.Name END AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE AND W.Type=board_getnewboardwidget._type
	ORDER BY W.Sort DESC;
END;
$function$

```
</details>

## `board_getprenextcontent`

- Input: `0::integer, 0::integer, ''::character varying, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getprenextcontent"(0::integer, 0::integer, ''::character varying, 0::integer, false);`
- SQLSTATE: `42703`
- Error: column "text" does not exist
- Stack context: PL/pgSQL function board_getprenextcontent(integer,integer,character varying,integer,boolean) line 5 at RETURN QUERY
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getprenextcontent(_contentno integer DEFAULT 4946, _boardno integer DEFAULT 0, _languagesign character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 70, _isadmin boolean DEFAULT true)
 RETURNS TABLE(contentno bigint, title character varying, modusername character varying, boardname text, regdatetostring text, type boolean, private boolean, viewmode integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH PERMISSION AS (
	Select *
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getprenextcontent._userno
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getprenextcontent._userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getprenextcontent._userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getprenextcontent._boardno OR  _BoardNo =0 ) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	)
,TMP AS (
	SELECT --BC.*,--T.Url AS FileUrl,
	BC.ContentNo,BC.Title,BC.ModUserName,BC.Private,BC.IsShareAll,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN B.Name::json->>board_getprenextcontent._languagesign ELSE B.Name END AS BoardName ,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE _LanguageSign WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	CONVERT(text, BC.RegDate, 120) as RegDateToString,
	B.ViewMode,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RootId DESC ,BC.ContentNo ASC) AS RowNumber
	FROM BOARD_CONTENTS BC
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	WHERE (BC.BoardNo=board_getprenextcontent._boardno OR   (_BoardNo =0 AND B.ViewMode>=2)) AND BC.Enabled = TRUE
	AND ( _IsAdmin = TRUE OR BC.RegUserNo=board_getprenextcontent._userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))


) ,
Total AS (Select count(*) as ToTal FROM TMP)


SELECT T.ContentNo,T.Title,T.ModUserName,T.BoardName,T.RegDateToString,FALSE AS Type,T.Private,T.ViewMode
FROM TMP T
LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo
LEFT JOIN SHARE S ON S.ContentNo=T.ContentNo
WHERE (T.IsShareAll = TRUE OR _IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL ) AND
T.RowNumber=(SELECT RowNumber-1 FROM TMP WHERE ContentNo=board_getprenextcontent._contentno)
UNION
SELECT T.ContentNo,T.Title,T.ModUserName,T.BoardName,T.RegDateToString,TRUE AS Type,T.Private,T.ViewMode
FROM TMP T
LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo
LEFT JOIN SHARE S ON S.ContentNo=T.ContentNo
WHERE (T.IsShareAll = TRUE OR _IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL ) AND
T.RowNumber=(SELECT RowNumber+1 FROM TMP WHERE ContentNo=board_getprenextcontent._contentno);

	----SET IsAdmin = TRUE
	--declare tempTable table(
	--Type char(1),
	--ContentNo bigint,
	--BoardNo int,
	--BoardName nvarchar(200),
	--ModUserNo int,
	--ModUserName nvarchar(200),
	--ModPositionNo int,
	--ModPositionName nvarchar(200),
	--ModDepartNo int,
	--ModDepartName nvarchar(200),
	--RegDate datetime,
	--RegUserNo int,
	--Title nvarchar(500),
	--TitleEffect int,
	--GroupNo bigint,
	--Depth int,
	--OrderNo int,
	--HeadNo int,
	--IsNotice bit,
	--IsFile bit,
	--FileCount int,
	--ReplyCount int,
	--RecommendedCount int,
	--ViewedCount int,
	--HeadName nvarchar(200),
	--IsRecommended bit,
	--IsAlarm bit,
	--ReadCount int
	--)

	----not admin :
	--if(IsAdmin = FALSE) begin
	---- Nghiem add 20180924
	--insert into tempTable
	--SELECT '0' as Type, BC.ContentNo,BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount,
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,

	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	--LEFT JOIN (SELECT * FROM public."board_getboardallow"(UserNo ,2)) AC ON BC.BoardNo=AC.BoardNo
	--LEFT JOIN  (SELECT * FROM public."board_getboardallow"(UserNo,4)) AD ON BC.BoardNo=AD.BoardNo
	--LEFT JOIN  (SELECT * FROM public."board_getboardallow"(UserNo,1)) AE ON BC.BoardNo=AE.BoardNo
	----(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = UserNo)))
	--WHERE BC.ContentNo < ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE
	--AND (BC.RegUserNo = UserNo	OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (UserNo) DP ON DP.DepartNo= BS1.DepartNo))
	--	OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=UserNo))
	--	OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ))
	--order by BC.ContentNo desc


	--insert into tempTable
	--SELECT '1'as Type, BC.ContentNo, BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount,
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	--LEFT JOIN (SELECT * FROM public."board_getboardallow"(UserNo ,2)) AC ON BC.BoardNo=AC.BoardNo
	--LEFT JOIN  (SELECT * FROM public."board_getboardallow"(UserNo,4)) AD ON BC.BoardNo=AD.BoardNo
	--LEFT JOIN  (SELECT * FROM public."board_getboardallow"(UserNo,1)) AE ON BC.BoardNo=AE.BoardNo

	--WHERE BC.ContentNo > ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE
	--AND (BC.RegUserNo = UserNo	OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."organization_getdepartmentsbyuser" (UserNo) DP ON DP.DepartNo= BS1.DepartNo))
	--	OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=UserNo))
	--	OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ))
	--order by BC.ContentNo asc
	--end
	---- Is admin
	--else begin


	--insert into tempTable
	--SELECT '0' as Type, BC.ContentNo,BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	  -- BC.Content,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount,
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
	--	 --, BC.StartDate, BC.EndDate,

	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

	--	--,BC.RegUserNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	--BC.RegPositionNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	-- BC.RegDepartNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	--WHERE BC.ContentNo < ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE
	--order by BC.ContentNo desc


	--insert into tempTable
	--SELECT '1' as Type, BC.ContentNo, BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	-- BC.ModDate,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	  -- BC.Content,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount,
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
	--	 --, BC.StartDate, BC.EndDate,

	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

	--	--,BC.RegUserNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	--BC.RegPositionNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	-- BC.RegDepartNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	--WHERE BC.ContentNo > ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE
	--order by BC.ContentNo asc

	--end
	--select * from tempTable
END;
$function$

```
</details>

## `board_getreplybycontent`

- Input: `0::bigint, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getreplybycontent"(0::bigint, ''::character varying, 0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getreplybycontent(bigint,character varying,integer) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getreplybycontent(_contentno bigint DEFAULT 5721, _langcode character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 70)
 RETURNS TABLE(replyno bigint, moduserno integer, modusername character varying, modpositionno integer, modpositionname character varying, moddepartno integer, moddepartname character varying, regdate timestamp without time zone, moddate timestamp without time zone, groupno bigint, depth integer, orderno integer, content text, userphoto boolean, photo character varying, isdelete boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
WITH RECURSIVE TMP AS (
  SELECT *--,0 AS Level
  ,CAST(ReplyNo AS text) AS Root
  FROM Board_Replies
  WHERE ContentNo = board_getreplybycontent._contentno AND ParentNo = 0
  UNION ALL
  SELECT BR.*--,(T.Level + 1) AS Level
  , (T.Root || '-' || CAST(BR.ReplyNo AS text)) AS Root
  FROM Board_Replies BR
  INNER JOIN TMP T ON T.ReplyNo = BR.ParentNo AND BR.ContentNo = board_getreplybycontent._contentno
)--,
--EndRoot AS (
--	SELECT P.ReplyNo
--	FROM TMP P
--	LEFT JOIN TMP  C ON P.ReplyNo=C.ParentNo
--	GROUP BY P.ReplyNo
--	HAVING COUNT(C.ParentNo) = 0
--)
	SELECT BR.ReplyNo,
		BR.ModUserNo,
		BR.ModUserName,
		BR.ModPositionNo,
		COALESCE(CASE _LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name)WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) ELSE OD.Name END,'') AS ModPositionName,
		--BR.ModPositionName,
		BR.ModDepartNo,
		COALESCE(CASE _LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name)WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) ELSE OD.Name END,'') AS ModDepartName,
		BR.RegDate,
		BR.ModDate,
		BR.GroupNo,
		BR.Depth,
		BR.OrderNo,
		BR.Content,
		OU.UserPhoto,
		OU.Photo,--BR.Level  ,BR.Root,
		 CAST(
            CASE
                WHEN BR.ModUserNo = board_getreplybycontent._userno
                  AND NOT EXISTS (
                        SELECT 1
                        FROM Board_Replies C
                        WHERE C.ParentNo = BR.ReplyNo AND C.ContentNo = board_getreplybycontent._contentno
                  )
                THEN 1 ELSE 0 END
        AS BIT) AS IsDelete
		--CAST((CASE WHEN ER.ReplyNo IS NOT NULL AND BR.ModUserNo=UserNo THEN 1 ELSE 0 END) AS BIT) AS IsDelete
	FROM TMP BR
	LEFT OUTER JOIN Organization_Users OU ON OU.UserNo = BR.ModUserNo
	LEFT OUTER JOIN Organization_Departments OD ON OD.DepartNo=BR.ModDepartNo AND OD.Enabled = TRUE
	LEFT OUTER JOIN Organization_Positions OP ON OP.PositionNo=BR.ModPositionNo AND OP.Enabled = TRUE
	--LEFT OUTER JOIN EndRoot ER ON ER.ReplyNo=BR.ReplyNo
	WHERE ContentNo = board_getreplybycontent._contentno
	ORDER BY BR.GroupNo DESC, BR.Root ASC;
END;
$function$

```
</details>

## `board_getsettingcommunitywidget`

- Input: `''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getsettingcommunitywidget"(''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_getsettingcommunitywidget(character varying) line 7 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getsettingcommunitywidget(_langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(boardno integer, moduserno integer, moddate timestamp without time zone, name text, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, viewmode integer, enabled boolean, spectype integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN



	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate,
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_getsettingcommunitywidget._langcode,B.Name::json->>'KO') ELSE B.Name END,'') AS Name
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE AND W.Type=2
	ORDER BY W.Sort DESC;
END;
$function$

```
</details>

## `board_getsubmenus`

- Input: `0::integer, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getsubmenus"(0::integer, false, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + text
- Stack context: PL/pgSQL function board_getsubmenus(integer,boolean,character varying) line 6 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getsubmenus(_userno integer DEFAULT 222, _isadmin boolean DEFAULT false, _langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(id character varying, parent character varying, text text, icon character varying, li_attr character varying, data text, state character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
WITH
 DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType,ROW_NUMBER() OVER(PARTITION BY ItemNo,UserNo  ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_getsubmenus._userno AND OB.IsDefault= TRUE
),
History AS (SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder BH WHERE BH.UserNo=board_getsubmenus._userno),
FOLDER AS (
	SELECT BF.Name,BF.FolderNo ,BF.ModUserNo,BF.ModDate, BF.Name AS JsonName, BF.ParentNo, BF.SortNo,TRUE AS IsFolder , 0 AS CountContent, 0 AS ViewMode ,COALESCE(BH.IsOpen, TRUE) AS IsOpen
	FROM  Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getsubmenus._userno
	LEFT JOIN History BH ON  BF.FolderNo=BH.FolderNo AND BH.RowNum=1
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE   BF.Enabled = TRUE AND (_IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0 )
	ORDER BY SortNo ASC,BF.FolderNo ASC),
BOARD AS (
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
				B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled,B.ViewMode,B.SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE
					And BC.RegUserNo <> board_getsubmenus._userno
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_getsubmenus._userno)
					And (_IsAdmin = TRUE OR BA.AllowValue=7 OR D.AllowValue=7 OR
					(  (BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(_UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_belongtodepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_getsubmenus._userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getsubmenus._userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			--INNER JOIN FOLDER F ON F.FolderNo=B.FolderNo
			LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getsubmenus._userno
			LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2 AND Rn=1
			WHERE  B.Enabled = TRUE  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
			--ORDER BY SortNo ASC
),
TREESUB AS
(
    SELECT    	COALESCE(CASE WHEN STRPOS(T.Name, '{')>0 THEN COALESCE(T.Name::json->>board_getsubmenus._langcode,T.Name::json->>'KO') ELSE T.Name END,'') AS Name ,
	 ('f' || CAST(T.FolderNo AS VARCHAR))AS Id  ,
	 T.ModUserNo,T.ModDate, T.Name AS JsonName,
	CASE  WHEN T.ParentNo = 0 THEN '#' ELSE 'f' || CAST(T.ParentNo AS VARCHAR)  END AS ParentNo,
	T.SortNo,TRUE AS IsFolder ,T.IsOpen , 0 AS CountContent, 0 AS ViewMode, 'fa fa-folder' AS icon
    FROM       FOLDER T
    UNION ALL
	SELECT	COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_getsubmenus._langcode,B.Name::json->>'KO') ELSE B.Name END,'') AS Name ,
		('b' || CAST(B.BoardNo AS VARCHAR) )  AS Id  ,
		B.ModUserNo,B.ModDate, B.Name AS JsonName,
		CASE WHEN B.FolderNo = 0 THEN '#' ELSE 'f' || CAST(B.FolderNo AS VARCHAR)   END  AS ParentNo,
		B.SortNo,FALSE AS IsFolder ,FALSE AS IsOpen,B.CountContent,B.ViewMode, 'fa fa-file-o' AS icon
	 FROM      BOARD B
)
SELECT F.id,F.ParentNo AS parent, F.Name+ CASE
    WHEN ViewMode > 0 THEN ' <span class="submenu_board_content_count">' || CAST(ViewMode AS VARCHAR) || '</span>'
    ELSE ''
  END AS text,f.icon,
  '{ "type": "' || CAST(F.ViewMode AS varchar) || '", "RegUserNo": "' || CAST( F.ModUserNo AS varchar) || '" }' AS li_attr,
    '{ "title": "' || F.Name || '", "jsonName": "' || F.JsonName || '" }' AS data,
	 '{ "opened": "' || CASE  WHEN F.IsOpen = TRUE THEN 'true'  ELSE 'false' END || '", "selected": "'|| 'false'  || '" }' AS state
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
END;
$function$

```
</details>

## `board_gettreeboard`

- Input: `false, ''::character varying, 0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_gettreeboard"(false, ''::character varying, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "folder" does not exist
- Stack context: PL/pgSQL function board_gettreeboard(boolean,character varying,integer,boolean) line 6 at RETURN QUERY
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreeboard(_isdisabled boolean DEFAULT true, _langcode character varying DEFAULT 'EN'::character varying, _userno integer DEFAULT 70, _isadmin boolean DEFAULT true)
 RETURNS TABLE(no integer, name text, parentno integer, isboard boolean, roottree integer, index integer, islastroot boolean, viewmode integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
WITH
 DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_gettreeboard._userno AND OB.IsDefault= TRUE
),
PARENTS AS (
	SELECT BF.*
	FROM  Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_gettreeboard._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE  BF.ParentNo = 0 AND  BF.Enabled = TRUE AND (_IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
	ORDER BY SortNo ASC,FolderNo ASC),
CHILDRENTS AS (
	SELECT BF.*
	FROM  Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_gettreeboard._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE  BF.ParentNo >0 AND  BF.Enabled = TRUE  AND (_IsAdmin = TRUE OR BF.SpecType=1 OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
	ORDER BY SortNo ASC,FolderNo ASC),
BOARDCHILD AS (
	SELECT B.*
	FROM Board_Boards B
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_gettreeboard._userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2
	WHERE  B.Enabled = TRUE  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
),
FOLDER AS
(
    SELECT     T.FolderNo as No ,T.Name,T.ParentNo, FALSE as IsBoard,T.SortNo as RootTree,1 as Index,T.SortNo,0 AS ViewMode
    FROM       PARENTS T
    UNION ALL
    SELECT     C.FolderNo as No,C.Name,C.ParentNo, FALSE as IsBoard,F.RootTree,(F.Index + 1) AS Index,C.SortNo,0 AS ViewMode
    FROM       CHILDRENTS C
    INNER JOIN FOLDER F ON F.No = C.ParentNo AND C.Enabled=board_gettreeboard._isdisabled AND F.IsBoard = FALSE
	UNION ALL
	SELECT B.BoardNo as No ,B.Name,B.FolderNo as ParentNo,TRUE as IsBoard ,F.RootTree,(F.Index + 1) AS Index,B.SortNo,B.ViewMode AS ViewMode
	FROM BOARDCHILD B
	INNER JOIN FOLDER F on F.No= B.FolderNo AND B.Enabled=board_gettreeboard._isdisabled AND F.IsBoard = FALSE
), TEMP AS (
	SELECT RootTree, MAX(Index) AS LastRoot
	FROM FOLDER
	GROUP BY RootTree
)
SELECT	F.No ,
		--F.Name ,
		COALESCE(CASE WHEN STRPOS(F.Name, '{')>0 THEN COALESCE(F.Name::json->>board_gettreeboard._langcode,F.Name::json->>'KO') ELSE F.Name END,'') AS Name ,
		F.ParentNo ,
		F.IsBoard ,
		F.RootTree ,
		F.Index ,
		Cast((CASE WHEN T.LastRoot IS NULL THEN 0 ELSE 1 END) AS BIT) AS IsLastRoot ,
		F.ViewMode
	FROM FOLDER F
	LEFT JOIN TEMP T ON T.RootTree=F.RootTree And T.LastRoot=F.Index
	ORDER BY  ParentNo ASC,--IsBoard DESC,
	F.SortNo DESC; --,F.No ASC
END;
$function$

```
</details>

## `board_gettreesubmenu`

- Input: `0::integer, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_gettreesubmenu"(0::integer, false, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_gettreesubmenu(integer,boolean,character varying) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu(_userno integer DEFAULT 222, _isadmin boolean DEFAULT false, _langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(name text, no integer, moduserno integer, moddate timestamp without time zone, jsonname character varying, parentno integer, sortno integer, isfolder boolean, isopen boolean, countcontent integer, viewmode integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

RETURN QUERY
WITH RECURSIVE DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType,ROW_NUMBER() OVER(PARTITION BY ItemNo,UserNo,ItemType  ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_gettreesubmenu._userno AND OB.IsDefault= TRUE
),
History AS (SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder BH WHERE BH.UserNo=board_gettreesubmenu._userno),
PERMISSION AS (
        SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
        FROM (
            SELECT ItemNo, ItemType, AllowValue
            FROM Board_AllowAccess
            WHERE UserNo = board_gettreesubmenu._userno

            UNION ALL

            SELECT ItemNo, ItemType, AllowValue
            FROM DEPARTPERMISSION
            WHERE rn = 1
        ) P
        GROUP BY ItemNo, ItemType
    ),

FOLDER AS (
	SELECT BF.FolderNo,
            BF.ParentNo,
            BF.Name,
            BF.SortNo,
            BF.ModUserNo,
            BF.ModDate,
            COALESCE(BH.IsOpen, TRUE) AS IsOpen
	FROM  Board_Folders BF
	LEFT JOIN PERMISSION BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 --AND BA.UserNo=UserNo
	LEFT JOIN History BH ON  BF.FolderNo=BH.FolderNo AND BH.RowNum=1
	--LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE   BF.Enabled = TRUE AND (_IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0-- OR D.AllowValue>0
	)
	ORDER BY SortNo ASC,FolderNo ASC),
	    CONTENT_COUNT AS (
        SELECT
            BC.BoardNo,
            COUNT(*) AS CountContent
        FROM Board_Contents BC
        WHERE
            BC.Enabled = TRUE
            AND BC.RegDate > '2020-12-31'
            AND BC.RegUserNo <> board_gettreesubmenu._userno
            AND NOT EXISTS (
                SELECT 1
                FROM Board_ViewedLogs BV
                WHERE BV.ContentNo = BC.ContentNo
                  AND BV.UserNo = board_gettreesubmenu._userno
            )
        GROUP BY BC.BoardNo
    ),
BOARD AS (
	SELECT  B.BoardNo,
            B.FolderNo,
            B.Name,
            B.SortNo,
            B.ModUserNo,
            B.ModDate,
            B.ViewMode,
				(SELECT COUNT(*) FROM Board_Contents BC
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE
					And BC.RegUserNo <> board_gettreesubmenu._userno
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_gettreesubmenu._userno)
					And (_IsAdmin = TRUE OR BA.AllowValue=7  OR
					(  (BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(_UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_belongtodepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_gettreesubmenu._userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_gettreesubmenu._userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			--INNER JOIN FOLDER F ON F.FolderNo=B.FolderNo
			LEFT JOIN PERMISSION BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2-- AND BA.UserNo=UserNo
			--LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2 AND Rn=1
			WHERE  B.Enabled = TRUE  AND (_IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL )
			--ORDER BY SortNo ASC
),
TREESUB AS
(
    SELECT    	COALESCE(CASE WHEN STRPOS(T.Name, '{')>0 THEN COALESCE(T.Name::json->>board_gettreesubmenu._langcode,T.Name::json->>'KO') ELSE T.Name END,'') AS Name ,
	T.FolderNo AS No  ,T.ModUserNo,T.ModDate, T.Name AS JsonName, T.ParentNo, T.SortNo,TRUE AS IsFolder ,T.IsOpen , 0 AS CountContent, 0 AS ViewMode
    FROM       FOLDER T
    UNION ALL
	SELECT	COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE(B.Name::json->>board_gettreesubmenu._langcode,B.Name::json->>'KO') ELSE B.Name END,'') AS Name ,
		B.BoardNo AS No  ,B.ModUserNo,B.ModDate, B.Name AS JsonName, B.FolderNo AS ParentNo, B.SortNo,FALSE AS IsFolder ,FALSE AS IsOpen,B.CountContent,B.ViewMode
	 FROM      BOARD B
)
SELECT F.* --,   ROW_NUMBER() OVER (PARTITION BY No,IsFolder ORDER BY ParentNo ASC, SortNo DESC) AS rn
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
  --SET NOCOUNT ON;

  --  -- 1. Optimized Permission CTE
  --  WITH DEPARTPERMISSION AS (
  --      SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
  --      FROM Board_DepartAllowAccess BD
  --      INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
  --      WHERE OB.UserNo = UserNo AND OB.IsDefault = TRUE
  --      GROUP BY ItemNo, ItemType
  --  ),

  --  -- 2. History CTE (Get only the latest state)
  --  History AS (
  --      SELECT FolderNo, IsOpen
  --      FROM (
  --          SELECT FolderNo, IsOpen, ROW_NUMBER() OVER (PARTITION BY FolderNo ORDER BY HistoryFolderNo DESC) AS Rn
  --          FROM Board_HistoryFolder
  --          WHERE UserNo = UserNo
  --      ) H WHERE Rn = 1    ),

  --  -- 3. Content Count logic moved to CTE to prevent RBAR (Row-By-Agonizing-Row) processing
  --  BoardContentCounts AS (
  --      SELECT BC.BoardNo, COUNT(*) AS CountContent
  --      FROM Board_Contents BC
  --      WHERE BC.RegDate > '2020-12-31'
  --        AND BC.Enabled = TRUE
  --        AND BC.RegUserNo <> UserNo
  --        AND NOT EXISTS (SELECT 1 FROM Board_ViewedLogs BV WHERE BV.ContentNo = BC.ContentNo AND BV.UserNo = UserNo)
  --        -- Logic for sharing/permissions can be complex; simplified here for aggregation performance
  --      GROUP BY BC.BoardNo
  --  ),

  --  -- 4. Folders Data
  --  FOLDER_DATA AS (
  --      SELECT
  --          BF.FolderNo, BF.Name, BF.ParentNo, BF.SortNo, BF.ModUserNo, BF.ModDate,
  --          COALESCE(BH.IsOpen, TRUE) AS IsOpen,
  --          TRUE AS IsFolder,
  --          0 AS CountContent,
  --          0 AS ViewMode
  --      FROM Board_Folders BF
  --      LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = UserNo
  --      LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
  --      LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo
  --      WHERE BF.Enabled = TRUE
  --        AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
  --  ),

  --  -- 5. Boards Data
  --  BOARD_DATA AS (
  --      SELECT
  --          B.BoardNo, B.Name, B.FolderNo AS ParentNo, B.SortNo, B.ModUserNo, B.ModDate,
  --          FALSE AS IsOpen,
  --          FALSE AS IsFolder,
  --          COALESCE(BCC.CountContent, 0) AS CountContent,
  --          B.ViewMode
  --      FROM Board_Boards B
  --      LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = UserNo
  --      LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2
  --      LEFT JOIN BoardContentCounts BCC ON BCC.BoardNo = B.BoardNo
  --      WHERE B.Enabled = TRUE
  --        AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
  --  ),

  --  -- 6. Combine and Parse JSON Names
  --  TREESUB AS (
  --      SELECT * FROM FOLDER_DATA
  --      UNION ALL        SELECT * FROM BOARD_DATA
  --  )
  --  SELECT
  --      COALESCE(
  --          CASE                 WHEN F.Name ILIKE '{%}' THEN
  --                  COALESCE(
  --                      F.Name::json->>LangCode,
  --                      F.Name::json->>'KO',
  --                      F.Name
  --                  )
  --              ELSE F.Name
  --          END, ''
  --      ) AS Name,
  --      F.FolderNo AS No,
  --      F.ModUserNo,
  --      F.ModDate,
  --      F.Name AS JsonName,
  --      F.ParentNo,
  --      F.SortNo,
  --      F.IsFolder,
  --      F.IsOpen,
  --      F.CountContent,
  --      F.ViewMode
  --  FROM TREESUB F
  --  ORDER BY F.ParentNo ASC, F.SortNo DESC;
END;
$function$

```
</details>

## `board_gettreesubmenu_v2`

- Input: `0::integer, false, ''::character varying, 0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_gettreesubmenu_v2"(0::integer, false, ''::character varying, 0::integer, 0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_gettreesubmenu_v2(integer,boolean,character varying,integer,integer) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu_v2(_userno integer DEFAULT 222, _isadmin boolean DEFAULT false, _langcode character varying DEFAULT 'EN'::character varying, _selectedboardno integer DEFAULT 0, _selectedfolderno integer DEFAULT 0)
 RETURNS TABLE(name text, no integer, moduserno integer, moddate timestamp without time zone, jsonname character varying, parentno integer, sortno integer, isfolder boolean, isopen boolean, countcontent integer, viewmode integer, isselected boolean)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
WITH
 DEPARTPERMISSION AS (
	Select ItemNo, AllowValue, AllowAccessNo, ItemType, ROW_NUMBER() OVER(PARTITION BY ItemNo, UserNo, ItemType ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
	WHERE OB.UserNo = board_gettreesubmenu_v2._userno AND OB.IsDefault = TRUE
),
History AS (
	SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY BH.UserNo, BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
	FROM Board_HistoryFolder BH
	WHERE BH.UserNo = board_gettreesubmenu_v2._userno
),
FOLDER AS (
	SELECT BF.*, COALESCE(BH.IsOpen, TRUE) AS IsOpen
	FROM Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenu_v2._userno
	LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo AND BH.RowNum = 1
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
	WHERE BF.Enabled = TRUE AND (_IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
),
BOARD AS (
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
			B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled, B.ViewMode, B.SpecType,
			(SELECT COUNT(*) FROM Board_Contents BC
			WHERE '2020-12-31'::timestamp < BC.RegDate AND (BC.BoardNo = B.BoardNo
				AND BC.Enabled = TRUE
				AND BC.RegUserNo <> board_gettreesubmenu_v2._userno
				AND BC.ContentNo NOT IN (SELECT BV.ContentNo FROM Board_ViewedLogs BV WHERE BV.UserNo = board_gettreesubmenu_v2._userno)
				AND (_IsAdmin = TRUE OR BA.AllowValue = 7 OR D.AllowValue = 7 OR
				(  (BC.BoardNo IN (SELECT * FROM public."board_getboardallow"(_UserNo, 2)) OR B.SpecType = 1)
					AND (
						(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."organization_belongtodepartment" DP ON DP.DepartNo = BS1.DepartNo AND DP.UserNo = board_gettreesubmenu_v2._userno))
					  OR (BC.ContentNo IN (SELECT BSS1.ContentNo FROM Board_Sharers BSS1 WHERE BSS1.ContentNo = BC.ContentNo AND BSS1.UserNo = board_gettreesubmenu_v2._userno))
					  OR BC.IsShareAll = TRUE
						) )
				))
			) AS CountContent
		FROM Board_Boards B
		LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenu_v2._userno
		LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2 AND Rn = 1
		WHERE B.Enabled = TRUE AND (_IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
),
TREESUB AS (
	SELECT COALESCE(CASE WHEN STRPOS(T.Name, '{') > 0 THEN COALESCE(T.Name::json->>board_gettreesubmenu_v2._langcode, T.Name::json->>'KO') ELSE T.Name END, '') AS Name,
		T.FolderNo AS No, T.ModUserNo, T.ModDate, T.Name AS JsonName, T.ParentNo, T.SortNo, TRUE AS IsFolder, T.IsOpen, 0 AS CountContent, 0 AS ViewMode
	FROM FOLDER T
	UNION ALL
	SELECT COALESCE(CASE WHEN STRPOS(B.Name, '{') > 0 THEN COALESCE(B.Name::json->>board_gettreesubmenu_v2._langcode, B.Name::json->>'KO') ELSE B.Name END, '') AS Name,
		B.BoardNo AS No, B.ModUserNo, B.ModDate, B.Name AS JsonName, B.FolderNo AS ParentNo, B.SortNo, FALSE AS IsFolder, FALSE AS IsOpen, B.CountContent, B.ViewMode
	FROM BOARD B
)
SELECT F.*,
	CASE
		WHEN F.IsFolder = TRUE AND F.No = board_gettreesubmenu_v2._selectedfolderno THEN TRUE
		WHEN F.IsFolder = FALSE AND F.No = board_gettreesubmenu_v2._selectedboardno  THEN TRUE
		ELSE FALSE
	END AS IsSelected
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
END;
$function$

```
</details>

## `board_gettreesubmenutest`

- Input: `0::integer, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_gettreesubmenutest"(0::integer, false, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function board_gettreesubmenutest(integer,boolean,character varying) line 8 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreesubmenutest(_userno integer DEFAULT 70, _isadmin boolean DEFAULT true, _langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(name text, no integer, moduserno integer, moddate timestamp without time zone, jsonname character varying, parentno integer, sortno integer, isfolder boolean, isopen boolean, countcontent integer, viewmode integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN



    -- 1. Optimized Permission CTE
    RETURN QUERY
    WITH DEPARTPERMISSION AS (
        SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
        FROM Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE OB.UserNo = board_gettreesubmenutest._userno AND OB.IsDefault = TRUE
        GROUP BY ItemNo, ItemType
    ),

    -- 2. History CTE (Get only the latest state)
    History AS (
        SELECT FolderNo, IsOpen
        FROM (
            SELECT FolderNo, IsOpen, ROW_NUMBER() OVER (PARTITION BY FolderNo ORDER BY HistoryFolderNo DESC) AS Rn
            FROM Board_HistoryFolder
            WHERE UserNo = board_gettreesubmenutest._userno
        ) H WHERE Rn = 1    ),

    -- 3. Content Count logic moved to CTE to prevent RBAR (Row-By-Agonizing-Row) processing
    BoardContentCounts AS (
        SELECT BC.BoardNo, COUNT(*) AS CountContent
        FROM Board_Contents BC
        WHERE BC.RegDate > '2020-12-31'
          AND BC.Enabled = TRUE
          AND BC.RegUserNo <> board_gettreesubmenutest._userno
          AND NOT EXISTS (SELECT 1 FROM Board_ViewedLogs BV WHERE BV.ContentNo = BC.ContentNo AND BV.UserNo = board_gettreesubmenutest._userno)
          -- Logic for sharing/permissions can be complex; simplified here for aggregation performance
        GROUP BY BC.BoardNo
    ),

    -- 4. Folders Data
    FOLDER_DATA AS (
        SELECT
            BF.FolderNo, BF.Name, BF.ParentNo, BF.SortNo, BF.ModUserNo, BF.ModDate,
            COALESCE(BH.IsOpen, TRUE) AS IsOpen,
            TRUE AS IsFolder,
            0 AS CountContent,
            0 AS ViewMode
        FROM Board_Folders BF
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenutest._userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
        LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo
        WHERE BF.Enabled = TRUE
          AND (_IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
    ),

    -- 5. Boards Data
    BOARD_DATA AS (
        SELECT
            B.BoardNo, B.Name, B.FolderNo AS ParentNo, B.SortNo, B.ModUserNo, B.ModDate,
            FALSE AS IsOpen,
            FALSE AS IsFolder,
            COALESCE(BCC.CountContent, 0) AS CountContent,
            B.ViewMode
        FROM Board_Boards B
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenutest._userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2
        LEFT JOIN BoardContentCounts BCC ON BCC.BoardNo = B.BoardNo
        WHERE B.Enabled = TRUE
          AND (_IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
    ),

    -- 6. Combine and Parse JSON Names
    TREESUB AS (
        SELECT * FROM FOLDER_DATA
        UNION ALL        SELECT * FROM BOARD_DATA
    )
    SELECT
        COALESCE(
            CASE                 WHEN F.Name ILIKE '{%}' THEN
                    COALESCE(
                        F.Name::json->>board_gettreesubmenutest._langcode,
                        F.Name::json->>'KO',
                        F.Name
                    )
                ELSE F.Name
            END, ''
        ) AS Name,
        F.FolderNo AS No,
        F.ModUserNo,
        F.ModDate,
        F.Name AS JsonName,
        F.ParentNo,
        F.SortNo,
        F.IsFolder,
        F.IsOpen,
        F.CountContent,
        F.ViewMode
    FROM TREESUB F
    ORDER BY F.ParentNo ASC, F.SortNo DESC;
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

## `board_treeboard`

- Input: ``
- Generated SQL: `SELECT * FROM "public"."board_treeboard"();`
- SQLSTATE: `42P19`
- Error: recursive reference to query "folder" must not appear within its non-recursive term
- Stack context: PL/pgSQL function board_treeboard() line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_treeboard()
 RETURNS TABLE(no integer, name character varying, parentno integer, isboard integer, roottree integer, index integer, lastroot integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
WITH RECURSIVE FOLDER AS (
    SELECT     FolderNo as No ,Name,ParentNo, 0 as IsBoard,FolderNo as RootTree,1 as Index
    FROM       Board_Folders
    WHERE      ParentNo = 0 AND Enabled = TRUE
    UNION ALL
    SELECT     C.FolderNo as No,C.Name,C.ParentNo, 0 as IsBoard,F.RootTree,(F.Index + 1) AS Index
    FROM       Board_Folders C
    INNER JOIN FOLDER F ON F.No = C.ParentNo AND C.Enabled = TRUE AND F.IsBoard = FALSE
	UNION ALL
	SELECT B.BoardNo as No ,B.Name,B.FolderNo as ParentNo,1 as IsBoard ,F.RootTree,(F.Index + 1) AS Index
	FROM Board_Boards B
	INNER JOIN FOLDER F on F.No= B.FolderNo AND B.Enabled = TRUE AND F.IsBoard = FALSE
), TEMP AS (
	SELECT RootTree, MAX(Index) AS LastRoot
	FROM FOLDER
	GROUP BY RootTree
)
SELECT F.* , (CASE WHEN T.LastRoot IS NULL THEN 0 ELSE 1 END) AS  LastRoot
	FROM FOLDER F
	LEFT JOIN TEMP T ON T.RootTree=F.RootTree And T.LastRoot=F.Index
	ORDER BY RootTree,ParentNo;
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

## `contacts_checkgroup`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_checkgroup"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: integer = character varying
- Stack context: PL/pgSQL function contacts_checkgroup(integer,integer,character varying) line 7 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_checkgroup(_reguserno integer, _type integer, _value character varying)
 RETURNS TABLE(groupno integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	-- 그룹번호로 체크
	IF _Type = 0 THEN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup
		WHERE RegUserNo=contacts_checkgroup._reguserno
		AND GroupNo=contacts_checkgroup._value
		AND UseYn='Y';
	-- 그룹이름으로 체크
	ELSIF _Type = 1 THEN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup
		WHERE RegUserNo=contacts_checkgroup._reguserno
		AND GroupName=contacts_checkgroup._value
		AND UseYn='Y';
	END IF;
END;
$function$

```
</details>

## `contacts_checknumber`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_checknumber"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_checknumber(integer,character varying,integer) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_checknumber(_reguserno integer, _value character varying, _type integer)
 RETURNS TABLE(cnt integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN
IF _Type = 0 THEN
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsNumber N
	INNER JOIN ContactsUser U ON U.Seq = N.UserSeq AND U.UseYn='Y'
	WHERE N.RegUserNo = contacts_checknumber._reguserno
	AND REPLACE(N.Value,'-','') = REPLACE(_Value,'-','');
ELSE
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsEmail E
	INNER JOIN ContactsUser U ON U.Seq = E.UserSeq AND U.UseYn='Y'
	WHERE E.RegUserNo = contacts_checknumber._reguserno AND E.Value = contacts_checknumber._value;







END IF;
END;
$function$

```
</details>

## `contacts_finduser`

- Input: `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_finduser"(0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: function public.uf_regularextext(character varying) does not exist
- Stack context: PL/pgSQL function contacts_finduser(integer,integer,character varying,integer,integer,character varying,character varying) line 86 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_finduser(_userno integer, _serchtype integer, _serchtext character varying, _viewcount integer, _currentpageindex integer, _initial character varying, _sortcolumn character varying)
 RETURNS TABLE(totalcnt integer, rownum integer, company character varying, depart character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	-- 이름검색
	IF _SerchType = 0 THEN
		IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			(U.FirstName + U.LastName) ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY
			C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
			AND (((U.FirstName + U.LastName) ILIKE '%' || _SerchText || '%') OR ((U.LastName + U.FirstName) ILIKE '%' || _SerchText || '%'))
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 전화번호검색
	ELSIF _SerchType = 1 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			N.Value ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND N.Value ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 회사 검색
	ELSIF _SerchType = 2 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Company ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND C.Company ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 부서검색
	ELSIF _SerchType = 3 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Depart ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND C.Depart ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	--직위검색
	ELSIF _SerchType = 4 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Position ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND C.Position ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 이메일
	ELSIF _SerchType = 5 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			E.Value ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND E.Value ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 그룹
	ELSIF _SerchType = 6 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			(SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	-- 주소 검색
	ELSIF _SerchType = 7 THEN
	IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
			WHERE
			A.Address ILIKE '%' || _SerchText || '%'
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName) = 0
			GROUP BY C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser._userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser._userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser._userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser._userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser._userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser._userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser._userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName) > 0
				AND A.Address ILIKE '%' || _SerchText || '%'
				GROUP BY C.Company
				,C.Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
	END IF;
END;
$function$

```
</details>

## `contacts_getaddressinfo`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getaddressinfo"(0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getaddressinfo(integer) line 7 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getaddressinfo(_seq integer DEFAULT 7997)
 RETURNS TABLE(seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, viewcount integer, grouplist character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = contacts_getaddressinfo._seq;
	RETURN QUERY
	SELECT * FROM Contact_PublicGroupUser WHERE UserSeq = contacts_getaddressinfo._seq AND IsDelete= FALSE;
	RETURN QUERY
	SELECT * FROM Contact_ShareGroupUser WHERE UserSeq = contacts_getaddressinfo._seq AND IsDelete= FALSE;
	UPDATE ContactsUser
	SET
		ViewCount = ViewCount+1
	WHERE Seq = contacts_getaddressinfo._seq;
END;
$function$

```
</details>

## `contacts_getaddressnotupdatecount`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getaddressnotupdatecount"(0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getaddressnotupdatecount(integer) line 7 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getaddressnotupdatecount(_seq integer)
 RETURNS TABLE(seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, viewcount integer, grouplist character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = contacts_getaddressnotupdatecount._seq;
END;
$function$

```
</details>

## `contacts_getallcontactslist`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getallcontactslist"(0::integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: text = integer
- Stack context: PL/pgSQL function contacts_getallcontactslist(integer) line 6 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getallcontactslist(_userno integer)
 RETURNS TABLE(seq integer, firstname character varying, lastname character varying, value character varying, "position" character varying, company character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	RETURN QUERY
	SELECT U.Seq,
		COALESCE(U.FirstName, '') AS FirstName,
		COALESCE(U.LastName, '') AS LastName,
		COALESCE(E.Value, '') AS Value,
		COALESCE(C.Position, '') AS Position,
		COALESCE(C.Company, '') AS Company
	FROM ContactsUser U
	INNER JOIN ContactsEmail E ON E.UserSeq = U.Seq
	LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq
	WHERE (U.RegUserNo = contacts_getallcontactslist._userno or SUBSTRING(U.Share,1,3) = 300)  AND U.UseYn = 'Y';
END;
$function$

```
</details>

## `contacts_getallgroup`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getallgroup"(0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getallgroup(integer,character varying) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getallgroup(_reguserno integer DEFAULT 70, _langcode character varying DEFAULT 'KO'::character varying)
 RETURNS TABLE(groupno integer, groupname text, rootgroupno integer, reguserno integer, regdate timestamp without time zone, memo character varying, parentgno integer, sort integer, isdefault character, usercount integer, name text)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH RECURSIVE ContactsGroups AS (
		   SELECT CGP.GroupNo,CGP.GroupNo AS RootGroupNo, CGP.GroupName, CGP.RegUserNo, CGP.RegDate, CGP.Memo, CGP.ParentGNo, CGP.Sort, CGP.IsDefault,CGP.UseYn
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y' AND CGP.ParentGNo=0 AND  CGP.RegUserNo=contacts_getallgroup._reguserno
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGroupNo, CGC.GroupName, CGC.RegUserNo, CGC.RegDate, CGC.Memo, CGC.ParentGNo, CGC.Sort, CGC.IsDefault,CGC.UseYn
		  FROM ContactsGroup CGC
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y' AND   CGC.RegUserNo=contacts_getallgroup._reguserno
	)
	SELECT CG.GroupNo,CG.GroupName,CG.RootGroupNo,CG.RegUserNo,CG.RegDate,CG.Memo,CG.ParentGNo,CG.Sort,CG.IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq
		WHERE U.UseYn='Y' AND C.GroupNo =CG.GroupNo
	) AS UserCount,
	CASE WHEN STRPOS(CG.GroupName, '{')>0 THEN CG.GroupName::json->>contacts_getallgroup._langcode ELSE CG.GroupName END AS  Name
	FROM ContactsGroups  CG
	WHERE CG.RegUserNo=contacts_getallgroup._reguserno AND CG.UseYn='Y' ORDER BY CG.Sort;
END;
$function$

```
</details>

## `contacts_getalluser_distinct`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getalluser_distinct"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_getalluser_distinct(integer,integer,integer) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getalluser_distinct(_reguserno integer, _currpage integer DEFAULT 1, _recodperpage integer DEFAULT 20)
 RETURNS TABLE(rownum bigint, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, callname character varying, viewcount integer, fullname character varying, counts integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH RECURSIVE s AS (
			SELECT ROW_NUMBER()
				OVER(ORDER BY Seq DESC) AS RowNum,Seq,FirstName,LastName,RegUserNo,Memo,RegDate,Photo,ModDate,CallName,ViewCount,(FirstName+LastName) as FullName
				--,(SELECT COUNT(*) FROM ContactsUser WHERE  Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=RegUserNo GROUP BY FirstName+LastName)) as counts
			FROM ContactsUser Cu
			WHERE Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=contacts_getalluser_distinct._reguserno   GROUP BY FirstName+LastName)
		  AND RegUserNo=contacts_getalluser_distinct._reguserno AND UseYn='Y'
		)
		Select * , (select COUNT(*) FROM s) As counts From s
		Where RowNum Between
			(_currPage - 1)*_recodperpage+1
			AND _currPage*_recodperpage
			ORDER BY Seq DESC;
END;
$function$

```
</details>

## `contacts_getcontactgroup`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getcontactgroup"(0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getcontactgroup(integer,character varying) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactgroup(_userno integer DEFAULT 70, _langcode character varying DEFAULT 'KO'::character varying)
 RETURNS TABLE(id integer, jsonname text, parentno integer, sharenumber integer, name text)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH RECURSIVE ContactsGroups AS (
		   SELECT CGP.GroupNo,CGP.GroupNo AS RootGroupNo, CGP.GroupName, CGP.RegUserNo, CGP.RegDate, CGP.Memo, CGP.ParentGNo, CGP.Sort, CGP.IsDefault,CGP.UseYn
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y' AND CGP.ParentGNo=0 AND  CGP.RegUserNo=contacts_getcontactgroup._userno
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGroupNo, CGC.GroupName, CGC.RegUserNo, CGC.RegDate, CGC.Memo, CGC.ParentGNo, CGC.Sort, CGC.IsDefault,CGC.UseYn
		  FROM ContactsGroup CGC
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y' AND   CGC.RegUserNo=contacts_getcontactgroup._userno
	)
	SELECT CG.GroupNo AS Id,CG.GroupName AS JsonName,CG.ParentGNo AS ParentNo  ,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq
		WHERE U.UseYn='Y' AND C.GroupNo =CG.GroupNo
	) AS ShareNumber,
	CASE WHEN STRPOS(CG.GroupName, '{')>0 THEN CG.GroupName::json->>contacts_getcontactgroup._langcode ELSE CG.GroupName END AS Name
	FROM ContactsGroups  CG
	WHERE CG.RegUserNo=contacts_getcontactgroup._userno AND CG.UseYn='Y' ORDER BY CG.Sort;
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

## `contacts_getcontactstrashlist`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getcontactstrashlist"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getcontactstrashlist(integer,integer,integer,character varying,character varying,character varying,character varying,integer,character varying,character varying) line 2040 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactstrashlist(_reguserno integer, _sidx integer, _eidx integer, _ts character varying, _te character varying, _search character varying, _searchmode character varying, _groupno integer, _mode character varying, _sortcolumn character varying DEFAULT ''::character varying)
 RETURNS TABLE(rownum bigint, seq integer, firstname character varying, lastname character varying, memo character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	-- ==========================
	-- 데이터/카운트 구분 0 = 데이터 / 1 = 카운트
	-- ==========================
	IF _Mode = '0' THEN
		-- ==========================
		-- 검색값 - 검색이 아닌 경우
		-- ==========================
		IF _Search = '' THEN
			-- ===========================
			-- 색인 모드가 아닐 경우
			-- ===========================
			IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
				-- ===========================
				-- 정렬
				-- ===========================
				IF _SortColumn = 'FirstName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'FirstName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'LastName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'LastName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSE
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				END IF;
			ELSE
			-- ===========================
			-- 색인 모드 일 경우
			-- ===========================

				-- ===========================
				-- 정렬
				-- ===========================
				IF _SortColumn = 'FirstName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
						AND LastName BETWEEN _TS AND _TE
						AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'FirstName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
						AND LastName BETWEEN _TS AND _TE
						AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'LastName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
						AND LastName BETWEEN _TS AND _TE
						AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSIF _SortColumn = 'LastName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
						AND LastName BETWEEN _TS AND _TE
						AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				ELSE
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
						AND LastName BETWEEN _TS AND _TE
						AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
				END IF;
			END IF;
		-- ===========================
		-- 검색일경우
		-- ===========================
		ELSE
			-- ===========================
			-- 성/이름 검색
			-- ===========================
			IF _SearchMode = '0' THEN -- 이름 검색
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' )
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				END IF;
			ELSIF _SearchMode = '1' THEN
			-- ===========================
			-- 직위 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				END IF;
			ELSIF _SearchMode = '2' THEN
			-- ===========================
			-- 전화번호 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				END IF;
			ELSIF _SearchMode = '3' THEN
			-- ===========================
			-- 회사 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				END IF;
			ELSIF _SearchMode = '4' THEN
			-- ===========================
			-- 부서 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				END IF;
			ELSIF _SearchMode = '5' THEN
			-- ===========================
			-- 이메일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || _Search || '%')
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				END IF;
			ELSIF _SearchMode = '6' THEN
			-- ===========================
			-- 그룹 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'))
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;

					END IF;
				END IF;
			ELSIF _SearchMode = '7' THEN
			-- ===========================
			-- 등록일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				END IF;
			ELSIF _SearchMode = '8' THEN
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				END IF;
			ELSIF _SearchMode = '9' THEN
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF _SortColumn = 'FirstName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'FirstName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName ASC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSIF _SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
							AND LastName BETWEEN _TS AND _TE
							AND Seq IN (
										 SELECT UserSeq
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."getchildgroup"(_RegUserNo, _GroupNo)
														)
										)
							AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%'
						) A
						WHERE ROWNUM BETWEEN _Sidx AND _Eidx;
					END IF;
				END IF;
			END IF;
		END IF;
	ELSE
	-- ===========================
	-- 카운트 쿼리
	-- ===========================
		-- ===========================
		-- 검색이 아닌경우
		-- ===========================
		IF _Search = '' THEN
			-- ===========================
			-- 색인이 아닌 경우
			-- ===========================
			IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
				RETURN QUERY
				SELECT COUNT (*) CNT
				FROM ContactsUser CU
				WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno;
			ELSE
			-- ===========================
			-- 색인인 경우
			-- ===========================;
				RETURN QUERY
				SELECT COUNT (*) CNT
				FROM ContactsUser CU
				WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
				AND LastName BETWEEN _TS AND _TE
				AND Seq IN (
								 SELECT UserSeq
								 FROM ContactsGroupUser
								 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
								 AND GroupNo IN (
												SELECT TreeID
												FROM public."getchildgroup"(_RegUserNo, _GroupNo)
												)
								);
			END IF;
		ELSE
		-- ===========================
		-- 검색인 경우
		-- ===========================
			-- ===========================
			-- 이름 검색인 경우
			-- ===========================
			IF _SearchMode = '0' THEN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' );
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND ( FirstName ILIKE '%' || _Search || '%' OR LastName ILIKE '%' || _Search || '%' );
				END IF;
			ELSIF _SearchMode = '1' THEN
			-- ===========================
			-- 직위 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || _Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || _Search || '%');
				END IF;
			ELSIF _SearchMode = '2' THEN
			-- ===========================
			-- 전화번호 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || _Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || _Search || '%');
				END IF;
			ELSIF _SearchMode = '3' THEN
			-- ===========================
			-- 회사 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || _Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || _Search || '%');
				END IF;
			ELSIF _SearchMode = '4' THEN
			-- ===========================
			-- 부서 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || _Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || _Search || '%');
				END IF;
			ELSIF _SearchMode = '5' THEN
			-- ===========================
			-- 이메일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || _Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || _Search || '%');
				END IF;
			ELSIF _SearchMode = '6' THEN
			-- ===========================
			-- 그룹검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'));
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || _Search || '%'));
				END IF;
			ELSIF _SearchMode = '7' THEN
			-- ===========================
			-- 등록일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND TO_CHAR(RegDate, 'YYYYMMDD') ILIKE '%' || _Search || '%';
				END IF;
			ELSIF _SearchMode = '8' THEN
			-- ===========================
			-- 수정일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND TO_CHAR(ModDate, 'YYYYMMDD') = '%' || _Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND TO_CHAR(ModDate, 'YYYYMMDD') ILIKE '%' || _Search || '%';
				END IF;
			ELSIF _SearchMode = '9' THEN
			-- ===========================
			-- 체크일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF _TS = '' AND _TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND TO_CHAR(CheckDate, 'YYYYMMDD') = '%' || _Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist._reguserno
					AND LastName BETWEEN _TS AND _TE
					AND Seq IN (
									 SELECT UserSeq
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist._reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."getchildgroup"(_RegUserNo, _GroupNo)
													)
									)
					AND TO_CHAR(CheckDate, 'YYYYMMDD') ILIKE '%' || _Search || '%';
				END IF;
			END IF;
		END IF;

	END IF;
END;
$function$

```
</details>

## `contacts_getcountchilduser`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getcountchilduser"(0::integer, 0::integer);`
- SQLSTATE: `42883`
- Error: function public.getchildgroup(integer, integer) does not exist
- Stack context: PL/pgSQL function contacts_getcountchilduser(integer,integer) line 4 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcountchilduser(_seq integer, _reguserno integer)
 RETURNS TABLE(count integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN
RETURN QUERY
select COUNT(*) count FROM ContactsUser WHERE UseYn = 'Y'  AND Seq IN
 (SELECT UserSeq from ContactsGroupUser WHERE RegUserNo = contacts_getcountchilduser._reguserno
AND GroupNo IN (SELECT TreeID FROM public."getchildgroup"(_RegUserNo, _Seq)));
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

## `contacts_gethistorylistcount`

- Input: `0::integer, 0::integer, 0::integer, CURRENT_DATE, CURRENT_DATE`
- Generated SQL: `SELECT * FROM "public"."contacts_gethistorylistcount"(0::integer, 0::integer, 0::integer, CURRENT_DATE, CURRENT_DATE);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_gethistorylistcount(integer,integer,integer,date,date) line 15 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_gethistorylistcount(_userno integer, _searchtype integer, _searchday integer DEFAULT 0, _searchdate1 date DEFAULT ('now'::text)::date, _searchdate2 date DEFAULT ('now'::text)::date)
 RETURNS TABLE(cnt integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF _SearchType = 1 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = contacts_gethistorylistcount._userno
		AND U.ModDate >= DATEADD(dd, _SearchDay, NOW());
	ELSE
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = contacts_gethistorylistcount._userno
		AND U.ModDate BETWEEN _SearchDate1 AND _SearchDate2;
	END IF;
END;
$function$

```
</details>

## `contacts_getonerowchildgroup`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getonerowchildgroup"(0::integer, 0::integer);`
- SQLSTATE: `42883`
- Error: function public.getchildgroup(integer, integer) does not exist
- Stack context: PL/pgSQL function contacts_getonerowchildgroup(integer,integer) line 4 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getonerowchildgroup(_groupno integer, _reguserno integer)
 RETURNS TABLE(groupno integer, groupname text, reguserno integer, regdate timestamp without time zone, memo character varying, parentgno integer, sort integer, isdefault character, useyn character)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN
RETURN QUERY
SELECT b.* FROM
(select * FROM public."getchildgroup"(_RegUserNo,_groupno) WHERE Level=2) a,
(select *from ContactsGroup where RegUserNo = contacts_getonerowchildgroup._reguserno) b where a.TreeID = b.GroupNo
order by b.Sort asc;
END;
$function$

```
</details>

## `contacts_getoutfile`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getoutfile"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function public.uf_contactsdetail(integer, unknown) does not exist
- Stack context: PL/pgSQL function contacts_getoutfile(integer,character varying) line 46 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutfile(_userno integer, _userseqlist character varying DEFAULT 'ALL'::character varying)
 RETURNS TABLE(seq integer, lastname character varying, firstname character varying, "position" character varying, number character varying, company character varying, depart character varying, groupname character varying, email character varying, checkdate timestamp without time zone, moddate timestamp without time zone, regdate timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _userseq integer;
BEGIN


	IF _UserSeqList = 'ALL' THEN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			public."uf_contactsdetail"(U.Seq,'Position') AS Position,
			public."uf_contactsdetail"(U.Seq,'number') AS Number,
			public."uf_contactsdetail"(U.Seq,'company') AS Company,
			public."uf_contactsdetail"(U.Seq,'Depart') As Depart,
			public."uf_contactsdetail"(U.Seq,'group') AS GroupName,
			public."uf_contactsdetail"(U.Seq,'email') AS Email,
			U.CheckDate,
			U.ModDate,
			U.RegDate
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfile._userno
		AND UseYn = 'Y';
	ELSE

		CREATE TEMP TABLE _tabUser (UserSeq INT) ON COMMIT DROP;

		_UserSeqList := contacts_getoutfile._userseqlist || ',';
		WHILE STRPOS(_UserSeqList, ',') > 0 LOOP

			_UserSeq := COALESCE(NULLIF((SUBSTRING(_UserSeqList,0,STRPOS(_UserSeqList, ',')))::text, '')::integer, 0);
			INSERT INTO _tabUser
			(
				UserSeq
			)
			VALUES
			(
				_UserSeq
			);

			_UserSeqList := SUBSTRING(_UserSeqList,STRPOS(_UserSeqList, ',')+1,LENGTH(_UserSeqList));
		END LOOP;

		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			U.CheckDate,
			U.ModDate,
			U.RegDate,
			public."uf_contactsdetail"(U.Seq,'company') AS Company,
			public."uf_contactsdetail"(U.Seq,'Depart') As Depart,
			public."uf_contactsdetail"(U.Seq,'Position') AS Position,
			public."uf_contactsdetail"(U.Seq,'email') AS Email,
			public."uf_contactsdetail"(U.Seq,'number') AS Number,
			public."uf_contactsdetail"(U.Seq,'group') AS GroupName
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfile._userno
		AND UseYn = 'Y'
		AND Seq IN (SELECT UserSeq FROM _tabUser);
	END IF;
END;
$function$

```
</details>

## `contacts_getoutfileexcel`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getoutfileexcel"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function public.uf_contactsdetailexcel(integer, unknown) does not exist
- Stack context: PL/pgSQL function contacts_getoutfileexcel(integer,character varying) line 54 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutfileexcel(_userno integer DEFAULT 1, _userseqlist character varying DEFAULT '2,3,4,5'::character varying)
 RETURNS TABLE(lastname character varying, firstname character varying, callname character varying, cellphone character varying, companyphone character varying, homephone character varying, faxphone character varying, company character varying, "position" character varying, depart character varying, email character varying, companyzipcode character varying, companyaddress character varying, homezipcode character varying, homeaddress character varying, homepage character varying, memo character varying, groupname character varying, regdate timestamp without time zone, moddate timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _userseq integer;
BEGIN


	IF _UserSeqList = 'ALL' THEN
		RETURN QUERY
		SELECT
			U.LastName,
			U.FirstName,
			U.CallName,
			public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
			public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
			public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
			public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
			public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
			public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
			public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
			public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
			public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
			public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
			public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
			public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfileexcel._userno
		AND UseYn = 'Y';
	ELSE

		CREATE TEMP TABLE _tabUser (UserSeq INT) ON COMMIT DROP;

		_UserSeqList := contacts_getoutfileexcel._userseqlist || ',';
		WHILE STRPOS(_UserSeqList, ',') > 0 LOOP

			_UserSeq := COALESCE(NULLIF((SUBSTRING(_UserSeqList,0,STRPOS(_UserSeqList, ',')))::text, '')::integer, 0);
			INSERT INTO _tabUser
			(
				UserSeq
			)
			VALUES
			(
				_UserSeq
			);

			_UserSeqList := SUBSTRING(_UserSeqList,STRPOS(_UserSeqList, ',')+1,LENGTH(_UserSeqList));
		END LOOP;

		RETURN QUERY
		SELECT
			U.LastName,
			U.FirstName,
			U.CallName,
			public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
			public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
			public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
			public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
			public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
			public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
			public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
			public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
			public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
			public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
			public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
			public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE
		--RegUserNo = UserNo	AND
		 UseYn = 'Y'
		AND Seq IN (SELECT UserSeq FROM _tabUser);
	END IF;
END;
$function$

```
</details>

## `contacts_getoutlist`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getoutlist"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function public.uf_contactsdetail(integer, unknown) does not exist
- Stack context: PL/pgSQL function contacts_getoutlist(integer,character varying) line 80 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlist(_userno integer, _grouplist character varying DEFAULT 'ALL'::character varying)
 RETURNS TABLE(seq integer, lastname character varying, firstname character varying, checkdate timestamp without time zone, moddate timestamp without time zone, regdate timestamp without time zone, company character varying, depart character varying, "position" character varying, email character varying, number character varying, groupname character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _groupno integer;
BEGIN

	IF _GroupList = 'ALL' THEN
		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."uf_contactsdetail"(U.Seq,'company') AS Company,
				public."uf_contactsdetail"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetail"(U.Seq,'Position') AS Position,
				public."uf_contactsdetail"(U.Seq,'email') AS Email,
				public."uf_contactsdetail"(U.Seq,'number') AS Number,
				public."uf_contactsdetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			WHERE RegUserNo = contacts_getoutlist._userno
			AND UseYn = 'Y'
		) A
		WHERE 1>0;
	ELSIF _GroupList = 'LIST' THEN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			U.CheckDate,
			U.ModDate,
			U.RegDate,
			public."uf_contactsdetail"(U.Seq,'company') AS Company,
			public."uf_contactsdetail"(U.Seq,'Depart') As Depart,
			public."uf_contactsdetail"(U.Seq,'Position') AS Position,
			public."uf_contactsdetail"(U.Seq,'email') AS Email,
			public."uf_contactsdetail"(U.Seq,'number') AS Number,
			public."uf_contactsdetail"(U.Seq,'group') AS GroupName
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutlist._userno
		AND UseYn = 'Y';
	ELSE
		CREATE TEMP TABLE _tabGroup (GroupNo INT) ON COMMIT DROP;

		_GroupList := contacts_getoutlist._grouplist || ',';
		WHILE STRPOS(_GroupList, ',') > 0 LOOP

			_GroupNo := COALESCE(NULLIF((SUBSTRING(_GroupList,0,STRPOS(_GroupList, ',')))::text, '')::integer, 0);
			INSERT INTO _tabGroup
			(
				GroupNo
			)
			VALUES
			(
				_GroupNo
			);

			_GroupList := SUBSTRING(_GroupList,STRPOS(_GroupList, ',')+1,LENGTH(_GroupList));
		END LOOP;

		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."uf_contactsdetail"(U.Seq,'company') AS Company,
				public."uf_contactsdetail"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetail"(U.Seq,'Position') AS Position,
				public."uf_contactsdetail"(U.Seq,'email') AS Email,
				public."uf_contactsdetail"(U.Seq,'number') AS Number,
				public."uf_contactsdetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
			JOIN ContactsGroup GR ON G.GroupNo=GR.GroupNo
			WHERE U.RegUserNo = contacts_getoutlist._userno
			AND U.UseYn = 'Y'
			AND G.GroupNo IN (SELECT GroupNo FROM _tabGroup)
		) A
		WHERE 1>0;
	END IF;
END;
$function$

```
</details>

## `contacts_getoutlistcount`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getoutlistcount"(0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getoutlistcount(integer,character varying) line 34 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlistcount(_userno integer, _grouplist character varying DEFAULT 'ALL'::character varying)
 RETURNS TABLE(cnt integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _groupno integer;
BEGIN

	IF _GroupList = 'ALL' THEN

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutlistcount._userno
		AND UseYn = 'Y';
	ELSE
		CREATE TEMP TABLE _tabGroup (GroupNo INT) ON COMMIT DROP;

		_GroupList := contacts_getoutlistcount._grouplist || ',';
		WHILE STRPOS(_GroupList, ',') > 0 LOOP

			_GroupNo := COALESCE(NULLIF((SUBSTRING(_GroupList,0,STRPOS(_GroupList, ',')))::text, '')::integer, 0);
			INSERT INTO _tabGroup
			(
				GroupNo
			)
			VALUES
			(
				_GroupNo
			);

			_GroupList := SUBSTRING(_GroupList,STRPOS(_GroupList, ',')+1,LENGTH(_GroupList));
		END LOOP;

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
		WHERE U.RegUserNo = contacts_getoutlistcount._userno
		AND U.UseYn = 'Y'
		AND G.GroupNo IN (SELECT GroupNo FROM _tabGroup);

	END IF;
END;
$function$

```
</details>

## `contacts_getoutlistexcel`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, false`
- Generated SQL: `SELECT * FROM "public"."contacts_getoutlistexcel"(0::integer, ''::character varying, ''::character varying, ''::character varying, false);`
- SQLSTATE: `42883`
- Error: function public.uf_contactsdetailexcel(integer, unknown) does not exist
- Stack context: PL/pgSQL function contacts_getoutlistexcel(integer,character varying,character varying,character varying,boolean) line 164 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlistexcel(_userno integer DEFAULT 70, _grouplist character varying DEFAULT ''::character varying, _sharelist character varying DEFAULT '0'::character varying, _publiclist character varying DEFAULT ''::character varying, _isadmin boolean DEFAULT true)
 RETURNS TABLE(seq integer, lastname character varying, callname character varying, firstname character varying, cellphone character varying, companyphone character varying, homephone character varying, faxphone character varying, company character varying, "position" character varying, depart character varying, email character varying, companyzipcode character varying, companyaddress character varying, homezipcode character varying, homeaddress character varying, homepage character varying, moddate timestamp without time zone, regdate timestamp without time zone, groupname text, memo character varying, groupid integer, reguserno integer, useyn character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _groupno integer;
BEGIN

CREATE TEMP TABLE _tabGroup (GroupNo INT) ON COMMIT DROP;
	_GroupList := contacts_getoutlistexcel._grouplist || ',';
		WHILE STRPOS(_GroupList, ',') > 0 LOOP

			_GroupNo := COALESCE(NULLIF((SUBSTRING(_GroupList,0,STRPOS(_GroupList, ',')))::text, '')::integer, 0);
			INSERT INTO _tabGroup
			(
				GroupNo
			)
			VALUES
			(
				_GroupNo
			);

			_GroupList := SUBSTRING(_GroupList,STRPOS(_GroupList, ',')+1,LENGTH(_GroupList));
		END LOOP;
IF _IsAdmin = TRUE THEN
		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN GroupName::json->>'KO' ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel._userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM _tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT unnest(string_to_array(_PublicList, ','))::integer)
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 --((U.RegUserNo=UserNo AND SUBSTRING(U.Share,1,3)='200')

				--or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_GetDepartmentsByUser(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			SUBSTRING(U.Share,1,3)='200'
			--AND U.RegUserNo <> UserNo
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT unnest(string_to_array(_ShareList, ','))::integer)
		) A;

		ELSE




		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN GroupName::json->>'KO' ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel._userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM _tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT unnest(string_to_array(_PublicList, ','))::integer)
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."uf_contactsdetailexcel"(U.Seq,'cellphone') AS cellphone,
				public."uf_contactsdetailexcel"(U.Seq,'companyphone') AS companyphone,
				public."uf_contactsdetailexcel"(U.Seq,'homephone') AS homephone,
				public."uf_contactsdetailexcel"(U.Seq,'faxphone') AS faxphone,
				public."uf_contactsdetailexcel"(U.Seq,'company') AS Company,
				public."uf_contactsdetailexcel"(U.Seq,'Position') AS Position,
				public."uf_contactsdetailexcel"(U.Seq,'Depart') As Depart,
				public."uf_contactsdetailexcel"(U.Seq,'email') AS Email,
				public."uf_contactsdetailexcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."uf_contactsdetailexcel"(U.Seq,'companyaddress') AS companyaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homezipcode') AS homezipcode,
				public."uf_contactsdetailexcel"(U.Seq,'homeaddress') AS homeaddress,
				public."uf_contactsdetailexcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."uf_contactsdetailexcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."uf_contactsdetailexcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."uf_contactsdetailexcel"(U.Seq,'group') END AS GroupName ,
				--public."uf_contactsdetailexcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 ((U.RegUserNo=contacts_getoutlistexcel._userno AND SUBSTRING(U.Share,1,3)='200')

				or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getoutlistexcel._userno))))
			--SUBSTRING(U.Share,1,3)='200'
			AND U.RegUserNo <> contacts_getoutlistexcel._userno
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT unnest(string_to_array(_ShareList, ','))::integer)
		) A;
END IF;
END;
$function$

```
</details>

## `contacts_getpublicgroup`

- Input: `''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getpublicgroup"(''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getpublicgroup(character varying) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getpublicgroup(_langcode character varying DEFAULT 'KO'::character varying)
 RETURNS TABLE(id integer, jsonname text, name text, parentno integer, sharenumber integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	SELECT PG.PublicGroupNo AS Id,PG.PublicGroupName AS JsonName,COALESCE(CASE WHEN STRPOS(PG.PublicGroupName, '{')>0 THEN COALESCE(PG.PublicGroupName::json->>contacts_getpublicgroup._langcode,PG.PublicGroupName::json->>'KO') ELSE PG.PublicGroupName END,'') AS Name , PG.ParentNo ,
	COALESCE(SU.ShareNumber,0) AS ShareNumber
	FROM  Contact_PublicGroup PG
	LEFT JOIN  ( SELECT P.PublicGroupNo, Count(P.PublicGroupNo) AS ShareNumber
				FROM Contact_PublicGroupUser  P
				INNER JOIN ContactsUser U ON U.Seq = P.UserSeq AND U.UseYn='Y'
				WHERE P.IsDelete= FALSE
				GROUP BY P.PublicGroupNo) SU ON SU.PublicGroupNo = PG.PublicGroupNo
	WHERE PG.IsDelete= FALSE
	ORDER BY  PG.ParentNo, PG.Sort;
END;
$function$

```
</details>

## `contacts_getsharegroup`

- Input: `0::integer, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getsharegroup"(0::integer, false, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getsharegroup(integer,boolean,character varying) line 31 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getsharegroup(_userno integer DEFAULT 222, _isadmin boolean DEFAULT false, _langcode character varying DEFAULT 'KO'::character varying)
 RETURNS TABLE(id integer, jsonname text, name text, parentno integer, sharenumber integer, sort integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

IF _IsAdmin = TRUE THEN
	RETURN QUERY
	SELECT * FROM (
	SELECT SG.ShareGroupNo AS Id,
	ShareGroupName AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE(SG.ShareGroupName::json->>contacts_getsharegroup._langcode,SG.ShareGroupName::json->>'KO') ELSE SG.ShareGroupName END,'') AS Name ,
	ParentNo ,
	COALESCE(SU.ShareNumber,0) AS ShareNumber,
	SG.Sort
	FROM  Contact_ShareGroup SG
	LEFT JOIN  ( SELECT ShareGroupNo, Count(ShareGroupNo) AS ShareNumber
				FROM Contact_ShareGroupUser S
				INNER JOIN ContactsUser U ON U.Seq=S.UserSeq AND U.UseYn='Y'
				WHERE S.IsDelete= FALSE
				GROUP BY S.ShareGroupNo) SU ON SU.ShareGroupNo = SG.ShareGroupNo
	WHERE SG.IsDelete= FALSE
	UNION ALL
	SELECT 0 AS Id,'' as JsonName,'' AS Name,-1 AS ParentNo,(SELECT Count(*)
				FROM ContactsUser U
				LEFT OUTER JOIN  Contact_ShareGroupUser S   ON U.Seq=S.UserSeq AND S.IsDelete= FALSE
				WHERE  U.UseYn='Y'  AND SUBSTRING(U.Share,1,3)='200') AS ShareNumber,
				0 AS Sort

	) T
	ORDER BY  T.ParentNo, T.Sort;
ELSE
	RETURN QUERY
	WITH RECURSIVE DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Contact_DepartAllowAccess BD
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE  OB.UserNo=contacts_getsharegroup._userno AND OB.IsDefault= TRUE
	),SHARE AS (
		SELECT S.Seq FROM ContactsSharers S
		INNER JOIN Organization_BelongToDepartment D ON D.DepartNo=S.DepartNo
		WHERE  D.UserNo=contacts_getsharegroup._userno
	)
	SELECT COALESCE(SG.ShareGroupNo,0) AS Id,
	COALESCE(ShareGroupName,'') AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE(SG.ShareGroupName::json->>contacts_getsharegroup._langcode,SG.ShareGroupName::json->>'KO') ELSE SG.ShareGroupName END,'') AS Name ,
	COALESCE(ParentNo,-1) AS ParentNo,
	COALESCE(SU.ShareNumber,0) AS ShareNumber
	FROM DEPARTPERMISSION D
	LEFT JOIN Contact_ShareGroup SG   ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE
	LEFT JOIN  ( SELECT ShareGroupNo, Count(ShareGroupNo) AS ShareNumber
				FROM Contact_ShareGroupUser SG
				INNER JOIN ContactsUser U ON U.Seq=SG.UserSeq AND U.UseYn='Y'
				INNER JOIN SHARE CS ON CS.Seq=U.Seq
				WHERE SG.IsDelete= FALSE
				GROUP BY SG.ShareGroupNo
				--UNION
				--SELECT 0 AS ShareGroupNo,
				--(SELECT COUNT (*)FROM ContactsUser U
				--LEFT OUTER JOIN Contact_ShareGroupUser S  ON U.Seq=S.UserSeq AND  S.IsDelete= FALSE
				--INNER JOIN SHARE CS ON CS.Seq=U.Seq
				--WHERE SUBSTRING(U.Share,1,3)='200'  AND U.UseYn='Y') AS ShareNumber
				) SU ON SU.ShareGroupNo =D.ItemNo
	WHERE   D.AllowValue>0
	ORDER BY  SG.ParentNo, SG.Sort;
END IF;
END;
$function$

```
</details>

## `contacts_getsharegroupbyuser`

- Input: `0::integer, false, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getsharegroupbyuser"(0::integer, false, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getsharegroupbyuser(integer,boolean,character varying) line 17 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getsharegroupbyuser(_userno integer DEFAULT 70, _isadmin boolean DEFAULT true, _langcode character varying DEFAULT 'KO'::character varying)
 RETURNS TABLE(id integer, jsonname text, name text, parentno integer, sort integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

IF _IsAdmin = TRUE THEN
	RETURN QUERY
	SELECT * FROM (SELECT SG.ShareGroupNo AS Id,
	ShareGroupName AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE(SG.ShareGroupName::json->>contacts_getsharegroupbyuser._langcode,SG.ShareGroupName::json->>'KO') ELSE SG.ShareGroupName END,'') AS Name ,
	ParentNo ,Sort
	FROM  Contact_ShareGroup SG
	WHERE SG.IsDelete= FALSE
	UNION ALL
	SELECT 0 AS Id,'' as JsonName,'' AS Name,-1 AS ParentNo,0 AS Sort) T
	ORDER BY  T.ParentNo, T.Sort;
ELSE
	RETURN QUERY
	WITH RECURSIVE DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Contact_DepartAllowAccess BD
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE  OB.UserNo=contacts_getsharegroupbyuser._userno AND OB.IsDefault= TRUE
	)
	SELECT SG.ShareGroupNo AS Id,
	COALESCE(ShareGroupName,'') AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE(SG.ShareGroupName::json->>contacts_getsharegroupbyuser._langcode,SG.ShareGroupName::json->>'KO') ELSE SG.ShareGroupName END,'') AS Name ,
	COALESCE(ParentNo,-1) AS ParentNo
	FROM DEPARTPERMISSION D
	LEFT JOIN Contact_ShareGroup SG   ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE
	--FROM  Contact_ShareGroup SG
	--INNER JOIN DEPARTPERMISSION D ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE
	 WHERE   D.AllowValue>4
	ORDER BY  SG.ParentNo, SG.Sort;
END IF;
END;
$function$

```
</details>

## `contacts_gettrashuserlist`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_gettrashuserlist"(0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_gettrashuserlist(integer,integer,integer,character varying,integer,character varying) line 6 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_gettrashuserlist(_userno integer DEFAULT 70, _viewcount integer DEFAULT 20, _currentpageindex integer DEFAULT 1, _sortcolumn character varying DEFAULT 'ASC_NAME'::character varying, _serchtype integer DEFAULT 0, _serchtext character varying DEFAULT ''::character varying)
 RETURNS TABLE(totalcnt integer, rownum bigint, seq integer, company character varying, depart character varying, "position" character varying, firstname character varying, lastname character varying, email character varying, number character varying, deldate timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


RETURN QUERY
SELECT --MAX(T.RowNum) TotalCnt
	  T.*
FROM(
		select
			COUNT(*) OVER() AS TotalCnt
			,ROW_NUMBER() OVER (ORDER BY
				CASE WHEN _SortColumn='ASC_NAME'  THEN LastName END ASC,
				CASE WHEN _SortColumn='DESC_NAME'  THEN LastName END DESC,
				CASE WHEN _SortColumn='ASC_NAME'  THEN FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN Depart END DESC,
				CASE WHEN _SortColumn='ASC_DELDATE' THEN DelDate END ASC,
				CASE WHEN _SortColumn='DESC_DELDATE' THEN DelDate END DESC
			) AS RowNum
			,U.Seq
			,C.Company
			,C.Depart
			,C.Position
			,U.FirstName
			,U.LastName
			,max(E.Value) Email
			,max(N.Value) Number
			,U.DelDate
 from ContactsUser U
 left JOIN ContactsCompany C ON C.UserSeq = U.Seq -- AND C.IsDefault = TRUE
 left join ContactsEmail  E ON E.UserSeq=U.Seq -- AND E.IsDefault = TRUE
 left join ContactsNumber N ON N.UserSeq=U.Seq
 WHERE U.RegUserNo = contacts_gettrashuserlist._userno AND U.UseYn = ''
 AND
	 (( _SerchType = 0
		AND ( U.FirstName ILIKE '%' || _SerchText || '%' OR U.LastName ILIKE '%' || _SerchText || '%' OR U.CallName ILIKE '%' || _SerchText || '%')
	 )
	or ( _SerchType = 1
		AND N.Value ILIKE '%' || _SerchText || '%'
	)
	or ( _SerchType = 2
		AND E.Value ILIKE '%' || _SerchText || '%'
	)
	or ( _SerchType = 3
		AND (C.Company ILIKE '%' || _SerchText || '%')
	)
	or ( _SerchType = 4
		AND (C.Depart ILIKE '%' || _SerchText || '%')
	)
	or ( _SerchType = 5
		AND (C.Position ILIKE '%' || _SerchText || '%')
	))
	group by U.Seq,C.Company,C.Position,LastName, FirstName, Company, Depart, DelDate
) T
 WHERE T.RowNum BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1 AND _CurrentPageIndex * _ViewCount
ORDER BY T.RowNum;
END;
$function$

```
</details>

## `contacts_getuser`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_getuser(integer,integer,integer,integer,character varying,integer,character varying,character varying) line 6 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser(_userno integer DEFAULT 70, _groupno integer DEFAULT 0, _currentpageindex integer DEFAULT 1, _pagesize integer DEFAULT 20, _sortcolumn character varying DEFAULT ''::character varying, _serchtype integer DEFAULT 0, _serchtext character varying DEFAULT ''::character varying, _initial character varying DEFAULT ''::character varying)
 RETURNS TABLE(totalcount integer, rownum integer, company character varying, depart character varying, "position" character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, isdefault character, fullname character varying, cellphone character varying, companyphone character varying, faxphone character varying, email character varying, regusername character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

IF _GroupNo=0 THEN
        RETURN QUERY
        WITH PhoneNumbers AS (
			SELECT CT.UserSeq,CT.Value ,CT.Type ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT
		),
	    GroupUsers AS(
			SELECT GU.UserSeq,GU.GroupNo,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU
		),
	    ContactsEmails AS(SELECT   CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
		ContactsCompanys AS(SELECT  C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
        SELECT  * FROM (
			SELECT
			CAST(COUNT(*) OVER() as INT) AS TotalCount,
			CAST(ROW_NUMBER() OVER (
				ORDER BY
				CASE WHEN _SortColumn='' THEN U.Important END DESC,
				CASE WHEN _SortColumn='' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_IMPORTANT' THEN U.Important END ASC,
				CASE WHEN _SortColumn='DESC_IMPORTANT' THEN U.Important END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC

			) as INT ) AS RowNum,
			COALESCE(C.Company,'') as Company,
			COALESCE(C.Depart,'') as Depart,
			COALESCE(C.Position,'') as Position,
			U.Seq,
			U.FirstName,
			U.LastName,
			U.RegUserNo,
			U.Memo,U.RegDate,COALESCE(U.Photo,'') AS Photo,U.ModDate,U.CheckDate,U.Share,U.UseYn,
			U.DelDate,U.Important,U.CallName,G.IsDefault,U.LastName || ' ' || U.FirstName AS FullName,
			N0.Value AS CellPhone,N2.Value AS CompanyPhone, N3.Value AS FaxPhone,
			E.Value AS Email,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN PhoneNumbers  N3 ON N3.Type=3 AND N3.UserSeq=U.Seq AND N3.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
			LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE (U.RegUserNo = contacts_getuser._userno
				OR (U.Share='300'  AND U.RegUserNo <> contacts_getuser._userno)
				OR (SUBSTRING(U.Share,1,3)='200' AND U.RegUserNo IN (SELECT UserNo
																	 FROM Organization_BelongToDepartment
																     WHERE DepartNo IN (SELECT DepartNo
																						FROM Organization_BelongToDepartment
																						WHERE UserNo = contacts_getuser._userno)
																	)
												 AND (U.Seq IN (select C.Seq
																from ContactsSharers  C
																INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getuser._userno))
																	)) --and (U.Seq IN (select C.Seq from ContactsSharers  C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = UserNo))))
			AND U.UseYn = 'Y'
			AND (_serchtext=''
					OR (_serchtext !='' AND (
						U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR N0.Value ILIKE '%' || _SerchText || '%'
						OR N2.Value ILIKE '%' || _SerchText || '%'
						OR N3.Value ILIKE '%' || _SerchText || '%'
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.GroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.GroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
			)
			AND (_Initial=''
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
				)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _PageSize) + 1
			AND _CurrentPageIndex * _PageSize
			ORDER BY T.RowNum;
ELSE
	RETURN QUERY
	WITH PhoneNumbers AS (	SELECT CT.UserSeq,CT.Value ,CT.Type ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm FROM ContactsNumber CT  ),
		GroupUsers AS(SELECT GU.UserSeq,GU.GroupNo,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU),
		ContactsEmails AS(SELECT  CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
		ContactsCompanys AS(SELECT  C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
	SELECT * FROM (SELECT
		CAST(COUNT(*) OVER() AS INT) AS TotalCount,
		CAST( ROW_NUMBER() OVER (
		ORDER BY
			CASE WHEN _SortColumn='' THEN U.Important END DESC,
			CASE WHEN _SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
			CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName  END DESC,
			CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
			CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
			CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
			CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
			CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum,
		COALESCE(C.Company,'') AS Company,
		COALESCE(C.Depart,'')  AS Depart,
		COALESCE(C.Position,'') AS Position,
		U.Seq,
		U.FirstName,U.LastName,U.RegUserNo,U.Memo,U.RegDate,COALESCE(U.Photo,'') AS Photo,
		U.ModDate,
		U.CheckDate,
		U.Share,
		U.UseYn,
		U.DelDate,
		U.Important,
		U.CallName,
		CAST('0' AS char) AS IsDefault,
		U.LastName || ' ' || U.FirstName AS FullName,
		N0.Value AS CellPhone,
		N2.Value AS CompanyPhone,
		N3.Value AS FaxPhone,
		E.Value AS Email,
		OU.Name AS RegUserName
	FROM ContactsUser U
	LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
	LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
	LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
	LEFT JOIN PhoneNumbers  N3 ON N3.Type=3 AND N3.UserSeq=U.Seq AND N3.Nm=1
	LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
	INNER JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
	LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
	LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND   OU.UserNo=U.RegUserNo
	WHERE  GU.GroupNo IN (select * from Contacts_GetChildGroupByGroupNo(_GroupNo))
	AND U.UseYn = 'Y'
	AND (_Initial='' OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE _Initial || '%')
		AND (_serchtext=''
		OR (_serchtext !='' AND
			(_SerchType = 0 AND
				(U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
				OR N0.Value ILIKE '%' || _SerchText || '%'
				OR N2.Value ILIKE '%' || _SerchText || '%'
				OR N3.Value ILIKE '%' || _SerchText || '%'
				OR C.Company ILIKE '%' || _SerchText || '%'
				OR C.Depart ILIKE '%' || _SerchText || '%'
				OR C.Position ILIKE '%' || _SerchText || '%'
				OR E.Value ILIKE '%' || _SerchText || '%'
				OR G.GroupName ILIKE '%' || _SerchText || '%'
				OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
			OR (_SerchType = 1 AND (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%'))
			OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
			OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
			OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
			OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
			OR (_SerchType = 6 AND G.GroupName ILIKE '%' || _SerchText || '%')
			OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
		  	))
	) T
	WHERE T.RowNum
	BETWEEN ((_CurrentPageIndex - 1) * _PageSize) + 1
	AND _CurrentPageIndex * _PageSize
	ORDER BY T.RowNum;

END IF;
END;
$function$

```
</details>

## `contacts_getuser_department`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_department"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function organization_getdepartmentsbyuser(integer) does not exist
- Stack context: PL/pgSQL function contacts_getuser_department(integer,integer,integer,integer,character varying,character varying,integer,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_department(_userno integer DEFAULT 70, _groupno integer DEFAULT 16, _viewcount integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _initial character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _serchtype integer DEFAULT NULL::integer, _serchtext character varying DEFAULT ''::character varying)
 RETURNS TABLE(totalcount integer, rownum integer, company character varying, depart character varying, "position" character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, isdefault integer, fullname character varying, cellphone character varying, companyphone character varying, email character varying, regusername character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH PhoneNumbers AS (
			SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT
		),GroupUsers AS(
			SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU
		),
		ContactsEmails AS(
			SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE
		),
		ContactsCompanys AS(
			SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C
		)
		SELECT * FROM (SELECT
		CAST(COUNT(*) OVER() AS INT) AS TotalCount
		,CAST( ROW_NUMBER() OVER (
		ORDER BY
			CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq  AND E.Nm=1
			LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE ((U.RegUserNo=contacts_getuser_department._userno AND SUBSTRING(U.Share,1,3)='200') or (SUBSTRING(U.Share,1,3)='200'
			AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_GetDepartmentsByUser(_UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND U.UseYn = 'Y'
			AND (_serchtext=''
				OR ( _serchtext !='' AND
				  (	   (_SerchType = 0 AND
						(U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.GroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.GroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
				  )

				)

			    )
			AND (_Initial=''
				OR U.LastName || ' ' || U.FirstName ILIKE '%' || _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
			)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
END;
$function$

```
</details>

## `contacts_getuser_share`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_share"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_getuser_share(integer,integer,integer,integer,character varying,character varying,integer,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_share(_userno integer DEFAULT 70, _groupno integer DEFAULT 0, _viewcount integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _initial character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT 'DESC_RegDate'::character varying, _serchtype integer DEFAULT 0, _serchtext character varying DEFAULT ''::character varying)
 RETURNS TABLE(totalcount integer, rownum integer, company character varying, depart character varying, "position" character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, isdefault integer, fullname character varying, cellphone character varying, companyphone character varying, email character varying, regusername character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

			RETURN QUERY
			WITH PhoneNumbers AS (SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm FROM ContactsNumber CT ),
			GroupUsers AS(SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU),
			ContactsEmails AS(SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
			ContactsCompanys AS(SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS INT) AS TotalCount
			,CAST( ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_IMPORTANT' THEN U.Important END ASC,
				CASE WHEN _SortColumn='DESC_IMPORTANT' THEN U.Important END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS INT) RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND  C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
			LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE (SUBSTRING(U.Share,1,3)='300')
			AND U.UseYn = 'Y'
			AND (_serchtext=''
					OR (_serchtext !='' AND (
						U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR N0.Value ILIKE '%' || _SerchText || '%'
						OR N2.Value ILIKE '%' || _SerchText || '%'
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.GroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.GroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
			)
			AND (_Initial=''
				OR U.LastName || ' ' || U.FirstName ILIKE '%' || _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
				)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
END;
$function$

```
</details>

## `contacts_getuser_togroupmobile`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_togroupmobile"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character = boolean
- Stack context: PL/pgSQL function contacts_getuser_togroupmobile(integer,integer,integer,character varying,character varying,character varying,integer,character varying) line 14 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_togroupmobile(_groupno integer, _viewcount integer, _currentpageindex integer, _initial character varying, _sortcolumn character varying, _textsearch character varying, _userno integer DEFAULT 10, _isdefault character varying DEFAULT '1'::character varying)
 RETURNS TABLE(seq integer, firstname character varying, lastname character varying, email character varying, photo character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
    _topgroupno integer;
BEGIN

	--전체그룹인지 체크 합니다.;

	SELECT GroupNo INTO _topgroupno FROM ContactsGroup WHERE ParentGNo=0 and RegUserNo=contacts_getuser_togroupmobile._userno AND IsDefault='1';

	-- 전체 그룹이라면
	IF _TopGroupNo = contacts_getuser_togroupmobile._groupno OR _GroupNo=0 OR _GroupNo=-1 THEN
		IF _TextSearch='' THEN
			RETURN QUERY
			SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
			SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,gg.IsDefault
			,E.Value as email

			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

			left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
			left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroupmobile._userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
			WHERE
			(U.RegUserNo = contacts_getuser_togroupmobile._userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."organization_getdepartmentsbyuser"(_UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND
			 U.UseYn = 'Y'
			AND PATINDEX( '%' || public."uf_regularextext"(_Initial) || '%' , U.LastName+U.FirstName) > 0
			--AND gg.IsDefault=sDefault

			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;

		ELSE
			 RETURN QUERY
			 SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
				SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
					CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
					CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				) AS int) AS RowNum
				,COALESCE(C.Company,'') as Company
				,COALESCE(C.Depart,'') as Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				,gg.IsDefault
				,E.Value as email

				FROM ContactsUser U
				--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

				left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
				LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
				left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
						FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
						where M.RegUserNo=contacts_getuser_togroupmobile._userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
				WHERE
				(U.RegUserNo = contacts_getuser_togroupmobile._userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."organization_getdepartmentsbyuser"(_UserNo) DP ON DP.DepartNo = C.DepartNo))))
				AND
				 U.UseYn = 'Y'
				AND PATINDEX( '%' || public."uf_regularextext"(_Initial) || '%' , U.LastName+U.FirstName) > 0
				--AND gg.IsDefault=sDefault

				) T
				WHERE ((T.FirstName ILIKE '%' || _TextSearch || '%') OR (T.LastName ILIKE '%' || _TextSearch || '%')) AND T.RowNum
				BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
				AND _CurrentPageIndex * _ViewCount;
		 END IF;
END IF;
END;
$function$

```
</details>

## `contacts_getuser_ungroup`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_ungroup"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character = boolean
- Stack context: PL/pgSQL function contacts_getuser_ungroup(integer,integer,integer,character varying,character varying) line 65 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_ungroup(_userno integer, _viewcount integer, _currentpageindex integer, _initial character varying, _sortcolumn character varying)
 RETURNS TABLE(totalcnt integer, rownum integer, company character varying, depart character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


		IF _Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE U.RegUserNo = contacts_getuser_ungroup._userno
			AND U.UseYn = 'Y'
			AND (M.GroupNo is Null OR M.UseYn='F')
			AND PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName+U.FirstName) > 0
			AND PATINDEX(public."uf_regularextext"('ㄱ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄴ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄷ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㄹ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅁ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅂ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅅ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅇ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅈ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅊ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅋ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅌ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅍ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('ㅎ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('A') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."uf_regularextext"('0') || '%' , U.LastName+U.FirstName) = 0
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS int) AS TotalCnt
			,CAST(ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS int) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE U.RegUserNo = contacts_getuser_ungroup._userno
			AND U.UseYn = 'Y'
			AND (M.GroupNo is Null OR M.UseYn='F')
			AND PATINDEX(public."uf_regularextext"(_Initial) || '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
		END IF;
END;
$function$

```
</details>

## `contacts_getuserbypublicgroup`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuserbypublicgroup"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_getuserbypublicgroup(integer,integer,integer,integer,character varying,character varying,integer,character varying) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuserbypublicgroup(_userno integer DEFAULT 70, _groupno integer DEFAULT 8, _viewcount integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _initial character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT 'DESC_RegDate'::character varying, _serchtype integer DEFAULT 0, _serchtext character varying DEFAULT ''::character varying)
 RETURNS TABLE(totalcount integer, rownum integer, company character varying, depart character varying, "position" character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, isdefault integer, fullname character varying, cellphone character varying, companyphone character varying, email character varying, regusername character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

			RETURN QUERY
			WITH PhoneNumbers AS (SELECT CT.UserSeq,CT.Value ,CT.Type  ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm FROM ContactsNumber CT ),
			--GroupUsers AS(SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_PublicGroup GU),
			ContactsEmails AS(SELECT     CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
			ContactsCompanys AS(SELECT      C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
			SELECT * FROM (SELECT
			CAST(COUNT(*) OVER() AS INT) AS TotalCount
			,CAST( ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN _SortColumn='' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_IMPORTANT' THEN U.Important END ASC,
				CASE WHEN _SortColumn='DESC_IMPORTANT' THEN U.Important END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS INT) RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser SG ON SG.UserSeq=U.Seq AND SG.IsDelete= FALSE
			LEFT JOIN Contact_PublicGroup G ON G.PublicGroupNo= SG.PublicGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND  C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
			--LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			--LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE (SUBSTRING(U.Share,1,3)='300')
			AND COALESCE(SG.PublicGroupNo,0)=contacts_getuserbypublicgroup._groupno
			AND U.UseYn = 'Y'
			AND (_serchtext=''
					OR (_serchtext !='' AND (
						U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR N0.Value ILIKE '%' || _SerchText || '%'
						OR N2.Value ILIKE '%' || _SerchText || '%'
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.PublicGroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.PublicGroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
			)
			AND (_Initial=''
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
				)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
END;
$function$

```
</details>

## `contacts_getuserbysharegroup`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying, false`
- Generated SQL: `SELECT * FROM "public"."contacts_getuserbysharegroup"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, 0::integer, ''::character varying, false);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_getuserbysharegroup(integer,integer,integer,integer,character varying,character varying,integer,character varying,boolean) line 109 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuserbysharegroup(_userno integer DEFAULT 70, _groupno integer DEFAULT 0, _viewcount integer DEFAULT 10, _currentpageindex integer DEFAULT 1, _initial character varying DEFAULT ''::character varying, _sortcolumn character varying DEFAULT ''::character varying, _serchtype integer DEFAULT 0, _serchtext character varying DEFAULT ''::character varying, _isadmin boolean DEFAULT true)
 RETURNS TABLE(totalcount integer, rownum integer, company character varying, depart character varying, "position" character varying, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying, isdefault integer, fullname character varying, cellphone character varying, companyphone character varying, email character varying, regusername character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

IF _IsAdmin = TRUE THEN
	RETURN QUERY
	WITH PhoneNumbers AS (
			SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT
		),GroupUsers AS(
			SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.ShareGroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_ShareGroupUser GU WHERE IsDelete= FALSE
		),
		ContactsEmails AS(
			SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE
		),
		ContactsCompanys AS(
			SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C
		)
		SELECT * FROM (SELECT
		CAST(COUNT(*) OVER() AS INT) AS TotalCount
		,CAST( ROW_NUMBER() OVER (
		ORDER BY
		CASE WHEN _SortColumn='' THEN U.Important END DESC,
			CASE WHEN _SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN GroupUsers SG ON SG.UserSeq=U.Seq  AND SG.Nm=1
			LEFT JOIN Contact_ShareGroup G ON G.ShareGroupNo= SG.ShareGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq  AND E.Nm=1

			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE
			--((U.RegUserNo=UserNo AND SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=GroupNo)

			((SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=contacts_getuserbysharegroup._groupno)
			/*OR (SUBSTRING(U.Share,1,3)='200' AND U.Seq IN (select C.Seq
														from ContactsSharers C
														INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=UserNo)
			)*/
			)
			AND U.UseYn = 'Y'
			AND (_serchtext=''
				OR ( _serchtext !='' AND
				  (	   (_SerchType = 0 AND
						(U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.ShareGroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.ShareGroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
				  )

				)

			    )
			AND (_Initial=''
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
			)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;

	ELSE

		RETURN QUERY
		WITH PhoneNumbers AS (
			SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT
		),GroupUsers AS(
			SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.ShareGroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_ShareGroupUser GU WHERE IsDelete= FALSE
		),
		ContactsEmails AS(
			SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE
		),
		ContactsCompanys AS(
			SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C
		),
		DEPARTPERMISSION AS (
			Select ItemNo ,AllowValue,AllowAccessNo
			FROM Contact_DepartAllowAccess BD
			INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
			WHERE  OB.UserNo=contacts_getuserbysharegroup._userno AND OB.IsDefault= TRUE AND _GroupNo=BD.ItemNo
		)
		SELECT * FROM (SELECT
		CAST(COUNT(*) OVER() AS INT) AS TotalCount
		,CAST( ROW_NUMBER() OVER (
		ORDER BY
		CASE WHEN _SortColumn='' THEN U.Important END DESC,
			CASE WHEN _SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN _SortColumn='ASC_NAME' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN _SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN _SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN _SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN _SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN _SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN _SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN GroupUsers SG ON SG.UserSeq=U.Seq
			LEFT JOIN DEPARTPERMISSION P ON P.ItemNo=SG.ShareGroupNo
			LEFT JOIN Contact_ShareGroup G ON G.ShareGroupNo= SG.ShareGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq  AND E.Nm=1
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo

			WHERE
			((U.RegUserNo=contacts_getuserbysharegroup._userno AND SUBSTRING(U.Share,1,3)='200' AND _GroupNo=0)
			--OR (SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=GroupNo AND U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=UserNo))
			/*OR (SUBSTRING(U.Share,1,3)='200' AND (U.RegUserNo IN (SELECT UserNo
															FROM Organization_BelongToDepartment
															WHERE DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo))))
				*/
			OR (SUBSTRING(U.Share,1,3) ='200' AND _GroupNo=SG.ShareGroupNo AND (U.Seq IN (select C.Seq
												from ContactsSharers  C
												INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getuserbysharegroup._userno)))

			)
			AND U.UseYn = 'Y'
			AND (_serchtext=''
				OR ( _serchtext !='' AND
				  (	   (_SerchType = 0 AND
						(U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'
						OR (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%')
						OR C.Company ILIKE '%' || _SerchText || '%'
						OR C.Depart ILIKE '%' || _SerchText || '%'
						OR C.Position ILIKE '%' || _SerchText || '%'
						OR E.Value ILIKE '%' || _SerchText || '%'
						OR G.ShareGroupName ILIKE '%' || _SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 1 AND (N0.Value ILIKE '%' || _SerchText || '%' OR N2.Value ILIKE '%' || _SerchText || '%'))
					OR (_SerchType = 2 AND C.Company ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 3 AND C.Depart ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 4 AND C.Position ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 5 AND E.Value ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 6 AND G.ShareGroupName ILIKE '%' || _SerchText || '%')
					OR (_SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || _SerchText || '%')
				  )

				)

			    )
			AND (_Initial=''
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE _Initial || '%'
				OR _Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
			)
			) T
			WHERE T.RowNum
			BETWEEN ((_CurrentPageIndex - 1) * _ViewCount) + 1
			AND _CurrentPageIndex * _ViewCount;
	END IF;
END;
$function$

```
</details>

## `contacts_getuserdata`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuserdata"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getuserdata(integer,integer,character varying) line 67 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuserdata(_reguserno integer, _userseq integer, _key character varying)
 RETURNS TABLE(value character varying, type smallint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	IF _Key = 'number' THEN
		RETURN QUERY
		SELECT Value, Type FROM ContactsNumber  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'email' THEN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsEmail  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'days' THEN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsDays  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'comp' THEN
		RETURN QUERY
		SELECT Company As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'dept' THEN
		RETURN QUERY
		SELECT Depart As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'position' THEN
		RETURN QUERY
		SELECT Position As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'addr' THEN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address  As Value ,0 AS Type FROM ContactsAddress
        WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'sns' THEN
		RETURN QUERY
		SELECT Value ,0 AS Type FROM ContactsSns  WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND IsDefault='1';

	ELSIF _Key = 'memo' THEN
		RETURN QUERY
		SELECT Memo  As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata._reguserno AND Seq=contacts_getuserdata._userseq;

	ELSIF _Key = 'firstname' THEN
		RETURN QUERY
		SELECT FirstName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata._reguserno AND Seq=contacts_getuserdata._userseq;

	ELSIF _Key = 'lastname' THEN
		RETURN QUERY
		SELECT LastName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata._reguserno AND Seq=contacts_getuserdata._userseq;

	ELSIF _Key = 'callname' THEN
		RETURN QUERY
		SELECT CallName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata._reguserno AND Seq=contacts_getuserdata._userseq;

	ELSIF _Key = 'deldate' THEN
		RETURN QUERY
		SELECT DelDate As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata._reguserno AND Seq=contacts_getuserdata._userseq;
	ELSIF _Key = 'group' THEN
		RETURN QUERY
		SELECT G.GroupName As Value ,0 AS Type
		From ContactsGroupUser GU
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE GU.RegUserNo = contacts_getuserdata._reguserno
		AND GU.UserSeq = contacts_getuserdata._userseq
		ORDER BY G.Sort;
	ELSE
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUser
		WHERE RegUserNo=contacts_getuserdata._reguserno and Seq=contacts_getuserdata._userseq;
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumber
		WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq AND Value != '';
		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmail
		WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq;
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDays
		WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq;
		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompany
		WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq;
		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddress
        WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq;
        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSns
        WHERE RegUserNo=contacts_getuserdata._reguserno AND UserSeq=contacts_getuserdata._userseq;
        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G
        INNER JOIN ContactsGroupUser GU  ON G.GroupNo=GU.GroupNo
        WHERE GU.RegUserNo=contacts_getuserdata._reguserno and UserSeq=contacts_getuserdata._userseq;
	END IF;
END;
$function$

```
</details>

## `contacts_getuserdatahistory`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getuserdatahistory"(0::integer, 0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getuserdatahistory(integer,integer,integer,character varying) line 68 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuserdatahistory(_historyno integer, _reguserno integer, _userseq integer, _key character varying)
 RETURNS TABLE(value character varying, type smallint)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN


	IF _Key = 'number' THEN
		RETURN QUERY
		SELECT Value, Type FROM ContactsNumberHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'email' THEN
		RETURN QUERY
		SELECT Value FROM ContactsEmailHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'days' THEN
		RETURN QUERY
		SELECT Value FROM ContactsDaysHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'comp' THEN
		RETURN QUERY
		SELECT Company FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'dept' THEN
		RETURN QUERY
		SELECT Depart FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'position' THEN
		RETURN QUERY
		SELECT Position FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'addr' THEN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address Address FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq AND IsDefault='1';

	ELSIF _Key = 'sns' THEN
		RETURN QUERY
		SELECT Value FROM ContactsSnsHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq ORDER BY IsDefault DESC, Seq DESC;

	ELSIF _Key = 'memo' THEN
		RETURN QUERY
		SELECT Memo FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND Seq=contacts_getuserdatahistory._userseq;

	ELSIF _Key = 'firstname' THEN
		RETURN QUERY
		SELECT FirstName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND Seq=contacts_getuserdatahistory._userseq;

	ELSIF _Key = 'lastname' THEN
		RETURN QUERY
		SELECT LastName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND Seq=contacts_getuserdatahistory._userseq;

	ELSIF _Key = 'callname' THEN
		RETURN QUERY
		SELECT CallName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND Seq=contacts_getuserdatahistory._userseq;

	ELSIF _Key = 'deldate' THEN
		RETURN QUERY
		SELECT DelDate FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND Seq=contacts_getuserdatahistory._userseq;
	ELSIF _Key = 'group' THEN
		RETURN QUERY
		SELECT G.GroupName
		From ContactsGroupUserHistory GU
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE HistoryNo=contacts_getuserdatahistory._historyno
		AND GU.RegUserNo = contacts_getuserdatahistory._reguserno
		AND GU.UserSeq = contacts_getuserdatahistory._userseq
		ORDER BY G.Sort;
	ELSE
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUserHistory
		WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno and Seq=contacts_getuserdatahistory._userseq;

		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumberHistory
		WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq AND Value != '';

		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmailHistory
		WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq;

		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDaysHistory
		WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq;

		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompanyHistory
		WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq;

		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq;

        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSnsHistory
        WHERE HistoryNo=contacts_getuserdatahistory._historyno AND RegUserNo=contacts_getuserdatahistory._reguserno AND UserSeq=contacts_getuserdatahistory._userseq;

        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G
        INNER JOIN ContactsGroupUserHistory GU ON G.GroupNo=GU.GroupNo
        WHERE HistoryNo=contacts_getuserdatahistory._historyno AND GU.RegUserNo=contacts_getuserdatahistory._reguserno and UserSeq=contacts_getuserdatahistory._userseq;
	END IF;
END;
$function$

```
</details>

## `contacts_getuserdetail`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuserdetail"(0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getuserdetail(integer) line 22 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuserdetail(_userseq integer)
 RETURNS TABLE(seq integer, reguserno integer, userseq integer, type smallint, typename character varying, zipcode1 character varying, zipcode2 character varying, address character varying, isdefault character, regdate timestamp without time zone, moddate timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	-- 주소;
	RETURN QUERY
	SELECT
	Seq,
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
	FROM ContactsAddress WHERE UserSeq = contacts_getuserdetail._userseq;

	-- 회사;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Company,
	Depart,
	Position,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsCompany WHERE UserSeq = contacts_getuserdetail._userseq;

	-- 기념일;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	SolarLunar,
	RegDate,
	ModDate
	FROM ContactsDays WHERE UserSeq = contacts_getuserdetail._userseq;

	-- 이메일;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsEmail WHERE UserSeq = contacts_getuserdetail._userseq;

	-- 그룹;
	RETURN QUERY
	SELECT G.* FROM ContactsGroupUser U
	INNER JOIN ContactsGroup G ON G.GroupNo = U.GroupNo
	WHERE U.UserSeq=contacts_getuserdetail._userseq;

	-- 홈페이지;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsHomepage WHERE UserSeq = contacts_getuserdetail._userseq;

	-- 전화번호;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsNumber WHERE UserSeq = contacts_getuserdetail._userseq;

	-- SNS;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsSns WHERE UserSeq = contacts_getuserdetail._userseq;
END;
$function$

```
</details>

## `contacts_getusergroupbylanguage`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getusergroupbylanguage"(0::integer, ''::character varying);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getusergroupbylanguage(integer,character varying) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getusergroupbylanguage(_reguserno integer DEFAULT 70, _langcode character varying DEFAULT 'EN'::character varying)
 RETURNS TABLE(groupno integer, groupname text, reguserno integer, regdate timestamp without time zone, memo character varying, parentgno integer, sort integer, isdefault character, usercount integer, useyn character)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH RECURSIVE ContactsGroups AS (
		  SELECT CGP.GroupNo,CGP.GroupNo AS RootGourpNo
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y'
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGourpNo
		  FROM ContactsGroup CGC
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y'
	)
	SELECT GroupNo, CASE WHEN STRPOS(GroupName, '{')>0 THEN GroupName::json->>contacts_getusergroupbylanguage._langcode ELSE GroupName END AS  GroupName, RegUserNo, RegDate, Memo, COALESCE(ParentGNo,0) AS ParentGNo, Sort, IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq
		WHERE U.UseYn='Y' AND C.GroupNo IN (SELECT GroupNo FROM ContactsGroups WHERE RootGourpNo=CG.GroupNo)
	) AS UserCount,
	UseYn
	FROM ContactsGroup CG
	WHERE CG.RegUserNo=contacts_getusergroupbylanguage._reguserno AND CG.UseYn='Y'
	ORDER BY CG.Sort;
END;
$function$

```
</details>

## `contacts_getusergroupmobi`

- Input: `0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getusergroupmobi"(0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42804`
- Error: structure of query does not match function result type
- Stack context: PL/pgSQL function contacts_getusergroupmobi(integer,integer,integer,integer) line 5 at RETURN QUERY
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getusergroupmobi(_reguser integer, _groupid integer, _currpage integer DEFAULT 1, _recodperpage integer DEFAULT 20)
 RETURNS TABLE(rownum bigint, userseq integer, counts integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	WITH RECURSIVE s AS (
			SELECT ROW_NUMBER()
				OVER(ORDER BY CG.UserSeq DESC) AS RowNum,CG.UserSeq ,
				(SELECT COUNT(*) FROM ContactsGroupUser CG INNER JOIN ContactsUser CU ON CG.UserSeq=CU.Seq
					WHERE CG.RegUserNo=contacts_getusergroupmobi._reguser
						  AND CG.GroupNo=contacts_getusergroupmobi._groupid
						  AND CU.UseYn='Y') as counts
			FROM ContactsGroupUser CG
			INNER JOIN ContactsUser CU
			ON CG.UserSeq=CU.Seq
			WHERE CG.RegUserNo=contacts_getusergroupmobi._reguser
				  AND CG.GroupNo=contacts_getusergroupmobi._groupid
				  AND CU.UseYn='Y'
		)
		Select * From s
		Where RowNum Between
			(_currPage - 1)*_recodperpage+1
			AND _currPage*_recodperpage;
END;
$function$

```
</details>

## `contacts_getusernumber`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_getusernumber"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: integer = character varying
- Stack context: PL/pgSQL function contacts_getusernumber(integer,character varying) line 4 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getusernumber(_reguserno integer, _userseq character varying)
 RETURNS TABLE(seq integer, reguserno integer, userseq integer, type smallint, typename character varying, value character varying, isdefault character, regdate timestamp without time zone, moddate timestamp without time zone, setcall integer)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN
RETURN QUERY
SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_getusernumber._reguserno AND UserSeq=contacts_getusernumber._userseq;
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
						_TelType := COALESCE(NULLIF((SUBSTRING(_TempTel,0,STRPOS(_TempTel, ',')))::text, '')::integer, 0);
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
						_EmailIsDefault := COALESCE(NULLIF((SUBSTRING(_TempEmail,0,STRPOS(_TempEmail, ',')))::text, '')::integer, 0);
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
						_CompanyIsDefault := COALESCE(NULLIF((SUBSTRING(_TempCompany,0,STRPOS(_TempCompany, ',')))::text, '')::integer, 0);
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
						_AddrIsDefault := COALESCE(NULLIF((SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ',')))::text, '')::integer, 0);
					ELSIF _AddrCnt = 1 THEN
						_AddrType := COALESCE(NULLIF((SUBSTRING(_TempAddr,0,STRPOS(_TempAddr, ',')))::text, '')::integer, 0);
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
						_HomeIsDefault := COALESCE(NULLIF((SUBSTRING(_TempHome,0,STRPOS(_TempHome, ',')))::text, '')::integer, 0);
					ELSIF _HomeCnt = 1 THEN
						_HomeType := COALESCE(NULLIF((SUBSTRING(_TempHome,0,STRPOS(_TempHome, ',')))::text, '')::integer, 0);
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
						_SnsIsDefault := COALESCE(NULLIF((SUBSTRING(_TempSns,0,STRPOS(_TempSns, ',')))::text, '')::integer, 0);
					ELSIF _SnsCnt = 1 THEN
						_SnsType := COALESCE(NULLIF((SUBSTRING(_TempSns,0,STRPOS(_TempSns, ',')))::text, '')::integer, 0);
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
				_GroupNo := COALESCE(NULLIF((SUBSTRING(_GroupInfo,0,STRPOS(_GroupInfo, ',')))::text, '')::integer, 0);
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
						_TelIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempTelUp,0,STRPOS(_TempTelUp, ',')))::text, '')::integer, 0);
					ELSIF _TelCntUp = 1 THEN
						_TelTypeUp := COALESCE(NULLIF((SUBSTRING(_TempTelUp,0,STRPOS(_TempTelUp, ',')))::text, '')::integer, 0);
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
						_EmailIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempEmailUp,0,STRPOS(_TempEmailUp, ',')))::text, '')::integer, 0);
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
						_CompanyIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempCompanyUp,0,STRPOS(_TempCompanyUp, ',')))::text, '')::integer, 0);
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
						_AddrIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ',')))::text, '')::integer, 0);
					ELSIF _AddrCntUp = 1 THEN
						_AddrTypeUp := COALESCE(NULLIF((SUBSTRING(_TempAddrUp,0,STRPOS(_TempAddrUp, ',')))::text, '')::integer, 0);
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
						_HomeIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempHomeUp,0,STRPOS(_TempHomeUp, ',')))::text, '')::integer, 0);
					ELSIF _HomeCntUp = 1 THEN
						_HomeTypeUp := COALESCE(NULLIF((SUBSTRING(_TempHomeUp,0,STRPOS(_TempHomeUp, ',')))::text, '')::integer, 0);
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
						_SnsIsDefaultUp := COALESCE(NULLIF((SUBSTRING(_TempSnsUp,0,STRPOS(_TempSnsUp, ',')))::text, '')::integer, 0);
					ELSIF _SnsCntUp = 1 THEN
						_SnsTypeUp := COALESCE(NULLIF((SUBSTRING(_TempSnsUp,0,STRPOS(_TempSnsUp, ',')))::text, '')::integer, 0);
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
				_GroupNoUp := COALESCE(NULLIF((SUBSTRING(_GroupInfo,0,STRPOS(_GroupInfo, ',')))::text, '')::integer, 0);
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

## `contacts_searchmobi`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_searchmobi"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying + character varying
- Stack context: PL/pgSQL function contacts_searchmobi(integer,character varying,integer) line 5 at RETURN QUERY
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_searchmobi(_userno integer, _serchtext character varying, _type integer)
 RETURNS TABLE(totalcnt integer, rownum integer, seq integer, firstname character varying, lastname character varying, reguserno integer, memo character varying, regdate timestamp without time zone, photo character varying, moddate timestamp without time zone, checkdate timestamp without time zone, share character varying, useyn character varying, deldate timestamp without time zone, important integer, callname character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
BEGIN

	RETURN QUERY
	SELECT * FROM (SELECT
				CAST(COUNT(*) OVER() AS int) AS TotalCnt
				,CAST(ROW_NUMBER() OVER (
				ORDER BY
					U.LastName ASC
				) AS int) AS RowNum
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_searchmobi._userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN ContactsNumber CN ON CN.UserSeq=U.Seq
				WHERE U.Seq IN (SELECT MAX(Seq) FROM ContactsUser WHERE RegUserNo=contacts_searchmobi._userno GROUP BY (FirstName+LastName)) AND
				((U.LastName || ' ' || U.FirstName) ILIKE '%' || _SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || _SerchText || '%' or CN.Value ILIKE '%' || _SerchText || '%')

				GROUP BY
				U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T;
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

