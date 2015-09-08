/* Formatted on 21/04/2015 19:44:55 (QP5 v5.227.12220.39724) */
SELECT h.*,
       TO_CHAR (h.birthday, 'dd.mm.yyyy') birthday,
       TO_CHAR (h.planned_start, 'dd.mm.yyyy') planned_start,
       TO_CHAR (h.prob_period_start, 'dd.mm.yyyy') prob_period_start,
       TO_CHAR (h.prob_period_end, 'dd.mm.yyyy') prob_period_end
  FROM iv_head h
 WHERE id = :id