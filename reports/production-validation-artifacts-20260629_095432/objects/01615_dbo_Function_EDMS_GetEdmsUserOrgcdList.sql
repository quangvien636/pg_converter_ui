-- ─── FUNCTION: edms_getedmsuserorgcdlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getedmsuserorgcdlist(character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getedmsuserorgcdlist(
    langcode character varying,
    orgcd character varying,
    pagesize integer,
    currentpageindex integer
) RETURNS TABLE(
    totalcnt text,
    numrow text,
    userno text,
    moduserno text,
    moddate text,
    userid text,
    usernm text,
    departno text,
    orgnm text,
    grpnm text,
    authoritylevel text
)
AS $function$
DECLARE
    query character varying;
    userno integer;
    groupnm character varying;
BEGIN




	UserId nvarchar(100),
	UserNm nvarchar(100),
	--GrpNm char(1),
	OrgNm nvarchar(100),
	AuthorityLevel nvarchar(100)
	)

	insert into EDMSUSERLIST
	RETURN QUERY
	select	a.UserId	
,		a.Name	as UserNm
,		c.Name as OrgNm		
,		public."EDMSGetAuthorityLevelContents"(d.AuthorityLevel) AS AuthorityLevel
FROM	Organization_Users   A
		left join
  		Organization_BelongToDepartment	b
		on	A.USERNO=b.UserNo
		left JOIN
		Organization_Departments	c
		on	b.DepartNo = c.DepartNo
		left join
		edmsUserEnv d
		on	a.userid = d.userid 
WHERE	c.DepartNo ILIKE Orgcd
and		a.Enabled = '1'




		RowNum			INT IDENTITY,
		UserNo			INT,
		ModUserNo		INT,
		ModDate			DATETIME,
		UserID			VARCHAR(100),
		Name			NVARCHAR(100),
		Name_EN			NVARCHAR(100),		
		DepartNo		INT,
		DepartName		NVARCHAR(100),
		DepartName_EN	NVARCHAR(100),
		DepartSortNo	INT,
		GroupNM NVARCHAR(200)
		--PositionNo		INT,
		--PositionName	NVARCHAR(100),
		--PositionName_EN	NVARCHAR(100),
		--PositionSortNo	INT
		
	)

	


	SET Query = 'SELECT DISTINCT(B.UserNo), U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, 
			D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo, '''' as GroupNM '
			--P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo '
			
		SET Query +=' FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo'
		--INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo'	
	
		SET Query +=' WHERE B.IsDefault = TRUE '	
		if(Orgcd >0) BEGIN 
			SET Query +=' AND  B.DepartNo=' || convert(nvarchar(20),Orgcd)+' '
		END 	
		SET Query +='ORDER BY  U.Name ASC,U.UserId'

		INSERT INTO ListOfUsers
			EXEC SP_EXECUTESQL Query

			



		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM ListOfUsers)

		while RowIndex <=MaxIndex BEGIN

			select UserNo=UserNo from ListOfUsers where RowNum= RowIndex

			exec EDMS_GetGroupNM LangCode,UserNo,0,GroupNM OUTPUT

			if(GroupNM <> '') BEGIN;
				UPDATE ListOfUsers SET GroupNM = GroupNM where UserNo=UserNo and RowNum=RowIndex
			END

			SET RowIndex = RowIndex + 1
		END



		RETURN QUERY
		SELECT * from (
				SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, CONVERT(INT, ROW_NUMBER() OVER (ORDER BY L.RowNum)) as NumRow , L.UserNo
				, L.ModUserNo, L.ModDate
				 , L.UserID, 
				 (case when LangCode='EN' THEN L.Name_EN ELSE L.Name END) as UserNm,
					 L.DepartNo,
					 (case when LangCode='EN' THEN L.DepartName_EN ELSE L.DepartName END)
					  as OrgNm 
					,L.GroupNM as GrpNm
					,E.AuthorityLevel
				FROM  ListOfUsers  L left join EDMSUSERLIST E ON E.UserId=L.UserID) T
				WHERE T.NumRow BETWEEN  CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * PageSize) + 1) AND  CONVERT(NVARCHAR(20), CurrentPageIndex * PageSize);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
