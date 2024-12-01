CREATE TABLE IF NOT EXISTS day01 (num1 INTEGER NOT NULL, num2 INTEGER NOT NULL);
DELETE FROM day01;
INSERT INTO day01 (num1, num2) SELECT num1, num2 FROM (
    SELECT ar[1]::INTEGER num1, ar[2]::INTEGER num2 FROM (
      SELECT string_to_array(string_to_table(pg_read_file('/home/charlotte/repos/aoc2024/day01/input'), E'\n'), '   ') ar
    ) text_columns
  ) int_columns WHERE num1 IS NOT NULL;

CREATE TABLE IF NOT EXISTS day01left (num INTEGER NOT NULL);
INSERT INTO day01left (num) SELECT num1 FROM day01;
CREATE TABLE IF NOT EXISTS day01right (num INTEGER NOT NULL);
INSERT INTO day01right (num) SELECT num2 FROM day01;

DROP TABLE day01;

