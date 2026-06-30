-- ─── FUNCTION: getdepartmenttop ───────────────────────────────
DROP FUNCTION IF EXISTS public.getdepartmenttop(integer);
CREATE OR REPLACE FUNCTION public.getdepartmenttop(
    departno integer
) RETURNS integer
AS $function$
BEGIN




	
	select parentno=getdepartmenttop.departno
	select parentdepartno=100
	select cnt=100

	WHILE cnt>-1		
	begin
		select parentno=parentno,parentdepartno=getdepartmenttop.departno from Organization_Departments where departno=parentno
		if parentno = 0
		begin
			select cnt=-1
		end
		else
		begin
			select cnt=cnt-1
		end
	end
	return parentdepartno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
