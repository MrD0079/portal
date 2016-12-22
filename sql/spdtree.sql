/* Formatted on 21.11.2013 9:14:55 (QP5 v5.227.12220.39724) */
  SELECT ID,
         FAM,
         IM,
         OTCH,
         ADDRESS,
         DOLGN,
         TO_CHAR (BIRTHDAY, 'dd.mm.yyyy') BIRTHDAY,
         EMAIL,
         TO_CHAR (FDATA, 'dd.mm.yyyy') fdata,
         TO_CHAR (DATAPER, 'dd.mm.yyyy') DATAPER,
         TO_CHAR (DATAUVOL, 'dd.mm.yyyy') DATAUVOL,
         TO_CHAR (DATASTART, 'dd.mm.yyyy') DATASTART,
         PHONE,
         DOGOVORNUM,
         TO_CHAR (DOGOVORDATA, 'dd.mm.yyyy') DOGOVORDATA,
         DOGOVOROPL,
         DOGOVORUSLUGI,
         SVIDREGNUM,
         TO_CHAR (SVIDREGDATA, 'dd.mm.yyyy') SVIDREGDATA,
         SVIDREGVID,
         SVIDENNUM,
         TO_CHAR (SVIDENDATA, 'dd.mm.yyyy') SVIDENDATA,
         SVIDENINN,
         SVIDENPLACE,
         BANKNAME,
         REKVBANK,
         REKVMFO,
         REKVOKPO,
         REKVRS,
         REKVPLAT,
         OPLATAKAT,
         OPLATASTAVKA,
         OPLATABONUS,
         l.LIMITKOM,
         l.LIMITTRANS,
         l.LIMITPIT,
         l.LIMITPRED,
         l.LIMITKANC,
         l.LIMITMOB,
         l.LIMIT_CAR_VOL,
         l.limit_gbo,
         LIMITPER,
         AVANS,
         DECODE (NVL (AMORT, 0), 0, NULL, '��') amort,
         CAR_BRAND,
         CAR_RASHOD,
         TAB_NUM,
         POS_ID,
         s.DPT_ID,
         d.dpt_name,
         d.cnt_name,
         d.cnt_kod,
         d.sort,
         s.region_name,
         s.department_name
    FROM PERSIK.SPDTREE s, departments d, limits_current l
   WHERE     s.dpt_id = D.DPT_ID
         AND d.dpt_id = :dpt_id
         AND DECODE (:flt,
                     0, SYSDATE,
                     1, NVL (datauvol, SYSDATE),
                     -1, datauvol) =
                DECODE (:flt,  0, SYSDATE,  1, SYSDATE,  -1, datauvol)
         AND s.svideninn = l.tn(+)
ORDER BY d.sort,
         fam,
         im,
         otch