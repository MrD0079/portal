/* Formatted on 2011/12/27 08:52 (Formatter Plus v4.8.8) */
SELECT DECODE(ROUND(ROWNUM / 2) * 2,
              ROWNUM, 1,
              0
             ) color,
       z.*
  FROM (SELECT   ct.ID,
                 ct.cooperation_term_name
            FROM sdu_terms ct
        ORDER BY ct.ID) z