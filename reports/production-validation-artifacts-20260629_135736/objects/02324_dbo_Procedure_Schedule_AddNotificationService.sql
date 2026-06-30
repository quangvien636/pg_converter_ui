-- ─── PROCEDURE→FUNCTION: schedule_addnotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_addnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_addnotificationservice(
    IN p_cno integer,
    IN p_pcode character varying,
    IN p_connectionkey integer,
    IN p_senduserno integer,
    IN p_recipientuserno character varying,
    IN p_recipientdepartno character varying,
    IN p_startdate date,
    IN p_enddate date,
    IN p_repeattype character varying
) RETURNS SETOF record
AS $function$
DECLARE
    notificationno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State)
	values (p_cNo, p_PCode, p_Connectionkey, p_SendUserNo,p_RecipientUserNo,p_RecipientDepartNo,p_StartDate,p_EndDate,p_RepeatType,p_RepeatOptions,0)
	NotificationNo := (lastval());
	RETURN QUERY
	select NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
