-- ─── FUNCTION: organization_getdepartmentsviewhistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentsviewhistory(boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentsviewhistory(
    isdisabled boolean,
    currentpage integer,
    total integer
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
AS $function$
BEGIN


		IF CurrentPage=1 BEGIN
			SET startPos = 1;
		SET endPos = organization_getdepartmentsviewhistory.total;
	END
	ELSE BEGIN
		SET startPos = organization_getdepartmentsviewhistory.currentpage*Total;
		SET endPos = startPos + Total;
	END
	

		No int,
		DepartNo int,
		ModUserNo int,
		ModDate DateTime,
		ParentNo int,
		Name nvarchar(200),
		Name_EN nvarchar(200),
		ShortName nvarchar(200),
		SortNo int,
		Enabled int,
		Name_CH nvarchar(200),
		Name_JP nvarchar(200),
		Name_VN nvarchar(200)
	)
	IF IsDisabled = TRUE BEGIN;
		INSERT INTO Organization_DepartmentsTemp
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY SortNo) AS No,DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		ORDER BY SortNo ASC
	END
	
	ELSE BEGIN;
		INSERT INTO Organization_DepartmentsTemp
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY SortNo) AS No,DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		WHERE Enabled = TRUE
		ORDER BY SortNo ASC
	END
	
	RETURN QUERY
	SELECT * FROM Organization_DepartmentsTemp T WHERE T.No between startPos and endPos;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
