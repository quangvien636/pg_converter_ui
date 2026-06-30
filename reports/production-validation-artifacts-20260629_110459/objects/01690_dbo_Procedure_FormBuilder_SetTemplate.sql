-- ─── PROCEDURE→FUNCTION: formbuilder_settemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.formbuilder_settemplate(integer, character varying, text, character varying);
CREATE OR REPLACE FUNCTION public.formbuilder_settemplate(
    IN eformid integer,
    IN templatetype character varying,
    IN content text,
    IN userid character varying
) RETURNS void
AS $function$
BEGIN


	IF EXISTS(SELECT * FROM EAPPFormTemplate WHERE EFormID = formbuilder_settemplate.eformid AND TemplateType = formbuilder_settemplate.templatetype)
	BEGIN;
		UPDATE EAPPFormTemplate
		EFormID := formbuilder_settemplate.eformid;
			,TemplateType = formbuilder_settemplate.templatetype
			,Content = formbuilder_settemplate.content
			,ModDate = NOW()
			,ModID = formbuilder_settemplate.userid
			,UseYN = UseYN
		WHERE EFormID = formbuilder_settemplate.eformid AND TemplateType = formbuilder_settemplate.templatetype
	END;
	ELSE;
		INSERT INTO EAPPFormTemplate
				(EFormID
				,TemplateType
				,Content
				,RegDate
				,RegID
				,ModDate
				,ModID
				,UseYN)
			 VALUES
				(EFormID
				,TemplateType
				,Content
				,NOW()
				,UserID
				,NOW()
				,UserID
				,UseYN)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
