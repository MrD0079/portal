/* Formatted on 23.10.2012 15:43:12 (QP5 v5.163.1008.3004) */
           SELECT LEVEL,
                  z.id,
                  z.parent,
                  z.name,
                  z.lu,
                  z.sort,
                  TO_CHAR (z.dt_start, 'dd/mm/yyyy') dt_start,
                  TO_CHAR (z.dt_end, 'dd/mm/yyyy') dt_end,
                  TO_CHAR (z.dt_fin, 'dd/mm/yyyy') dt_fin
             FROM project z
       START WITH PARENT = :prj_id
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY sort