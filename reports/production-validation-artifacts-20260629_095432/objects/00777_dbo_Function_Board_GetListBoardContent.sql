-- ─── FUNCTION: board_getlistboardcontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getlistboardcontent(integer, integer, integer, integer, character varying, integer, integer, character varying, character varying, integer, timestamp without time zone, timestamp without time zone, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_getlistboardcontent(
    userno integer DEFAULT 70,
    boardno integer DEFAULT 1094,
    curentpage integer DEFAULT 1,
    pagesize integer DEFAULT 15,
    langcode character varying DEFAULT 'EN',
    filtertype integer DEFAULT 100,
    searchtype integer DEFAULT 0,
    searchvalue character varying DEFAULT '',
    sortcolumn character varying DEFAULT '',
    sorttype integer DEFAULT 0,
    fromdate timestamp without time zone DEFAULT '2000-07-08 00:00:01',
    todate timestamp without time zone DEFAULT '2026-07-09 00:00:01',
    isadmin boolean DEFAULT TRUE,
    titleeffect boolean DEFAULT FALSE,
    mgdepartment character varying DEFAULT ''
) RETURNS TABLE(
    col1 text,
    name text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



    SET SearchValue  = COALESCE(LTRIM(RTRIM(SearchValue)),  '');
    SET MgDepartment = COALESCE(LTRIM(RTRIM(MgDepartment)), '');
    SET SortColumn   = COALESCE(LTRIM(RTRIM(SortColumn)),   '');

    WITH
    PERMISSION AS (
        SELECT ItemNo, AllowValue, AllowAccessNo
        FROM   Board_AllowAccess
        WHERE  ItemType = 2 AND UserNo = board_getlistboardcontent.userno AND AllowValue > 0
    ),
    DEPARTPERMISSION AS (
        SELECT BD.ItemNo, BD.AllowValue, BD.AllowAccessNo
        FROM   Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE  BD.ItemType = 2 AND OB.UserNo = board_getlistboardcontent.userno
          AND  OB.IsDefault = TRUE AND BD.AllowValue > 0
    ),
    USER_DEPART AS (
        SELECT U.UserNo, OB.DepartNo
        FROM   Organization_Users U
        INNER JOIN Organization_BelongToDepartment OB ON OB.UserNo = U.UserNo
        WHERE  U.UserNo = board_getlistboardcontent.userno AND U.Enabled = TRUE
    ),
    SHARE AS (
        SELECT DISTINCT BS.ContentNo FROM Board_Sharers BS
        INNER JOIN USER_DEPART UD ON BS.UserNo   = UD.UserNo
        UNION
        SELECT DISTINCT BS.ContentNo FROM Board_Sharers BS
        INNER JOIN USER_DEPART UD ON BS.DepartNo = UD.DepartNo
    ),
    PERMISSION_BOARD AS (
        SELECT B.BoardNo, B.Name, B.ViewMode, B.SpecType
        FROM   Board_Boards B
        LEFT JOIN PERMISSION       P ON P.ItemNo = B.BoardNo
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo
        WHERE  (B.BoardNo = board_getlistboardcontent.boardno OR BoardNo = 0)
          AND  (IsAdmin = TRUE OR P.AllowValue > 0 OR D.AllowValue > 0 OR B.SpecType = 1)
    ),
    VIEWED AS (
        SELECT DISTINCT ContentNo FROM Board_ViewedLogs WHERE UserNo = board_getlistboardcontent.userno
    ),
    TMP AS (
        SELECT
            BC.BoardNo, BC.ContentNo, BC.Title, BC.IsFile, BC.ViewedCount, BC.RootId,
            BC.TitleEffect, BC.RegDate, BC.ModDate, BC.IsNotice, BC.RegUserNo,
            CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* TOP 1 */ StringValue FROM ParseJson(B.Name) WHERE Name=board_getlistboardcontent.langcode) ELSE B.Name END AS BoardName,
            CASE LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
            CASE LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
            CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
            SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) AS RegDateToString,
            CASE WHEN '2020-12-31'::timestamp>BC.RegDate OR BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent.userno
                 THEN TRUE ELSE FALSE END AS IsReaded,
            ROW_NUMBER() OVER (ORDER BY
                CASE WHEN SortType=0 AND SortColumn=''         THEN BC.RootId    END DESC,
                CASE WHEN SortType=0 AND SortColumn=''         THEN BC.HeadNo    END ASC,
                CASE WHEN SortType=0 AND SortColumn=''         THEN BC.ContentNo END ASC,
                CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.IsNotice  END DESC,
                CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.RootId    END DESC,
                CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.HeadNo    END ASC,
                CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.ContentNo END ASC,
                CASE WHEN SortType=0 AND SortColumn='TITLE'      THEN BC.Title       END ASC,
                CASE WHEN SortType=0 AND SortColumn='REGDATE'    THEN BC.RegDate     END ASC,
                CASE WHEN SortType=0 AND SortColumn='VIEWED'     THEN BC.ViewedCount END ASC,
                CASE WHEN SortType=0 AND SortColumn='TYPE'       THEN BC.Type        END ASC,
                CASE WHEN SortType=0 AND SortColumn='ERRORTYPE'  THEN BC.ErrorType   END ASC,
                CASE WHEN SortType=0 AND SortColumn='PERSONTYPE' THEN BC.PersonType  END ASC,
                CASE WHEN SortType=0 AND SortColumn='BOARD' THEN CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* TOP 1 */ StringValue FROM ParseJson(B.Name) WHERE Name=board_getlistboardcontent.langcode) ELSE B.Name END END ASC,
                CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN CASE LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
                CASE WHEN SortType=0 AND SortColumn='DEPART' THEN CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
                CASE WHEN SortType=1 AND SortColumn='TITLE'      THEN BC.Title       END DESC,
                CASE WHEN SortType=1 AND SortColumn='REGDATE'    THEN BC.RegDate     END DESC,
                CASE WHEN SortType=1 AND SortColumn='VIEWED'     THEN BC.ViewedCount END DESC,
                CASE WHEN SortType=1 AND SortColumn='TYPE'       THEN BC.Type        END DESC,
                CASE WHEN SortType=1 AND SortColumn='ERRORTYPE'  THEN BC.ErrorType   END DESC,
                CASE WHEN SortType=1 AND SortColumn='PERSONTYPE' THEN BC.PersonType  END DESC,
                CASE WHEN SortType=1 AND SortColumn='BOARD' THEN CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* TOP 1 */ StringValue FROM ParseJson(B.Name) WHERE Name=board_getlistboardcontent.langcode) ELSE B.Name END END DESC,
                CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN CASE LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
                CASE WHEN SortType=1 AND SortColumn='DEPART' THEN CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC
            ) AS RowNum,
            COUNT(*) OVER () AS TotalRows,
            B.ViewMode AS BoardType, B.SpecType,
            CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent.userno
                 THEN TRUE ELSE FALSE END AS IsDelete,
            BC.Type, BC.ErrorType, BC.PersonType, BC.VisitDate, BC.VisitCompleteDate,
            BC.ConstructionName, BC.ApplyTo, BC.MailRecipientNo, BC.MailRecipientName,
            CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date) END AS DayDateView,
            BC.Important, BC.DesignNo, BC.Private, BC.Purpose, BC.RecommendedCount, BC.IsRecommendPublic,
            BC.IsShareAll
        FROM    Board_Contents BC
        INNER JOIN PERMISSION_BOARD  B  ON B.BoardNo     = BC.BoardNo
        LEFT  JOIN Organization_Users       OU ON OU.UserNo     = BC.RegUserNo
        LEFT  JOIN Organization_Positions   OP ON OP.PositionNo = BC.RegPositionNo
        LEFT  JOIN Organization_Departments OD ON OD.DepartNo   = BC.RegDepartNO
        LEFT  JOIN VIEWED                   BV ON BV.ContentNo  = BC.ContentNo
        LEFT  JOIN PERMISSION               P  ON  P.ItemNo     = BC.BoardNo
        LEFT  JOIN DEPARTPERMISSION         D  ON  D.ItemNo     = BC.BoardNo
        LEFT  JOIN SHARE                    S  ON  S.ContentNo  = BC.ContentNo
        WHERE  (BC.BoardNo = board_getlistboardcontent.boardno OR (BoardNo = 0 AND B.ViewMode >= 2))
          AND  BC.Enabled = TRUE
          AND  BC.RegDate       >= board_getlistboardcontent.fromdate
          AND  BC.RegDate       <= board_getlistboardcontent.todate
          AND  (FilterType = 100 OR (FilterType = 1 AND BV.ContentNo IS NULL))
          AND  (TitleEffect = 1 OR (TitleEffect = 0 AND TitleEffect = 0))
          AND  (MgDepartment   = '' OR MgDepartment = BC.PersonType)
          AND  (SearchValue = ''
                OR (SearchType=0 AND BC.Title ILIKE '%' || SearchValue || '%')
                OR (SearchType=1 AND CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || SearchValue || '%')
                OR (SearchType=2 AND CASE LangCode WHEN 'EN' THEN COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name) WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || SearchValue || '%')
                OR (SearchType=3 AND BC.Type             =    board_getlistboardcontent.searchvalue)
                OR (SearchType=4 AND BC.Type             ILIKE '%' || SearchValue || '%')
                OR (SearchType=5 AND BC.ErrorType        ILIKE '%' || SearchValue || '%')
                OR (SearchType=6 AND BC.ApplyTo          ILIKE '%' || SearchValue || '%')
                OR (SearchType=7 AND BC.ConstructionName ILIKE '%' || SearchValue || '%'))
          AND  (IsAdmin = TRUE OR BC.RegUserNo = board_getlistboardcontent.userno OR P.AllowValue = 7 OR D.AllowValue = 7
                OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL) AND B.SpecType=0 AND (BC.IsShareAll = TRUE OR S.ContentNo IS NOT NULL))
                OR ((BC.IsShareAll = TRUE OR S.ContentNo IS NOT NULL) AND B.SpecType=1))
    )
    RETURN QUERY
    SELECT
        T.BoardNo, T.ContentNo, T.Title,
        COALESCE(F.Url,'')                                                                AS FileUrl,
        F.Name                                                                          AS FileName,
        REPLACE(REPLACE(COALESCE(F.Url,''),'/Attach/','/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
        T.IsFile, T.BoardName, T.RegUserName, T.RegPositionName, T.RegDepartName,
        COALESCE(VL.ViewedCount, 0)                                                       AS ViewedCount,
        T.RegDateToString, T.RootId, T.TitleEffect, T.IsDelete, T.IsReaded,
        T.TotalRows                                                                     AS Total,
        COALESCE(R.ReplyCount, 0)                                                         AS ReplyCount,
        T.BoardType, T.RegDate, T.ModDate, T.IsNotice,
        CASE WHEN BoardNo<>0 THEN T.Type              ELSE NULL END AS Type,
        CASE WHEN BoardNo<>0 THEN T.ErrorType         ELSE NULL END AS ErrorType,
        CASE WHEN BoardNo<>0 THEN T.PersonType        ELSE NULL END AS PersonType,
        CASE WHEN BoardNo<>0 THEN T.VisitDate         ELSE NULL END AS VisitDate,
        CASE WHEN BoardNo<>0 THEN T.VisitCompleteDate ELSE NULL END AS VisitCompleteDate,
        CASE WHEN BoardNo<>0 THEN T.ConstructionName  ELSE NULL END AS ConstructionName,
        CASE WHEN BoardNo<>0 THEN T.DayDateView       ELSE NULL END AS DayDateView,
        CASE WHEN BoardNo<>0 THEN T.ApplyTo           ELSE NULL END AS ApplyTo,
        CASE WHEN BoardNo<>0 THEN T.MailRecipientNo   ELSE NULL END AS MailRecipientNo,
        CASE WHEN BoardNo<>0 THEN T.MailRecipientName ELSE NULL END AS MailRecipientName,
        CASE WHEN BoardNo<>0 THEN T.Important         ELSE NULL END AS Important,
        CASE WHEN BoardNo<>0 THEN T.DesignNo          ELSE NULL END AS DesignNo,
        CASE WHEN BoardNo<>0 THEN T.Private           ELSE NULL END AS Private,
        CASE WHEN BoardNo<>0 THEN T.RegUserNo         ELSE NULL END AS RegUserNo,
        CASE WHEN BoardNo<>0 THEN T.Purpose           ELSE NULL END AS Purpose,
        CASE WHEN BoardNo<>0 THEN T.RecommendedCount  ELSE NULL END AS RecommendedCount,
        CASE WHEN BoardNo<>0 THEN T.IsRecommendPublic ELSE NULL END AS IsRecommendPublic,
        COALESCE(T.TotalRows,0) - T.RowNum + 1                                            AS RowNumber
    FROM TMP T
    OUTER APPLY (
        SELECT COUNT(DISTINCT BV.UserNo) AS ViewedCount
        FROM   Board_ViewedLogs BV
        WHERE  BV.ContentNo = T.ContentNo
          AND  (   T.SpecType      = 1
                OR T.IsShareAll    = TRUE
                OR BV.UserNo      = T.RegUserNo
                OR EXISTS (
                    SELECT 1 FROM Board_Sharers BS
                    WHERE  BS.ContentNo = T.ContentNo
                      AND  (   BS.UserNo   IN (SELECT UserNo   FROM USER_DEPART)
                            OR BS.DepartNo IN (SELECT DepartNo FROM USER_DEPART))
                ))
    ) VL
    OUTER APPLY (
        SELECT COUNT(ReplyNo) AS ReplyCount
        FROM   Board_Replies
        WHERE  ContentNo = T.ContentNo
    ) R
    OUTER APPLY (
        SELECT /* TOP 1 */ Url, Name
        FROM   Board_Files
        WHERE  ContentNo = T.ContentNo
        ORDER BY ContentNo
    ) F
    WHERE  T.RowNum >  (CurentPage - 1) * PageSize
      AND  T.RowNum <= board_getlistboardcontent.curentpage       * PageSize
    ORDER BY T.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
