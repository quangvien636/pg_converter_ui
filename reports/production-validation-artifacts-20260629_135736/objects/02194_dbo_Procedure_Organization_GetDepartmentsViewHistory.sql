-- ─── PROCEDURE→FUNCTION: organization_getdepartmentsviewhistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getdepartmentsviewhistory(boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentsviewhistory(
    IN isdisabled boolean,
    IN currentpage integer,
    IN total integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		IF CurrentPage=1 THEN
			startPos := 1;
		endPos := organization_getdepartmentsviewhistory.total;
	END IF;
	ELSE BEGIN
		startPos := organization_getdepartmentsviewhistory.currentpage*Total;
		endPos := startPos + Total;
	END;
	
	,
		Name_EN nvarchar(200),
		ShortName nvarchar(200),
		SortNo int,
		Enabled int,
		Name_CH nvarchar(200),
		Name_JP nvarchar(200),
		Name_VN nvarchar(200)
	)
	IF IsDisabled = TRUE THEN;
		INSERT INTO Organization_DepartmentsTemp
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY SortNo) AS No,DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		ORDER BY SortNo ASC
	END IF;
	
	ELSE BEGIN;
		INSERT INTO Organization_DepartmentsTemp
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY SortNo) AS No,DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		WHERE Enabled = TRUE
		ORDER BY SortNo ASC
	END;
	
	RETURN QUERY
	SELECT * FROM Organization_DepartmentsTemp T WHERE T.No between startPos and endPos;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
