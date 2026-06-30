-- ─── FUNCTION: edms_getparentid ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getparentid(integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getparentid(
    id integer,
    divid integer
) RETURNS integer
AS $function$
DECLARE
    parentid integer;
BEGIN



if(Id > 0) begin
	select ParentId = ParentID from EDMSTreeItem where ID = edms_getparentid.id and DivID = edms_getparentid.divid
	if(ParentId>0) begin
		set ReturnResult = ParentId
	end	
end

return ParentId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
