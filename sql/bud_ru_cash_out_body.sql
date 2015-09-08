/* Formatted on 11.11.2013 15:16:30 (QP5 v5.227.12220.39724) */
           SELECT st.id st,
                  st.name,
                  b.plan,
                  b.fakt,
                  b.text,
                  b.zd_fakt,
                  b.zd_text,
                  b.id,
                  st.parent
             FROM bud_ru_st_ras st,
                  (SELECT *
                     FROM bud_ru_cash_out_body
                    WHERE head_id = :id) b
            WHERE b.st(+) = st.id AND st.dpt_id = :dpt_id
       START WITH st.parent = 0
       CONNECT BY PRIOR st.id = st.parent
ORDER SIBLINGS BY st.sort