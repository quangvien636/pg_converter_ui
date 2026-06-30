-- ─── FUNCTION: quicklink_changeorder ───────────────────────────────
DROP FUNCTION IF EXISTS public.quicklink_changeorder(bigint, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.quicklink_changeorder(
    seq bigint,
    userno integer,
    orderidcurrent integer,
    orderidnew integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    seqcurrent bigint;
    seqnew bigint;
BEGIN


	


	SELECT SeqCurrent = quicklink_changeorder.seq FROM QuickLink WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and OrderId = quicklink_changeorder.orderidcurrent and Seq=quicklink_changeorder.seq
	SELECT SeqNew = quicklink_changeorder.seq FROM QuickLink WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and OrderId = quicklink_changeorder.orderidnew

	IF(SeqCurrent is null OR SeqNew is null) RETURN;

	UPDATE public."QuickLink"
	SET OrderId = quicklink_changeorder.orderidnew
		WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and Seq=SeqCurrent

	UPDATE public."QuickLink"
	SET OrderId = quicklink_changeorder.orderidcurrent
		WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and Seq=SeqNew

	RETURN QUERY
	SELECT 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
