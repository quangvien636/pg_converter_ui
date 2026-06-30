-- ─── FUNCTION: board_getboardbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getboardbyuserno(integer, boolean, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getboardbyuserno(
    userno integer DEFAULT 6656,
    isdisabled boolean DEFAULT FALSE,
    viewmode integer DEFAULT -1,
    displaytypeno integer DEFAULT -1,
    isadmin boolean DEFAULT FALSE
) RETURNS TABLE(
    contentno text
)
AS $function$
BEGIN

WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getboardbyuserno.userno AND OB.IsDefault= TRUE
)
	RETURN QUERY
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
				B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled,B.ViewMode,B.SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC 
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE 
					And BC.RegUserNo <> board_getboardbyuserno.userno 
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_getboardbyuserno.userno)
					And (IsAdmin = TRUE OR BA.AllowValue=7 OR
					(  (BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_BelongToDepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_getboardbyuserno.userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboardbyuserno.userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getboardbyuserno.userno
			LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
			WHERE (ViewMode=board_getboardbyuserno.viewmode OR ViewMode < 0) And (DisplayTypeNo=board_getboardbyuserno.displaytypeno OR DisplayTypeNo < 0)  AND  B.Enabled = ~IsDisabled  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
			ORDER BY SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
