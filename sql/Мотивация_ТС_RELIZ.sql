
SELECT (CASE WHEN eta_list.tm_inn IS NOT null
             THEN eta_list.tm_inn
             
             WHEN SVS_PROMO.tm_inn IS NOT null
             THEN SVS_PROMO.tm_inn

             WHEN ma_4_11_11a.tm_inn IS NOT null
             THEN ma_4_11_11a.tm_inn

             ELSE NULL
        END) AS tm_inn,
       (CASE WHEN eta_list.tm_fio IS NOT null
             THEN eta_list.tm_fio

             WHEN SVS_PROMO.tm_fio IS NOT null
             THEN SVS_PROMO.tm_fio

             WHEN ma_4_11_11a.tm_fio IS NOT null
             THEN ma_4_11_11a.tm_fio

             ELSE NULL
        END) AS tm_fio,
       eta_list.ts_inn,
       eta_list.ts_fio,
       --eta_list.H_ETA,
      (CASE WHEN eta_list.ETA IS NOT null
             THEN eta_list.ETA

             WHEN svs_promo.ETA IS NOT NULL
             THEN svs_promo.ETA

             WHEN ma_4_11_11a.ETA IS NOT NULL
             THEN ma_4_11_11a.ETA

             ELSE NULL
        END) AS ETA,
      -- eta_list.ETA,
       /*(CASE WHEN eta_list.filial_id IS NOT null
             THEN eta_list.filial_id

             WHEN SVS_PROMO.FILIAL_ID IS NOT NULL
             THEN SVS_PROMO.FILIAL_ID

             WHEN ma_4_11_11a.FILIAL_ID IS NOT NULL
             THEN ma_4_11_11a.FILIAL_ID

             ELSE NULL
        END) AS filial_id,*/
       (CASE WHEN eta_list.filial_name IS NOT null
             THEN eta_list.filial_name

             WHEN SVS_PROMO.FILIAL_ID IS NOT NULL
             THEN SVS_PROMO.filial_name

             WHEN ma_4_11_11a.FILIAL_ID IS NOT NULL
             THEN ma_4_11_11a.filial_name

             ELSE null
        END) AS filial_name,
        (CASE WHEN eta_list.UNSCHEDULED IS NOT NULL 
              THEN CASE WHEN eta_list.UNSCHEDULED = 0
                        THEN 'ЭТА'
                        ELSE 'ТМР'
                   END

              WHEN SVS_PROMO.UNSCHEDULED IS NOT NULL 
              THEN CASE WHEN SVS_PROMO.UNSCHEDULED = 0
                        THEN 'ЭТА'
                        ELSE 'ТМР'
                   END

              WHEN ma_4_11_11a.UNSCHEDULED IS NOT NULL 
              THEN CASE WHEN ma_4_11_11a.UNSCHEDULED = 0
                        THEN 'ЭТА'
                        ELSE 'ТМР'
                   END
               
        END) AS position,
       eta_list.ETA_TAB_NUMBER,
       eta_list.gsm_total,
       MA_PROMO.BONUS_FAKT as BONUS_MA_PROMO,
       SVS_PROMO.BONUS_FAKT as BONUS_SVS_PROMO,
       MA_4_11_11A.COMPENS_DISTR AS MA_4_11_11A_COMPENS_DISTR,
       COUNT(ETA_LIST.H_ETA) OVER(PARTITION BY ETA_LIST.H_ETA)
