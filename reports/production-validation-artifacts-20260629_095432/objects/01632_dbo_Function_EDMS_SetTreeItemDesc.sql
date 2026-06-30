-- ─── FUNCTION: edms_settreeitemdesc ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_settreeitemdesc(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edms_settreeitemdesc(
    divid character varying,
    desc1 character varying,
    desc2 character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.



	SELECT CNT = COUNT(*) FROM EDMSTreeItemDesc WHERE Id = Id And DivID = edms_settreeitemdesc.divid
    -- INSERT INTO statements for procedure here
	IF CNT > 0
	BEGIN;
		UPDATE EDMSTreeItemDesc 
		SET
			Desc1 = edms_settreeitemdesc.desc1,
			Desc2 = edms_settreeitemdesc.desc2,
			Desc3 = Desc3
		WHERE Id = Id And DivID = edms_settreeitemdesc.divid
	END
	ELSE
	BEGIN;
		INSERT INTO EDMSTreeItemDesc
		(Id, DivID, Desc1, Desc2, Desc3)
		VALUES
		(Id, DivId, Desc1, Desc2, Desc3)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
