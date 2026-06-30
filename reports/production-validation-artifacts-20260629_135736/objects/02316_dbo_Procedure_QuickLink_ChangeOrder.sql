-- ─── PROCEDURE→FUNCTION: quicklink_changeorder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.quicklink_changeorder(bigint, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.quicklink_changeorder(
    IN seq bigint,
    IN userno integer,
    IN orderidcurrent integer,
    IN orderidnew integer
) RETURNS SETOF record
AS $function$
DECLARE
    seqcurrent bigint;
    seqnew bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	


	SELECT Seq INTO seqcurrent FROM QuickLink WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and OrderId = quicklink_changeorder.orderidcurrent and Seq=quicklink_changeorder.seq
	SELECT Seq INTO seqnew FROM QuickLink WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and OrderId = quicklink_changeorder.orderidnew

	IF(SeqCurrent is null OR SeqNew is null) RETURN;

	UPDATE public."QuickLink"
	OrderId := quicklink_changeorder.orderidnew;
		WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and Seq=SeqCurrent

	UPDATE public."QuickLink"
	OrderId := quicklink_changeorder.orderidcurrent;
		WHERE UserNo=quicklink_changeorder.userno and IsActive = TRUE and Seq=SeqNew

	RETURN QUERY
	SELECT 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
