-- ─── FUNCTION: board_getnewboardcontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getnewboardcontent(integer, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.board_getnewboardcontent(
    userno integer DEFAULT 120,
    countperpage integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    languagesign character varying DEFAULT 'KO',
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    boardno text,
    contentno text,
    title text,
    regdate text
)
AS $function$
BEGIN

WITH PERMISSION AS (
	Select * 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getnewboardcontent.userno
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getnewboardcontent.userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),

TMP AS (
	SELECT BC.*,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RegDate DESC) AS RowNumber,
	B.ViewMode AS BoardType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR BC.RegUserNo=board_getnewboardcontent.userno THEN TRUE ELSE FALSE END AS IsDelete 
	FROM BOARD_ContentS BC
	INNER JOIN Board_NewBoardWidget W ON W.BoardNo=BC.BoardNo AND W.Type=3  And W.IsDelete= FALSE
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE 
	BC.Enabled = TRUE 
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getnewboardcontent.userno OR  (P.AllowAccessNo IS NOT NULL AND B.SpecType=0) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))

)
RETURN QUERY
SELECT T.BoardNo,
T.ContentNo ,
T.Title,

T.RegDate
FROM TMP T  
WHERE T.RowNumber>(CurrentPageIndex-1)*CountPerPage AND T.RowNumber<=board_getnewboardcontent.currentpageindex*CountPerPage
ORDER BY T.RootId DESC,T.ContentNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
