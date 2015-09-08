/* Formatted on 2011/12/15 23:29 (Formatter Plus v4.8.8) */
SELECT DECODE(ROUND(ROWNUM / 2) * 2,
              ROWNUM, 1,
              0
             ) color,
       z.*
  FROM (SELECT   ID,
                 meet_file,
                 meet_file_name,
                 TO_CHAR(meet_date, 'dd.mm.yyyy') meet_date,
                 TO_CHAR(meet_date_next, 'dd.mm.yyyy') meet_date_next,
                 manager,
                 fn_getname ( manager) manager_fio
            FROM nets_meetings_year
           WHERE :YEAR = YEAR
             AND :net = id_net
        ORDER BY meet_date) z