  SELECT di.*
    FROM sku_avk_distrib_income di,
    (SELECT kod_filiala, CONCAT(kod_filiala,MAX(date_p)) distib_date
  FROM (
      SELECT * FROM sku_avk_distrib_income
      WHERE trunc(date_p) <= trunc(sysdate)
      )
  GROUP BY kod_filiala ) mss
  WHERE CONCAT(di.kod_filiala,di.date_p) = mss.distib_date
    AND mss.kod_filiala = (
      SELECT DISTINCT sw_kod FROM bud_fil where id = :fil_kod
    )