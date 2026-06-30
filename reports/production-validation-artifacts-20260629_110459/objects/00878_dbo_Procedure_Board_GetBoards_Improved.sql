-- ─── PROCEDURE→FUNCTION: board_getboards_improved ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getboards_improved(integer, boolean, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getboards_improved(
    IN userno integer DEFAULT 70,
    IN isdisabled boolean DEFAULT FALSE,
    IN viewmode integer DEFAULT -1,
    IN displaytypeno integer DEFAULT -1,
    IN isadmin boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


    WITH

    -- ----------------------------------------------------------------
    -- 1 Táº¥t cáº£ phÃ²ng ban cá»§a user â€” gá»“m cáº£ dept cha trong hierarchy
    --     Anchor  : dept trá»±c tiáº¿p tá»« Organization_BelongToDepartment
    --     Recursive: leo ngÆ°á»£c ParentNo Ä‘áº¿n root (ParentNo=0)
    --     Fix v1  : v1 chá»‰ query Organization_BelongToDepartment (dept trá»±c tiáº¿p)
    --               â†’ bá» sÃ³t dept cha â†’ share check sai
    --     Replaces: Organization_GetDepartmentsByUser(UserNo)
    -- ----------------------------------------------------------------
    USER_DEPART AS (
        -- Anchor: dept trá»±c tiáº¿p
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_BelongToDepartment      OBD
        INNER JOIN Organization_Departments OD ON OD.DepartNo = OBD.DepartNo
        WHERE  OBD.UserNo = board_getboards_improved.userno

        UNION ALL

        -- Recursive: dept cha
        SELECT OD.DepartNo, OD.ParentNo
        FROM   Organization_Departments OD
        INNER JOIN USER_DEPART                   UD ON OD.DepartNo = UD.ParentNo
        WHERE  UD.ParentNo <> 0
    ),

    -- ----------------------------------------------------------------
    -- 2 Board user cÃ³ quyá»n Ä‘á»c trá»±c tiáº¿p (AllowValue bit 2)
    -- ----------------------------------------------------------------
    PERM_BOARD_DIRECT AS (
        SELECT A.ItemNo AS BoardNo
        FROM   Board_AllowAccess A
        WHERE  A.UserNo     = board_getboards_improved.userno
          AND  A.ItemType   = 2
          AND  (A.AllowValue & 2) > 0
    ),

    -- ----------------------------------------------------------------
    -- 3 Folder cÃ³ quyá»n Ä‘á»c + toÃ n bá»™ sub-folder con chÃ¡u
    --     Anchor  : folder user cÃ³ AllowValue bit 2 â€” ItemType=1
    --     Recursive: má»Ÿ rá»™ng xuá»‘ng folder con qua ParentNo
    -- ----------------------------------------------------------------
    PERMITTED_FOLDER_TREE AS (
        -- Anchor: folder cÃ³ quyá»n trá»±c tiáº¿p
        SELECT BF.FolderNo, BF.ParentNo
        FROM   Board_AllowAccess               A
        INNER JOIN Board_Folders      BF ON BF.FolderNo = A.ItemNo
        WHERE  A.UserNo     = board_getboards_improved.userno
          AND  A.ItemType   = 1
          AND  (A.AllowValue & 2) > 0
          AND  BF.Enabled = TRUE

        UNION ALL

        -- Recursive: folder con
        SELECT F.FolderNo, F.ParentNo
        FROM   Board_Folders F
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON F.ParentNo = PFT.FolderNo
        WHERE  F.Enabled = TRUE
    ),

    -- ----------------------------------------------------------------
    -- 4 Board trong folder (hoáº·c sub-folder) Ä‘Æ°á»£c phÃ©p Ä‘á»c
    -- ----------------------------------------------------------------
    PERM_BOARD_FOLDER AS (
        SELECT DISTINCT B.BoardNo
        FROM   Board_Boards B
        INNER JOIN PERMITTED_FOLDER_TREE      PFT ON PFT.FolderNo = B.FolderNo
    ),

    -- ----------------------------------------------------------------
    -- 5 Tá»•ng há»£p: board user Ä‘Æ°á»£c phÃ©p Ä‘á»c (trá»±c tiáº¿p + qua folder)
    -- ----------------------------------------------------------------
    PERM_BOARD AS (
        SELECT BoardNo FROM PERM_BOARD_DIRECT
        UNION
        SELECT BoardNo FROM PERM_BOARD_FOLDER
    ),

    -- ----------------------------------------------------------------
    -- 6 Contents user Ä‘Ã£ Ä‘á»c
    -- ----------------------------------------------------------------
    VIEWED AS (
        SELECT ContentNo
        FROM   Board_ViewedLogs
        WHERE  UserNo = board_getboards_improved.userno
    ),

    -- ----------------------------------------------------------------
    -- 7 Contents shared vá»›i user (dept trá»±c tiáº¿p + toÃ n bá»™ dept cha)
    --     Fix v1: v1 chá»‰ check dept trá»±c tiáº¿p â†’ miss share vá»›i dept cha
    -- ----------------------------------------------------------------
    SHARED AS (
        SELECT DISTINCT BS.ContentNo
        FROM   Board_Sharers BS
        WHERE  BS.UserNo   = board_getboards_improved.userno
           OR  BS.DepartNo IN (SELECT DISTINCT DepartNo FROM USER_DEPART)
    ),

    -- ----------------------------------------------------------------
    -- 8 Sá»‘ content chÆ°a Ä‘á»c â€” ADMIN path
    -- ----------------------------------------------------------------
    COUNT_ADMIN AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    NOT EXISTS (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
        GROUP BY BC.BoardNo
    ),

    -- ----------------------------------------------------------------
    -- 9 Sá»‘ content chÆ°a Ä‘á»c â€” USER path (permission + share)
    -- ----------------------------------------------------------------
    COUNT_USER AS (
        SELECT   BC.BoardNo,
                 COUNT(*) AS UnreadCount
        FROM     Board_Contents BC
        WHERE    BC.Enabled = TRUE
          AND    BC.BoardNo  IN (SELECT BoardNo FROM PERM_BOARD)
          AND    NOT EXISTS  (SELECT 1 FROM VIEWED V WHERE V.ContentNo = BC.ContentNo)
          AND    (
                      BC.ContentNo IN (SELECT ContentNo FROM SHARED)
                   OR NOT EXISTS (SELECT 1 FROM Board_Sharers BS2 WHERE BS2.ContentNo = BC.ContentNo)
                 )
        GROUP BY BC.BoardNo
    )

    -- ----------------------------------------------------------------
    -- 10 Káº¿t quáº£ cuá»‘i
    -- ----------------------------------------------------------------
    RETURN QUERY
    SELECT
        B.BoardNo,
        B.ModUserNo,
        B.ModDate,
        B.Name,
        B.Description,
        B.FolderNo,
        B.DisplayTypeNo,
        B.SortNo,
        B.IsReply,
        B.IsHead,
        B.IsNotice,
        B.IsRecommend,
        B.RecommendedDisplayCount,
        B.Enabled,
        B.ViewMode,
        B.SpecType,
        COALESCE(
            CASE WHEN IsAdmin = TRUE THEN CA.UnreadCount
                                   ELSE CU.UnreadCount
            END,
            0
        ) AS CountContent
    FROM  Board_Boards B
    LEFT JOIN COUNT_ADMIN CA ON CA.BoardNo = B.BoardNo
    LEFT JOIN COUNT_USER  CU ON CU.BoardNo = B.BoardNo
    WHERE  (IsDisabled = TRUE OR B.Enabled = TRUE)
      AND  (B.ViewMode      = board_getboards_improved.viewmode      OR ViewMode      < 0)
      AND  (B.DisplayTypeNo = board_getboards_improved.displaytypeno OR DisplayTypeNo < 0)
    ORDER BY B.SortNo ASC, B.BoardNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
