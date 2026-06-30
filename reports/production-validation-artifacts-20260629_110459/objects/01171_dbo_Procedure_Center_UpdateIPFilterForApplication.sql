-- ─── PROCEDURE→FUNCTION: center_updateipfilterforapplication ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateipfilterforapplication(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilterforapplication(
    IN filterno integer,
    IN clientip character varying,
    IN allow boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_IPFiltersForApplication SET
		ClientIP = center_updateipfilterforapplication.clientip,
		Allow = center_updateipfilterforapplication.allow
	WHERE FilterNo = center_updateipfilterforapplication.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
