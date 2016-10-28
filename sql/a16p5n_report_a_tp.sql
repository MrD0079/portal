/* Formatted on 26/04/2016 13:52:02 (QP5 v5.252.13127.32867) */
  SELECT n.tp_kod,
         m4.eta fio_eta,
         m4.tp_ur,
         m4.tp_addr,
         tp.bonus_sum1,
         TO_CHAR (tp.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief_date,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief,
         fn_getname ( (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn,
         CASE
            WHEN st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE ( :tn, -1, master, :tn))
            THEN
               1
         END
            enabled
    FROM a16p5net d,
         user_list st,
         a16p5net_select net,
         a16p5n_nettp tp,
         a14mega m3,
         a14mega m4,
         tp_nets n
   WHERE     m4.tab_num = st.tab_num
         AND st.dpt_id = :dpt_id
         AND n.h_net = net.net_kod
         AND n.tp_kod = tp.tp_kod(+)
         AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) = m4.h_eta
         /*AND DECODE ( :ok_bonus, 0, 0, DECODE (tp.bonus_dt1, NULL, 2, 1)) =
                :ok_bonus*/
         AND n.tp_kod = m3.tp_kod(+)
         AND m3.dt(+) = TO_DATE ('01/03/2016', 'dd/mm/yyyy')
         AND n.tp_kod = m4.tp_kod
         AND m4.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy')
         AND n.tp_kod = n.tp_kod
         AND d.net_name = n.net
         AND n.h_net = :h_net
ORDER BY n.tp_kod