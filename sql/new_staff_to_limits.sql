/* Formatted on 10.02.2017 16:24:34 (QP5 v5.252.13127.32867) */
INSERT INTO limits (tn,
                    limitkom,
                    limittrans,
                    limit_car_vol,
                    gbo_installed)
   SELECT svideninn,
          limitkom,
          limittrans,
          limit_car_vol,
          gbo_installed
     FROM new_staff ns
    WHERE ID = :id