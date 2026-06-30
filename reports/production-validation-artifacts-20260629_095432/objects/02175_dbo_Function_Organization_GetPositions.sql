-- ─── FUNCTION: organization_getpositions ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getpositions(boolean);
CREATE OR REPLACE FUNCTION public.organization_getpositions(
    alsodisabled boolean
) RETURNS TABLE(
    positionno text,
    moduserno text,
    modusername text,
    modusername_en text,
    modusername_ch text,
    modusername_jp text,
    modusername_vn text,
    moddate text,
    name text,
    name_en text,
    sortno text,
    enabled text,
    name_ch text,
    name_jp text,
    name_vn text
)
AS $function$
BEGIN


	IF (AlsoDisabled = 1) BEGIN

		RETURN QUERY
		SELECT P.PositionNo, P.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN,
		U.Name_CH AS ModUserName_CH,U.Name_JP AS ModUserName_JP,U.Name_VN AS ModUserName_VN,
			P.ModDate, P.Name, P.Name_EN, P.SortNo, P.Enabled , P.Name_CH,P.Name_JP,P.Name_VN
		FROM Organization_Positions P
		LEFT JOIN Organization_Users U ON U.UserNo = P.ModUserNo
		ORDER BY SortNo ASC

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT P.PositionNo, P.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN,
		U.Name_CH AS ModUserName_CH,U.Name_JP AS ModUserName_JP,U.Name_VN AS ModUserName_VN,
			P.ModDate, P.Name, P.Name_EN, P.SortNo, P.Enabled, P.Name_CH,P.Name_JP,P.Name_VN
		FROM Organization_Positions P
		LEFT JOIN Organization_Users U ON U.UserNo = P.ModUserNo
		WHERE P.Enabled = TRUE
		ORDER BY SortNo ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
