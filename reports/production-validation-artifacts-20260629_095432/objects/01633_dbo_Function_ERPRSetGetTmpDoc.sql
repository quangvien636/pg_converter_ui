-- ─── FUNCTION: erprsetgettmpdoc ───────────────────────────────
DROP FUNCTION IF EXISTS public.erprsetgettmpdoc(character varying, integer, character varying, text, integer);
CREATE OR REPLACE FUNCTION public.erprsetgettmpdoc(
    mode character varying,
    erpseq integer DEFAULT NULL,
    erpkeyxml character varying DEFAULT NULL,
    erpdoc text DEFAULT NULL,
    id integer DEFAULT NULL
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
IF Mode='i'
Begin;
	Insert into public."ERPRBrdgEAPP" (ErpKeyXml,ErpDoc) Values(ErpKeyXml,ErpDoc)
	Set ErpSeq=@Identity
End
Else IF Mode='s'
Begin
	RETURN QUERY
	Select ErpKeyXml,ErpDoc From ERPRBrdgEAPP Where ErpSeq=erprsetgettmpdoc.erpseq
End
Else IF Mode='p'
Begin
	Set ErpKeyXml=(Select ErpKey From eappdocument Where ID=erprsetgettmpdoc.id)
End
Else IF Mode='k'
Begin
	Select ErpKeyXml=erprsetgettmpdoc.erpkeyxml From ERPRBrdgEAPP Where ErpSeq=erprsetgettmpdoc.erpseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
