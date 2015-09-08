/* Formatted on 25.12.2013 15:55:17 (QP5 v5.227.12220.39724) */
  SELECT d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.tp_addr,
         NVL (tp.selected, 0) selected_if1,
         tp.bonus_sum1,
         TO_CHAR (tp.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         TO_CHAR (tp.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         TO_CHAR (tp.ok_traid_date, 'dd.mm.yyyy hh24:mi:ss') ok_traid_date,
         tp.ok_chief,
         tp.ok_traid,
         tp.ok_traid_fio,
         NVL (tp.ok_chief_fio,
              fn_getname (
                           (SELECT parent
                              FROM parents
                             WHERE tn = st.tn)))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn,
         d.salesnov,
         d.salesdec - NVL (hc.summa, 0) - NVL (oy.summa, 0) - NVL (sn.summa, 0)
            salesdec,
         CASE
            WHEN       d.salesdec
                     - NVL (hc.summa, 0)
                     - NVL (oy.summa, 0)
                     - NVL (sn.summa, 0)
                     - d.salesnov > 0
                 AND d.salesnov > 0
            THEN
               TRUNC (
                    (    (  d.salesdec
                          - NVL (hc.summa, 0)
                          - NVL (oy.summa, 0)
                          - NVL (sn.summa, 0))
                       / d.salesnov
                     - 1)
                  * 100)
            ELSE
               0
         END
            rost,
         CASE
            WHEN     CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END >= 20
                 AND CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END < 30
            THEN
               0.05
            WHEN     CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END >= 30
                 AND CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END < 40
            THEN
               0.06
            WHEN     CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END >= 40
                 AND CASE
                        WHEN       d.salesdec
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - d.salesnov > 0
                             AND d.salesnov > 0
                        THEN
                           TRUNC (
                                (    (  d.salesdec
                                      - NVL (hc.summa, 0)
                                      - NVL (oy.summa, 0)
                                      - NVL (sn.summa, 0))
                                   / d.salesnov
                                 - 1)
                              * 100)
                        ELSE
                           0
                     END < 50
            THEN
               0.07
            WHEN CASE
                    WHEN       d.salesdec
                             - NVL (hc.summa, 0)
                             - NVL (oy.summa, 0)
                             - NVL (sn.summa, 0)
                             - d.salesnov > 0
                         AND d.salesnov > 0
                    THEN
                       TRUNC (
                            (    (  d.salesdec
                                  - NVL (hc.summa, 0)
                                  - NVL (oy.summa, 0)
                                  - NVL (sn.summa, 0))
                               / d.salesnov
                             - 1)
                          * 100)
                    ELSE
                       0
                 END >= 50
            THEN
               0.08
         END
            koef,
           CASE
              WHEN     CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END >= 20
                   AND CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END < 30
              THEN
                 0.05
              WHEN     CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END >= 30
                   AND CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END < 40
              THEN
                 0.06
              WHEN     CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END >= 40
                   AND CASE
                          WHEN       d.salesdec
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0)
                                   - d.salesnov > 0
                               AND d.salesnov > 0
                          THEN
                             TRUNC (
                                  (    (  d.salesdec
                                        - NVL (hc.summa, 0)
                                        - NVL (oy.summa, 0)
                                        - NVL (sn.summa, 0))
                                     / d.salesnov
                                   - 1)
                                * 100)
                          ELSE
                             0
                       END < 50
              THEN
                 0.07
              WHEN CASE
                      WHEN       d.salesdec
                               - NVL (hc.summa, 0)
                               - NVL (oy.summa, 0)
                               - NVL (sn.summa, 0)
                               - d.salesnov > 0
                           AND d.salesnov > 0
                      THEN
                         TRUNC (
                              (    (  d.salesdec
                                    - NVL (hc.summa, 0)
                                    - NVL (oy.summa, 0)
                                    - NVL (sn.summa, 0))
                                 / d.salesnov
                               - 1)
                            * 100)
                      ELSE
                         0
                   END >= 50
              THEN
                 0.08
           END
         * (  d.salesdec
            - NVL (hc.summa, 0)
            - NVL (oy.summa, 0)
            - NVL (sn.summa, 0))
            bonusplan
    FROM a13_nv d,
         user_list st,
         a13_nv_tp_select tp,
         (  SELECT d.tp_kod, SUM (d.summa) summa
              FROM a13_hc d, a13_hc_action_nakl an, a13_hc_tp_select tp
             WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                   AND d.tp_kod = tp.tp_kod
                   AND an.if1 = 1
                   AND TRUNC (d.data, 'mm') =
                          TO_DATE ('01.12.2013', 'dd.mm.yyyy')
          GROUP BY d.tp_kod) hc,
         (  SELECT d.tp_kod, SUM (d.summa) summa
              FROM a13_oy d, a13_oy_action_nakl an, a13_oy_tp_select tp
             WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                   AND d.tp_kod = tp.tp_kod
                   AND an.if1 = 1
                   AND TRUNC (d.data, 'mm') =
                          TO_DATE ('01.12.2013', 'dd.mm.yyyy')
          GROUP BY d.tp_kod) oy,
         (  SELECT d.tp_kod, SUM (d.summa) summa
              FROM a13_sn d, a13_sn_action_nakl an, a13_sn_tp_select tp
             WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                   AND d.tp_kod = tp.tp_kod
                   AND an.if1 = 1
                   AND TRUNC (d.data, 'mm') =
                          TO_DATE ('01.12.2013', 'dd.mm.yyyy')
          GROUP BY d.tp_kod) sn
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn,
                                                   -1, (SELECT MAX (tn)
                                                          FROM user_list
                                                         WHERE is_admin = 1),
                                                   :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = DECODE (:tn,
                                      -1, (SELECT MAX (tn)
                                             FROM user_list
                                            WHERE is_admin = 1),
                                      :tn)) = 1)
         AND st.dpt_id = :dpt_id
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_chief,
                        1, 0,
                        2, tp.ok_chief,
                        3, NVL (tp.ok_chief, 0))
         AND tp.selected = 1
         AND d.tp_kod = hc.tp_kod(+)
         AND d.tp_kod = oy.tp_kod(+)
         AND d.tp_kod = sn.tp_kod(+)
ORDER BY parent_fio, ts_fio, fio_eta