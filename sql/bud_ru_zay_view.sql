/* Formatted on 17/06/2015 12:56:42 (QP5 v5.227.12220.39724) */
  SELECT z.*
    FROM (SELECT bud_ru_zay.id,
                 TO_CHAR (bud_ru_zay.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (bud_ru_zay.created, 'dd.mm.yyyy') created_dt,
                 fn_getname (bud_ru_zay.tn) creator,
                 fn_getname (bud_ru_zay.recipient) recipient,
                 fn_getdolgn (bud_ru_zay.tn) creator_pos,
                 fn_getdolgn (bud_ru_zay.recipient) recipient_pos,
                 (SELECT tn
                    FROM bud_ru_zay_accept
                   WHERE     z_id = bud_ru_zay.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE     z_id = bud_ru_zay.id
                                        AND accepted = 464260))
                    current_acceptor_tn,
                 fn_getname (
                    (SELECT tn
                       FROM bud_ru_zay_accept
                      WHERE     z_id = bud_ru_zay.id
                            AND accept_order =
                                   (SELECT MIN (accept_order)
                                      FROM bud_ru_zay_accept
                                     WHERE     z_id = bud_ru_zay.id
                                           AND accepted = 464260)))
                    current_acceptor_name,
                 bud_ru_zay_accept.tn acceptor_tn,
                 fn_getname (bud_ru_zay_accept.tn) acceptor_name,
                 bud_ru_zay_accept.accepted,
                 bud_ru_zay_accept.failure,
                 bud_ru_zay_accept.accept_order,
                 bud_ru_zayat.name accepted_name,
                 DECODE (
                    bud_ru_zay_accept.accepted,
                    464260, NULL,
                    TO_CHAR (bud_ru_zay_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 DECODE ( (SELECT COUNT (*)
                             FROM bud_ru_zay_accept
                            WHERE z_id = bud_ru_zay.id AND accepted = 464262),
                         0, 0,
                         1)
                    deleted,
                 (SELECT id
                    FROM bud_ru_zay_accept
                   WHERE     z_id = bud_ru_zay.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE     z_id = bud_ru_zay.id
                                        AND accepted = 464260))
                    current_accept_id,
                 bud_ru_zay.fil,
                 f.name fil_name,
                 fu.name funds_name,
                 n.net_name,
                 pt.pay_type payment_type_name,
                 ss.cost_item statya_name,bud_ru_zay.distr_compensation
            FROM bud_ru_zay,
                 bud_ru_zay_accept,
                 bud_ru_zay_accept_types bud_ru_zayat,
                 bud_fil f,
                 bud_funds fu,
                 nets n,
                 payment_type pt,
                 statya ss
           WHERE     bud_ru_zay.id_net = n.id_net(+)
                 AND bud_ru_zay.payment_type = pt.id(+)
                 AND bud_ru_zay.statya = ss.id(+)
                 AND bud_ru_zay.fil = f.id
                 AND bud_ru_zay.funds = fu.id
                 AND bud_ru_zay.id = bud_ru_zay_accept.z_id
                 AND bud_ru_zay_accept.accepted = bud_ru_zayat.id
                 AND bud_ru_zay.id = :id) z
ORDER BY id, accept_order