/* Formatted on 26.09.2014 14:20:16 (QP5 v5.227.12220.39724) */
SELECT z.*,
       TO_CHAR (z.data_start, 'dd.mm.yyyy') data_start,
       TO_CHAR (z.data_start_avk, 'dd.mm.yyyy') data_start_avk,
       o.name ownership_name,
       a.name activity_name
  FROM bud_fil z, distr_ownership o, distr_activity a
 WHERE z.id = :id AND z.ownership = o.id(+) AND z.activity = a.id(+)