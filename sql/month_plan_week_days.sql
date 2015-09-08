select c.dw,to_char(c.data,'dd.mm.yyyy') data,c.y,c.q,c.my,c.wm,c.dy,c.dw,c.is_wd,c.mt,c.dwt from calendar c where trunc(data,'mm')=TO_DATE(:sd,'dd.mm.yyyy') and wm=:week and dw<>7 order by data
