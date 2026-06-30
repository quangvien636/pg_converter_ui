-- ─── FUNCTION: board_gettreesubmenutest ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_gettreesubmenutest(integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_gettreesubmenutest(
    userno integer DEFAULT 70,
    isadmin boolean DEFAULT TRUE,
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




    -- 1. Optimized Permission CTE
    WITH DEPARTPERMISSION AS (
        SELECT ItemNo, ItemType, MAX(AllowValue) AS AllowValue
        FROM Board_DepartAllowAccess BD 
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE OB.UserNo = board_gettreesubmenutest.userno AND OB.IsDefault = TRUE
        GROUP BY ItemNo, ItemType
    ),

    -- 2. History CTE (Get only the latest state)
    History AS (
        SELECT FolderNo, IsOpen
        FROM (
            SELECT FolderNo, IsOpen, ROW_NUMBER() OVER (PARTITION BY FolderNo ORDER BY HistoryFolderNo DESC) AS Rn
            FROM Board_HistoryFolder 
            WHERE UserNo = board_gettreesubmenutest.userno
        ) H WHERE Rn = 1    ),

    -- 3. Content Count logic moved to CTE to prevent RBAR (Row-By-Agonizing-Row) processing
    BoardContentCounts AS (
        SELECT BC.BoardNo, COUNT(*) AS CountContent
        FROM Board_Contents BC
        WHERE BC.RegDate > '2020-12-31' 
          AND BC.Enabled = TRUE 
          AND BC.RegUserNo <> board_gettreesubmenutest.userno
          AND NOT EXISTS (SELECT 1 FROM Board_ViewedLogs BV WHERE BV.ContentNo = BC.ContentNo AND BV.UserNo = board_gettreesubmenutest.userno)
          -- Logic for sharing/permissions can be complex; simplified here for aggregation performance
        GROUP BY BC.BoardNo
    ),

    -- 4. Folders Data
    FOLDER_DATA AS (
        SELECT 
            BF.FolderNo, BF.Name, BF.ParentNo, BF.SortNo, BF.ModUserNo, BF.ModDate,
            COALESCE(BH.IsOpen, 1) AS IsOpen,
            TRUE AS IsFolder,
            0 AS CountContent,
            0 AS ViewMode
        FROM Board_Folders BF
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenutest.userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
        LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo
        WHERE BF.Enabled = TRUE 
          AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
    ),

    -- 5. Boards Data
    BOARD_DATA AS (
        SELECT 
            B.BoardNo, B.Name, B.FolderNo AS ParentNo, B.SortNo, B.ModUserNo, B.ModDate,
            FALSE AS IsOpen,
            FALSE AS IsFolder,
            COALESCE(BCC.CountContent, 0) AS CountContent,
            B.ViewMode
        FROM Board_Boards B
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenutest.userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2
        LEFT JOIN BoardContentCounts BCC ON BCC.BoardNo = B.BoardNo
        WHERE B.Enabled = TRUE 
          AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
    ),

    -- 6. Combine and Parse JSON Names
    TREESUB AS (
        SELECT * FROM FOLDER_DATA
        UNION ALL        SELECT * FROM BOARD_DATA
    )
    RETURN QUERY
    SELECT 
        COALESCE(
            CASE                 WHEN F.Name ILIKE '{%}' THEN 
                    COALESCE(
                        (SELECT /* TOP 1 */ StringValue FROM ParseJson(F.Name) WHERE Name = board_gettreesubmenutest.langcode),
                        (SELECT /* TOP 1 */ StringValue FROM ParseJson(F.Name) WHERE Name = 'KO'),
                        F.Name
                    )
                ELSE F.Name 
            END, ''
        ) AS Name,
        F.FolderNo AS No,
        F.ModUserNo,
        F.ModDate,
        F.Name AS JsonName,
        F.ParentNo,
        F.SortNo,
        F.IsFolder,
        F.IsOpen,
        F.CountContent,
        F.ViewMode
    FROM TREESUB F
    ORDER BY F.ParentNo ASC, F.SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
