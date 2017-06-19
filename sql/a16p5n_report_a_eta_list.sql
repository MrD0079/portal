/* Formatted on 20/04/2016 14:53:38 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT m.eta fio_eta, m.h_eta h_fio_eta
    FROM a16p5net_select s,
         a16p5net,
         user_list st,
         a14mega m,
         tp_nets n
   WHERE     m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a16p5net.net_kod = s.net_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND m.tp_kod = n.tp_kod
         AND a16p5net.net_name = n.net
         AND m.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy')
ORDER BY m.eta