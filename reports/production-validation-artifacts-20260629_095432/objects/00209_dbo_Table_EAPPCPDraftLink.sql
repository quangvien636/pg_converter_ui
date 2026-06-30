-- ─── TABLE: EAPPCPDraftLink ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCPDraftLink" (
    id serial NOT NULL,
    CPDraftDocID integer,
    CPApprovalDocID integer,
    Regdate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
