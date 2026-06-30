-- ─── FUNCTION: integrated_deletefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_deletefile(bigint);
CREATE OR REPLACE FUNCTION public.integrated_deletefile(
    fileno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Integrated_Files WHERE FileNo = integrated_deletefile.fileno

END;

--------------/////////////////////
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
