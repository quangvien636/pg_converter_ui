-- ─── FUNCTION: integrated_updateimportant ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_updateimportant(
    integratedno integer,
    important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Integrateds
	SET Important = integrated_updateimportant.important,
	IsImportant= FALSE
	WHERE  IntegratedNo = integrated_updateimportant.integratedno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
