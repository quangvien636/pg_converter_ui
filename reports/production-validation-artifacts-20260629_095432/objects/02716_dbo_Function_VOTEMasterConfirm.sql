-- ─── FUNCTION: votemasterconfirm ───────────────────────────────
DROP FUNCTION IF EXISTS public.votemasterconfirm(integer, integer);
CREATE OR REPLACE FUNCTION public.votemasterconfirm(
    id integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEMaster SET IsReg = TRUE, ModDate = NOW(), ModUserNo = votemasterconfirm.userno WHERE ID = votemasterconfirm.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
