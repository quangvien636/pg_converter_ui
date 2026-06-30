-- ─── FUNCTION: edmsdocumnetcheckout ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsdocumnetcheckout(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsdocumnetcheckout(
    id integer,
    checkoutid character varying
) RETURNS void
AS $function$
DECLARE
    id integer;
BEGIN
/*

	,	FLAG		varchar(1)

SELECT ID			= 27
	,	CHECKOUTID = 'ADMIN'
	,	Flag		= '1'
--*/
begin;
UPDATE	EDMSDOCUMENT
SET		CHECKOUTID = edmsdocumnetcheckout.checkoutid	
,		STATE	= Flag
WHERE	ID		=	edmsdocumnetcheckout.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
