-- ─── PROCEDURE→FUNCTION: edms_settreeitemdesc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_settreeitemdesc(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edms_settreeitemdesc(
    IN divid character varying,
    IN desc1 character varying,
    IN desc2 character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


	SELECT COUNT(*) INTO cnt FROM EDMSTreeItemDesc WHERE Id = Id And DivID = edms_settreeitemdesc.divid
    -- INSERT INTO statements for procedure here
	IF CNT > 0 THEN;
		UPDATE EDMSTreeItemDesc 
		Desc1 := edms_settreeitemdesc.desc1,;
			Desc2 = edms_settreeitemdesc.desc2,
			Desc3 = Desc3
		WHERE Id = Id And DivID = edms_settreeitemdesc.divid
	END IF;
	ELSE;
		INSERT INTO EDMSTreeItemDesc
		(Id, DivID, Desc1, Desc2, Desc3)
		VALUES
		(Id, DivId, Desc1, Desc2, Desc3)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
