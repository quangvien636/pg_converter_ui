-- ─── PROCEDURE→FUNCTION: center_insertnotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice(
    IN companyno integer,
    IN projectcode character varying,
    IN connectionkey integer,
    IN senduserno integer,
    IN recipientuserno character varying,
    IN recipientdepartno character varying,
    IN startdate date,
    IN enddate date,
    IN repeattype character varying
) RETURNS SETOF record
AS $function$
DECLARE
    notificationno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,
		RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions)
	values(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,
		RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions)


	NotificationNo := COALESCE(lastval(), 0);
	RETURN QUERY
	SELECT NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
