/* Formatted on 05/11/2015 15:43:26 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT TO_CHAR (x.data, 'dd.mm.yyyy') dt,
                  TO_CHAR (x.data, 'yyyymmdd') dt1,
                  x.ag_id,
                  x.tz_oblast tz_oblast,
                  x.city city,
                  x.ur_tz_name ur_tz_name,
                  x.tz_address tz_address,
                  x.kodtp kodtp,
                  x.net_name,
                  x.ag_name,
                  f.id msr_file_id,
                  f.fn,
                  NVL (f.chat_closed, 0) chat_closed,
                  FN_GET_msrfc_cnt (f.id) c,
                  f.last_is_spd,
                  FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) mc_c,
                  FN_GET_mc_closed (x.data, x.ag_id, x.kodtp) mc_closed,
                  FN_GET_mc_last (x.data, x.ag_id, x.kodtp) mc_last_is_spd
    FROM (SELECT cpp.tz_oblast,
                 cpp.city,
                 cpp.ur_tz_name,
                 cpp.tz_address,
                 cpp.kodtp,
                 calendar.data,
                 a.id ag_id,
                 m.net_name,
                 a.name ag_name
            FROM cpp,
                 calendar,
                 routes_agents a,
                 ms_nets m
           WHERE     cpp.id_net = m.id_net
                 AND DECODE ( :agent, 0, 0, a.id) =
                        DECODE ( :agent, 0, 0, :agent)
                 AND calendar.data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                       AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND DECODE ( :oblast, '0', '0', cpp.h_tz_oblast) =
                        DECODE ( :oblast, '0', '0', :oblast)
                 AND DECODE ( :city, '0', '0', cpp.h_city) =
                        DECODE ( :city, '0', '0', :city)
                 AND DECODE ( :nets, 0, 0, cpp.id_net) =
                        DECODE ( :nets, 0, 0, :nets)) x,
         merch_spec_report_files f,
         merch_chat c
   WHERE     x.data = f.dt(+)
         AND x.ag_id = f.ag_id(+)
         AND x.kodtp = F.KOD_TP(+)
         AND x.data = c.dt(+)
         AND x.ag_id = c.ag_id(+)
         AND x.kodtp = c.KOD_TP(+)
         AND (   FN_GET_msrfc_cnt (f.id) > 0
              OR FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0)
         AND CASE
                WHEN :flt_chat = 0
                THEN
                   1
                WHEN     :flt_chat = 1
                     AND (   (    NVL (f.chat_closed, 0) = 1
                              AND FN_GET_msrfc_cnt (f.id) > 0)
                          OR (    FN_GET_mc_closed (x.data, x.ag_id, x.kodtp) =
                                     1
                              AND FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0))
                THEN
                   1
                WHEN     :flt_chat = 2
                     AND (   (    NVL (f.chat_closed, 0) = 0
                              AND FN_GET_msrfc_cnt (f.id) > 0)
                          OR (    FN_GET_mc_closed (x.data, x.ag_id, x.kodtp) =
                                     0
                              AND FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0))
                THEN
                   1
                WHEN     :flt_chat = 3
                     AND (   (    f.last_is_spd = 1
                              AND (NVL (f.chat_closed, 0) = 0)
                              AND FN_GET_msrfc_cnt (f.id) > 0)
                          OR (    FN_GET_mc_last (x.data, x.ag_id, x.kodtp) = 1
                              AND FN_GET_mc_closed (x.data, x.ag_id, x.kodtp) =
                                     0
                              AND FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0))
                THEN
                   1
                WHEN     :flt_chat = 4
                     AND (   (    f.last_is_spd = -1
                              AND (NVL (f.chat_closed, 0) = 0)
                              AND FN_GET_msrfc_cnt (f.id) > 0)
                          OR (    FN_GET_mc_last (x.data, x.ag_id, x.kodtp) =
                                     -1
                              AND FN_GET_mc_closed (x.data, x.ag_id, x.kodtp) =
                                     0
                              AND FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0))
                THEN
                   1
             END = 1
ORDER BY dt1,
         tz_oblast,
         city,
         ur_tz_name,
         tz_address,
         f.fn