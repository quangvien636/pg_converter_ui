# Board Procedures — 156 Passing Baseline

**Baseline commit**: `7d24ed3` (Fix cursor whitespace and control-flow boundaries)  
**Generated**: 2026-06-30 10:43  

---

## Validation Summary

| Step | Result |
|------|--------|
| dotnet build | **PASS** (0 warnings, 0 errors) |
| NUnit (31 tests) | **PASS** 31/31 |
| Board validation (162 procedures) | **156 PASS / 6 FAIL** |

All counts match expected baseline (156/162). No deviations.

---

## Board PASS Count: 156

1. `Board_Authority_Select`
2. `Board_Board_MaxSortNo_Select`
3. `Board_CheckAllowByItem`
4. `Board_CheckPermission`
5. `Board_CheckPermissionByContentNo`
6. `Board_ConvertBoard`
7. `Board_CountBoardInFolder`
8. `Board_CountContentInBoard`
9. `Board_CountFolderInFolder`
10. `Board_DeleteCommentSetting`
11. `Board_DeleteCurrentManager`
12. `Board_DeleteDepartAllowAccess`
13. `Board_DeleteFile`
14. `Board_DeleteFileByContent`
15. `Board_DeleteIOSDevice`
16. `Board_DeleteMultiBoardWidget`
17. `Board_DeleteNewBoardWidget`
18. `Board_DeleteNotificationService`
19. `Board_DeleteReply`
20. `Board_DeleteShare`
21. `Board_DownBoard`
22. `Board_DownBoardByUser`
23. `Board_DownFolder`
24. `Board_DownFolderByUser`
25. `Board_DownMultilWidget`
26. `Board_DownMultiWidget`
27. `Board_DownWidget`
28. `Board_Folder_MaxSortNo_Select`
29. `Board_GetAllBoardContents`
30. `Board_GetAllBoardWidget`
31. `Board_GetAllowByItem`
32. `Board_GetAllowByItemType`
33. `Board_GetAllowByUser`
34. `Board_GetAndroidDeviceOfAllUsers`
35. `Board_GetAndroidDeviceOfUsersByDepartment`
36. `Board_GetApprovalDoc`
37. `Board_GetApprovalFiles`
38. `Board_GetBoard`
39. `Board_GetBoardByUserNo`
40. `Board_GetBoardCommunityWidget`
41. `Board_GetBoardContent`
42. `Board_GetBoardContentInfo`
43. `Board_GetBoards`
44. `Board_GetBoards_BK`
45. `Board_GetBoards_Improved`
46. `Board_GetCommentSetting`
47. `Board_GetCompanyList`
48. `Board_GetConfig`
49. `Board_GetContentSetting`
50. `Board_GetCurrentManagerList`
51. `Board_GetDepartAllowAccess`
52. `Board_GetDepartAndPositionName`
53. `Board_GetFile`
54. `Board_GetFiles`
55. `Board_GetFolderByFolderNo`
56. `Board_GetFolderByUserNo`
57. `Board_GetFolders`
58. `Board_GetHeads`
59. `Board_GetIOSDeviceOfAllUsers`
60. `Board_GetIOSDeviceOfUsersByDepartment`
61. `Board_GetListBoardContent`
62. `Board_GetListBoardContent_BK`
63. `Board_GetListBoardContent_Search`
64. `Board_GetListBoardContentByFolder`
65. `Board_GetListBoardContentSearch`
66. `Board_GetListBoardContentToExcel`
67. `Board_GetListCommentSetting`
68. `Board_GetListConvertUrlFile`
69. `Board_GetListNoticePermission`
70. `Board_GetListUserPermission`
71. `Board_GetListUserPermissionToExcel`
72. `Board_GetMaxSortOfTree`
73. `Board_GetMultiWidget`
74. `Board_GetNewBoardContent`
75. `Board_GetNewBoardWidget`
76. `Board_GetOpenFolder`
77. `Board_GetPreNextContent`
78. `Board_GetRecommendCount`
79. `Board_GetRecommendedLogByUserNo`
80. `Board_GetRecommendedLogs`
81. `Board_GetRecommendLogCount`
82. `Board_GetReplies`
83. `Board_GetReply`
84. `Board_GetReplyByContent`
85. `Board_GetReplyFileByContentNo`
86. `Board_GetReplyFileByReplyFileNo`
87. `Board_GetReplyFileByReplyNo`
88. `Board_GetSettingCommunityWidget`
89. `Board_GetSharers`
90. `Board_GetStatusApprovalPermission`
91. `Board_GetSubMenus`
92. `Board_GetTeamList`
93. `Board_GetTeamName`
94. `Board_GetTreeBoard`
95. `Board_GetTreeSubMenu`
96. `Board_GetTreeSubMenu_V2`
97. `Board_GetTreeSubMenuTest`
98. `Board_GetUserByShare`
99. `Board_GetUserSetting`
100. `Board_GetViewedLogs`
101. `Board_GetWidgetCarousel`
102. `Board_InsertAndroidDevice`
103. `Board_InsertBoard`
104. `Board_InsertBoardContent`
105. `Board_InsertCommentSetting`
106. `Board_InsertCurrentManager`
107. `Board_InsertDepartAllowAccess`
108. `Board_InsertFile`
109. `Board_InsertIOSDevice`
110. `Board_InsertMultiBoardWidget`
111. `Board_InsertNewBoardWidget`
112. `Board_InsertNotificationService`
113. `Board_InsertRecommendedLog`
114. `Board_InsertReply`
115. `Board_InsertReplyFile`
116. `Board_InsertUserSetting`
117. `Board_InsertViewedLog`
118. `Board_SetAllHistoryFolder`
119. `Board_SetContentSetting`
120. `Board_SetFolders`
121. `Board_SetHistoryFolder`
122. `Board_SetShare`
123. `Board_TreeBoard`
124. `Board_UpBoard`
125. `Board_UpBoardByUser`
126. `Board_UpdateAllowAccess`
127. `Board_UpdateAndroidDevice_NotificationOptions`
128. `Board_UpdateAndroidDevice_TimezoneOffset`
129. `Board_UpdateApprovalDoc`
130. `Board_UpdateBoard`
131. `Board_UpdateBoardContent`
132. `Board_UpdateBoardContent_Content`
133. `Board_UpdateBoardContent_Enabled`
134. `Board_UpdateBoardContent_EnabledForUser`
135. `Board_UpdateBoardContent_IsNotice`
136. `Board_UpdateBoardContent_TitleEffect`
137. `Board_UpdateBoardContent_Viewed`
138. `Board_UpdateBoardCustorm`
139. `Board_UpdateConfig`
140. `Board_UpdateDepartAllowAccess`
141. `Board_UpdateFile`
142. `Board_UpdateFolder`
143. `Board_UpdateIOSDevice_NotificationOptions`
144. `Board_UpdateLevelRand`
145. `Board_UpdateNoticePermission`
146. `Board_UpdateNotificationService`
147. `Board_UpdatePermissionsByParent`
148. `Board_UpdateRecommendPublic`
149. `Board_UpdateReply`
150. `Board_UpdateSpecType`
151. `Board_UpdateStatusApproval`
152. `Board_UpFolder`
153. `Board_UpFolderByUser`
154. `Board_UpMultiWidget`
155. `Board_UpWidget`
156. `Board_UserCollection_Select`

---

## Board FAIL Count: 6

| Procedure | SqlState | Error |
|-----------|----------|-------|
| `Board_GetAllBoardContentsByBoardList` | `42601` | syntax error at or near ";" |
| `Board_GetBoardContents` | `42601` | syntax error at or near ";" |
| `Board_GetBoardContents_BK20181227` | `42601` | syntax error at or near ";" |
| `Board_GetTreeSubMenu_V2_Json` | `42601` | syntax error at or near "XML" |
| `Board_Mobile_Search` | `42601` | syntax error at or near ";" |
| `Board_Web_Search` | `42601` | syntax error at or near ";" |
