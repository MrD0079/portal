/* Formatted on 09/04/2015 12:49:48 (QP5 v5.227.12220.39724) */
  SELECT fn_getname (cse.tn) fio,
         cse.*,
         TO_CHAR (cse.datauvol, 'dd.mm.yyyy') datauvol_txt,
         NVL (zc.total, 0) + NVL (zt.total, 0) + NVL (zm.total, 0) total,
         cse.full,
         l.*,
         zm.valuta
    FROM (SELECT c1.dt,
                 c1.mt,
                 c1.y,
                 e1.full,
                 s1.*
            FROM user_list s1,
                 (SELECT DISTINCT full, slave tn
                    FROM full
                   WHERE dpt_id = :dpt_id AND master = :exp_tn) e1,
                 (SELECT DISTINCT TRUNC (data, 'mm') dt, mt, y
                    FROM calendar
                   WHERE TRUNC (data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                                AND TO_DATE (:ed, 'dd.mm.yyyy')) c1
           WHERE     S1.TN = e1.tn
                 AND s1.dpt_id = :dpt_id
                 AND s1.is_spd = 1
                 AND (INSTR (:full, TO_CHAR (e1.full)) > 0 OR e1.full = -2)) cse,
         (  SELECT TRUNC (zc.data, 'mm') dt,
                   zc.tn,
                   SUM (
                        NVL (PET_SUM, 0)
                      + NVL (OIL_SUM, 0)
                      + NVL (WASH, 0)
                      + NVL (SERVICE, 0)
                      + NVL (PARKING, 0))
                      total
              FROM zat_daily_car zc
             WHERE TRUNC (zc.data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                             AND TO_DATE (:ed, 'dd.mm.yyyy')
          GROUP BY TRUNC (zc.data, 'mm'), zc.tn) zc,
         (  SELECT TRUNC (zt.data, 'mm') dt,
                   zt.tn,
                   SUM (
                        +NVL (DAILY_COST, 0)
                      + NVL (FOOD, 0)
                      + NVL (HOTEL, 0)
                      + NVL (TRANSPORT, 0))
                      total
              FROM zat_daily_trip zt
             WHERE TRUNC (zt.data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                             AND TO_DATE (:ed, 'dd.mm.yyyy')
          GROUP BY TRUNC (zt.data, 'mm'), zt.tn) zt,
         (SELECT TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') dt,
                 zm.tn,
                   NVL (PRESENT_COST, 0)
                 + NVL (STATIONERY, 0)
                 + NVL (MEDIA_ADVERT, 0)
                 + NVL (MAIL, 0)
                 + NVL (CONFERENCE, 0)
                 + NVL (TRAINING_FOOD, 0)
                 + NVL (ESV, 0)
                 + NVL (SINGLE_TAX, 0)
                 + NVL (account_payments, 0)
                 + NVL (mobile, 0)
                 + NVL (AMORT, 0)
               + NVL (gbo_warmup_sum, 0)
                    total,
                 (SELECT name
                    FROM currencies
                   WHERE id = zm.cur_id)
                    valuta,
                 zm.cur_id
            FROM zat_monthly zm
           WHERE TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') BETWEEN TO_DATE (
                                                                           :sd,
                                                                           'dd.mm.yyyy')
                                                                    AND TO_DATE (
                                                                           :ed,
                                                                           'dd.mm.yyyy')) zm,
         limits_current l
   WHERE     cse.tn = zc.tn(+)
         AND cse.tn = zt.tn(+)
         AND cse.tn = zm.tn(+)
         AND cse.dt = zm.dt(+)
         AND cse.dt = zt.dt(+)
         AND cse.dt = zc.dt(+)
         AND cse.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
         AND cse.tn = l.tn(+)
         AND (NVL (zm.cur_id, 0) IN (:cur))
ORDER BY cse.pos_name,
         cse.fio,
         cse.dt,
         cse.mt