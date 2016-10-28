/* Formatted on 13/09/2013 17:04:26 (QP5 v5.227.12220.39724) */
SELECT u.fio,
       u.h_eta,
       TO_CHAR (h.dt_start, 'dd.mm.yyyy') dt_start,
       l.name loc_name,
       tr.name,
       pe.chief_tn
  FROM tr_pt_order_head h,
       tr_pt_order_body b,
       parents_eta pe,
       user_list u,
       tr_loc l,
       tr
 WHERE     h.dt_start >= TRUNC (SYSDATE)
       AND h.tr = tr.id
       AND h.loc = l.id
       AND h.id = b.head
       AND b.manual >= 0
       AND h.ok_final = 1
       AND pe.chief_tn IN
              (SELECT slave
                 FROM full
                WHERE master = DECODE (:tn, -1, master, :tn) AND full <> 0)
       AND u.h_eta = b.h_eta
       AND b.h_eta = pe.h_eta
       AND u.dpt_id = pe.dpt_id
       AND (:eta is null OR :eta = b.h_eta)