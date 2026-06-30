-- ─── TABLE: Note_Attachment ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_Attachment" (
    AttachmentNo uuid NOT NULL PRIMARY KEY,
    UserNo integer,
    FileUrl character varying(250),
    ListNo uuid,
    TypeFile character varying(50),
    DayCreate timestamp without time zone,
    DayEdit timestamp without time zone,
    fileURI character varying(250),
    RealPath character varying(250),
    IsAvatar boolean NOT NULL,
    AttachTimeZone double precision,
    FileSize character varying(200),
    FileName character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
