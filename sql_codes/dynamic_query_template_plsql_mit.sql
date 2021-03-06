---------- Dynamic/Functional SQL Template for PL/SQL ------------
-------- Created by Mornin Feng on 07/12/14 ----------------------

-- Creating column definitions for the output table

create or replace force type column_t as object 
(SUBJECT_ID	NUMBER(7,0),
HADM_ID	NUMBER(7,0),
SEQUENCE	NUMBER(7,0),
CODE	VARCHAR2(100 BYTE),
DESCRIPTION	VARCHAR2(255 BYTE)
);

-- Creating table type for the output table
create or replace type icd9set_t as table of column_t;

-- Defining the dynamic sql function
create or replace function return_table(q_subject_id in ICD9.SUBJECT_ID%type)
return icd9set_t as
  v_ret   icd9set_t;
begin
  select 
  cast(
  multiset(
    -- The SQL code goes here!!!
    select * from icd9 where subject_id=q_subject_id)
    as icd9set_t)
    into
      v_ret
    from 
      dual;

  return v_ret;
  
end return_table;

-- Testing the defined function
select * from table(return_table(44));