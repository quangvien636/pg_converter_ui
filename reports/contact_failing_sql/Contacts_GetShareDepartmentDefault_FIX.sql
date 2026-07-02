-- Fix for 42804: structure of query does not match function result type
-- DETAIL: Returned type character varying(100) does not match expected type text in column 2.
-- Root cause: RETURNS TABLE declares "Name" as text, but Organization_Departments.name*
-- columns are character varying(100); RETURN QUERY requires an exact type match.
-- Fix: cast the CASE expression result to text.

CREATE OR REPLACE FUNCTION public.contacts_getsharedepartmentdefault(
    userno integer DEFAULT 222,
    langcode text DEFAULT 'KO'::text
) RETURNS TABLE("DepartNo" integer, "Name" text)
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        od.departno,
        (CASE langcode
            WHEN 'EN' THEN COALESCE(od.name_en, od.name)
            WHEN 'VN' THEN COALESCE(od.name_vn, od.name)
            WHEN 'CH' THEN COALESCE(od.name_ch, od.name)
            WHEN 'JP' THEN COALESCE(od.name_jp, od.name)
            ELSE od.name
        END)::text AS "Name"
    FROM contact_departallowaccess da
    INNER JOIN organization_belongtodepartment ob ON ob.departno = da.departno
    INNER JOIN organization_departments od        ON od.departno = ob.departno
    WHERE ob.userno = contacts_getsharedepartmentdefault.userno
    LIMIT 1;
END;
$function$;
