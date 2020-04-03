/*
*
* $("#tableData").exporttabletoexceljs();
*
 */


(function ($) {
    var $defaults = {
        containerid: null
        , datatype: 'table'
        , dataset: null
        , columns: null
        , returnUri: false
        , locale: 'en-US'
        , worksheetName: "My Worksheet"
        , encoding: "utf-8"
    };

    var $settings = $defaults;

    $.fn.exporttabletoexceljs = function (options) {

        $settings = $.extend({}, $defaults, options);

        var excelData;

        return Initialize();

        function Initialize() {
            var type = $settings.datatype.toLowerCase();

            var tabelHtml = getTable('sku_selected');

            excelData = Export(tabelHtml);

            if ($settings.returnUri) {
                return excelData;
            }
            else {

                if (!isBrowserIE())
                {
                    window.open(excelData);
                }


            }
        }

        function getTable(tableid){
            var tab_text='<table border="2px"><tr bgcolor="#87AFC6">';
            var textRange;
            var j=0;
            tab = document.getElementById(tableid); // id of table
            var akciya_type = $("#akciya_type").val();
            var akciya_type_revers = akciya_type == 1 ? 2 : 1;
            for(j = 0 ; j < tab.rows.length ; j++){
                var tr = tab.rows[j];
                var tr_txt = "";
                var tr_params = "";
                $.each(tr.attributes,function(p,e){
                    tr_params += e.name;
                    tr_params += "='"+e.value+"' ";
                })
                if(j >= 2 && j != tab.rows.length-1){ /* skip theader and tfooter*/
                    for(t = 1; t < tr.cells.length; t++){
                        var is_disable_td = false;
                        var $td = $(tr.cells[t]);
                        var td = tr.cells[t];
                        var td_params = "";
                        $.each(td.attributes,function(p,e){
                            td_params += e.name;
                            td_params += "='"+e.value+"' ";
                            if((e.name == "class" && e.value == "type"+akciya_type_revers) || (e.name == "style" && e.value == "display: none;")){
                                is_disable_td = true;
                            }
                        })
                        if(!is_disable_td){
                            if($td.has("input")){
                                tr_txt += "<td "+td_params+">"+$td.find("input").val().replace('.', ',')+"</td>";
                            }else{
                                tr_txt += "<td "+td_params+">"+$td.text()+"</td>";
                            }
                        }
                    }
                }else{
                    var t_start = 1;
                    if(j == 1 || j == tab.rows.length-1){
                        t_start = 0;
                    }
                    for(t = t_start; t < tr.cells.length; t++){
                        var is_disable_td = false;
                        var $td = $(tr.cells[t]);
                        var td = tr.cells[t];
                        var td_params = "";
                        $.each(td.attributes,function(p,e){
                            td_params += e.name;
                            var val = e.value;
                            if(e.name === "colspan" && j === tab.rows.length-1)
                                val -= 1;
                            td_params += "='"+val+"' ";
                            if((e.name == "class" && e.value == "type"+akciya_type_revers) || (e.name == "style" && e.value == "display: none;")){
                                is_disable_td = true;
                            }
                        })
                        if(!is_disable_td){
                            if($td.find("input").length){
                                tr_txt += "<td "+td_params+">"+$td.find("input").val().replace('.', ',')+"</td>";
                            }else{
                                tr_txt += "<td "+td_params+">"+$td.text()+"</td>";
                            }
                        }
                    }
                }
                if(j == 1)
                    tab_text += '<tr bgcolor="#87AFC6" '+tr_params+'>';

                if(j > 1)
                    tab_text += "<tr "+tr_params+">";
                tab_text += tr_txt;
                tab_text += "</tr>";
            }

            tab_text=tab_text+"</table>";
            //tab_text= tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
            //tab_text= tab_text.replace(/<img[^>]*>/gi,""); // remove if u want images in your table
            //tab_text= tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

            return tab_text;
        }

        function Export(htmltable) {

            if (isBrowserIE()) {

                alert('Pleas, use another browser!');
                return "";
            }
            else {
                var excelFile = "<html xml:lang=" + $defaults.locale + " xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>";
                excelFile += "<head>";
                excelFile += '<meta http-equiv="Content-type" content="text/html;charset=' + $defaults.encoding + '" />';
                excelFile += "<!--[if gte mso 9]>";
                excelFile += "<xml>";
                excelFile += "<x:ExcelWorkbook>";
                excelFile += "<x:ExcelWorksheets>";
                excelFile += "<x:ExcelWorksheet>";
                excelFile += "<x:Name>";
                excelFile += "{worksheet}";
                excelFile += "</x:Name>";
                excelFile += "<x:WorksheetOptions>";
                excelFile += "<x:DisplayGridlines/>";
                excelFile += "</x:WorksheetOptions>";
                excelFile += "</x:ExcelWorksheet>";
                excelFile += "</x:ExcelWorksheets>";
                excelFile += "</x:ExcelWorkbook>";
                excelFile += "</xml>";
                excelFile += "<![endif]-->";
                excelFile += "<title>{worksheet}</title>";
                excelFile += "</head>";
                excelFile += "<body>";
                excelFile += "{table}";
                //excelFile += htmltable.replace(/"/g, '\'');
                excelFile += "</body>";
                excelFile += "</html>";

                var uri = "data:application/vnd.ms-excel;base64,";
                var ctx = { worksheet: $settings.worksheetName, table: htmltable };
                console.log($settings.worksheetName);
                var doc = format(excelFile, ctx);
                var res = uri + base64(doc);
                return res;
            }
        }

        function base64(s) {
            return window.btoa(unescape(encodeURIComponent(s)));
        }

        function format(s, c) {
            return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; });
        }

        function isBrowserIE() {
            var msie = !!navigator.userAgent.match(/Trident/g) || !!navigator.userAgent.match(/MSIE/g);
            if (msie > 0) {  // If Internet Explorer, return true
                return true;
            }
            else {  // If another browser, return false
                return false;
            }
        }


    };
})(jQuery);

