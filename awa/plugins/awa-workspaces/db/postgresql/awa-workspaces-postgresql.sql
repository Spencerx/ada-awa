/* File generated automatically by dynamo */
/*  */
CREATE TABLE IF NOT EXISTS awa_invitation (
  /* the invitation identifier. */
  "id" BIGINT NOT NULL,
  /* version optimistic lock. */
  "version" INTEGER NOT NULL,
  /* date when the invitation was created and sent. */
  "create_date" TIMESTAMP NOT NULL,
  /* the email address to which the invitation was sent. */
  "email" VARCHAR(255) NOT NULL,
  /* the invitation message. */
  "message" text NOT NULL,
  /* the date when the invitation was accepted. */
  "acceptance_date" TIMESTAMP ,
  /* the workspace where the user is invited. */
  "workspace_id" BIGINT NOT NULL,
  /*  */
  "access_key_id" BIGINT ,
  /* the user being invited. */
  "invitee_id" BIGINT ,
  /*  */
  "inviter_id" BIGINT NOT NULL,
  /*  */
  "member_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/* The workspace controls the features available in the application
for a set of users: the workspace members.  A user could create
several workspaces and be part of several workspaces that other
users have created. */
CREATE TABLE IF NOT EXISTS awa_workspace (
  /* the workspace identifier */
  "id" BIGINT NOT NULL,
  /*  */
  "version" INTEGER NOT NULL,
  /*  */
  "create_date" TIMESTAMP NOT NULL,
  /*  */
  "owner_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/*  */
CREATE TABLE IF NOT EXISTS awa_workspace_feature (
  /*  */
  "id" BIGINT NOT NULL,
  /*  */
  "limit" INTEGER NOT NULL,
  /*  */
  "workspace_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/* The workspace member indicates the users who
are part of the workspace. The join_date is NULL when
a user was invited but has not accepted the invitation. */
CREATE TABLE IF NOT EXISTS awa_workspace_member (
  /*  */
  "id" BIGINT NOT NULL,
  /* the date when the user has joined the workspace. */
  "join_date" TIMESTAMP ,
  /* the member role. */
  "role" VARCHAR(255) NOT NULL,
  /*  */
  "member_id" BIGINT NOT NULL,
  /*  */
  "workspace_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
INSERT INTO ado_entity_type (name) VALUES
('awa_invitation'), ('awa_workspace'), ('awa_workspace_feature'), ('awa_workspace_member')
  ON CONFLICT DO NOTHING;
INSERT INTO ado_version (name, version)
  VALUES ("awa-workspaces", 1)
  ON CONFLICT DO NOTHING;
