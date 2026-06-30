-- ─── FUNCTION: organization_getduties ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getduties(boolean);
CREATE OR REPLACE FUNCTION public.organization_getduties(
    alsodisabled boolean
) RETURNS TABLE(
    dutyno text,
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
		SELECT D.DutyNo, D.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN, U.Name_CH AS ModUserName_CH, U.Name_JP AS ModUserName_JP, U.Name_VN AS ModUserName_VN,
			D.ModDate, D.Name, D.Name_EN, D.SortNo, D.Enabled,D.Name_CH,D.Name_JP,D.Name_VN
		FROM Organization_Duties D
		LEFT JOIN Organization_Users U ON U.UserNo = D.ModUserNo
		ORDER BY SortNo ASC

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT D.DutyNo, D.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN, U.Name_CH AS ModUserName_CH, U.Name_JP AS ModUserName_JP, U.Name_VN AS ModUserName_VN,
			D.ModDate, D.Name, D.Name_EN, D.SortNo, D.Enabled,D.Name_CH,D.Name_JP,D.Name_VN
		FROM Organization_Duties D
		LEFT JOIN Organization_Users U ON U.UserNo = D.ModUserNo
		WHERE D.Enabled = TRUE
		ORDER BY SortNo ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
