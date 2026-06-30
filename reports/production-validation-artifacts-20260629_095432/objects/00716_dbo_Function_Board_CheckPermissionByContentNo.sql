-- ─── FUNCTION: board_checkpermissionbycontentno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_checkpermissionbycontentno(integer, integer);
CREATE OR REPLACE FUNCTION public.board_checkpermissionbycontentno(
    userno integer DEFAULT 6656,
    contentno integer DEFAULT 5504
) RETURNS TABLE(
    allowvalue text
)
AS $function$
BEGIN

	WITH SHARE AS(
		SELECT U.UserNo ,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_checkpermissionbycontentno.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
	),
	DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_checkpermissionbycontentno.userno AND OB.IsDefault= TRUE
)
	RETURN QUERY
	SELECT COUNT(*) AS AllowValue FROM Board_Contents BC
	INNER JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BB.BoardNo AND ItemType=2 AND UserNo=board_checkpermissionbycontentno.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE  BC.ContentNo= board_checkpermissionbycontentno.contentno AND (BC.RegUserNo=board_checkpermissionbycontentno.userno OR BA.AllowValue=7 OR  D.AllowValue=7 OR  ((BA.AllowAccessNo IS NOT NULL  OR D.AllowAccessNo IS NOT NULL) AND BB.SpecType=0) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  BB.SpecType=1));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
