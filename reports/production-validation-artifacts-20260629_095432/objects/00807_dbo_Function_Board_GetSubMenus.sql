-- ─── FUNCTION: board_getsubmenus ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getsubmenus(integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_getsubmenus(
    userno integer DEFAULT 222,
    isadmin boolean DEFAULT FALSE,
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    id text,
    parent text,
    text text,
    icon text,
    li_attr text,
    data text,
    state text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH 
 DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType,ROW_NUMBER() OVER(PARTITION BY ItemNo,UserNo  ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_getsubmenus.userno AND OB.IsDefault= TRUE
),
History AS (SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder BH WHERE BH.UserNo=board_getsubmenus.userno),
FOLDER AS (
	SELECT /* TOP 1000 */ BF.Name,BF.FolderNo ,BF.ModUserNo,BF.ModDate, BF.Name AS JsonName, BF.ParentNo, BF.SortNo,TRUE AS IsFolder , 0 AS CountContent, 0 AS ViewMode ,COALESCE(BH.IsOpen,1) AS IsOpen
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getsubmenus.userno
	LEFT JOIN History BH ON  BF.FolderNo=BH.FolderNo AND BH.RowNum=1
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE   BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0 )
	ORDER BY SortNo ASC,BF.FolderNo ASC),
BOARD AS (
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
				B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled,B.ViewMode,B.SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC 
				WHERE '2020-12-31'::timestamp< BC.RegDate AND (BC.BoardNo = B.BoardNo
					AND BC.Enabled = TRUE 
					And BC.RegUserNo <> board_getsubmenus.userno 
					And BC.ContentNo Not In (Select BV.ContentNo From Board_ViewedLogs BV where BV.UserNo=board_getsubmenus.userno)
					And (IsAdmin = TRUE OR BA.AllowValue=7 OR D.AllowValue=7 OR
					(  (BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo ,2)) OR B.SpecType=1)
						AND (
							(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_BelongToDepartment" DP ON DP.DepartNo= BS1.DepartNo AND DP.UserNo=board_getsubmenus.userno)) -- SHARE BY DEPARTMENT
						  OR(BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getsubmenus.userno)) -- SHARE BY USER
						  OR BC.IsShareAll = TRUE  -- SHARE ALL
							) )
					))
				 ) As CountContent
			FROM Board_Boards B
			--INNER JOIN FOLDER F ON F.FolderNo=B.FolderNo
			LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getsubmenus.userno
			LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2 AND Rn=1
			WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
			--ORDER BY SortNo ASC
),
TREESUB AS
(
    SELECT    	COALESCE(CASE WHEN STRPOS(T.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name)  WHERE NAME=board_getsubmenus.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name)  WHERE NAME='KO')) ELSE T.Name END,'') AS Name ,
	 ('f' || CAST(T.FolderNo AS VARCHAR))AS Id  ,
	 T.ModUserNo,T.ModDate, T.Name AS JsonName, 
	CASE  WHEN T.ParentNo = 0 THEN '#' ELSE 'f' || CAST(T.ParentNo AS VARCHAR)  END AS ParentNo,
	T.SortNo,TRUE AS IsFolder ,T.IsOpen , 0 AS CountContent, 0 AS ViewMode, 'fa fa-folder' AS icon
    FROM       FOLDER T
    UNION ALL
	SELECT	COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getsubmenus.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME='KO')) ELSE B.Name END,'') AS Name ,
		('b' || CAST(B.BoardNo AS VARCHAR) )  AS Id  ,
		B.ModUserNo,B.ModDate, B.Name AS JsonName,
		CASE WHEN B.FolderNo = 0 THEN '#' ELSE 'f' || CAST(B.FolderNo AS VARCHAR)   END  AS ParentNo,
		B.SortNo,FALSE AS IsFolder ,FALSE AS IsOpen,B.CountContent,B.ViewMode, 'fa fa-file-o' AS icon
	 FROM      BOARD B
)
RETURN QUERY
SELECT F.id,F.ParentNo AS parent, F.Name+ CASE 
    WHEN ViewMode > 0 THEN ' <span class="submenu_board_content_count">' || CAST(ViewMode AS VARCHAR) + '</span>' 
    ELSE '' 
  END AS text,f.icon,
  '{ "type": "' || CAST(F.ViewMode AS varchar) + '", "RegUserNo": "' || CAST( F.ModUserNo AS varchar) + '" }' AS li_attr,
    '{ "title": "' || F.Name || '", "jsonName": "' || F.JsonName || '" }' AS data,
	 '{ "opened": "' || CASE  WHEN F.IsOpen = TRUE THEN 'true'  ELSE 'false' END || '", "selected": "'+ 'false'  + '" }' AS state
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
