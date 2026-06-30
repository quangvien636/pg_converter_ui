-- ─── FUNCTION: noticesyn_insertdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertdivision(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertdivision(
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO NoticeSyn_Divisions (RegUserNo, RegDate, ModUserNo, ModDate, Name,Sort,Status)
	VALUES (RegUserNo, NOW(), '','', Name,0,1)
END;
-----------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
