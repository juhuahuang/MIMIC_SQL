-- Execute as administrative user (e.g. SYSTEM).

select * from AFL_FUNCTIONS where AREA_NAME = 'INTRO_AREA';

-- Create test user
DROP USER TESTAFL CASCADE;
CREATE USER TESTAFL PASSWORD Pass1234;
ALTER USER TESTAFL DISABLE PASSWORD LIFETIME;

-- Grant execution privileges to test user
GRANT AFL__SYS_AFL_INTRO_AREA_EXECUTE TO TESTAFL;
GRANT EXECUTE ON SYSTEM.AFL_WRAPPER_GENERATOR TO TESTAFL;
GRANT EXECUTE ON SYSTEM.AFL_WRAPPER_ERASER TO TESTAFL;

-- Switch to test user
CONNECT TESTAFL PASSWORD Pass1234;

-- DEMONSTRATE_DATATYPES
DROP TABLE T_I;
DROP TABLE T_O;
CREATE COLUMN TABLE T_I ("InputColumn" VARCHAR(100));
CREATE COLUMN TABLE T_O ("IntColumn" INT, "DoubleColumn" DOUBLE, "VarcharColumn" VARCHAR(100));
CALL _SYS_AFL.INTRO_AREA_DEMONSTRATE_DATATYPES_PROC(1, 9.5, 'Hello', T_I, ?, ?, ?, T_O) WITH OVERVIEW;

-- DEMONSTRATE_FLEXIBLE_COLUMNS (make sure the wrapper generator procedure is created first)
DROP TYPE TYPE_IN;
CREATE TYPE TYPE_IN AS TABLE ("C_INT" INT, "C_VARCHAR" VARCHAR(90), "C_DOUBLE" double);
DROP TYPE TYPE_OUT;
CREATE TYPE TYPE_OUT AS TABLE ("ItemDataType" VARCHAR(987), "ItemId" INT, "ItemName" VARCHAR(100));
DROP TABLE SIGNATURE;
CREATE COLUMN TABLE SIGNATURE ("ID" INT, "TYPENAME" VARCHAR(100), "DIRECTION" VARCHAR(100));
INSERT INTO SIGNATURE VALUES (1, 'SYSTEM.TYPE_IN', 'in');
INSERT INTO SIGNATURE VALUES (2, 'SYSTEM.TYPE_OUT', 'out');
CALL SYSTEM.AFL_WRAPPER_ERASER('TEST_FLEXIBLE');
CALL SYSTEM.AFL_WRAPPER_GENERATOR('TEST_FLEXIBLE', 'INTRO_AREA', 'DEMONSTRATE_FLEXIBLE_COLUMNS', SIGNATURE);
DROP TABLE T_I;
CREATE COLUMN TABLE T_I LIKE TYPE_IN;
INSERT INTO T_I VALUES (0, 'dummy', 5.555);
DROP TABLE T_O;
CREATE COLUMN TABLE T_O LIKE TYPE_OUT;
CALL _SYS_AFL.TEST_FLEXIBLE(T_I, T_O) WITH OVERVIEW;
SELECT * FROM T_O;

-- DEMONSTRATE_PARALLELIZATION
DROP TABLE T_I;
CREATE COLUMN TABLE T_I("In" INT);
INSERT INTO T_I VALUES (1);
INSERT INTO T_I VALUES (2);
INSERT INTO T_I VALUES (3);
INSERT INTO T_I VALUES (4);
INSERT INTO T_I VALUES (5);
INSERT INTO T_I VALUES (6);
INSERT INTO T_I VALUES (7);
INSERT INTO T_I VALUES (8);
INSERT INTO T_I VALUES (9);
CALL _SYS_AFL.INTRO_AREA_DEMONSTRATE_PARALLELIZATION_PROC(T_I, ?);
