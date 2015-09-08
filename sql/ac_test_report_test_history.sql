/* Formatted on 12/09/2014 15:44:11 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         DECODE ( (SELECT NVL (COUNT (*), 0)
                     FROM ac_test qa
                    WHERE parent = :ac_test_id),
                 0, 0,
                 ROUND (  h.ball
                        / (SELECT NVL (COUNT (*), 0)
                             FROM ac_test qa
                            WHERE parent = :ac_test_id)
                        * 100,
                        2))
            test_perc,
         h.ball test_ball,
         TO_CHAR (h.lu, 'dd/mm/yyyy hh24:mi:ss') test_lu
    FROM ac_test_history h
   WHERE h.ac_id = :ac_id AND h.test_id = :ac_test_id AND h.memb_id = :memb_id
ORDER BY h.lu