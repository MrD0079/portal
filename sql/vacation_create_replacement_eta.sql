/* Formatted on 04.12.2013 15:24:05 (QP5 v5.227.12220.39724) */
  SELECT h_eta, eta
    FROM PARENTS_ETA
   WHERE chief_tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
ORDER BY eta