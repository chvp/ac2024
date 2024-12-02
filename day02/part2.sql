WITH diff1s AS (SELECT day02_vals.id, day02_vals.lineno, (day02_vals2.val - day02_vals.val) AS diff1 FROM day02_vals INNER JOIN day02_vals day02_vals2 ON (day02_vals.lineno = day02_vals2.lineno AND day02_vals.id + 1  = day02_vals2.id)),
     diff2s AS (SELECT day02_vals.id, day02_vals.lineno, (day02_vals2.val - day02_vals.val) AS diff2 FROM day02_vals INNER JOIN day02_vals day02_vals2 ON (day02_vals.lineno = day02_vals2.lineno AND day02_vals.id + 2  = day02_vals2.id)),
     positive_diff1s AS (SELECT lineno, id FROM diff1s WHERE diff1 IN (1, 2, 3)),
     negative_diff1s AS (SELECT lineno, id FROM diff1s WHERE diff1 IN (-1, -2, -3)),
     positive_diff1_counts AS (SELECT lineno, COUNT(id) AS pcount FROM positive_diff1s GROUP BY lineno),
     negative_diff1_counts AS (SELECT lineno, COUNT(id) AS ncount FROM negative_diff1s GROUP BY lineno),
     positive_diff2s AS (SELECT lineno, id FROM diff2s WHERE diff2 IN (1, 2, 3)),
     negative_diff2s AS (SELECT lineno, id FROM diff2s WHERE diff2 IN (-1, -2, -3)),
     expected_count AS (SELECT lineno, COUNT(*) AS ecount FROM day02_vals GROUP BY lineno)
  SELECT * FROM expected_count
             LEFT JOIN positive_diff1_counts ON expected_count.lineno = positive_diff1_counts.lineno
             LEFT JOIN negative_diff1_counts ON expected_count.lineno = negative_diff1_counts.lineno
    WHERE (ecount = pcount + 1)
       OR (ecount = ncount + 1)
       OR (ecount = pcount + 2 AND (SELECT MIN(id) FROM positive_diff1s WHERE id + 1 NOT IN (SELECT id FROM positive_diff1s WHERE lineno = expected_count.lineno) AND lineno = expected_count.lineno) IN (SELECT id FROM positive_diff2s))
       OR (ecount = ncount + 2 AND (SELECT MIN(id) FROM negative_diff1s WHERE id + 1 NOT IN (SELECT id FROM negative_diff1s WHERE lineno = expected_count.lineno) AND lineno = expected_count.lineno) IN (SELECT id FROM negative_diff2s));
