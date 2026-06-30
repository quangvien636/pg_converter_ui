-- ─── FUNCTION: formbuilder_seteditor ───────────────────────────────
DROP FUNCTION IF EXISTS public.formbuilder_seteditor(integer, text);
CREATE OR REPLACE FUNCTION public.formbuilder_seteditor(
    formid integer,
    content text
) RETURNS void
AS $function$
BEGIN


	IF EXISTS(SELECT * FROM EAPPEditorForm WHERE FormID = formbuilder_seteditor.formid)
	BEGIN;
		UPDATE EAPPEditorForm
		   SET Content = formbuilder_seteditor.content
		 WHERE FormID = formbuilder_seteditor.formid
	END
	ELSE
	BEGIN;
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
