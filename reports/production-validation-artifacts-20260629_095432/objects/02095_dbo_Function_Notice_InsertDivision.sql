-- ─── FUNCTION: notice_insertdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertdivision(integer);
CREATE OR REPLACE FUNCTION public.notice_insertdivision(
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO NoticeDivisions (RegUserNo, RegDate, ModUserNo, ModDate, Name,Sort,Status)
	VALUES (RegUserNo, NOW(), '','', Name,0,1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
