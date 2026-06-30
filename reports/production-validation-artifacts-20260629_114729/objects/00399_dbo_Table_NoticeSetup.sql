-- ─── TABLE: NoticeSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSetup" (
    UsePopup character(1) NOT NULL DEFAULT 'N',
    PageSize integer NOT NULL DEFAULT 20,
    EndNoticeView character(1) NOT NULL DEFAULT 'Y',
    RegUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    NoticeTreeSub character(1),
    IsImportant integer,
    popupType integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
