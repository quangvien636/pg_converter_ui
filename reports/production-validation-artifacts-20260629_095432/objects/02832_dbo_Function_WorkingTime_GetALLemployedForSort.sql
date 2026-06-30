-- ─── FUNCTION: workingtime_getallemployedforsort ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getallemployedforsort(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getallemployedforsort(
    userno integer,
    usertype integer,
    groupno integer
) RETURNS TABLE(
    userid text,
    name text,
    name_en text,
    userno text,
    mailaddress text,
    photo text,
    userphoto text,
    moduserno text,
    moddate text,
    birthdate text,
    cellphone text,
    sex text,
    companyphone text,
    extensionnumber text,
    possitionname text,
    possitionname_en text,
    rn text,
    departname text,
    departname_en text
)
AS $function$
DECLARE
    tbl table(departno int,parentno int);
BEGIN

	
	


	 IF (UserType <> 1 AND GroupNo = 0) 
	 BEGIN
	   set p_dno = -1;
		with name_tree as 
		(
		   select DepartNo, ParentNo
		   from Organization_Departments
		   where DepartNo in (  select  DepartNo FROM Organization_BelongToDepartment WHERE UserNo = workingtime_getallemployedforsort.userno )
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.ParentNo = p.DepartNo
		) ;
		insert into tbl(DepartNo, ParentNo)
		RETURN QUERY
		select DepartNo, ParentNo
		from name_tree;END
	 else begin
	  set p_dno = workingtime_getallemployedforsort.groupno;;
	  insert into tbl(DepartNo, ParentNo) values(p_dno,0)
	 end;

		WITH ListOfUsers AS(
			SELECT 

				B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
				D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
				P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
				COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo,
				U.BirthDate
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,COALESCE(G.TimeOut,ST2.SettingValue) TimeOut
			FROM (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, max(DutyNo) DutyNo, UserNo 
					from  Organization_BelongToDepartment 
					WHERE (p_dno = 0 OR DepartNo IN (SELECT DepartNo FROM tbl))
					group by UserNo) B
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			JOIN (SELECT u1.UserNo FROM Organization_Users U1
				LEFT JOIN WorkingTime_AllowDevices A
				ON U1.userno = a.userno
				where COALESCE(ContentAllow, 'true') ILIKE '%true%'
			) AL ON U.UserNo = AL.UserNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 2) ST2 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 7) ST3 ON 1 = 1
			--AND B.IsDefault = TRUE ???20230925
	)
	
	RETURN QUERY
	SELECT UserID, Name, Name_EN, UserNo, MailAddress, Photo, UserPhoto, ModUserNo, ModDate, BirthDate,
		CellPhone, 1 AS Sex, CompanyPhone, '' AS ExtensionNumber
		, PositionName AS PossitionName
		, PositionName_EN AS PossitionName_EN
		, 1 AS RN 
		, DepartName
		, DepartName_EN
	FROM ListOfUsers
	ORDER BY Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
