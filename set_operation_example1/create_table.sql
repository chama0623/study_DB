CREATE TABLE companyA (
 code CHAR(5) NOT NULL PRIMARY KEY,
 name VARCHAR(10),
 group_code CHAR(3)
);

CREATE TABLE companyB (
 code CHAR(5) NOT NULL PRIMARY KEY,
 name VARCHAR(10),
 group_code CHAR(3)
);

CREATE TABLE department (
    group_code CHAR(3) NOT NULL PRIMARY KEY,
    group_name VARCHAR(10)
);


INSERT INTO companyA VALUES (11001, '中川夏紀', 'E01'), (11002, '吉川優子', 'E02');
INSERT INTO companyB VALUES (11001, "中川夏紀", 'E01'), (22001, '黄前久美子', 'J01');
INSERT INTO department VALUES ('E01', '1組'), ('E02', '2組');