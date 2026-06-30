-- ─── FUNCTION: contacts_getdepartallowaccess ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getdepartallowaccess(character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getdepartallowaccess(
    itemnos character varying DEFAULT '16',
    langcode character varying DEFAULT 'VN'
) RETURNS TABLE(
    allowaccessno serial,
    departno integer,
    allowvalue integer,
    itemno integer,
    moddate timestamp without time zone,
    moduserno integer,
    regdate timestamp without time zone,
    reguserno integer
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT A.AllowAccessNo,A.DepartNo,A.AllowValue,A.ItemNo,
	CASE WHEN LangCode='KO' THEN D.Name ELSE COALESCE(D.Name_EN,D.Name) END AS DepartName,
		CASE WHEN A.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue =2 OR A.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue =4 OR A.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN A.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue=4 OR A.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
	FROM Contact_DepartAllowAccess A
	INNER JOIN Organization_Departments D ON D.DepartNo=A.DepartNo
	WHERE A.ItemNo IN  (SELECT * FROM Contacts_StringToListInt(ItemNos));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
