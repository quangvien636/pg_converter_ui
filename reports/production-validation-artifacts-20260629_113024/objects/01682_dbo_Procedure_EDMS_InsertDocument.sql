-- ─── PROCEDURE→FUNCTION: edms_insertdocument ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_insertdocument(integer, timestamp without time zone, character varying, character varying, character varying, character varying, integer, integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edms_insertdocument(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN regusername character varying,
    IN regpositionname character varying,
    IN regdepartname character varying,
    IN title character varying,
    IN categoryno integer,
    IN publiclevel integer,
    IN securitylevel integer,
    IN retentionperiod integer,
    IN version character varying,
    IN serialnumber character varying
) RETURNS SETOF record
AS $function$
DECLARE
    documentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO EDMS_Documents (
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, CategoryNo, PublicLevel, SecurityLevel, RetentionPeriod, Version, SerialNumber, IsDelete)
	VALUES (
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		Title, CategoryNo, PublicLevel, SecurityLevel, RetentionPeriod, Version, SerialNumber, 0)
		

	DocumentNo := lastval();
	RETURN QUERY
	SELECT DocumentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
