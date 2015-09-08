/* Formatted on 22/07/2015 11:38:12 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         TO_CHAR (h.birthday, 'dd.mm.yyyy') birthday,
         TO_CHAR (h.planned_start, 'dd.mm.yyyy') planned_start,
         TO_CHAR (h.prob_period_start, 'dd.mm.yyyy') prob_period_start,
         TO_CHAR (h.prob_period_end, 'dd.mm.yyyy') prob_period_end,
         p.pos_name,
         m.fio mentor_fio
    FROM iv_head h, user_list m, pos p
   WHERE     h.current_acceptor = :tn
         AND h.current_status IN (0, 3)
         AND m.tn(+) = h.mentor
         AND p.pos_id(+) = h.pos
ORDER BY h.id