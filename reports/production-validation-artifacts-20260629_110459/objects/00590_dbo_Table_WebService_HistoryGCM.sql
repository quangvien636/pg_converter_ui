-- ─── TABLE: WebService_HistoryGCM ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WebService_HistoryGCM" (
    HistoryNo uuid NOT NULL PRIMARY KEY,
    Title text,
    Message text,
    Type integer,
    DateCreate timestamp without time zone,
    Sucess integer,
    Fail integer,
    multicast_id character varying(250),
    AppKey character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
