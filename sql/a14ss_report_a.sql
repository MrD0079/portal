/* Formatted on 27/12/2014 10:12:01 (QP5 v5.227.12220.39724) */
  SELECT tp.tp_kod,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         CASE
            WHEN :month = 10 THEN pb.b10
            WHEN :month = 11 THEN pb.b11
            WHEN :month = 12 THEN pb.b12
         END
            bonus_plan,
         CASE
            WHEN :month = 10 THEN pb.p10
            WHEN :month = 11 THEN pb.p11
            WHEN :month = 12 THEN pb.p12
         END
            plan,
           d.sales
         - NVL (ny.summny, 0)
         - NVL (xs.summnds, 0)
         - NVL (z.sales, 0)
         - NVL (ny1412.sales, 0)
         - NVL (s7.sales, 0)
            fakt,
         DECODE (
            NVL (
               CASE
                  WHEN :month = 10 THEN pb.p10
                  WHEN :month = 11 THEN pb.p11
                  WHEN :month = 12 THEN pb.p12
               END,
               0),
            0, 0,
              (  d.sales
               - NVL (ny.summny, 0)
               - NVL (xs.summnds, 0)
               - NVL (z.sales, 0)
               - NVL (ny1412.sales, 0)
               - NVL (s7.sales, 0))
            / CASE
                 WHEN :month = 10 THEN pb.p10
                 WHEN :month = 11 THEN pb.p11
                 WHEN :month = 12 THEN pb.p12
              END
            * 100)
            perc,
         CASE
            WHEN :month = 10 THEN tp.bonus_sum10
            WHEN :month = 11 THEN tp.bonus_sum11
            WHEN :month = 12 THEN tp.bonus_sum12
         END
            bonus_sum1,
         CASE
            WHEN :month = 10 THEN pb.b10
            WHEN :month = 11 THEN pb.b11
            WHEN :month = 12 THEN pb.b12
         END
            max_bonus,
         TO_CHAR (
            CASE
               WHEN :month = 10 THEN tp.bonus_dt10
               WHEN :month = 11 THEN tp.bonus_dt11
               WHEN :month = 12 THEN tp.bonus_dt12
            END,
            'dd.mm.yyyy')
            bonus_dt1,
                  (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief_date,
                  (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a14ss d,
         user_list st,
         a14ss_tp_select tp,
         a14ss_pb pb,
         (  SELECT d.tp_kod, SUM (d.summny) summny
              FROM a14ny d, a14ny_action_nakl an, a14ny_tp_select tp
             WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                   AND d.tp_kod = tp.tp_kod
                   AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = tp.m
                   AND tp.m = :month
          GROUP BY d.tp_kod) ny,
         (  SELECT d.tp_kod, SUM (d.summnds) summnds
              FROM a14xs d, a14xs_action_nakl an, a14xs_tp_select tp
             WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                   AND d.tp_kod = tp.tp_kod
                   AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = tp.m
                   AND tp.m = :month
          GROUP BY d.tp_kod) xs,
         (  SELECT z.tp_kod_key, SUM (sales) sales
              FROM a1411z z, a1411z_action_nakl n, a1411z_tp_select tp
             WHERE     z.H_TP_KOD_KEY_DATA_NAKL = n.H_TP_KOD_KEY_DATA_NAKL
                   AND z.tp_kod_key = tp.tp_kod_key
                   AND TO_NUMBER (TO_CHAR (z.data, 'mm')) = :month
          GROUP BY z.tp_kod_key) z,
         (  SELECT z.tp_kod, SUM (sales_dec) sales
              FROM a1412ny z, a1412ny_tp_select tp
             WHERE z.tp_kod = tp.tp_kod AND :month = 12
          GROUP BY z.tp_kod) ny1412,
         (  SELECT z.tp_kod, SUM (summnds) sales
              FROM a1412s7 z, a1412s7_action_nakl n, a1412s7_tp_select tp
             WHERE     z.H_TP_KOD_DATA_NAKL = n.H_TP_KOD_DATA_NAKL
                   AND z.tp_kod = tp.tp_kod
                   AND TO_NUMBER (TO_CHAR (z.data, 'mm')) = :month
          GROUP BY z.tp_kod) s7,
         (SELECT tp_kod_key, sales
            FROM a14ss
           WHERE m = 10) s10,
         (SELECT tp_kod_key, sales
            FROM a14ss
           WHERE m = 11) s11,
         (SELECT tp_kod_key, sales
            FROM a14ss
           WHERE m = 12) s12
   WHERE     d.tp_kod = pb.tp_kod
         AND pb.tp_kod_sw = ny.tp_kod(+)
         AND d.tp_kod_key = xs.tp_kod(+)
         AND d.tp_kod_key = z.tp_kod_key(+)
         AND d.tab_num = st.tab_num
         AND st.dpt_id = :dpt_id
         AND d.tp_kod = tp.tp_kod
         AND d.m = :month
         AND d.tp_kod_key = s10.tp_kod_key(+)
         AND d.tp_kod_key = s11.tp_kod_key(+)
         AND d.tp_kod_key = s12.tp_kod_key(+)
         AND d.tp_kod_key = ny1412.tp_kod(+)
         AND d.tp_kod_key = s7.tp_kod(+)
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                DECODE (
                   :ok_bonus,
                   1, 0,
                   2, DECODE (
                         CASE
                            WHEN :month = 10 THEN tp.bonus_dt10
                            WHEN :month = 11 THEN tp.bonus_dt11
                            WHEN :month = 12 THEN tp.bonus_dt12
                         END,
                         NULL, 0,
                         1),
                   3, DECODE (
                         CASE
                            WHEN :month = 10 THEN tp.bonus_dt10
                            WHEN :month = 11 THEN tp.bonus_dt11
                            WHEN :month = 12 THEN tp.bonus_dt12
                         END,
                         NULL, 0,
                         1))
         AND CASE
                WHEN :month = 10
                THEN
                   1
                WHEN     :month = 11
                     AND DECODE (NVL (pb.p10, 0),
                                 0, 0,
                                 s10.sales / pb.p10 * 100) >= 100
                THEN
                   1
                WHEN     :month = 12
                     AND DECODE (NVL (pb.p10, 0),
                                 0, 0,
                                 s10.sales / pb.p10 * 100) >= 100
                     AND DECODE (NVL (pb.p11, 0),
                                 0, 0,
                                 s11.sales / pb.p11 * 100) >= 100
                THEN
                   1
             END = 1
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         d.tp_ur,
         d.tp_addr