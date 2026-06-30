-- ─── PROCEDURE→FUNCTION: formbuilder_seteditor ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.formbuilder_seteditor(integer, text);
CREATE OR REPLACE FUNCTION public.formbuilder_seteditor(
    IN formid integer,
    IN content text
) RETURNS void
AS $function$
BEGIN


	IF EXISTS(SELECT * FROM EAPPEditorForm WHERE FormID = formbuilder_seteditor.formid)
	BEGIN;
		UPDATE EAPPEditorForm
		   Content := formbuilder_seteditor.content;
		 WHERE FormID = formbuilder_seteditor.formid
	END;
	ELSE;
		INSERT INTO EAPPEditorForm
				   (formid
				   ,Title
				   ,Content
				   ,RegDate)
			 VALUES
				   (FormID
				   ,NULL
				   ,Content
				   ,NOW())
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
