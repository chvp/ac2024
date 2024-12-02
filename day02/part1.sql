WITH diffs AS (SELECT day02_vals.lineno, (day02_vals.val - day02_vals2.val) AS diff FROM day02_vals INNER JOIN day02_vals day02_vals2 ON (day02_vals.lineno = day02_vals2.lineno AND day02_vals.id + 1 = day02_vals2.id)),
     positive_diff_count AS (SELECT lineno, COUNT(*) AS pcount FROM diffs WHERE diff IN (1, 2, 3) GROUP BY lineno),
     negative_diff_count AS (SELECT lineno, COUNT(*) AS ncount FROM diffs WHERE diff in (-1, -2, -3) GROUP BY lineno),
     expected_count AS (SELECT lineno, COUNT(*) - 1 AS ecount FROM day02_vals GROUP BY lineno)
  SELECT COUNT(*) FROM expected_count LEFT JOIN positive_diff_count ON expected_count.lineno = positive_diff_count.lineno LEFT JOIN negative_diff_count ON expected_count.lineno = negative_diff_count.lineno WHERE (ecount = pcount) OR (ecount = ncount);
