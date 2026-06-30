-- ─── TABLE: Contacts_ListGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contacts_ListGroup" (
    ListGroup_Id serial NOT NULL,
    ListGroup_Content character varying(250),
    ListGroup_RegDate timestamp without time zone,
    ListGroup_ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