FROM ( /* Топливный Фонд */ 
        SELECT ts.CHIEF_TN AS tm_inn,
               ts.CHIEF_FIO AS tm_fio,
               ts.tn AS ts_inn,
               ts.FIO AS ts_fio,
               sv.H_ETA,
               eta.fio AS eta,
              /* r.FILIAL_ID AS sales_filial,
               r.filial_name AS  sales_filial,*/
               f.id AS filial_id,
               f.name AS filial_name,
               NVL(SV.UNSCHEDULED, 0) UNSCHEDULED,
               sv.ETA_TAB_NUMBER,
               NVL(SV.fal_payment, 0) + NVL(SV.AMORT, 0) + NVL(SV.gbo_warmup, 0)
               gsm_total

          FROM /*(SELECT DISTINCT M.TAB_NUM,
                                M.H_ETA,
                                M.ETA,
                                M.ETA_TAB_NUMBER,
                                f.id AS filial_id,
                                f.name AS filial_name
                   FROM A14MEGA M
                   INNER JOIN bud_fil f ON f.SW_KOD = m.KOD_FILIAL AND f.kk = 0 AND F.DPT_ID = 1
                   WHERE M.DPT_ID = 1
                     AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT ) R
          INNER JOIN*/ USER_LIST ts /*ON R.TAB_NUM = ts.TAB_NUM*/
          LEFT JOIN BUD_SVOD_ZP SV ON ts.tn = sv.tn --R.H_ETA = SV.H_ETA --and R.FILIAL_ID = sv.FIL
          LEFT JOIN USER_LIST eta ON eta.H_ETA = sv.H_ETA --AND eta.CHIEF_TN = ts.tn
          LEFT JOIN BUD_FIL F ON SV.FIL = F.ID
          LEFT JOIN (SELECT FIL,
                       ok_db_tn
                   FROM BUD_SVOD_TAF
                   WHERE DT = TO_DATE('01.09.2019', 'dd.mm.yyyy')) TAF ON SV.FIL = TAF.FIL
          WHERE ts.IS_TS = 1
            AND ts.DPT_ID = 1
            AND ts.IS_SPD = 1
            AND SV.DT = TO_DATE('01.09.2019', 'dd.mm.yyyy') 
            AND SV.DPT_ID = 1 
            AND sv.unscheduled = 0
            /*AND sv.H_ETA = '834d4e4e2d48223601c737510e81fea7' */
        UNION
        SELECT ts.CHIEF_TN AS tm_inn,
               ts.CHIEF_FIO AS tm_fio,
               ts.tn AS ts_inn,
               ts.FIO AS ts_fio,
               sv.h_eta,
               sv.fio eta,
               f.id AS filial_id,
               f.name AS filial_name,
               NVL (sv.unscheduled, 0) unscheduled,
               sv.eta_tab_number,
               NVL (sv.fal_payment, 0) + NVL (sv.amort, 0) + NVL (sv.gbo_warmup, 0)
                  total1
          FROM USER_LIST ts,
               BUD_SVOD_ZP SV,
               BUD_FIL F,
               (SELECT FIL,
                       ok_db_tn
                   FROM BUD_SVOD_TAF
                   WHERE DT = TO_DATE('01.09.2019', 'dd.mm.yyyy')) TAF
          WHERE SV.FIL = F.ID (+)
            AND SV.FIL = TAF.FIL (+)
            --AND DECODE(:fil, 0, F.ID, :fil) = F.ID
            AND SV.TN = ts.TN
            AND ts.DPT_ID = SV.DPT_ID
            AND ts.IS_SPD = 1
            AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = SV.DT (+)
            AND sv.unscheduled = 1
--AND sv.H_ETA = '834d4e4e2d48223601c737510e81fea7'
        ORDER BY unscheduled NULLS FIRST, tm_fio, ts_fio, eta ) eta_list
