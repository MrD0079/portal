/* Formatted on 07.07.2012 12:15:51 (QP5 v5.163.1008.3004) */
SELECT rh.*,
       (SELECT svms_ok
          FROM merch_report_ok
         WHERE dt = TO_DATE (:data, 'dd/mm/yyyy') AND head_id = rh.id)
          svms_ok,
       (SELECT to_char(lu,'dd.mm.yyyy hh24:mi:ss')
          FROM merch_report_ok
         WHERE dt = TO_DATE (:data, 'dd/mm/yyyy') AND head_id = rh.id)
          svms_ok_date
  FROM routes_head rh
 WHERE login = :login
       AND data = TRUNC (TO_DATE (:data, 'dd/mm/yyyy'), 'mm')