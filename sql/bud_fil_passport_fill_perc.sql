/* Formatted on 09/10/2014 11:46:07 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.lu,
         z.name,
         z.f_cnt,
         z.f_total,
         ROUND (z.f_cnt / z.f_total * 100) perc,
         c.fc_cnt,
         c.fc_total,
         ROUND (c.fc_cnt / c.fc_total * 100) cperc,
         NVL (z.f_cnt, 0) + NVL (c.fc_cnt, 0) t_cnt,
         NVL (z.f_total, 0) + NVL (c.fc_total, 0) t_total,
         ROUND (
              (NVL (z.f_cnt, 0) + NVL (c.fc_cnt, 0))
            / (NVL (z.f_total, 0) + NVL (c.fc_total, 0))
            * 100)
            tperc
    FROM (SELECT id,
                 lu,
                 name,
                 dpt_id,
                   DECODE (OWNERSHIP, NULL, 0, 1)
                 + DECODE (ACTIVITY, NULL, 0, 1)
                 + DECODE (DATA_START, NULL, 0, 1)
                 + DECODE (DATA_START_AVK, NULL, 0, 1)
                 + DECODE (PORTFOLIO, NULL, 0, 1)
                 + DECODE (AREAS, NULL, 0, 1)
                 + DECODE (ADDRESS_FAKT, NULL, 0, 1)
                 + DECODE (ADDRESS_UR, NULL, 0, 1)
                 + DECODE (WSAREA, NULL, 0, 1)
                 + DECODE (WS_ADDRES_FAKT, NULL, 0, 1)
                 + DECODE (TRANSPORT_OWN, NULL, 0, 1)
                 + DECODE (TRANSPORT_HIRED, NULL, 0, 1)
                 + DECODE (TPBASE, NULL, 0, 1)
                 + DECODE (WEB, NULL, 0, 1)
                 + DECODE (OTHER, NULL, 0, 1)
                 + DECODE (WARRANTY, NULL, 0, 1)
                 + DECODE (RETAILER, NULL, 0, 1)
                 + DECODE (PROPS, NULL, 0, 1)
                 + DECODE (SKYPE, NULL, 0, 1)
                    f_cnt,
                 19 f_total
            FROM bud_fil
           WHERE data_end IS NULL) z,
         (  SELECT fil,
                   SUM (
                        DECODE (fio, NULL, 0, 1)
                      + DECODE (phone, NULL, 0, 1)
                      + DECODE (mail, NULL, 0, 1)
                      + DECODE (birthday, NULL, 0, 1)
                      + DECODE (comm, NULL, 0, 1)
                      + DECODE (skype, NULL, 0, 1))
                      fc_cnt,
                   COUNT (*) * 6 fc_total
              FROM bud_fil_contacts
             WHERE required = 1
          GROUP BY fil) c
   WHERE z.dpt_id = :dpt_id AND z.id = c.fil(+)
ORDER BY tperc DESC, z.name