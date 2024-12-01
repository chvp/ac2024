SELECT SUM(ABS(num1 - num2)) FROM
  (SELECT num as num1, ROW_NUMBER() OVER(ORDER BY num ASC) as i1 FROM day01left ORDER BY num ASC) num1ordered
    INNER JOIN
  (SELECT num as num2, ROW_NUMBER() OVER(ORDER BY num ASC) as i2 FROM day01right ORDER BY num ASC) num2ordered
    ON i1 = i2;
