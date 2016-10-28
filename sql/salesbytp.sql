/* Formatted on 15/09/2015 16:17:32 (QP5 v5.227.12220.39724) */
SELECT SUM (m.summa) summa,
       SUM (CASE WHEN ROWNUM <= :top THEN m.summa END) sumtop,
       SUM (CASE WHEN ROWNUM > :top THEN m.summa END) sumnottop,
       COUNT (*) cnt,
       SUM (CASE WHEN ROWNUM <= :top THEN 1 END) cnttop,
       SUM (CASE WHEN ROWNUM > :top THEN 1 END) cntnottop,
       DECODE (
          SUM (CASE WHEN ROWNUM > :top THEN 1 END),
          0, 0,
            SUM (CASE WHEN ROWNUM > :top THEN m.summa END)
          / SUM (CASE WHEN ROWNUM > :top THEN 1 END))
          val
  FROM (  SELECT *
            FROM a14mega m
           WHERE m.dt = TO_DATE (:dt, 'dd.mm.yyyy') AND m.summa > 0
        ORDER BY m.summa DESC) m,
       user_list st
 WHERE     m.tab_num = st.tab_num
       AND m.dpt_id = st.dpt_id
       AND m.dpt_id = :dpt_id
       AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
                           FROM full
                          WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)