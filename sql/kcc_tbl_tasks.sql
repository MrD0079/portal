/* Formatted on 12.08.2015 15:50:07 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM kcct k
   WHERE k.dt = TO_DATE (:sd, 'dd.mm.yyyy') AND k.coach = :coach
ORDER BY k.id