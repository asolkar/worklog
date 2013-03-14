--
-- Run this as postgres to bring sequence ids back in sync
-- especially after import/export of DB
--
-- wl_db1=# \d
--                 List of relations
--  Schema |       Name        |   Type   |  Owner   
-- --------+-------------------+----------+----------
--  public | entries           | table    | postgres
--  public | entries_id_seq    | sequence | postgres
--  public | logs              | table    | postgres
--  public | logs_id_seq       | sequence | postgres
--  public | schema_migrations | table    | postgres
--  public | taggings          | table    | postgres
--  public | taggings_id_seq   | sequence | postgres
--  public | tags              | table    | postgres
--  public | tags_id_seq       | sequence | postgres
--  public | users             | table    | postgres
--  public | users_id_seq      | sequence | postgres
--
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('logs_id_seq', (SELECT MAX(id) FROM logs));
SELECT setval('entries_id_seq', (SELECT MAX(id) FROM entries));
SELECT setval('tags_id_seq', (SELECT MAX(id) FROM tags));
SELECT setval('taggings_id_seq', (SELECT MAX(id) FROM taggings));
