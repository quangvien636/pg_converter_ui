-- ─── PROCEDURE→FUNCTION: quicklink_addnew ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.quicklink_addnew(character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.quicklink_addnew(
    IN title character varying,
    IN url character varying,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	OrderId := (COALESCE(MAX(OrderId), 0)+1 from QuickLink WHERE UserNo=quicklink_addnew.userno and IsActive = TRUE);;
	INSERT INTO public."QuickLink"
           (Title
           ,Url
           ,UserNo
		   ,OrderId
           ,RegDate
		   ,IsActive)
     VALUES
           (Title ,Url ,UserNo ,OrderId ,NOW() ,1)

	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE UserNo=quicklink_addnew.userno and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
