-- ─── FUNCTION: dday_getallofdays ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getallofdays(integer, bigint, integer, character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.dday_getallofdays(
    userno integer,
    groupno bigint,
    typeno integer,
    searchtext character varying,
    searchtype integer DEFAULT 0,
    isshare boolean DEFAULT TRUE
) RETURNS TABLE(
    dayno text
)
AS $function$
DECLARE
    includedshareddays table (
		dayno		bigint
	);
    includedmanageddays table (
		dayno		bigint
	);
    groupinfoofshareddays table (
		dayno		bigint,
		groupno		bigint
	);
    listofdepartnos table (
			departno	int
		);
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int
		);
BEGIN





	IF (IsShare = TRUE) BEGIN



		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = dday_getallofdays.userno
		)


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)



		WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT DepartNo = DepartNo, ParentNo = ParentNo
			FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo

			WHILE (ParentNo != 0) BEGIN

				SELECT DepartNo = DepartNo, ParentNo = ParentNo FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo

			END

			SET RowIndex = RowIndex + 1

		END

		INSERT INTO IncludedSharedDays
		RETURN QUERY
		SELECT DISTINCT DayNo
		FROM DDay_Sharers
		WHERE (DepartNo IN (SELECT DepartNo FROM ListOfDepartNos) OR UserNo = dday_getallofdays.userno)
			AND DayNo NOT IN (SELECT DayNo FROM DDay_ExcludedSharers WHERE UserNo = dday_getallofdays.userno)

		INSERT INTO IncludedManagedDays
		RETURN QUERY
		SELECT DISTINCT DayNo
		FROM DDay_Managers
		WHERE UserNo = dday_getallofdays.userno

		INSERT INTO GroupInfoOfSharedDays
		RETURN QUERY
		SELECT DayNo, GroupNo
		FROM DDay_GroupInfoOfSharedDays
		WHERE UserNo = dday_getallofdays.userno

	END

	IF (GroupNo = -1) BEGIN

		IF (TypeNo = 0) BEGIN

			IF (SearchText = '') BEGIN

				RETURN QUERY
				SELECT D.DayNo, RegUserNo, ModUserNo, ModDate,
					CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
					TypeNo, RepeatOptions, Title, Content, CanHide,
					COALESCE(R.UserNo, 0) AS DirectorUserNo
				FROM DDay_Days D
				LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
				LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
				WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
					AND TypeNo != 3

			END

			ELSE BEGIN

				RETURN QUERY
				SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
					CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
					TypeNo, RepeatOptions, Title, Content, CanHide,
					COALESCE(R.UserNo, 0) AS DirectorUserNo
				FROM DDay_Days D
				LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
				LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
				left join Organization_Users OU on  OU.UserNo = d.RegUserNo
				left join dday_directors dm ON dm.dayno = d.dayno
				left join Organization_Users OUM on  OUM.UserNo =dm.UserNo
				WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
					AND TypeNo != 3 
					AND ((SearchType=0 AND UPPER(d.title) ILIKE '%' || UPPER(SearchText)+'%')
								OR(SearchType=1 AND UPPER(OU.Name) ILIKE '%' || UPPER(searchtext)+'%' )
								OR(SearchType=2 AND UPPER(OUM.Name) ILIKE '%' || UPPER(SearchText)+'%'))

			END

		END

		ELSE BEGIN

			IF (SearchText = '') BEGIN

				RETURN QUERY
				SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
					CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
					TypeNo, RepeatOptions, Title, Content, CanHide,
					COALESCE(R.UserNo, 0) AS DirectorUserNo
				FROM DDay_Days D
				LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
				LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
				WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
					AND TypeNo = dday_getallofdays.typeno

			END

			ELSE BEGIN

				RETURN QUERY
				SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
					CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
					TypeNo, RepeatOptions, Title, Content, CanHide,
					COALESCE(R.UserNo, 0) AS DirectorUserNo
				FROM DDay_Days D
				LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
				LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
				left join Organization_Users OU on  OU.UserNo = d.RegUserNo
				left join dday_directors dm ON dm.dayno = d.dayno
				left join Organization_Users OUM on  OUM.UserNo =dm.UserNo
				WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
					AND TypeNo = dday_getallofdays.typeno 
					AND ((SearchType=0 AND UPPER(d.title) ILIKE '%' || UPPER(SearchText)+'%')
								OR(SearchType=1 AND UPPER(OU.Name) ILIKE '%' || UPPER(searchtext)+'%' )
								OR(SearchType=2 AND UPPER(OUM.Name) ILIKE '%' || UPPER(SearchText)+'%'))

			END

		END

	END

	ELSE BEGIN

		IF (TypeNo = 0) BEGIN

			IF (SearchText = '') BEGIN

				RETURN QUERY
				SELECT * FROM (
					SELECT D.DayNo, RegUserNo, ModUserNo, ModDate,
						CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
						TypeNo, RepeatOptions, Title, Content, CanHide,
						COALESCE(R.UserNo, 0) AS DirectorUserNo
					FROM DDay_Days D
					LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
					LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
					WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
						AND TypeNo != 3
				) AS T
				WHERE GroupNo = dday_getallofdays.groupno

			END

			ELSE BEGIN

				RETURN QUERY
				SELECT * FROM (
					SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
						CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
						TypeNo, RepeatOptions, Title, Content, CanHide,
						COALESCE(R.UserNo, 0) AS DirectorUserNo
					FROM DDay_Days D
					LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
					LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
					left join Organization_Users OU on  OU.UserNo = d.RegUserNo
					left join dday_directors dm ON dm.dayno = d.dayno
					left join Organization_Users OUM on  OUM.UserNo =dm.UserNo
					WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
						AND TypeNo != 3 
						AND ((SearchType=0 AND UPPER(d.title) ILIKE '%' || UPPER(SearchText)+'%')
								OR(SearchType=1 AND UPPER(OU.Name) ILIKE '%' || UPPER(searchtext)+'%' )
								OR(SearchType=2 AND UPPER(OUM.Name) ILIKE '%' || UPPER(SearchText)+'%'))
				) AS T
				WHERE GroupNo = dday_getallofdays.groupno

			END
		
		END

		ELSE BEGIN

			IF (SearchText = '') BEGIN

				RETURN QUERY
				SELECT * FROM (
					SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
						CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
						TypeNo, RepeatOptions, Title, Content, CanHide,
						COALESCE(R.UserNo, 0) AS DirectorUserNo
					FROM DDay_Days D
					LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
					LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
					left join Organization_Users OU on  OU.UserNo = d.RegUserNo
					left join dday_directors dm ON dm.dayno = d.dayno
					left join Organization_Users OUM on  OUM.UserNo =dm.UserNo
					WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
						AND TypeNo = dday_getallofdays.typeno
				) AS T
				WHERE GroupNo = dday_getallofdays.groupno
			END

			ELSE BEGIN

				RETURN QUERY
				SELECT * FROM (
					SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
						CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(S.GroupNo, 0) END AS GroupNo,
						TypeNo, RepeatOptions, Title, Content, CanHide,
						COALESCE(R.UserNo, 0) AS DirectorUserNo
					FROM DDay_Days D
					LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
					LEFT JOIN GroupInfoOfSharedDays S ON S.DayNo = D.DayNo
					left join Organization_Users OU on  OU.UserNo = d.RegUserNo
					left join dday_directors dm ON dm.dayno = d.dayno
					left join Organization_Users OUM on  OUM.UserNo =dm.UserNo
					WHERE (RegUserNo = dday_getallofdays.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays) OR D.DayNo IN (SELECT DayNo FROM IncludedManagedDays) OR R.UserNo=dday_getallofdays.userno)
						AND TypeNo = dday_getallofdays.typeno 
						AND ((SearchType=0 AND UPPER(d.title) ILIKE '%' || UPPER(SearchText)+'%')
								OR(SearchType=1 AND UPPER(OU.Name) ILIKE '%' || UPPER(searchtext)+'%' )
								OR(SearchType=2 AND UPPER(OUM.Name) ILIKE '%' || UPPER(SearchText)+'%'))
				) AS T
				WHERE GroupNo = dday_getallofdays.groupno

			END

		END

	END

	RETURN QUERY
	SELECT DayNo FROM IncludedManagedDays;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
