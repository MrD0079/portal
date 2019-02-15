--SELECT COUNT(z_id), COUNT(DISTINCT(z_id)) FROM(
--SELECT * FROM(
SELECT z.*
    FROM (SELECT 
                 z.id z_id,
                 TO_CHAR (z.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (z.dt_start, 'dd.mm.yyyy') dt_start,
                 TO_CHAR (z.dt_end, 'dd.mm.yyyy') dt_end,
                 TO_CHAR (z.report_data, 'dd.mm.yyyy') report_data,
                 CASE WHEN TRUNC (SYSDATE) <= TRUNC (z.report_data) THEN 1 ELSE 0 END
                    srok_ok /*,
                TO_CHAR (z.report_data_lu, 'dd.mm.yyyy hh24:mi:ss')
                    report_data_lu,
                 z.report_done,
                 TO_CHAR (z.report_done_lu, 'dd.mm.yyyy hh24:mi:ss')
      
                    report_done_lu,
                 (SELECT fio
                    FROM PERSIK.user_list
                   WHERE tn = z.report_data_tn)
                    report_data_fio,
                 z.report_data_text,
                 z.sup_doc,
                 u.phone,
                 u.e_mail,
                 u.skype,
                 z.rm_fio,
                 z.rm_tn ,
                z.created created_dt
      ,
                 z.valid_no,
                 z.valid_tn,
                 PERSIK.fn_getname (z.valid_tn) valid_fio,
                 TO_CHAR (z.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
                 z.valid_text
      */
                 ,PERSIK.fn_getname (z.tn) creator/*,
                 z.tn creator_tn,
                 z.recipient recipient_tn*/,
                 PERSIK.fn_getname (z.recipient) recipient/*,
                 za.tn acceptor_tn,
                 PERSIK.fn_getname (za.tn) acceptor_name,
                 za.rep_accepted accepted,
                 za.rep_failure failure
                 ,za.accept_order,
                 zat.name accepted_name,
                 DECODE (za.rep_accepted,
                         0, NULL,
                         TO_CHAR (za.rep_lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 ,DECODE ( (SELECT COUNT (*)
                             FROM PERSIK.bud_ru_zay_accept
                            WHERE z_id = z.id AND rep_accepted = 2 AND PERSIK.INN_not_ReportMA (tn) = 0),
                         0, 0,
                         1)
                    deleted*/,
                 (SELECT accepted status
                  FROM PERSIK.bud_ru_zay_accept
                  WHERE     z_id = z.id
                       AND accept_order =
                               (
                                      SELECT MAX(accept_order) ac_order
                                      FROM PERSIK.bud_ru_zay_accept
                                      WHERE z_id = z.id 
                              )
                  ) status  /* 0 - not yet accepted, 1 - accepted, 2 - rejected  */ 
                  /*, 
                 (SELECT rep_accepted
                    FROM PERSIK.bud_ru_zay_accept
                   WHERE     z_id = z.id AND PERSIK.INN_not_ReportMA (tn) = 0
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM PERSIK.bud_ru_zay_accept
                                        WHERE z_id = z.id AND rep_accepted = 2 AND PERSIK.INN_not_ReportMA (tn) = 0),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM PERSIK.bud_ru_zay_accept
                                        WHERE     z_id = z.id
                                              AND rep_accepted IS NOT NULL AND PERSIK.INN_not_ReportMA (tn) = 0),
                                   (SELECT MAX (accept_order)
                                      FROM PERSIK.bud_ru_zay_accept
                                     WHERE z_id = z.id AND rep_accepted = 2 AND PERSIK.INN_not_ReportMA (tn) = 0)))
                    current_accepted_id,
                 (SELECT tn
                    FROM PERSIK.bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM PERSIK.bud_ru_zay_accept
                                  WHERE z_id = z.id AND rep_accepted = 0 AND PERSIK.INN_not_ReportMA (tn) = 0))
                    current_acceptor_tn,
                 (SELECT id
                    FROM PERSIK.bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM PERSIK.bud_ru_zay_accept
                                  WHERE z_id = z.id AND rep_accepted = 0 AND PERSIK.INN_not_ReportMA (tn) = 0))
                    current_accept_id/*,
                 (SELECT lu
                    FROM PERSIK.bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM PERSIK.bud_ru_zay_accept
                                        WHERE z_id = z.id AND rep_accepted = 2 AND PERSIK.INN_not_ReportMA (tn) = 0),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM PERSIK.bud_ru_zay_accept
                                        WHERE     z_id = z.id
                                              AND rep_accepted IS NOT NULL AND PERSIK.INN_not_ReportMA (tn) = 0),
                                   (SELECT MAX (accept_order)
                                      FROM PERSIK.bud_ru_zay_accept
                                     WHERE z_id = z.id AND rep_accepted = 2 AND PERSIK.INN_not_ReportMA (tn) = 0)))
                    current_accepted_date,

                 
                 z.st st_id,
                 z.kat kat_id,
                 st.name st_name,
                 kat.name kat_name,
                
                 DECODE ( (SELECT COUNT (*)
                             FROM PERSIK.bud_ru_zay_accept
                            WHERE z_id = z.id AND rep_accepted <> 0 AND PERSIK.INN_not_ReportMA (tn) = 0),
                         0, 1,
                         0)
                    not_seen,

                 u.pos_id*/,
                 u.pos_name creator_pos_name/*,
                 u1.pos_name acceptor_pos_name,
                 u2.pos_name recipient_pos_name,
                 u.department_name creator_department_name,
                 u1.department_name acceptor_department_name,
                 u2.department_name recipient_department_name,
                 u.region_name,
                 z.fil,
                 z.funds,
                 z.id_net*/,
                 f.name distrib/*,
                 fu.name funds_name,
                 n.net_name,
                 z.report_short,
                 pt.pay_type payment_type_name,
                 ss.cost_item statya_name,
                 z.distr_compensation,
                 z.report_zero_cost,z.report_fakt_equal_plan,
                 bud_ru_zay_executors.tn executor_tn*/,
                 wm_concat ( PERSIK.fn_getname (bud_ru_zay_executors.tn)) executor_name/*,
                 bud_ru_zay_executors.execute_order,
                 bud_ru_zay_executors.pos_name executor_pos_name,
                 bud_ru_zay_executors.department_name executor_department_name,
                 TO_CHAR (z.cost_assign_month, 'dd.mm.yyyy') cost_assign_month*/
                ,(
                  SELECT CASE WHEN zf.val_list_name LIKE 'Единичное' THEN 1 ELSE 2 END kod_tu
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100027438
                ) type_tu /* Единичное / сетевое ТП */
                ,(
                  SELECT zf.val_list_name
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100027438
                ) type_tu_name /* Единичное / сетевое ТП */
                ,(
                      SELECT zf.val_list_name
                      FROM PERSIK.bud_ru_zay_ff zf
                      WHERE zf.z_id = z.id AND zf.FF_ID = 100027047
                ) net_name /* Название сети  */
                ,(
                      SELECT zf.val_list_name
                      FROM PERSIK.bud_ru_zay_ff zf
                      WHERE zf.z_id = z.id AND zf.FF_ID = 38477666
                ) tp_name /* Название ТП  */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 101187678
                ) type_tp /* Тип ТП  */
                ,(
                  SELECT zf.val_string
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 101470127
                ) condit_last_year  /* Торговые условия в предыдущем году: скидка / наценка / ретробонус / фиксированная оплата */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100916160
                ) total_disc_for_user /* ИТОГО СКИДКА (для клиента), %  */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100916155
                ) retro_bonus /* ИТОГО РЕТРОБОНУС (для клиента), %  */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100916168
                ) fix_pay /* ИТОГО ФИКСИРОВАННАЯ ОПЛАТА (для клиента), ГРН.  */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 102408591
                ) avk_expens_percent /* ИТОГО ЗАТРАТЫ (для АВК) ПЛАН, %  */
                ,(
                  SELECT zf.val_formula
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 102408617
                ) avk_expens_val /* ИТОГО ЗАТРАТЫ (для АВК) ПЛАН, грн.  */
                /* files */
                ,(
                  SELECT 'files/bud_ru_zay_files/' || z.id || '/100829427/report/'||zf.val_file
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100829427
                ) file_location
                ,(
                  SELECT 'files/bud_ru_zay_files/' || z.id || '/100829429/report/'||zf.val_file
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100829429
                ) file_specifik
                ,(
                  SELECT 'files/bud_ru_zay_files/' || z.id || '/100829430/report/'||zf.val_file
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100829430
                ) file_planogramma 
                ,(
                  SELECT 'files/bud_ru_zay_files/' || z.id || '/100850052/report/'||zf.val_file
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 100850052
                ) file_komerc_sogl
                ,(
                  SELECT 'files/bud_ru_zay_files/' || z.id || '/103466356/report/'||zf.val_file
                    FROM PERSIK.bud_ru_zay_ff zf
                   WHERE zf.z_id = z.id AND zf.FF_ID = 103466356
                ) file_syst_dogovor_usl 
                /* detailes */
                ,(
                    SELECT zf.VAL_TEXTAREA
                      FROM PERSIK.bud_ru_zay_ff zf
                     WHERE zf.z_id = z.id AND zf.FF_ID = 100949905
                  ) argument_text_for_tu /* Аргументация предоставления торговых условий */
                  ,(
                    SELECT zf.VAL_STRING
                      FROM PERSIK.bud_ru_zay_ff zf
                     WHERE zf.z_id = z.id AND zf.FF_ID = 180145467
                  ) avg_month_sales /* Среднемес. объем продаж на период действия новых ТУ, тыс грн */
            FROM PERSIK.bud_ru_zay z,
                /* PERSIK.bud_ru_zay_accept za,*/
                 (SELECT sze.*, szu.pos_name, szu.department_name
                    FROM PERSIK.bud_ru_zay_executors sze, PERSIK.user_list szu
                   WHERE sze.tn = szu.tn) bud_ru_zay_executors,
                -- PERSIK.accept_types zat,
                 PERSIK.user_list u,
                -- PERSIK.user_list u1,
                -- PERSIK.user_list u2,
                -- PERSIK.BUD_RU_st_ras st,
               --  PERSIK.BUD_RU_st_ras kat,
                 PERSIK.bud_fil f
               --  PERSIK.bud_funds fu,
               --  PERSIK.nets n,
               --  PERSIK.payment_type pt,
                -- PERSIK.statya ss
           WHERE     (SELECT NVL (tu, 0)
                        FROM PERSIK.bud_ru_st_ras
                       WHERE id = z.kat) = 1
             --    AND z.id_net = n.id_net(+)
                 
               --  AND z.payment_type = pt.id(+)
               --  AND z.statya = ss.id(+)
                 AND z.fil = f.id(+)
             --    AND z.funds = fu.id(+)
                 AND z.tn = u.tn
 
               -- AND za.tn = u1.tn
                -- AND z.recipient = u2.tn

              --   AND z.id = za.z_id(+)
                 AND z.id = bud_ru_zay_executors.z_id(+)
              --   AND za.rep_accepted = zat.id(+)
                -- AND za.rep_accepted IS NOT NULL AND PERSIK.INN_not_ReportMA (za.tn) = 0

             --    AND z.st = st.id(+) 
             --    AND z.kat = kat.id(+)
              GROUP BY z.id,
                      z.created,
                      z.dt_start,
                      z.dt_end,
                      z.report_data,
                      z.tn,
                      z.recipient,
                      u.pos_name,
                      f.name
                ) z
  -- WHERE  report_data IS NOT NULL /* if report_data IS NOT NULL THEN: confirmed trading conditions (TU), ELSE : list of all targets for conditions */

ORDER BY created DESC,
         z_id
       -- ,accept_order
 --) --WHERE z_id = 102845586
  /*GROUP BY z_id
  HAVING COUNT(z_id) > 1*/