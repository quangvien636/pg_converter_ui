-- ─── PROCEDURE→FUNCTION: edmsdocumnetcheckout ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmsdocumnetcheckout(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsdocumnetcheckout(
    IN id integer,
    IN checkoutid character varying
) RETURNS void
AS $function$
DECLARE
    id integer;
BEGIN
/*

	,	FLAG		varchar(1)

ID := (27);
	,	CHECKOUTID = 'ADMIN'
	,	Flag		= '1'
--*/
begin;
UPDATE	EDMSDOCUMENT
CHECKOUTID := edmsdocumnetcheckout.checkoutid;
,		STATE	= Flag
WHERE	ID		=	edmsdocumnetcheckout.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
