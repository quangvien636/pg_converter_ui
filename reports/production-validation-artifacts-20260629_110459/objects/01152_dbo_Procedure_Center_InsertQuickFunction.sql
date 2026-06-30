-- ─── PROCEDURE→FUNCTION: center_insertquickfunction ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertquickfunction(integer, integer, character varying, character varying, character varying, character varying, character varying, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertquickfunction(
    IN userno integer,
    IN applicationno integer,
    IN functionid character varying,
    IN iconurl character varying,
    IN name character varying,
    IN description character varying,
    IN url character varying,
    IN ispopup boolean,
    IN popupwidth integer,
    IN popupheight integer
) RETURNS SETOF record
AS $function$
DECLARE
    functionno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_QuickFunctions (UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight)
	VALUES (UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight)


	FunctionNo := lastval();
	RETURN QUERY
	SELECT FunctionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
