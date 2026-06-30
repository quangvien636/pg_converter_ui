-- ─── PROCEDURE→FUNCTION: formbuilder_gettemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.formbuilder_gettemplate(integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.formbuilder_gettemplate(
    IN currentpage integer,
    IN itemsperpage integer,
    IN templatetype character varying,
    IN formtype character varying,
    IN isusing character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- 조회갯수
	RETURN QUERY
	SELECT Count(*) Cnt
	FROM EAPPForm F 
	JOIN EAPPFormTemplate T ON (F.ID = T.EFormID)
	WHERE F.IsErp = '1' AND F.IsDelete = '0' AND T.TemplateType IN ('H', 'C')
	AND
	(
		CASE
		WHEN TemplateType = '' THEN 1
		WHEN TemplateType <> '' AND T.TemplateType = formbuilder_gettemplate.templatetype THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN IsUsing = '' THEN 1
		WHEN IsUsing <> '' AND F.IsUsing = formbuilder_gettemplate.isusing THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN FormType = '' THEN 1
		WHEN FormType <> '' AND F.FormType = formbuilder_gettemplate.formtype THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN FormName = '' THEN 1
		WHEN FormName <> '' AND F.Name ILIKE '%' || FormName || '%' THEN 1
		ELSE 0 END
	) = 1

	-- 목록
	RETURN QUERY
	SELECT Num, EftID, EFormID, TemplateType, Content, RegDate, RegID, ModDate, ModID, UseYN, FormType, Name, IsUsing
	FROM
	(
		SELECT ROW_NUMBER() OVER ( ORDER BY F.SeqNo ASC, T.TemplateType DESC ) AS Num,
		T.*, F.FormType, F.Name, F.IsUsing
		FROM EAPPForm F 
		JOIN EAPPFormTemplate T ON (F.ID = T.EFormID)
		WHERE F.IsErp = '1' AND F.IsDelete = '0' AND T.TemplateType IN ('H', 'C')
		AND
		(
			CASE
			WHEN TemplateType = '' THEN 1
			WHEN TemplateType <> '' AND T.TemplateType = formbuilder_gettemplate.templatetype THEN 1
			ELSE 0 END
		) = 1
		AND
		(
			CASE
			WHEN IsUsing = '' THEN 1
			WHEN IsUsing <> '' AND F.IsUsing = formbuilder_gettemplate.isusing THEN 1
			ELSE 0 END
		) = 1
		AND
		(
			CASE
			WHEN FormType = '' THEN 1
			WHEN FormType <> '' AND F.FormType = formbuilder_gettemplate.formtype THEN 1
			ELSE 0 END
		) = 1
		AND
		(
			CASE
			WHEN FormName = '' THEN 1
			WHEN FormName <> '' AND F.Name ILIKE '%' || FormName || '%' THEN 1
			ELSE 0 END
		) = 1
	) R
	WHERE R.Num BETWEEN ((CurrentPage - 1) * ItemsPerPage + 1) AND (CurrentPage * ItemsPerPage);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
