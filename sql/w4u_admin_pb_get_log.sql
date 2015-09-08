/* Formatted on 01.04.2013 15:30:19 (QP5 v5.163.1008.3004) */
  SELECT z.*, TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_t, TO_CHAR (m, 'dd.mm.yyyy') m_t
    FROM w4u_pb_log z
   WHERE m = TO_DATE (:dt, 'dd.mm.yyyy')
ORDER BY lu