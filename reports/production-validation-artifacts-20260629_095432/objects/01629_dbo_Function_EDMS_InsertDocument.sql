-- ─── FUNCTION: edms_insertdocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_insertdocument(integer, timestamp without time zone, character varying, character varying, character varying, character varying, integer, integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edms_insertdocument(
    reguserno integer,
    regdate timestamp without time zone,
    regusername character varying,
    regpositionname character varying,
    regdepartname character varying,
    title character varying,
    categoryno integer,
    publiclevel integer,
    securitylevel integer,
    retentionperiod integer,
    version character varying,
    serialnumber character varying
) RETURNS TABLE(
    documentno text
)
AS $function$
DECLARE
    documentno bigint;
BEGIN


	INSERT INTO EDMS_Documents (
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, CategoryNo, PublicLevel, SecurityLevel, RetentionPeriod, Version, SerialNumber, IsDelete)
	VALUES (
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		Title, CategoryNo, PublicLevel, SecurityLevel, RetentionPeriod, Version, SerialNumber, 0)
		

	SET DocumentNo = lastval()
	
	RETURN QUERY
	SELECT DocumentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
