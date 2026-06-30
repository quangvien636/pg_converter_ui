-- ─── PROCEDURE→FUNCTION: dday_getgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getgroups(integer);
CREATE OR REPLACE FUNCTION public.dday_getgroups(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*INSERT INTO BelongToDepartments
	RETURN QUERY
	SELECT DepartNo, ParentNo FROM Organization_Departments
	WHERE DepartNo IN (
		SELECT DepartNo FROM Organization_BelongToDepartment
		WHERE UserNo = dday_getgroups.userno
	)


	RowIndex := 1;
	MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);


	WHILE RowIndex <= MaxIndex LOOP

		SELECT DepartNo INTO departno FROM BelongToDepartments
		WHERE RowNum = RowIndex

		INSERT INTO ListOfDepartNos
		RETURN QUERY
		SELECT DepartNo

		WHILE ParentNo != 0 LOOP

			SELECT DepartNo, ParentNo INTO departno, parentno FROM Organization_Departments
			WHERE DepartNo = ParentNo

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo

		END LOOP;

		RowIndex := RowIndex + 1;
	END LOOP;

	INSERT INTO IncludedSharedDays
	RETURN QUERY
	SELECT DISTINCT DayNo
	FROM DDay_Sharers
	WHERE (DepartNo IN (SELECT DepartNo FROM ListOfDepartNos) OR UserNo = dday_getgroups.userno)
		AND DayNo NOT IN (SELECT DayNo FROM DDay_ExcludedSharers WHERE UserNo = dday_getgroups.userno)

	INSERT INTO GroupInfoOfSharedDays
	RETURN QUERY
	SELECT DayNo, GroupNo
	FROM DDay_GroupInfoOfSharedDays
	WHERE UserNo = dday_getgroups.userno*/

	------------------------------------------------------------------------------------------------------

	/*INSERT INTO CountOfGroups
	RETURN QUERY
	SELECT GroupNo, COUNT(*)
	FROM (
		SELECT CASE D.RegUserNo WHEN UserNo THEN D.GroupNo ELSE COALESCE(G.GroupNo, 0) END AS GroupNo
		FROM DDay_Days D
		LEFT JOIN GroupInfoOfSharedDays G ON G.DayNo = D.DayNo
		WHERE D.RegUserNo = dday_getgroups.userno OR D.DayNo IN (SELECT DayNo FROM IncludedSharedDays)
	) AS T
	GROUP BY GroupNo

	RETURN QUERY
	SELECT * FROM (
		SELECT 0 AS GroupNo, NOW() AS ModDate, 0 AS TagNo, '' AS Name,
			COALESCE((SELECT Count FROM CountOfGroups WHERE GroupNo = 0), 0) AS CountOfDays, 0 AS SortNo

		UNION ALL
		SELECT G.GroupNo, G.ModDate, G.TagNo, G.Name, COALESCE(C.Count, 0) AS CountOfDays, G.SortNo
		FROM DDay_Groups G
		LEFT JOIN CountOfGroups C ON C.GroupNo = G.GroupNo
		WHERE UserNo = dday_getgroups.userno
	) AS T
	ORDER BY T.SortNo */
		
	RETURN QUERY
	SELECT * FROM (
		SELECT 0 AS GroupNo, NOW() AS ModDate, 0 AS TagNo, '' AS Name, 0 AS CountOfDays, 0 AS SortNo

		UNION ALL
		SELECT G.GroupNo, G.ModDate, G.TagNo, G.Name, 0 AS CountOfDays, G.SortNo
		FROM DDay_Groups G
		WHERE UserNo = dday_getgroups.userno
	) AS T
	ORDER BY T.SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
