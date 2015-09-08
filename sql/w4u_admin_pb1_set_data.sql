/* Formatted on 24.04.2013 9:18:22 (QP5 v5.163.1008.3004) */
DECLARE
   fio_ts_    VARCHAR (255);
   tab_num_   INTEGER;
   fio_eta_   VARCHAR (255);
   c          INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO c
     FROM w4u_transit1
    WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta_new;

   IF c <> 0
   THEN
      SELECT DISTINCT fio_ts, tab_num, fio_eta
        INTO fio_ts_, tab_num_, fio_eta_
        FROM w4u_transit1
       WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta_new AND ROWNUM = 1;
   END IF;

   DELETE FROM w4u_transit1
         WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta_new;


   INSERT INTO w4u_transit1 (fio_ts,
                             tab_num,
                             fio_eta,
                             dt,
                             groupname,
                             h_groupname,
                             ttqty,
                             ttqtybaseperiod,
                             akb,
                             akbprev,
                             h_fio_eta,
                             visible,
                             m)
      SELECT fio_ts_,
             tab_num_,
             fio_eta_,
             t.dt,
             t.groupname,
             t.h_groupname,
             t.ttqty,
             t.ttqtybaseperiod,
             t.akb,
             t.akbprev,
             :h_fio_eta_new,
             1 visible,
             TO_DATE (:dt, 'dd.mm.yyyy')
        FROM w4u_transit1 t
       WHERE t.m = TO_DATE (:dt, 'dd.mm.yyyy') AND t.h_fio_eta = :h_fio_eta_old;


   COMMIT;
END;