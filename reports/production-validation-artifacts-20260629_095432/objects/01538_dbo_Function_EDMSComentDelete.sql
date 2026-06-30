-- ─── FUNCTION: edmscomentdelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmscomentdelete();
CREATE OR REPLACE FUNCTION public.edmscomentdelete(
) RETURNS void
AS $function$
DECLARE
    id integer;
BEGIN
/*	
sp_columns edmscoment

select	Id			=	
--*/

	update	EDMSComent
	set		isDelete	=	'Y'
	where	id		= id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
