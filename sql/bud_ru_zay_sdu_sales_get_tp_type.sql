SELECT DECODE (NVL (TO_NUMBER (getZayFieldVal ( :z_id, 'admin_id', 13)), 0),
               100027437, 'tp',
               100027436, 'net')
          tp_type
  FROM DUAL