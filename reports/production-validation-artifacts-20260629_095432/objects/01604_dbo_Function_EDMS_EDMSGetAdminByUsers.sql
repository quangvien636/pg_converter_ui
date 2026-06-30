-- ─── FUNCTION: edms_edmsgetadminbyusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_edmsgetadminbyusers();
CREATE OR REPLACE FUNCTION public.edms_edmsgetadminbyusers(
) RETURNS TABLE(
    numrow text,
    userno text,
    userid text,
    usernm text,
    grpnm text,
    orgnm text
)
AS $function$
DECLARE
    query character varying;
    userno integer;
    groupnm character varying;
BEGIN



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
		GroupNM   NVARCHAR(200)		
		
	)


	SET Query = 'SELECT DISTINCT(B.UserNo), U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, 
			D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo, '''' as GroupNM '		
	SET Query +=' FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo '	
SET Query +=' INNER JOIN EDMSUSERENV E ON E.UserID=U.UserID'
			
		SET Query +=' WHERE B.IsDefault = TRUE AND E.ADMINFLAG = ''Y'' '		
		
		--print Query;
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
		select CONVERT(INT, ROW_NUMBER() OVER (ORDER BY RowNum)) as NumRow,UserNo,UserID, (case when LangCode='EN' THEN Name_EN ELSE Name END) as UserNm
		,GroupNM as GrpNm
		,(case when LangCode='EN' THEN DepartName_EN ELSE DepartName END) as OrgNm
		 from ListOfUsers;

	--SELECT	 CONVERT(INT, ROW_NUMBER() OVER (ORDER BY L.RowNum)) as NumRow,L.UserNo,E.UserID,
	--(case when LangCode='EN' THEN L.Name_EN ELSE L.Name END) as UserNm
	--,		L.GroupNM as GrpNm
	--,		L.DepartName_EN as OrgNm
	--FROM EDMSUSERENV E inner join ListOfUsers L On E.UserID=L.UserID
	--WHERE	E.ADMINFLAG = 'Y'
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
