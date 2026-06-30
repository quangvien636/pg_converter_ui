-- ─── PROCEDURE→FUNCTION: worktodo_insertgroupnew ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_insertgroupnew(integer, timestamp without time zone, character varying, integer, integer, timestamp without time zone, character varying, boolean, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_insertgroupnew(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN parentno integer,
    IN repno integer,
    IN enddate timestamp without time zone,
    IN description character varying,
    IN enabled boolean,
    IN startdate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    maxsortno integer;
BEGIN
 

maxSortNo := COALESCE((select max(SortNo) from WorkToDo_Groups where ParentNo=worktodo_insertgroupnew.parentno),0) +1;;
	insert into WorkToDo_Groups values (ModUserNo,ModDate,Name,ParentNo,RepNo,EndDate,Description, maxSortNo+1,Enabled,StartDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
