-- ─── PROCEDURE→FUNCTION: board_gettreesubmenu_v2_json ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_gettreesubmenu_v2_json(integer, boolean, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu_v2_json(
    IN userno integer DEFAULT 222,
    IN isadmin boolean DEFAULT FALSE,
    IN langcode character varying DEFAULT 'EN',
    IN selectedboardno integer DEFAULT 0,
    IN selectedfolderno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    json character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


DROP TABLE IF EXISTS T;
DROP TABLE IF EXISTS O;
DROP TABLE IF EXISTS BL;

    -- Step 1: Build flat tree data
    CREATE TEMP TABLE T ON COMMIT DROP AS WITH
    DEPARTPERMISSION AS (
        SELECT ItemNo, AllowValue, AllowAccessNo, ItemType,
               ROW_NUMBER() OVER(PARTITION BY ItemNo, UserNo, ItemType ORDER BY ItemNo ASC) AS Rn
        FROM Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE OB.UserNo = board_gettreesubmenu_v2_json.userno AND OB.IsDefault = TRUE
    ),
    History AS (
        SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY BH.UserNo, BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
        FROM Board_HistoryFolder BH WHERE BH.UserNo = board_gettreesubmenu_v2_json.userno
    ),
    FOLDER AS (
        SELECT BF.*, COALESCE(BH.IsOpen, 1) AS IsOpen
        FROM Board_Folders BF
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenu_v2_json.userno
        LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo AND BH.RowNum = 1
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1 AND D.Rn = 1
        WHERE BF.Enabled = TRUE
          AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
    ),
    BOARD AS (
        SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.FolderNo, B.SortNo,
               B.Enabled, B.ViewMode, B.SpecType,
               (SELECT COUNT(*) FROM Board_Contents BC
                WHERE '2020-12-31'::timestamp < BC.RegDate
                  AND BC.BoardNo = B.BoardNo AND BC.Enabled = TRUE
                  AND BC.RegUserNo <> board_gettreesubmenu_v2_json.userno
                  AND BC.ContentNo NOT IN (SELECT BV.ContentNo FROM Board_ViewedLogs BV WHERE BV.UserNo = board_gettreesubmenu_v2_json.userno)
                  AND (IsAdmin = TRUE OR BA.AllowValue = 7 OR D.AllowValue = 7
                       OR ((BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo, 2)) OR B.SpecType = 1)
                           AND (
                               BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1
                                                INNER JOIN public."Organization_BelongToDepartment" DP
                                                ON DP.DepartNo = BS1.DepartNo AND DP.UserNo = board_gettreesubmenu_v2_json.userno)
                               OR BC.ContentNo IN (SELECT BSS1.ContentNo FROM Board_Sharers BSS1
                                                   WHERE BSS1.ContentNo = BC.ContentNo AND BSS1.UserNo = board_gettreesubmenu_v2_json.userno)
                               OR BC.IsShareAll = TRUE
                           )))
               ) AS CountContent
        FROM Board_Boards B
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenu_v2_json.userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2 AND D.Rn = 1
        WHERE B.Enabled = TRUE
          AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
    ),
    TREESUB AS (
        SELECT COALESCE(CASE WHEN STRPOS(F.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = board_gettreesubmenu_v2_json.langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'EN')))
                      ELSE F.Name END, '') AS Name,
               F.FolderNo AS No, F.ModUserNo, F.ModDate, F.Name AS JsonName,
               F.ParentNo, F.SortNo,
               TRUE AS IsFolder, F.IsOpen,
               CAST(0 AS BIGINT) AS CountContent, 0 AS ViewMode
        FROM FOLDER F
        UNION ALL
        SELECT COALESCE(CASE WHEN STRPOS(B.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = board_gettreesubmenu_v2_json.langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'EN')))
                      ELSE B.Name END, '') AS Name,
               B.BoardNo AS No, B.ModUserNo, B.ModDate, B.Name AS JsonName,
               B.FolderNo AS ParentNo, B.SortNo,
               FALSE AS IsFolder, FALSE AS IsOpen,
               CAST(B.CountContent AS BIGINT) AS CountContent, B.ViewMode
        FROM BOARD B
    )
    SELECT Name, No, ModUserNo, JsonName, ParentNo, SortNo,
        IsFolder, IsOpen, CountContent, ViewMode,
        CAST(CASE WHEN IsFolder = TRUE AND No = board_gettreesubmenu_v2_json.selectedfolderno THEN 1
                  WHEN IsFolder = FALSE AND No = board_gettreesubmenu_v2_json.selectedboardno  THEN 1
                  ELSE 0 END AS BIT) AS IsSelected FROM TREESUB;

    -- Step 2: Pre-compute boardlist per folder (separate step â€” SQL 2008 R2 no nested FOR XML);
    RETURN QUERY
    SELECT f.No AS FolderNo,
           STUFF((
               SELECT ',' || CAST(b.No AS text)
               FROM T b
               WHERE b.ParentNo = f.No AND b.IsFolder = FALSE
               ORDER BY b.SortNo DESC
               FOR XML PATH(''), TYPE
           ).value('.', 'text'), 1, 1, '') AS Boardlist
    INTO BL
    FROM T f WHERE f.IsFolder = TRUE;

    -- Step 3: Depth-first ordering
    --         Path component = (10000000 - SortNo) so higher SortNo â†’ smaller value â†’ sorts first
    CREATE TEMP TABLE O ON COMMIT DROP AS WITH RECURSIVE DFS AS (
        SELECT No, IsFolder,
               CAST(RIGHT('0000000' || CAST(10000000 - SortNo AS text), 7) AS text) AS SortPath
        FROM T WHERE ParentNo = 0
        UNION ALL
        SELECT t.No, t.IsFolder,
               d.SortPath || '|' || RIGHT('0000000' || CAST(10000000 - t.SortNo AS text), 7)
        FROM T t INNER JOIN DFS d ON t.ParentNo = d.No AND d.IsFolder = TRUE
    )
    SELECT No, IsFolder, SortPath FROM DFS;

    -- Step 4: Build JSON array using FOR XML PATH (SQL 2008 R2 compatible);


    json := (COALESCE((
SELECT
',' +
'{"id":"' || CASE WHEN t.IsFolder = TRUE THEN 'f' ELSE 'b' END + CAST(t.No AS text) + '",' +
'"parent":"' || CASE WHEN t.ParentNo=0 THEN '#' ELSE 'f' || CAST(t.ParentNo AS text) END || '",' +
'"text":"' || REPLACE(REPLACE(
CASE WHEN t.IsFolder = FALSE AND t.CountContent>0
THEN t.Name || ' <span class=''submenu_board_content_count''>' || CAST(t.CountContent AS text) + '</span>'
ELSE t.Name END,
'\', '\\'), '"', '\"') + '",' +
'"icon":"' || CASE WHEN t.IsFolder = TRUE THEN 'fa fa-folder' ELSE 'fa fa-file-o' END || '",' +
'"li_attr":{"type":"' || CASE WHEN t.IsFolder = TRUE THEN '0' ELSE CAST(t.ViewMode AS text) END || '","RegUserNo":' || CAST(t.ModUserNo AS text) + '},' +
'"data":{'   +
'"title":"' || REPLACE(REPLACE(COALESCE(t.Name,''), '\','\\'), '"','\"') + '",' +
'"boardlist":' || CASE WHEN t.IsFolder = TRUE
THEN '"' || COALESCE(bl.Boardlist, '') + '"'
ELSE 'null' END || ',' +
'"jsonName":"' || REPLACE(REPLACE(COALESCE(t.JsonName,''), '\','\\'), '"','\"') + '"' +
'},' +
'"state":' || CASE WHEN t.IsFolder = TRUE AND NOT EXISTS (SELECT 1 FROM T c WHERE c.ParentNo=t.No)
THEN 'null'
ELSE '{"opened":' || CASE WHEN t.IsFolder = FALSE THEN 'true'
WHEN t.IsOpen = TRUE   THEN 'true'
ELSE 'false' END || ',"disabled":false,"selected":' || CASE WHEN t.IsSelected = TRUE THEN 'true' ELSE 'false' END || '}'
END || '}'
FROM T t
INNER JOIN O o  ON t.No = o.No AND t.IsFolder = o.IsFolder
LEFT  JOIN BL bl ON t.IsFolder = TRUE AND bl.FolderNo = t.No
ORDER BY o.SortPath
FOR XML PATH(''), TYPE
).value('.', 'text'), ''));








































    RETURN QUERY
    SELECT '[' || STUFF(COALESCE(Json, ''), 1, 1, '') + ']' AS JsonData;

    DROP TABLE IF EXISTS T;
    DROP TABLE IF EXISTS O;
    DROP TABLE IF EXISTS BL;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.