LEFT JOIN (/* локальные акции (создается через МА - лок Акции*/
          SELECT M.H_ETA,
                 m.FILIAL_ID,
                 SUM(loc_a.BONUS_SUM) AS bonus_fakt
            FROM PERSIK.AKCII_LOCAL_TP loc_a
              JOIN PERSIK.BUD_RU_ZAY Z ON Z.ID = loc_a.Z_ID
              LEFT JOIN (SELECT DISTINCT M.H_ETA,
                                        M.tp_kod,
                                        f.id AS filial_id
                        FROM A14MEGA M
                        JOIN bud_fil f ON f.SW_KOD = m.KOD_FILIAL AND f.kk = 0 AND F.DPT_ID = 1
                        WHERE M.DPT_ID = 1 AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT) m ON M.TP_KOD = LOC_A.TP_KOD AND m.FILIAL_ID = z.FIL
            WHERE Z.DT_START BETWEEN '01-09-2019' AND '30-09-2019'/* AND M.H_ETA = '89cd65c88e0612584c5cc2b5232afac0' */
            GROUP BY M.H_ETA, m.FILIAL_ID) ma_promo ON MA_PROMO.H_ETA = ETA_LIST.H_ETA AND ETA_LIST.FILIAL_ID = MA_PROMO.FILIAL_ID
