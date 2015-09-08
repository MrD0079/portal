/* Formatted on 17/06/2015 12:58:27 (QP5 v5.227.12220.39724) */
INSERT INTO persik.nets_plan_month (id_net,
                                    YEAR,
                                    MONTH,
                                    statya,
                                    descript,
                                    payment_type,
                                    payment_format,
                                    bonus,
                                    price,
                                    cnt,
                                    plan_type,
                                    mkk_ter,
                                    tn_confirmed)
   SELECT n1.id_net,
          n1.YEAR,
          n1.MONTH,
          n1.statya,
          n1.descript,
          n1.payment_type,
          n1.payment_format,
          n1.bonus,
          n1.price,
          n1.cnt,
          :plan_type,
          mkk_ter,
          :tn_confirmed
     FROM persik.nets_plan_month n1
    WHERE n1.ID = :ID