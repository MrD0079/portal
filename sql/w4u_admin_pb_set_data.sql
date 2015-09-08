/* Formatted on 03.04.2013 13:54:54 (QP5 v5.163.1008.3004) */
DECLARE
   fio_ts_    VARCHAR (255);
   tab_num_   INTEGER;
   fio_eta_   VARCHAR (255);
   c          INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO c
     FROM w4u_transit
    WHERE h_fio_eta = :h_fio_eta_new;

   IF c <> 0
   THEN
      SELECT DISTINCT fio_ts, tab_num, fio_eta
        INTO fio_ts_, tab_num_, fio_eta_
        FROM w4u_transit
       WHERE h_fio_eta = :h_fio_eta_new AND ROWNUM = 1;
   END IF;

   DELETE FROM w4u_transit
         WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta_new;


   INSERT INTO w4u_transit (fio_ts,
                            tab_num,
                            fio_eta,
                            data,
                            product_id,
                            qtytt,
                            summa,
                            summweight,
                            akb,
                            h_fio_eta,
                            visible,
                            m)
      SELECT fio_ts_,
             tab_num_,
             fio_eta_,
             t.data,
             t.product_id,
             t.qtytt,
             t.summa,
             t.summweight,
             t.akb,
             :h_fio_eta_new,
             1 visible,
             TO_DATE (:dt, 'dd.mm.yyyy')
        FROM w4u_transit t
       WHERE t.m = TO_DATE (:dt, 'dd.mm.yyyy') AND t.h_fio_eta = :h_fio_eta_old;


   COMMIT;
END;