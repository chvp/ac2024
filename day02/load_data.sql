CREATE TABLE IF NOT EXISTS day02_arrs (id SERIAL PRIMARY KEY, val TEXT[] NOT NULL);
DELETE FROM day02_arrs;
INSERT INTO day02_arrs (val) SELECT arr FROM (
    SELECT arr FROM (
      SELECT string_to_array(string_to_table(pg_read_file('/Users/charlotte.vanpetegem/repos/aoc2024/day02/input'), E'\n'), ' ') arr
    ) text_columns
  ) arrs WHERE arr IS NOT NULL;

CREATE TABLE IF NOT EXISTS day02_vals (id SERIAL PRIMARY KEY, lineno INTEGER NOT NULL, val INTEGER NOT NULL);
CREATE INDEX IF NOT EXISTS day02_lineno ON day02_vals (lineno);
DELETE FROM day02_vals;
INSERT INTO day02_vals (lineno, val) SELECT id AS lineno, UNNEST(val)::INTEGER AS val FROM day02_arrs;
DROP TABLE day02_arrs;
