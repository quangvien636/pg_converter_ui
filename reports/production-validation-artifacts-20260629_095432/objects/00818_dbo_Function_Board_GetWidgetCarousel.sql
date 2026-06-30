-- ─── FUNCTION: board_getwidgetcarousel ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getwidgetcarousel(integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getwidgetcarousel(
    userno integer DEFAULT 70,
    curentpage integer DEFAULT 1,
    pagesize integer DEFAULT 10,
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    contentno text,
    url text,
    rn text
)
AS $function$
BEGIN

WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getwidgetcarousel.userno
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getwidgetcarousel.userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getwidgetcarousel.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title,BC.RegDate,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY  BC.RootId  DESC) AS RowNumber
	FROM BOARD_CONTENTS BC
	INNER JOIN Board_NewBoardWidget W ON BC.BoardNo= W.BoardNo AND W.Type=1 AND W.IsDelete = FALSE
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE B.ViewMode=1
	AND BC.Enabled = TRUE 
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getwidgetcarousel.userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) 
RETURN QUERY
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
F.Url AS FileUrl,
REPLACE(REPLACE(F.Url, '/Attach/', '/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl
FROM TMP T  
LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
WHERE   T.RowNumber>(CurentPage-1)*PageSize AND T.RowNumber<=board_getwidgetcarousel.curentpage*PageSize
ORDER BY T.RowNumber;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