FULL OUTER JOIN (/* ТУ */
            SELECT tu.H_ETA,
                   tu.eta, 
                   NVL(sv.UNSCHEDULED,0) AS UNSCHEDULED,
                   tu.filial_id,
                   bf.name AS filial_name,
                   tu.tm_fio,
                   tu.tm_inn,
                   tu.dt,
                   SUM(tu.bonus) AS bonus_fakt
            FROM ( SELECT m.H_ETA,
                          m.eta,
                         --NULL net_kod,
                         bf.BUD_ID AS filial_id,
                        /* sc.**/
                         sc.OK_DB_TN AS tm_inn,
                         sc.OK_DB_FIO AS tm_fio,
                         sc.DT,
                         SUM(sc.BONUS_FAKT) AS bonus
                    FROM PERSIK.SC_SVOD sc
                    LEFT JOIN (SELECT DISTINCT M.H_ETA,
                                               m.ETA,
                                                M.tp_kod,
                                                f1.id AS filial_id
                                FROM A14MEGA M
                                JOIN bud_fil f1 ON f1.SW_KOD = m.KOD_FILIAL AND f1.kk = 0 AND F1.DPT_ID = 1
                                WHERE M.DPT_ID = 1 
                                    AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT  ) m ON M.TP_KOD = sc.TP_KOD
                    JOIN BUD_TN_FIL bf ON bf.tn = sc.OK_DB_TN AND m.filial_id = bf.BUD_ID
                    WHERE sc.ok_db_tn IS NOT NULL
                      AND sc.DT = '01-09-2019' --AND m.H_ETA = '834d4e4e2d48223601c737510e81fea7'
                      GROUP BY m.H_ETA, m.eta, bf.BUD_ID, sc.OK_DB_TN, sc.OK_DB_FIO, sc.DT
                  UNION /* по ТП */
                    SELECT m.H_ETA,
                          m.eta AS eta,
                           --scn.net_kod,
                           bf.BUD_ID AS filial_id,
                           scn.OK_DB_TN AS tm_inn,
                           scn.OK_DB_FIO AS tm_fio,
                           scn.DT,
                           SUM(scn.bonus_fakt) AS bonus
                    FROM PERSIK.SC_SVODN scn
                    LEFT JOIN (SELECT DISTINCT M.H_ETA,
                                               M.eta,
                                                M.tp_kod,
                                                f2.id AS filial_id
                                FROM A14MEGA M
                                JOIN bud_fil f2 ON f2.SW_KOD = m.KOD_FILIAL AND f2.kk = 0 AND F2.DPT_ID = 1
                                WHERE M.DPT_ID = 1 AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT) m ON M.TP_KOD = scn.TP_KOD
                    JOIN BUD_TN_FIL bf ON bf.tn = scn.OK_DB_TN AND m.filial_id = bf.BUD_ID
                    WHERE DT = '01-09-2019' AND SCN.TP_KOD IS NOT NULL
                    GROUP BY m.H_ETA, m.eta, bf.BUD_ID, scn.OK_DB_TN, scn.OK_DB_FIO, scn.DT
                  UNION /* по Сетям */
                    SELECT doli.h_eta,
                          doli.eta AS eta,
                          -- doli.net_kod,
                          doli.filial_id,
                           doli.tm_inn,
                           doli.tm_fio,
                           doli.dt,
                           --doli.BONUS_FACKT_BY_DOLI,
                          -- scn.BONUS_FAKT,
                           (scn.BONUS_FAKT * doli.BONUS_FACKT_BY_DOLI / 100 ) AS bonus
                    FROM ( SELECT M.H_ETA,
                                  m.eta,
                                   scn.NET_KOD,
                                   (CASE WHEN bf.id IS NOT NULL
                                         THEN bf.id
                                         ELSE SCN.FIL
                                   END) AS filial_id,
                                   scn.OK_DB_TN AS tm_inn,
                                   scn.OK_DB_FIO AS tm_fio,
                                   scn.DT,
                                   /*m.summa,
                                    SUM(M.SUMMA) OVER (PARTITION BY scn.NET_KOD , M.H_ETA) AS total_sales_by_eta,
                                   SUM(M.SUMMA) OVER (PARTITION BY scn.NET_KOD) AS total_sales_by_net,*/
                                    ROUND(
                                       CASE WHEN (SUM(M.SUMMA) OVER (PARTITION BY scn.NET_KOD, M.H_ETA)) > 0 THEN SUM(M.SUMMA) OVER (PARTITION BY scn.NET_KOD , M.H_ETA) * 100 / SUM(M.SUMMA) OVER (PARTITION BY scn.NET_KOD) ELSE 0 END
                                       , 2) AS bonus_fackt_by_doli
                              FROM PERSIK.SC_SVODN SCN
                                LEFT JOIN (SELECT DISTINCT N.NET_KOD,
                                                           --M.TP_KOD,
                                                            M_ETA.H_ETA,
                                                            M_ETA.eta,
                                                           --m.tab_num,                                                          
                                                           SUM(m_summa.SUMMA) AS summa,
                                                           --M.SUMMA,
                                                           f.id AS filial_id
                                                           --m.KOD_FILIAL
                                            FROM TP_NETS N
                                            JOIN (  SELECT m.*
                                                    FROM A14MEGA M 
                                                    WHERE (TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT OR TO_DATE('01.08.2019', 'dd.mm.yyyy') = M.DT) AND M.H_ETA IS NOT NULL AND m.DPT_ID = 1
                                                  ) M_ETA ON M_ETA.TP_KOD = N.TP_KOD 
                                            JOIN bud_fil f ON f.SW_KOD = M_ETA.KOD_FILIAL AND f.kk = 0 AND F.DPT_ID = 1
                                            LEFT JOIN a14mega m_summa ON m_summa.TP_KOD = N.TP_KOD  AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = m_summa.DT
                                            WHERE M_ETA.DPT_ID = 1 
                                               --AND n.NET_KOD IN (3741,3709,3645,3505)
                                            GROUP BY n.NET_KOD, M_ETA.H_ETA, M_ETA.eta, f.id ) M
                                  ON m.NET_KOD = scn.NET_KOD
                              LEFT JOIN BUD_FIL bf ON /*bf.tn = scn.OK_DB_TN AND*/ m.filial_id = bf.id
                              WHERE SCN.DT = '01-09-2019' AND SCN.NET_KOD IS NOT NULL AND SCN.OK_DB_TN IS NOT null /*AND SCN.BONUS_FAKT <> 0*/ ) doli
                    LEFT JOIN SC_SVODN scn ON DOLI.NET_KOD = scn.NET_KOD AND scn.dt = doli.dt AND doli.FILIAL_ID = scn.FIL
                    GROUP BY doli.h_eta, doli.eta, doli.filial_id, doli.dt, doli.tm_inn, doli.tm_fio, (scn.BONUS_FAKT * doli.BONUS_FACKT_BY_DOLI / 100 ) ) tu
            LEFT JOIN BUD_FIL bf ON bf.id = tu.FILIAL_ID AND bf.DPT_ID = 1
            LEFT JOIN BUD_TN_FIL btn ON btn.BUD_ID = bf.id
            LEFT JOIN BUD_SVOD_ZP SV ON tu.h_eta = sv.H_ETA AND SV.DT = TO_DATE('01.09.2019', 'dd.mm.yyyy') 
            --LEFT JOIN USER_LIST tm ON tm.tn = btn.tn AND tm.DPT_ID = 1
            GROUP BY tu.H_ETA, tu.eta, NVL(sv.UNSCHEDULED,0), tu.filial_id, bf.name, tu.tm_fio, tu.tm_inn, tu.dt
            HAVING SUM(tu.bonus) IS NOT null) svs_promo ON SVS_PROMO.H_ETA = ETA_LIST.H_ETA AND SVS_PROMO.FILIAL_ID = ETA_LIST.FILIAL_ID
