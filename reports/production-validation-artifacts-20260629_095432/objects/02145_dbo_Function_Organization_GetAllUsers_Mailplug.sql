-- ─── FUNCTION: organization_getallusers_mailplug ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getallusers_mailplug();
CREATE OR REPLACE FUNCTION public.organization_getallusers_mailplug(
) RETURNS TABLE(
    userid text,
    name text,
    password text,
    departno text,
    positionname text,
    dutyname text,
    enabled text,
    mailaddress text,
    cellphone text,
    companyphone text,
    isdefault text
)
AS $function$
BEGIN


	
		RETURN QUERY
		SELECT 
		U.UserID,
		U.Name,
		U.Password,
		B.DepartNo,
		P.Name AS PositionName,
		COALESCE(DT.Name, '') AS DutyName,
		U.Enabled,
		U.MailAddress,
		U.CellPhone,
		U.CompanyPhone,
		B.IsDefault
		FROM Organization_BelongToDepartment B
		LEFT JOIN Organization_Users U ON U.UserNo = B.UserNo
		JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		where U.UserID is not null
		ORDER BY P.SortNo ASC, U.Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
