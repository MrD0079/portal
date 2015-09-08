/* Formatted on 29.03.2013 14:53:29 (QP5 v5.163.1008.3004) */
BEGIN
   w4u_transit_copy (TO_DATE (:ml1, 'dd.mm.yyyy'), TO_DATE (:ml2, 'dd.mm.yyyy'));
END;