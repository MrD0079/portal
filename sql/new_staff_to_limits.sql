/* Formatted on 11.01.2013 13:30:10 (QP5 v5.163.1008.3004) */
INSERT INTO limits (tn,
                     limitkom,
                     limittrans,
                     limit_car_vol)
   SELECT svideninn,
          limitkom,
          limittrans,
          limit_car_vol
     FROM new_staff ns
    WHERE ID = :id