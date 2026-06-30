-- ─── FUNCTION: edms_getdocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdocument(bigint);
CREATE OR REPLACE FUNCTION public.edms_getdocument(
    documentno bigint
) RETURNS TABLE(
    reguserno text,
    regdate text,
    regusername text,
    regpositionname text,
    regdepartname text,
    moduserno text,
    moddate text,
    modusername text,
    modpositionname text,
    moddepartname text,
    title text,
    categoryno text,
    publiclevel text,
    securitylevel text,
    retentionperiod text,
    version text,
    serialnumber text,
    isdelete text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, CategoryNo, PublicLevel, SecurityLevel, RetentionPeriod, Version, SerialNumber, IsDelete
	FROM EDMS_Documents
	WHERE DocumentNo = edms_getdocument.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
