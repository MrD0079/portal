/* Formatted on 27.02.2014 21:35:28 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT a.*,
                  (SELECT COUNT (*)
                     FROM merch_spec_head
                    WHERE ag_id = a.id)
                     c
    FROM routes_agents a
ORDER BY name