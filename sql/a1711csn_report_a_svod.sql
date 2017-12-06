/* Formatted on 05.12.2017 16:53:45 (QP5 v5.252.13127.32867) */
BEGIN
   INSERT INTO act_ok (act,
                       tn,
                       m,
                       fil,
                       part1)
      SELECT DISTINCT 'a1711csn',
                      :tn,
                      11,
                      f.id,
                      1
        FROM a1711csn d,
             user_list st,
             a1711csn_select tp,
             bud_fil f
       WHERE     d.tab_num = st.tab_num
             AND (st.tn IN (SELECT slave
                              FROM full
                             WHERE master = :tn))
             AND st.dpt_id = 1
             AND st.is_spd = 1
             AND d.net_kod = tp.net_kod
             AND tp.bonus_dt1 IS NOT NULL
             AND d.kod_filial = f.sw_kod;

   INSERT INTO act_svodn (act,
                          m,
                          sales,
                          bonus,
                          net_kod,
                          net_name,
                          fil_kod,
                          fil_name,
                          fio_ts,
                          ts_tab_num,
                          fio_db,
                          db_tn)
        SELECT :act act,
               :month m,
               d.fact sales,
               tp.bonus_sum1 bonus,
               d.net_kod,
               d.net_name,
               f.id fil_kod,
               f.name fil_name,
               fio_ts,
               d.tab_num ts_tab_num,
               fn_getname ( :tn) fio_db,
               :tn db_tn
          FROM a1711csn d,
               user_list st,
               a1711csn_select tp,
               bud_fil f
         WHERE     d.tab_num = st.tab_num
               AND (st.tn IN (SELECT slave
                                FROM full
                               WHERE master = :tn))
               AND st.dpt_id = 1
               AND st.is_spd = 1
               AND d.net_kod = tp.net_kod(+)
               AND tp.bonus_dt1 IS NOT NULL
               AND d.kod_filial = f.sw_kod
      ORDER BY fil_name, net_name;

   COMMIT;
END;