/* Formatted on 17.04.2014 16:00:55 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         DECODE (a1404bumtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1404bumtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = d.tp_kod AND ROWNUM = 1))
            contact_lpr,
         NVL (d.jan_feb, 0) jan_feb,
           NVL (d.mar_apr, 0)
         - NVL (cp.summa, 0)
         - NVL (oy.summa, 0)
         - NVL (vc.summa, 0)
         - NVL (oy4.summa, 0)
            mar_apr
    FROM a1404bum_tp_select a1404bumtps,
         a1404bum d,
         user_list st,
         (  SELECT t1.tp_kod,
                   t1.tab_num,
                   t1.h_fio_eta,
                   SUM (summa) summa
              FROM user_list st,
                   a1403cp t1,
                   a1403cp_action_nakl t2,
                   a1403cp_tp_select t3
             WHERE     st.tab_num = t1.tab_num
                   AND t3.tp_kod = t1.tp_kod
                   AND t2.H_TP_KOD_DATA_NAKL = t1.H_TP_KOD_DATA_NAKL
                   AND t2.if1 = 1
                   AND t1.data BETWEEN TO_DATE ('01.03.2014', 'dd.mm.yyyy')
                                   AND TO_DATE ('30.04.2014', 'dd.mm.yyyy')
                   AND st.dpt_id = :dpt_id
          GROUP BY t1.tp_kod, t1.tab_num, t1.h_fio_eta) cp,
         (  SELECT t1.tp_kod,
                   t1.tab_num,
                   t1.h_fio_eta,
                   SUM (summa) summa
              FROM user_list st,
                   a1403oy t1,
                   a1403oy_action_nakl t2,
                   a1403oy_tp_select t3
             WHERE     st.tab_num = t1.tab_num
                   AND t3.tp_kod = t1.tp_kod
                   AND t2.H_TP_KOD_DATA_NAKL = t1.H_TP_KOD_DATA_NAKL
                   AND t2.if1 = 1
                   AND t1.data BETWEEN TO_DATE ('01.03.2014', 'dd.mm.yyyy')
                                   AND TO_DATE ('30.04.2014', 'dd.mm.yyyy')
                   AND st.dpt_id = :dpt_id
          GROUP BY t1.tp_kod, t1.tab_num, t1.h_fio_eta) oy,
         (  SELECT t1.tp_kod,
                   t1.tab_num,
                   t1.h_fio_eta,
                   SUM (summa) summa
              FROM user_list st,
                   a1403vc t1,
                   a1403vc_action_nakl t2,
                   a1403vc_tp_select t3
             WHERE     st.tab_num = t1.tab_num
                   AND t3.tp_kod = t1.tp_kod
                   AND t2.H_TP_KOD_DATA_NAKL = t1.H_TP_KOD_DATA_NAKL
                   AND t2.if1 = 1
                   AND t1.data BETWEEN TO_DATE ('01.03.2014', 'dd.mm.yyyy')
                                   AND TO_DATE ('30.04.2014', 'dd.mm.yyyy')
                   AND st.dpt_id = :dpt_id
          GROUP BY t1.tp_kod, t1.tab_num, t1.h_fio_eta) vc,
         (  SELECT t1.tp_kod,
                   t1.tab_num,
                   t1.h_fio_eta,
                   SUM (summa) summa
              FROM user_list st,
                   a1404oy t1,
                   a1404oy_action_nakl t2,
                   a1404oy_tp_select t3
             WHERE     st.tab_num = t1.tab_num
                   AND t3.tp_kod = t1.tp_kod
                   AND t2.H_TP_KOD_DATA_NAKL = t1.H_TP_KOD_DATA_NAKL
                   AND t2.if1 = 1
                   AND t1.data BETWEEN TO_DATE ('01.03.2014', 'dd.mm.yyyy')
                                   AND TO_DATE ('30.04.2014', 'dd.mm.yyyy')
                   AND st.dpt_id = :dpt_id
          GROUP BY t1.tp_kod, t1.tab_num, t1.h_fio_eta) oy4
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND d.tp_kod = a1404bumtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND d.tp_kod = cp.tp_kod(+)
         AND d.tab_num = cp.tab_num(+)
         AND d.h_fio_eta = cp.h_fio_eta(+)
         AND d.tp_kod = oy.tp_kod(+)
         AND d.tab_num = oy.tab_num(+)
         AND d.h_fio_eta = oy.h_fio_eta(+)
         AND d.tp_kod = vc.tp_kod(+)
         AND d.tab_num = vc.tab_num(+)
         AND d.h_fio_eta = vc.h_fio_eta(+)
         AND d.tp_kod = oy4.tp_kod(+)
         AND d.tab_num = oy4.tab_num(+)
         AND d.h_fio_eta = oy4.h_fio_eta(+)
GROUP BY d.tab_num,
         st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         a1404bumtps.contact_lpr,
         DECODE (a1404bumtps.tp_kod, NULL, NULL, 1),
         d.jan_feb,
         d.mar_apr,
         cp.summa,
         oy.summa,
         vc.summa,
         oy4.summa
ORDER BY st.fio, d.fio_eta, d.tp_ur