-- ─── FUNCTION: formbuilder_settemplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.formbuilder_settemplate(integer, character varying, text, character varying);
CREATE OR REPLACE FUNCTION public.formbuilder_settemplate(
    eformid integer,
    templatetype character varying,
    content text,
    userid character varying
) RETURNS void
AS $function$
BEGIN


	IF EXISTS(SELECT * FROM EAPPFormTemplate WHERE EFormID = formbuilder_settemplate.eformid AND TemplateType = formbuilder_settemplate.templatetype)
	BEGIN;
		UPDATE EAPPFormTemplate
		SET EFormID = formbuilder_settemplate.eformid
			,TemplateType = formbuilder_settemplate.templatetype
			,Content = formbuilder_settemplate.content
			,ModDate = NOW()
			,ModID = formbuilder_settemplate.userid
			,UseYN = UseYN
		WHERE EFormID = formbuilder_settemplate.eformid AND TemplateType = formbuilder_settemplate.templatetype
	END
	ELSE
	BEGIN;
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
