-- ─── TABLE: Contacts_ListGroupContact ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contacts_ListGroupContact" (
    ListGroupContact_Id serial NOT NULL,
    ListGroupContact_ContactId integer NOT NULL,
    ListGroup_Id integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
