-- ─── FUNCTION: board_getteamname ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getteamname(character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getteamname(
    teamno character varying DEFAULT 'O&M',
    companyno character varying DEFAULT 'JN1'
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


SELECT Num = COUNT(*) FROM Board_Contents C
INNER JOIN Board_Boards B ON B.BoardNo=C.BoardNo
Where B.ViewMode=76 And C.BadNo =board_getteamname.teamno AND C.DesignNo=board_getteamname.companyno AND YEAR(C.RegDate) =YEAR(NOW()) AND C.Enabled = TRUE;
RETURN QUERY
SELECT CompanyNo || '-' || CAST(YEAR(NOW()) AS nvarchar) +'-' || TeamNo || '-' || CAST(REPLICATE('0',5-LEN(RTRIM(Num+1))) + RTRIM(Num+1) AS nvarchar);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
