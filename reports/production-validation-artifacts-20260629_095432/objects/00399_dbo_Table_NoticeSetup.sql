-- ─── TABLE: NoticeSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSetup" (
    UsePopup character(1) NOT NULL,
    PageSize integer NOT NULL,
    EndNoticeView character(1) NOT NULL,
    RegUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    NoticeTreeSub character(1),
    IsImportant integer,
    popupType integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
