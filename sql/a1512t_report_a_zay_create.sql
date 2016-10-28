/* Formatted on 1/4/2016 5:16:29  (QP5 v5.252.13127.32867) */
DECLARE
   vZayId         INTEGER;
   vDBTN          INTEGER;
   vDays4Report   INTEGER;
   vTraid         INTEGER;
   vSupDoc        VARCHAR2 (4000);
BEGIN
   vDBTN := :tn;

   SELECT days4report
     INTO vDays4Report
     FROM bud_ru_st_ras
    WHERE id = 66071025;

   SELECT tn
     INTO vTraid
     FROM user_list
    WHERE is_traid = 1 AND datauvol IS NULL AND dpt_id = 1 AND ROWNUM = 1;

   DELETE FROM act_ok
         WHERE act = 'a1512t' AND m = 12 AND tn = vDBTN;

   COMMIT;

   FOR a IN (  SELECT fil, SUM (bonus_sum1) bonus
                 FROM (SELECT DISTINCT an.H_client, an.bonus_sum1, f.id fil
                         FROM A1512T_XLS_TPCLIENT tp,
                              a1512t d,
                              A1512t_ACTION_CLIENT an,
                              user_list st,
                              bud_fil f
                        WHERE     d.tab_num = st.tab_num
                              AND (st.tn IN (SELECT slave
                                               FROM full
                                              WHERE master = vDBTN))
                              AND st.dpt_id = 1
                              AND tp.tp_kod = d.tp_kod
                              AND tp.H_client = an.H_client
                              AND an.bonus_dt1 IS NOT NULL
                              AND an.fil = f.id)
             GROUP BY fil)
   LOOP
      INSERT INTO act_ok (act,
                          tn,
                          m,
                          fil)
           VALUES ('a1512t',
                   vDBTN,
                   12,
                   a.fil);

      COMMIT;

      SELECT REPLACE (wm_concat (fn), ',', CHR (10))
        INTO vSupDoc
        FROM (SELECT DISTINCT af.fn
                FROM A1512T_XLS_TPCLIENT tp,
                     a1512t d,
                     A1512t_ACTION_CLIENT an,
                     user_list st,
                     bud_fil f,
                     act_files af
               WHERE     d.tab_num = st.tab_num
                     AND (st.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = vDBTN))
                     AND st.dpt_id = 1
                     AND tp.tp_kod = d.tp_kod
                     AND tp.H_client = an.H_client
                     AND an.bonus_dt1 IS NOT NULL
                     AND an.fil = f.id
                     AND af.act = 'a1512t'
                     AND af.m = 12
                     AND af.tn = st.tn
                     AND f.id = a.fil);



      SELECT seq_all.NEXTVAL INTO vZayId FROM DUAL;

      INSERT INTO bud_ru_zay (id,
                              tn,
                              recipient,
                              st,
                              kat,
                              dt_start,
                              dt_end,
                              fil,
                              funds,
                              report_data,
                              report_data_tn,
                              report_short,
                              sup_doc)
           VALUES (vZayId,
                   vDBTN,
                   vTraid,
                   66071024,
                   66071025,
                   TO_DATE ('01/12/2015', 'dd.mm.yyyy'),
                   TO_DATE ('31/12/2015', 'dd.mm.yyyy'),
                   a.fil,
                   3909729,
                   TO_DATE ('31/12/2015', 'dd.mm.yyyy') + vDays4Report,
                   vTraid,
                   1,
                   vSupDoc);

      COMMIT;

      INSERT INTO bud_ru_zay_accept (z_id, tn)
           VALUES (vZayId, vTraid);

      COMMIT;

      INSERT INTO bud_ru_zay_accept (z_id, tn)
           VALUES (vZayId, vDBTN);

      COMMIT;

      UPDATE bud_ru_zay_accept
         SET accepted = 1
       WHERE z_id = vZayId;

      COMMIT;

      UPDATE BUD_RU_ZAY_accept
         SET rep_accepted = NULL
       WHERE z_id = vZayId AND accept_order > 1;

      COMMIT;

      INSERT INTO bud_ru_zay_ff (z_id,
                                 ff_id,
                                 val_number,
                                 rep_val_number)
           VALUES (vZayId,
                   19311375,
                   a.bonus/1000,
                   a.bonus/1000);

      COMMIT;

      INSERT INTO bud_ru_zay_ff (z_id, ff_id, val_string)
           VALUES (vZayId, 19311378, 'рно 100');

      COMMIT;

      INSERT INTO bud_ru_zay_ff (z_id, ff_id, val_bool)
           VALUES (vZayId, 66012670, 1);

      COMMIT;
   END LOOP;
END;