FULL OUTER JOIN (/* МА (статьи затрат: 4,11,11a)*/
            SELECT MA_4_11_11A.FILIAL_ID,
                   MA_4_11_11A.filial_name,
                   MA_4_11_11A.INN_SOZDATELYA AS TM_INN,
                   MA_4_11_11A.FIO_sozdatelya AS TM_FIO,
                   MA_4_11_11A.H_ETA,
                   eta.fio AS eta,
                   NVL(sv.UNSCHEDULED, 0) AS UNSCHEDULED,
                   SUM(MA_4_11_11A.COMPENS_DISTR) AS COMPENS_DISTR
              FROM (SELECT Z.ID,
                           Z.CREATED,
                           Z.COST_ASSIGN_MONTH,
                           FIL.NAME AS FILIAL_NAME,
                           FIL.ID AS FILIAL_ID,
                           FUNDS.KOD,
                           FUNDS.NAME AS FUND_NAME,
                           US.TN AS INN_SOZDATELYA,
                           US.FIO AS FIO_sozdatelya,
                           Z.DT_START,
                           Z.DT_END,
                           ST_R.NAME AS STATYA_NAME,
                           ZATRATI.tovarom,
                           ZATRATI.fact_zatrat,
                           --zatrati.COMPENS_DISTR,
                           M_NETS_TP.dolya_prodazh_persent,
                           (CASE WHEN DATA2.tp_or_set = 'Единичное' THEN ZATRATI.COMPENS_DISTR ELSE CASE WHEN M_NETS_TP.dolya_prodazh_persent IS NOT NULL THEN ZATRATI.COMPENS_DISTR * M_NETS_TP.dolya_prodazh_persent / 100 ELSE ZATRATI.FACT_ZATRAT END END) AS COMPENS_DISTR,
                           DATA2.tp_or_set,
                           DATA3.tp_or_set_name,
                           DATA3.tp_or_set_kod,
                           FIL.SW_KOD,
                           (CASE WHEN DATA2.tp_or_set = 'Единичное' THEN M_TP.H_ETA WHEN DATA2.tp_or_set = 'Сетевое' THEN M_NETS_TP.H_ETA ELSE '-' END) AS H_ETA,
                           M_NETS_TP.NET_KOD
                  FROM PERSIK.BUD_RU_ZAY Z
                    LEFT JOIN BUD_FUNDS FUNDS
                      ON FUNDS.ID = Z.FUNDS
                    JOIN PERSIK.BUD_RU_ST_RAS ST_R
                      ON ST_R.ID = Z.ST
                    LEFT JOIN PERSIK.BUD_FIL FIL
                      ON FIL.ID = Z.FIL AND fil.kk = 0
                    LEFT JOIN PERSIK.USER_LIST US
                      ON US.TN = Z.TN
                    JOIN (SELECT Z_ID,
                                 COUNT(*) K,
                                 SUM(CASE WHEN REP_ACCEPTED = 2 THEN -100 ELSE REP_ACCEPTED END) ACP,
                                 MAX(REP_LU) M_D
                        FROM PERSIK.BUD_RU_ZAY_ACCEPT
                        WHERE TN <> 2923402273 /*убираем Романа из согласователей*/ 
                        GROUP BY Z_ID) ACP
                      ON ACP.Z_ID = Z.ID
                    LEFT JOIN (SELECT ZF.Z_ID,
                                      (NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv3')), 0) + NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv4')), 0)) FACT_ZATRAT,
                                      NVL(TO_NUMBER(GETZAYFIELDVAL(ZF.Z_ID, 'admin_id', 8)), 0) TOVAROM,
                                      CASE WHEN NVL(TO_NUMBER(GETZAYFIELDVAL(ZF.Z_ID, 'admin_id', 9)), 0) = 1 /* via_db */
                                          THEN 0 ELSE CASE WHEN NVL(TO_NUMBER(GETZAYFIELDVAL(ZF.Z_ID, 'admin_id', 8)), 0) = 0  /* tovarom */
                                              THEN NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv3')), 0) + NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv4')), 0) /* fact_zatrat */
                                            ELSE (NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv3')), 0) + NVL((GETZAYFIELDVAL(ZF.Z_ID, 'rep_var_name', 'rv4')), 0)) /* fact_zatrat */
                                              * (1
                                              - NVL((SELECT DISCOUNT
                                                  FROM BUD_FIL_DISCOUNT_BODY
                                                  WHERE DT =
                                                    TRUNC((SELECT DISTINCT DT_START
                                                        FROM PERSIK.BUD_RU_ZAY
                                                        WHERE ID = ZF.Z_ID),
                                                    'mm')
                                                    AND DISTR = (SELECT DISTINCT FIL
                                                        FROM PERSIK.BUD_RU_ZAY
                                                        WHERE ID = ZF.Z_ID)),
                                              0)
                                              / 100)
                                              * (SELECT BONUS_LOG_KOEF
                                                  FROM BUD_FIL
                                                  WHERE ID = (SELECT DISTINCT FIL
                                                        FROM PERSIK.BUD_RU_ZAY
                                                        WHERE ID = ZF.Z_ID)) END END
                                      COMPENS_DISTR
                        FROM (SELECT ZF.Z_ID
                            FROM PERSIK.BUD_RU_ZAY_FF ZF
                              JOIN PERSIK.BUD_RU_FF F
                                ON F.ID = ZF.FF_ID
                            WHERE F.NAME IN ('ПЛАН сумма затрат "АВК" (тыс. грн.) в ценах прайса', 'ПЛАН сумма затрат АВК, тыс.грн.', 'Товаром')
                            --AND  zf.Z_ID = 190827913
                            GROUP BY ZF.Z_ID) ZF
                        GROUP BY zf.Z_ID) ZATRATI
                      ON ZATRATI.Z_ID = Z.ID
                    LEFT JOIN (SELECT ZF.Z_ID,
                                      NVL(VAL_LIST_NAME, 0) TP_OR_SET,
                                      NVL(VAL_LIST, 0) KOD_TP_OR_SET
                        FROM PERSIK.BUD_RU_ZAY_FF ZF
                          JOIN PERSIK.BUD_RU_FF F
                            ON F.ID = ZF.FF_ID
                        WHERE F.NAME IN ('Единичное / сетевое ТП')) DATA2
                      ON DATA2.Z_ID = Z.ID
                    LEFT JOIN (SELECT ZF.Z_ID,
                                      NVL(VAL_LIST_NAME, 0) TP_OR_SET_NAME,
                                      NVL(VAL_LIST, 0) TP_OR_SET_KOD
                        FROM PERSIK.BUD_RU_ZAY_FF ZF
                          JOIN PERSIK.BUD_RU_FF F
                            ON F.ID = ZF.FF_ID
                        WHERE F.NAME IN ('Название сети', 'Название ТП')) DATA3
                      ON DATA3.Z_ID = Z.ID
                    LEFT JOIN (SELECT DISTINCT M.H_ETA,
                                               M.TP_KOD
                        FROM A14MEGA M
                        WHERE M.DPT_ID = 1
                          AND (TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT OR TO_DATE('01.08.2019', 'dd.mm.yyyy') = M.DT) AND M.H_ETA IS NOT NULL) M_TP
                      ON M_TP.TP_KOD = DATA3.tp_or_set_kod
                    LEFT JOIN (SELECT M.*,
                                      ROUND(
                                      CASE WHEN (SUM(M.SUMMA) OVER (PARTITION BY m.KOD_FILIAL, m.NET_KOD)) > 0 THEN M.SUMMA * 100 / SUM(M.SUMMA) OVER (PARTITION BY m.KOD_FILIAL, M.NET_KOD) ELSE 100 / COUNT(M.H_ETA) OVER (PARTITION BY m.KOD_FILIAL, M.NET_KOD) END, 2) AS DOLYA_PRODAZH_PERSENT
                        FROM (SELECT DISTINCT M.KOD_FILIAL,
                                              TPN.NET_KOD,
                                              M.H_ETA,
                                              SUM(NVL(M.SUMMA,0)) AS SUMMA
                            FROM TP_NETS TPN
                              JOIN A14MEGA M ON M.TP_KOD = TPN.TP_KOD AND TO_DATE('01.09.2019', 'dd.mm.yyyy') = M.DT
                            WHERE M.DPT_ID = 1 --AND TPN.NET_KOD = 172
                            GROUP BY M.KOD_FILIAL,
                                     TPN.NET_KOD,
                                     M.H_ETA
                            HAVING SUM(NVL(M.SUMMA,0)) IS NOT NULL) M) M_NETS_TP
                      ON M_NETS_TP.NET_KOD = DATA3.tp_or_set_kod
                      AND M_NETS_TP.KOD_FILIAL = FIL.SW_KOD
                  WHERE ST_R.NAME IN ('Ст. 4 "Программа возврат"', 'Ст. 11 "Ретробонус"', 'Ст 11/а разовые НТУ')
                    AND Z.DT_START BETWEEN '01-09-2019' AND '30-09-2019' /* конечная дата это последний день месяца */
                    AND Z.REPORT_DONE = 1
                    AND ACP.k > 0
                    AND ACP.ACP = acp.k
                    AND fil.kk = 0 
                    AND Fil.DPT_ID = 1
                  ORDER BY 4) MA_4_11_11A
              LEFT JOIN USER_LIST eta ON MA_4_11_11A.H_ETA = ETA.H_ETA AND eta.DPT_ID = 1
              LEFT JOIN BUD_SVOD_ZP SV ON eta.h_eta = sv.H_ETA AND SV.DT = TO_DATE('01.09.2019', 'dd.mm.yyyy') 
              /*WHERE MA_4_11_11A.H_ETA = '89cd65c88e0612584c5cc2b5232afac0'*/
              GROUP BY MA_4_11_11A.FILIAL_ID,
                       MA_4_11_11A.filial_name,
                       MA_4_11_11A.INN_SOZDATELYA,
                       MA_4_11_11A.FIO_sozdatelya,
                       MA_4_11_11A.H_ETA,
                       eta.fio,
                       NVL(sv.UNSCHEDULED, 0)
               ORDER BY MA_4_11_11A.filial_name ) ma_4_11_11a 
            ON MA_4_11_11A.H_ETA = ETA_LIST.H_ETA AND MA_4_11_11A.FILIAL_ID = ETA_LIST.FILIAL_ID AND MA_4_11_11A.TM_INN = ETA_LIST.TM_INN;
