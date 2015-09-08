/* Formatted on 12/03/2014 17:00:37 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         tp_kod,
         tp_name || ', ' || address || ', ' || tp_kod || ', ' || eta name,
         tp_name,
         address,
         eta,
         tp_type
    FROM routes r, beg_routes_head h, beg_routes_body b
   WHERE     h.id = b.head_id
         AND tn = :tn
         AND dt = TO_DATE (:dt, 'dd.mm.yyyy')
         AND r.tp_kod = b.tp
         AND LOWER (tp_name || ', ' || address) LIKE
                '%' || LOWER (:find_string) || '%'
ORDER BY name