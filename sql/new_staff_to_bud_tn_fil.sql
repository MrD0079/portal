/* Formatted on 07.02.2014 15:40:26 (QP5 v5.227.12220.39724) */
INSERT INTO bud_tn_fil (tn, bud_id)
   SELECT ns.svideninn, nsbf.fil
     FROM new_staff ns, new_staff_bud_fil nsbf
    WHERE ns.ID = :ID AND ns.id = nsbf.parent