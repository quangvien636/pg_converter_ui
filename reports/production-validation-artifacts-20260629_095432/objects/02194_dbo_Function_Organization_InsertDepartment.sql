-- ─── FUNCTION: organization_insertdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertdepartment(integer, timestamp without time zone, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertdepartment(
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying,
    name_en character varying,
    shortname character varying,
    enabled boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
    departno integer;
BEGIN



	select SortNo = COALESCE(max(SortNo) + 1,1) from Organization_Departments  where  ParentNo = organization_insertdepartment.parentno

	INSERT INTO Organization_Departments (ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled)
	VALUES (ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled)
	

	SET DepartNo = lastval()
	
	RETURN QUERY
	SELECT DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
