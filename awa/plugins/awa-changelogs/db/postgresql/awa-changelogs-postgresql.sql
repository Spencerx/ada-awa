/* File generated automatically by dynamo */
/*  */
CREATE TABLE awa_changelog (
  /* the changelog identifier. */
  "id" BIGINT NOT NULL,
  /* the changelog date. */
  "date" TIMESTAMP NOT NULL,
  /* the changelog text. */
  "text" VARCHAR(255) NOT NULL,
  /* the optional entity to which the changelog is associated. */
  "for_entity_id" BIGINT NOT NULL,
  /*  */
  "user_id" BIGINT NOT NULL,
  /*  */
  "entity_type" INTEGER NOT NULL,
  PRIMARY KEY ("id")
);
INSERT INTO entity_type (name) VALUES
('awa_changelog')
;
