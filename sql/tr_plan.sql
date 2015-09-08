/* Formatted on 03/09/2014 20:30:36 (QP5 v5.227.12220.39724) */
  SELECT tr.*,
         ob.u_tn,
         TO_CHAR (ob.datanob, 'dd/mm/yyyy') datanob,
         TO_CHAR (ob.datakob, 'dd/mm/yyyy') datakob,
         (SELECT TO_CHAR (MIN (dt_start), 'dd/mm/yyyy')
            FROM tr_order_head h, tr_order_body b
           WHERE     h.id = b.head
                 AND b.tn = :tn
                 AND h.tr = tr.id
                 AND dt_start >= TRUNC (SYSDATE)
                 AND b.manual >= 0)
            min_dt_start,
         (SELECT MAX (DECODE ( (SELECT NVL (COUNT (*), 0)
                                  FROM tr_test_qa qa
                                 WHERE qa.TYPE = 5 AND qa.tr = h.tr),
                              0, 0,
                              ROUND (  th.ball
                                     / (SELECT NVL (COUNT (*), 0)
                                          FROM tr_test_qa qa
                                         WHERE qa.TYPE = 5 AND qa.tr = h.tr)
                                     * 100,
                                     2)))
            FROM tr_order_head h, tr_order_body b, tr_order_test_history th
           WHERE     h.tr = tr.id
                 AND h.dt_start = ob.datanob
                 AND h.id = b.head
                 AND th.tn(+) = b.tn
                 AND TH.HEAD = b.head
                 AND b.tn = :tn)
            test_perc,
         (SELECT MAX (test_ball)
            FROM tr_order_head h, tr_order_body b, tr_order_test_history th
           WHERE     h.tr = tr.id
                 AND h.dt_start = ob.datanob
                 AND h.id = b.head
                 AND th.tn(+) = b.tn
                 AND TH.HEAD = b.head
                 AND b.tn = :tn)
            test_ball
    FROM (SELECT LC_TNKVAL.datanob,
                 LC_TNKVAL.datakob,
                 LC_TNKVAL.cel1 tr_kod,
                 u.fio u_fio,
                 u.tn u_tn,
                 u.pos_id
            FROM PERS.LC_TNKVAL@PERS LC_TNKVAL,
                 PERS.LC_c_kadr@PERS LC_c_kadr,
                 pers.xbid@pers xbid,
                 user_list u
           WHERE     LC_TNKVAL.cel2 = 1
                 AND LC_c_kadr.dcode = 24
                 AND LC_TNKVAL.cel1 = LC_c_kadr.code_
                 AND LC_TNKVAL.manufak = LC_c_kadr.manufak
                 AND LC_TNKVAL.tn = xbid.tn
                 AND LC_TNKVAL.manufak = xbid.manufak
                 AND TO_CHAR (u.tn) = xbid.tin
                 AND u.tn = :tn
                 AND u.dpt_id = :dpt_id) ob,
         (SELECT tr.id,
                 tr.name,
                 tr.text,
                 tr.kod,
                 tr_pos.pos_id,
                 tr_pos.sort
            FROM tr, tr_pos
           WHERE     tr.id = tr_pos.tr_id
                 AND pos_id = (SELECT pos_id
                                 FROM user_list
                                WHERE tn = :tn)) tr
   WHERE ob.pos_id(+) = tr.pos_id AND ob.tr_kod(+) = tr.kod
ORDER BY tr.sort, ob.datanob, ob.datakob