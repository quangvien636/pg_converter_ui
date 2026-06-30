-- ─── FUNCTION: board_gettreesubmenu ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_gettreesubmenu(integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu(
    userno integer DEFAULT 222,
    isadmin boolean DEFAULT FALSE,
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH 

 DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType,ROW_NUMBER() OVER(PARTITION BY ItemNo,UserNo,ItemType  ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_gettreesubmenu.userno AND OB.IsDefault= TRUE
),
History AS (SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder BH WHERE BH.UserNo=board_gettreesubmenu.userno),
PERMISSION AS (
        SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
        FROM (
            SELECT ItemNo, ItemType, AllowValue
            FROM Board_AllowAccess
            WHERE UserNo = board_gettreesubmenu.userno

            UNION ALL

            SELECT ItemNo, ItemType, AllowValue
            FROM DEPARTPERMISSION
            WHERE rn = 1
        ) P
        GROUP BY ItemNo, ItemType
    ),

FOLDER AS (
	SELECT /* TOP 1000 */   BF.FolderNo,
            BF.ParentNo,
            BF.Name,
            BF.SortNo,
            BF.ModUserNo,
            BF.ModDate,
            COALESCE(BH.IsOpen,1) AS IsOpen
	FROM  Board_Folders BF  
	LEFT JOIN PERMISSION BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 --AND BA.UserNo=UserNo
	LEFT JOIN History BH ON  BF.FolderNo=BH.FolderNo AND BH.RowNum=1
	--LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE   BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0-- OR D.AllowValue>0 
	)
	ORDER BY SortNo ASC,FolderNo ASC),
	    CONTENT_COUNT AS (
        SELECT 
            BC.BoardNo,
            COUNT(*) AS CountContent
        FROM Board_Contents BC
        WHERE 
            BC.Enabled = TRUE
            AND BC.RegDate > '2020-12-31'
            AND BC.RegUserNo <> board_gettreesubmenu.userno
            AND NOT EXISTS (
                SELECT 1 
                FROM Board_ViewedLogs BV
                WHERE BV.ContentNo = BC.ContentNo
                  AND BV.UserNo = board_gettreesubmenu.userno
            )
        GROUP BY BC.BoardNo
    ),
BOARD AS (
	SELECT  B.BoardNo,
            B.FolderNo,
            B.Name,
            B.SortNo,
            B.ModUserNo,
            B.ModDate,
            B.ViewMode,
				(SELECT COUNT(*) FROM Board_Contents BC 
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE 
					And BC.RegUserNo <> board_gettreesubmenu.userno 
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_gettreesubmenu.userno)
					And (IsAdmin = TRUE OR BA.AllowValue=7  OR
					(  (BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_BelongToDepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_gettreesubmenu.userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_gettreesubmenu.userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			--INNER JOIN FOLDER F ON F.FolderNo=B.FolderNo
			LEFT JOIN PERMISSION BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2-- AND BA.UserNo=UserNo
			--LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2 AND Rn=1
			WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL )
			--ORDER BY SortNo ASC
),
TREESUB AS
(
    SELECT    	COALESCE(CASE WHEN STRPOS(T.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name)  WHERE NAME=board_gettreesubmenu.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name)  WHERE NAME='KO')) ELSE T.Name END,'') AS Name ,
	T.FolderNo AS No  ,T.ModUserNo,T.ModDate, T.Name AS JsonName, T.ParentNo, T.SortNo,TRUE AS IsFolder ,T.IsOpen , 0 AS CountContent, 0 AS ViewMode
    FROM       FOLDER T
    UNION ALL
	SELECT	COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_gettreesubmenu.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME='KO')) ELSE B.Name END,'') AS Name ,
		B.BoardNo AS No  ,B.ModUserNo,B.ModDate, B.Name AS JsonName, B.FolderNo AS ParentNo, B.SortNo,FALSE AS IsFolder ,FALSE AS IsOpen,B.CountContent,B.ViewMode
	 FROM      BOARD B
)
RETURN QUERY
SELECT F.* --,   ROW_NUMBER() OVER (PARTITION BY No,IsFolder ORDER BY ParentNo ASC, SortNo DESC) AS rn
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
  --SET NOCOUNT ON;

  --  -- 1. Optimized Permission CTE
  --  WITH DEPARTPERMISSION AS (
  --      SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
  --      FROM Board_DepartAllowAccess BD 
  --      INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
  --      WHERE OB.UserNo = UserNo AND OB.IsDefault = TRUE
  --      GROUP BY ItemNo, ItemType
  --  ),

  --  -- 2. History CTE (Get only the latest state)
  --  History AS (
  --      SELECT FolderNo, IsOpen
  --      FROM (
  --          SELECT FolderNo, IsOpen, ROW_NUMBER() OVER (PARTITION BY FolderNo ORDER BY HistoryFolderNo DESC) AS Rn
  --          FROM Board_HistoryFolder 
  --          WHERE UserNo = UserNo
  --      ) H WHERE Rn = 1    ),

  --  -- 3. Content Count logic moved to CTE to prevent RBAR (Row-By-Agonizing-Row) processing
  --  BoardContentCounts AS (
  --      SELECT BC.BoardNo, COUNT(*) AS CountContent
  --      FROM Board_Contents BC
  --      WHERE BC.RegDate > '2020-12-31' 
  --        AND BC.Enabled = TRUE 
  --        AND BC.RegUserNo <> UserNo
  --        AND NOT EXISTS (SELECT 1 FROM Board_ViewedLogs BV WHERE BV.ContentNo = BC.ContentNo AND BV.UserNo = UserNo)
  --        -- Logic for sharing/permissions can be complex; simplified here for aggregation performance
  --      GROUP BY BC.BoardNo
  --  ),

  --  -- 4. Folders Data
  --  FOLDER_DATA AS (
  --      SELECT 
  --          BF.FolderNo, BF.Name, BF.ParentNo, BF.SortNo, BF.ModUserNo, BF.ModDate,
  --          COALESCE(BH.IsOpen, 1) AS IsOpen,
  --          TRUE AS IsFolder,
  --          0 AS CountContent,
  --          0 AS ViewMode
  --      FROM Board_Folders BF
  --      LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = UserNo
  --      LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
  --      LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo
  --      WHERE BF.Enabled = TRUE 
  --        AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
  --  ),

  --  -- 5. Boards Data
  --  BOARD_DATA AS (
  --      SELECT 
  --          B.BoardNo, B.Name, B.FolderNo AS ParentNo, B.SortNo, B.ModUserNo, B.ModDate,
  --          FALSE AS IsOpen,
  --          FALSE AS IsFolder,
  --          COALESCE(BCC.CountContent, 0) AS CountContent,
  --          B.ViewMode
  --      FROM Board_Boards B
  --      LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = UserNo
  --      LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2
  --      LEFT JOIN BoardContentCounts BCC ON BCC.BoardNo = B.BoardNo
  --      WHERE B.Enabled = TRUE 
  --        AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
  --  ),

  --  -- 6. Combine and Parse JSON Names
  --  TREESUB AS (
  --      SELECT * FROM FOLDER_DATA
  --      UNION ALL        SELECT * FROM BOARD_DATA
  --  )
  --  SELECT 
  --      COALESCE(
  --          CASE                 WHEN F.Name ILIKE '{%}' THEN 
  --                  COALESCE(
  --                      (SELECT /* TOP 1 */ StringValue FROM ParseJson(F.Name) WHERE Name = LangCode),
  --                      (SELECT /* TOP 1 */ StringValue FROM ParseJson(F.Name) WHERE Name = 'KO'),
  --                      F.Name
  --                  )
  --              ELSE F.Name 
  --          END, ''
  --      ) AS Name,
  --      F.FolderNo AS No,
  --      F.ModUserNo,
  --      F.ModDate,
  --      F.Name AS JsonName,
  --      F.ParentNo,
  --      F.SortNo,
  --      F.IsFolder,
  --      F.IsOpen,
  --      F.CountContent,
  --      F.ViewMode
  --  FROM TREESUB F
  --  ORDER BY F.ParentNo ASC, F.SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
