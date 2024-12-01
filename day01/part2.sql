SELECT SUM(num * (SELECT COUNT(*) FROM day01right WHERE day01left.num = day01right.num)) FROM day01left;
