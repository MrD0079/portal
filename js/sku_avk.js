$(window).load(function(){
    LoadDistribBonus();
    var init_glob = false;
    var $sku_select2 = $('#sku_select').select2({
        multiple: true,
        ajax: {
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            delay: 250,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: function (params) {
                return {
                    q: params.term, // search term
                    net_id: ($("#net").val() != "") ? $("#net").val() : 0,
                    sw_kod: ($("#sw_kod").val() != "") ? $("#sw_kod").val() : 0,
                    page: params.page
                };
            },
            processResults: function (data, params) {
                // parse the results into the format expected by Select2
                // since we are using custom formatting functions we do not need to
                // alter the remote JSON data, except to indicate that infinite
                // scrolling can be used
                params.page = params.page || 1;
                return {
                    results: data.items,
                    pagination: {
                        more: (params.page * 2) < data.total_count
                    }
                };
            },
            cache: true
        },
        language: "ru",
        placeholder: 'Поиск товара по имени, по sku, по tag',
        escapeMarkup: function (markup) {return markup; }, // let our custom formatter work
        minimumInputLength: 3,
        templateResult: formatRepo,
        templateSelection: formatRepoSelection
    });
    function formatRepo (repo) {
        if (repo.loading) {
            return repo.text;
        }
        if(repo.text){
            return "<div style='color:#000;'>"+repo.text+"</div>";
        }

        var item = "<div class='sku_item_option'>(<strong>"+repo.sku_id+"</strong>) "+
            repo.name+
            " <strong>"+repo.weight+": "+repo.type_name+"</strong> ( ";
        if(repo.bar_pot != null)
            item += "Штрих код(пот): <strong>"+repo.bar_pot+"</strong>; ";
        if(repo.bar_log != null)
            item +="Штрих код(лог): <strong>"+repo.bar_log+"</strong>; ";
        if(repo.bar_box != null)
            item +="Штрих код(бокс): <strong>"+repo.bar_box+"</strong>; ";
        item +="TAG ID: <strong>"+repo.tag_id+"</strong>)"+
            "</div>";
        var item_table = '<div class="sku_item_option no-padding">'+
            '<table  width=100% border="1" style="text-align:center;border-color:#eee;    border-color: #9a9a9a;">'+
            '<thead>'+
            '<tr>'+
            '<th colspan=2>'+repo.name+'</th>'+
            '</tr>'+
            '</thead>'+
            '<tbody>'+
            '<tr>'+
            '<td>SKU ID</td>'+
            '<td>'+repo.sku_id+'</td>'+
            '</tr>'+
            '<tr>'+
            '<td>Бренд</td>'+
            '<td>'+repo.name_brand+'</td>'+
            '</tr>';
        //if(repo.type_name != null && repo.weight != null)
        if(repo.weight != null)
            item_table += '<tr>'+
            '<td>Упаковка</td>'+
            '<td>'+repo.weight+' '+(repo.type_name != null ? repo.type_name : 'кг')+'</td>'+
            '</tr>';
        item_table +='<tr>'+
            '<td>TAG ID</td>'+
            '<td>'+repo.tag_id+'</td>'+
            '</tr>';
        if(repo.bar_pot != null)
            item_table += '<tr>'+
                '<td>Штрих код(пот)</td>'+
                '<td>'+repo.bar_pot+'</td>'+
                '</tr>';
        if(repo.bar_log != null)
            item_table += '<tr>'+
                '<td>Штрих код(лог)</td>'+
                '<td>'+repo.bar_log+'</td>'+
                '</tr>';
        if(repo.bar_box != null)
            item_table += '<tr>'+
                '<td>Штрих код(бокс)</td>'+
                '<td>'+repo.bar_box+'</td>'+
                '</tr>';
        item_table += '</tbody>'+
            '</table>'+
            '</div>';
        return item_table;
        return item;
    }
    //text was show if option is selected
    function formatRepoSelection (repo) {
        return repo.name || repo.text;
    }
    //add sku item in table with inputs when select it in select2
    $('#sku_select').on('select2:select', function (e) {
        try {
            var repo = e.params.data,
                akc_type = $("#akciya_type").val() ? $("#akciya_type").val() : 1;

            //if($.isArray(repo) || typeof repo === "object"){
            if($.isArray(repo) ){
                $.each(repo,function (i,v) {
                    v = CheckInicialization(v);
                    AddSkuHTML(akc_type,v);
                })
            }else{
                repo = CheckInicialization(repo);
                AddSkuHTML(akc_type,repo);
            }
        } catch (err) {
            console.log(err);
        }
    });
    //if some value is not initialize then set random() value
    function CheckInicialization(arr){
        if(arr['total_volume_q'] == null || arr['total_volume_q'] === "undefined"){
            if($("input[name=sku_values]").val() != "" && $("input[name=sku_values]").val() != "[]") {
                try{
                    var sku_list = JSON.parse($("input[name=sku_values]").val());
                    $.each(sku_list,function(k,v){
                        if(arr['id'] == v.id){
                            arr['total_volume_q'] = v.total_volume_q;
                             return false;
                        }
                    });
                }catch(err) {
                    console.log(err);
                }
            }
        }
        for(name in arr){
            if(arr[name] === "undefined" || arr[name] == null){
                arr[name] = 0;
            }
            //arr[name] = Math.floor((Math.random() * 10) + 1);
            arr[name] = NormalizeFloat(arr[name]);
        }
        return arr;
    }
    //delete sku item from table
    // $('#sku_select').on("select2:unselect", function (e) {
    //     RemoveSkuHTML(e.params.data.id);
    // });
    $('#sku_select').on('select2:unselecting', function (e) {
        if (confirm('Удалить продукт из списка ?')) {
            RemoveSkuHTML(e.params.args.data.id);
        }else{
            e.preventDefault();
        }
    });
    function DeleteAllSku(){
        $.each($('#sku_select').val(),function(k,v){
            RemoveSkuHTML(v);
        });
        $('#sku_select').val(null).trigger('change');
    }
    TriggerChangeNet = function(){
        var $net = $(this);
        var old_id_net = $net.attr("data-old-id");
        if(old_id_net != ""){
            $('#bonus_distr_pers').val("");
            LoadDistribBonus(old_id_net);
        }
    }
    $("#net").on('focus', function () {
        $(this).attr("data-old-id",$(this).val());
    });
    $("#net").on("change",TriggerChangeNet);

    function LoadDistribBonus(old_id_net = false){
        if($('#bonus_distr_pers').val() == ""){
            var fil_kod = 0;
            if(typeof $("#fil_kod").val() != "undefined" && $("#fil_kod").val() != ""){
                fil_kod = $("#fil_kod").val() ;
            }else if (typeof $("#new_fil").val() != "undefined" && $("#new_fil").val() != "") {
                fil_kod = $("[name*='new[fil]']").val() ;
            };
            $('#bonus_distr_pers').load('?action=sku_avk&print=1&pdf=1',{distrib_bonus:fil_kod},function(response, status, xhr) {
                if(status == "success"){
                    var resp = JSON.parse(response);
                    var perc = resp.items[0].procent;
                    if(typeof perc !== "undefined"){
                        perc = NormalizeFloat(perc);
                        perc *= 100;
                        perc = perc.toFixed(2);

                    }else{
                        perc = 0;
                    }

                    $(this).val(perc);
                }
                InitSkuList(old_id_net);
            });
        }
    }
    function NormalizeFloat(float){
        float = float+"";
        if(float.substr(0,1) == ".")
            float = "0"+float ;
        return float;
    }
    // Fetch the preselected item, and add to the control
    console.log("zid: "+zid);
    if(zid != null && zid != 0 && zid != ""){
        $.ajax({
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {
                z_id:zid,
                net_id: ($("#net").val() != "") ? $("#net").val() : 0,
                sw_kod: ($("#net").val() != "") ? $("#sw_kod").val() : 0
            }
        }).then(function (data) {
            if(data.items[0].text && data.items[0].text.length > 0){
                console.log("empty");
            }else{
                AddSku(data.items);
            }
        });
    }


    //test function for load selected sku from DB by some z_id
    window.testLoadSku = function(id){
        $.ajax({
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {z_id:id}
        }).then(function (data) {
            if(data.items[0].text && data.items[0].text.length > 0){
                console.log("empty");
            }else{
                AddSku(data.items);
            }
        });
    }

    //add sku items into select2, then into table and reCalculate it
    function AddSku(items){
        var productsSelect = $('#sku_select');
        $.each( items, function( key, value ) {
            // create the option and append to Select2
            var text = value.text;
            if(value.name)
                text = value.name;
            var option = new Option(text, value.id, true, true);
            productsSelect.append(option).trigger('change');
        });
        // manually trigger the `select2:select` event
        productsSelect.trigger({
            type: 'select2:select',
            params: {
                data: items
            }
        });
    }

    function LoadSkuListValues(sku_list,z_id = 0){
        $.ajax({
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {
                net_id: ($("#net").val() != "") ? $("#net").val() : 0,
                sw_kod: ($("#sw_kod").val() != "") ? $("#sw_kod").val() : 0,
                q:0,
                sku_list: sku_list,
                z_id:z_id
            }
        }).then(function (data) {
            if(data.items[0].text && data.items[0].text.length > 0){
                console.log("empty");
            }else{
                AddSku(data.items);
            }
        });
    }


    //initialize sku list again if we back to the step1
    function InitSkuList(old_id_net = false){
        if($("input[name=sku_values]").val() != "" && $("input[name=sku_values]").val() != "[]"){
            var arr = JSON.parse($("input[name=sku_values]").val());
            if($("input[name=step_params]").val() != ""){
                var step_params = JSON.parse($("input[name=step_params]").val());
                if(step_params.id_net != $('[name*="new[id_net]"]').val()){
                    //достать из БД новые цены для текущей сети
                    console.log("New old_net_id: "+step_params.id_net);
                    var sku_list = [];
                    $.each( arr, function( key, value ) {
                        sku_list.push(value.id);
                    });
                    sku_list = sku_list.join(',');
                    LoadSkuListValues(sku_list);
                }else{
                    AddSku(arr);
                }
            }else{
                AddSku(arr);
            }

        }else if(old_id_net && $("input[name=sku_values]").val() == ""){ //when edit
            if(old_id_net != $('[name*="new[id_net]"]').val()){
                //достать из БД новые цены для текущей сети
                console.log("New old_net_id: "+old_id_net);
                var sku_list = $("#sku_select").val();
                sku_list = sku_list.join(',');
                if(zid === null && zid == 0 && zid == "") {
                    zid_tmp = false;
                }else{
                    zid_tmp = zid;
                    DeleteAllSku();
                }
                LoadSkuListValues(sku_list,zid_tmp);
            }
        }
    }

    function escapeHtml(text) {
        var map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };

        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    //add sku item into table
    function AddSkuHTML(akc_type,sku){
        var outputHTML = '<tr style="text-align: center;" data-sku-id="'+sku.id+'">'+
            '<td><input type="button" value="X" class="del_sku_current new" title="Удалить SKU"></td>'+
            '<td>'+
            '<input type="text" name="sku_params['+sku.id_num+'][tag_id]" size="7" style="text-align: center;" readonly="readonly" value="'+sku.tag_id+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][id_num]" size="7" style="text-align: center;" value="'+sku.id_num+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][id]" size="7" style="text-align: center;" value="'+sku.id+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][sku_id]" size="7" style="text-align: center;" value="'+sku.sku_id+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][logistic_expens]" size="7" style="text-align: center;" d value="'+sku.logistic_expens+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][company_expens]" size="7" style="text-align: center;"  value="'+sku.company_expenses+'">'+
            '<input type="hidden" name="sku_params['+sku.id_num+'][market_val]" size="7" style="text-align: center;"  value="'+sku.market_val+'">'+
            '</td>'+
            '<td>'+sku.name_brand;
        outputHTML +=    "<input type='hidden' name='sku_params["+sku.id_num+"][name_brand]' size='7' style='text-align: center;'  value='"+sku.name_brand+"'>";
        outputHTML += '</td>'+
            '<td>'+sku.name;
        outputHTML +=    "<input type='hidden' name='sku_params["+sku.id_num+"][name]' size='7' style='text-align: center;' value='"+sku.name+"'>";
        outputHTML += '</td>'+
            '<td><input type="text" name="sku_params['+sku.id_num+'][weight]" size="4" style="text-align: center;" readonly="readonly" value="'+sku.weight+'"></td>'+
            '<td><input type="text" name="sku_params['+sku.id_num+'][price_ss]" size="4" style="text-align: center;" readonly="readonly" value="'+sku.price_ss+'"></td>'+
            '<td><input type="text" name="sku_params['+sku.id_num+'][price_urkaine]" size="4" style="text-align: center;" readonly="readonly" value="'+sku.price_urkaine+'"></td>'+
            '<td><input type="text" class="new change_input" name="sku_params['+sku.id_num+'][price_s_kk]" size="4" style="text-align: center;"  value="'+sku.price_s_kk+'"></td>'+ /* readonly="readonly" */
            '<td><input type="text" class="new change_input" name="sku_params['+sku.id_num+'][price_one]" size="4" style="text-align: center;"  value="'+sku.price_one+'"></td>'; /* readonly="readonly" */
        outputHTML += '<td class="type2"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][price_one_discount]" size="4" style="text-align: center;" readonly="readonly" value="'+sku.price_one_discount+'"></td>';
        sku.total_volume_q = (typeof sku.total_volume_q !== "undefined") ? sku.total_volume_q : 0;
        sku.add_expenses = (typeof sku.add_expenses !== "undefined") ? sku.add_expenses : 0;
        outputHTML += '<td><input type="text" class="new change_input" name="sku_params['+sku.id_num+'][total_volume_q]" size="5" style="text-align: center;" value="'+sku.total_volume_q+'"></td>';
        var outputHTMLCalculated = '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][total_volume_price]" size="4" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td style="background-color: #ffeb3b8a;"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][total_volume_price_one]" size="5" style="text-align: center;font-weight: bold" readonly="readonly" value="0"></td>';
        outputHTMLCalculated += '<td class="type2"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][total_volume_price_one_discount]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>';
        outputHTMLCalculated += '<td style="display: none;"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][ss_volume]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][expected_vp]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][bonus_net]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>';
        outputHTMLCalculated += '<td class="type1"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][akc_expenses]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>';
        outputHTMLCalculated += '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][share_expenses]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][logistics_expenses]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][company_expenses]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="new change_input" name="sku_params['+sku.id_num+'][add_expenses]" size="5" style="text-align: center;"  value="'+sku.add_expenses+'"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][net_clear]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][summ_prom_cost]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>';
        outputHTMLCalculated += '<td class="type2"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][prom_costs_discount]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>'+
            '<td class="type2"><input type="text" class="calc-input" name="sku_params['+sku.id_num+'][total_network_costs]" size="5" style="text-align: center;" readonly="readonly" value="0"></td>';
        outputHTML += outputHTMLCalculated;
        outputHTML +=  '</tr>';
        $("#sku_selected tbody").append($(outputHTML));
        SkuSelectedInit();
        ChangeAkciyaType(akc_type);
        $("#sku_selected").css("display","table");
    }

    function RemoveSkuHTML(sku_id){
        $("#sku_selected tr[data-sku-id='"+sku_id+"']").remove();
        if($("#sku_selected tbody tr").length <= 0)
            $("#sku_selected").css("display","none");
    }
    function SetAkciyaTypeToSelect(){
        var akc_type = $("#akciya_type").val();
        if(akc_type != ""){
            $(".akc_type_base").val($(".akc_type_base option[data-type='"+akc_type+"']").val());
        }else{
            $("#akciya_type").val($(".akc_type_base option:selected").attr("data-type"));
        }
    }
    function SetAkciyaTypeFromSelect(akc_type){
        if(akc_type !== "undefined")
            $("#akciya_type").val(akc_type);
    }
    SetAkciyaTypeToSelect();



    function SyncElem(elem1,elem2,reverse = false){
        var tmp_val = elem2.val();
        if(!reverse){
            if(tmp_val != "")
                elem1.val(tmp_val);
            else
                elem2.val(elem1.val());
        }else{
            tmp_val = elem1.val();
            if(tmp_val != "")
                elem2.val(tmp_val);
        }
    }
    var SyncElemEvent = function($elem1,$elem2){
        // do stuff when user has been idle for 0.5 second
        if($elem1.val() != $elem1.prop("data-val") && $elem1.val() != ""){
            $elem1.prop("data-val",$elem1.val());
            SyncElem($elem1,$elem2,true);
            $('#akciya_expences_perc').trigger("change");
        }
    }

    SyncElem($(".akciya_expences_perc"),$("#akciya_expences_perc"),false);
    SyncElem($(".bonus_net_perc"),$("#bonus_net_perc"),false);

    $('.akciya_expences_perc, .bonus_net_perc').on("input change",function(){
        SyncElemEvent($(this),$("#"+$(this).attr('class')));
    });


    $('.akciya_expences_perc, .bonus_net_perc').on('keypress', function(e){
        return SetOnlyFloatNumber($(this),e);
    });

    function SetOnlyFloatNumber(el,e){
        e = e || event;
        if (e.ctrlKey || e.altKey || e.metaKey) return;
        var chr = getChar(e);
        // с null надо осторожно в неравенствах,
        // т.к. например null >= '0' => true
        // на всякий случай лучше вынести проверку chr == null отдельно
        if (chr == null){
            if(el.val() != ""){ /* ctrl+v */
                var str = el.val();
                var is_dot = false;
                var output_str = "";
                for (var i = 0; i < str.length; i++) {
                    chr = str.charAt(i);
                    if(chr == ','){
                        chr = '.';
                    }
                    if (chr < '0' || chr > '9') {
                        if(chr != '.'){
                            el.val("");
                            return false;
                        }else if (!is_dot){
                            is_dot = true;
                            output_str += chr;
                            continue;
                        }
                    }
                    if(chr == '.' && is_dot){
                        el.val("");
                        return false;
                    }
                    output_str += chr;
                }
                el.val(output_str);
            }
            return;
        }

        if (chr < '0' || chr > '9') {
            if(chr != '.')
                return false;
        }
        if(chr == '.' && el.val().indexOf('.') > 0){
            return false;
        }
    }
    // event.type должен быть keypress
    function getChar(event) {
        if (event.which == null) { // IE
            if (event.keyCode < 32) return null; // спец. символ
            return String.fromCharCode(event.keyCode)
        }

        if (event.which != 0 && event.charCode != 0) { // все кроме IE
            if (event.which < 32) return null; // спец. символ
            return String.fromCharCode(event.which); // остальные
        }

        return null; // спец. символ
    }
    //recalculate sku values when akciya type was change
    $('.akc_type_base').on('change', function (e) {
        var $optionSelected = $("option:selected", this);
        var valueSelected = $optionSelected.data("type");
        setTimeout(function () {
            SetAkciyaTypeFromSelect(valueSelected);
            ChangeAkciyaType(valueSelected);
        },500);
    });

    //change table format for akciya type
    function ChangeAkciyaType(akc_type, recalc = true){
        if(akc_type == 1){
            $('#sku_selected .type1').css("display","");
            $('#sku_selected .type2').css("display","none");
            $('#sku_selected .colspan6').prop("colspan","6");
            $('#sku_selected .colspan11').prop("colspan","11");
        }else{
            $('#sku_selected .type2').css("display","");
            $('#sku_selected .type1').css("display","none");
            $('#sku_selected .colspan6').prop("colspan","5");
            $('#sku_selected .colspan11').prop("colspan","12");
        }
        if(recalc)
            reCalculateSkuAll();
    }
    function reCalculateSkuAll(){
        $('#sku_selected input[name*="[total_volume_q]"]').each(function(){
            CalculateSku($(this));
        });
    }

    //reCalculate sku values when some input change value
    var wtoR;
    var reCalculateSkuAllEvent = function(){
        clearTimeout(wtoR);
        var $elem = $(this);
        wtoR = setTimeout(function() {
            // do stuff when user has been idle for 0.5 second
            if($elem.val() != $elem.prop("data-val") && $elem.val() != ""){
                $elem.prop("data-val",$elem.val());
                reCalculateSkuAll();
            }
        }, 500);

    }
    $('#akciya_expences_perc').on("input change",reCalculateSkuAllEvent);

    //init all functions for new sku item
    if(!init_glob)
        SkuSelectedInit();
    function SkuSelectedInit(){
        init_glob = true;
        $('.change_input').on('keypress  input change', function(e){
            return SetOnlyFloatNumber($(this),e);
        });
        var DelSKUTrigger = function(){
            var $elem = $(this);
            $elem.removeClass('new');
            if (confirm('Удалить продукт из списка ?')) {
                RemoveSkuByButton($elem);
            }
        }
        function RemoveSkuByButton($button){
            var $row = $($button.parents('tr')[0]);
            var id = $row.find('input[name*="[id]"]').val();
            var wanted_option = $('#sku_select option[value="'+id+'"]');
            wanted_option.prop('selected', false);
            $('#sku_select').trigger('change.select2');
            $row.remove();
            if($("#sku_selected tbody tr").length <= 0)
                $("#sku_selected").css("display","none");
        }
        $(".del_sku_current.new").on("click",DelSKUTrigger);
        // --- Actions
        var wto;
        var inputChange = function(){
            clearTimeout(wto);
            var $elem = $(this);
            wto = setTimeout(function() {
                // do stuff when user has been idle for 0.5 second
                if($elem.val() != $elem.prop("data-val") && $elem.val() != ""){
                    $elem.prop("data-val",$elem.val());
                    $elem.removeClass('new');
                    CalculateSku($elem);
                }else if($elem.val() == ""){
                    ClearCalculatedFields($elem);
                }
            }, 500);
        }
        //$('#sku_selected input.new[name*="[total_volume_q]"]').on("input change",inputWeight);
        $('#sku_selected input.new.change_input').on("input change",inputChange);

        //get object with all sku items values as assoc. array
        window.GetSkuSelectedAll = function (){
            var result = [];
            //var result = {};
            $('#sku_selected tbody').find('tr').each(function(){
                var res = {};
                $(this).find('input[name*="sku_params"]').not(".calc-input").each(function(){
                    //res[$(this).prop('name').split(/sku_params\[\]\[([a-z_]*)/)[1]] = $(this).val();
                    var tmp_ = $(this).prop('name').split('][')[1];
                    res[tmp_.substr(0,tmp_.length-1)] = $(this).val();
                    //res[$(this).prop('name').split(/sku_params\[([a-z_]*)/)[1]] = $(this).val();
                });
                var id_num = ""+$(this).attr('data-sku-id')+"";
                //result[id_num ] = res;
                result.push(res);
            });
            return result;
        }
        window.GetStepParams = function(){
            var result = {};
            result['id_net'] = $('[name*="new[id_net]"]').val();

            return result;
        }

        //get sku values from inputs in table
        function GetSkuSelectedOne(el){
            var container = $(el.parents('tr')[0]);
            var result = [];
            container.find('input[name*="sku_params"]').each(function(){
                var tmp_ = $(this).prop('name').split('][')[1];
                result[tmp_.substr(0,tmp_.length-1)] = ($(this).val() !== "undefined" ) ? $(this).val() : 0;
                //result[$(this).prop('name').split(/sku_params\[([a-z_]*)/)[1]] = ($(this).val() !== "undefined" ) ? $(this).val() : 0;
            });
            return result;
        }

        window.CalculateSku = function(el){
            var sku = GetSkuSelectedOne($(el));
            // console.log(sku);
            var akc_type = $("#akciya_type").val() ? $("#akciya_type").val() : 1,
                bonus_net_perc = $("#bonus_net_perc").val() ? $("#bonus_net_perc").val()/100 : 0,
                bonus_distr_pers = $("#bonus_distr_pers").val() ? $("#bonus_distr_pers").val()/100 : 0,
                akciya_expences_perc = $("#akciya_expences_perc").val() ? $("#akciya_expences_perc").val()/100 : 0;

            ChangeAkciyaType(akc_type,false);
            var sku_values = [];
            //sku.total_volume_q;//объем продаж шт.
            sku_values['total_volume_price'] = sku.total_volume_q*sku.weight;//объем продаж кг.
            sku_values['total_volume_price_one'] = sku.total_volume_q*sku.price_one;//объем продаж грн
            sku_values['price_one_discount'] = sku.price_one - (sku.price_one*akciya_expences_perc);
            sku_values['total_volume_price_one_discount'] = sku.total_volume_q*sku_values['price_one_discount'];//объем продаж грн. СКИДКА
            sku_values['ss_volume'] = sku_values['total_volume_price'] *sku.price_ss;//СС на объем отгрузки
            if(akc_type == 1){
                sku_values['expected_vp'] = sku_values['total_volume_price_one']-sku_values['ss_volume'];//Ожидаемая ВП
                sku_values['bonus_net'] = sku_values['total_volume_price_one']*bonus_net_perc;//бонус сети
            }else{
                sku_values['expected_vp'] = sku_values['total_volume_price_one_discount']-sku_values['ss_volume'];//Ожидаемая ВП
                sku_values['bonus_net'] = sku_values['total_volume_price_one_discount']*bonus_net_perc;//бонус сети
            }
            sku_values['share_expenses'] = sku.price_urkaine*sku.total_volume_q*bonus_distr_pers;//Бонус дистриб
            sku_values['akc_expenses'] = sku_values['total_volume_price_one']*akciya_expences_perc;//затраты по акции б/н
            sku_values['logistics_expenses'] = sku_values['total_volume_price']*sku.logistic_expens*0.001;//Расходы по логистике

            company_expens = sku.company_expens * sku_values['total_volume_price'] * 0.001; //цена за тонну -> кг
            market_val = sku.market_val * sku_values['total_volume_price'] * 0.001;
            sku_values['company_expenses'] = (company_expens + market_val) / 1 /* Выручка от реализации */ * sku_values['ss_volume'];//Расходы компании
            all_expenses = sku_values['bonus_net'] + sku_values['share_expenses'] + sku_values['logistics_expenses'] + sku_values['company_expenses'] + parseFloat(sku.add_expenses);
            sku_values['net_clear'] = sku_values['expected_vp']-(all_expenses);//чистая прибыль
            if(akc_type == 1)
                sku_values['net_clear'] -= sku_values['akc_expenses'];//чистая прибыль
            sku_values['summ_prom_cost'] = sku_values['akc_expenses'] * 1.2; // Сумма затрат по акции, грн с НДС
            sku_values['prom_costs_discount'] = sku_values['total_volume_price_one']-sku_values['total_volume_price_one_discount'];//Расходы по акции в скидке
            sku_values['total_network_costs'] = all_expenses+sku_values['prom_costs_discount'];//Всего затрат по сети
            SetCalculateField(el,sku.id,sku_values);
            calcTotal();
        }
        function calcTotal(){
            var total_arr = {};
            total_arr['total_vol_price'] = 0;
            total_arr['total_prom_cost'] = 0;
            $("#sku_selected tbody tr").each(function(e){
                total_arr['total_vol_price'] += parseFloat($(this).find("input[name*='[total_volume_price_one]']").val());
                total_arr['total_prom_cost'] += parseFloat($(this).find("input[name*='[summ_prom_cost]']").val());
            });
            total_arr['total_vol_price'] = total_arr['total_vol_price'].toFixed(5);
            total_arr['total_prom_cost'] = total_arr['total_prom_cost'].toFixed(5);
            $("#sku_selected .total_vol_price").val(total_arr['total_vol_price']);
            $("#sku_selected .total_prom_cost").val(total_arr['total_prom_cost']);
        }
        function ClearCalculatedFields(el){
            $(el.parents('tr')[0]).find('input.calc-input').val('0');
        }
        function SetCalculateField(el,id_num,data){
            for (var param in data) {
                var val = data[param];
                if(param != "total_volume_price" && param != "price_one_discount"){ // обьем продаж кг
                    val = (data[param]/1000).toFixed(5); // перевод в тыс. грн
                }
                if(param == "price_one_discount"){
                    val = data[param].toFixed(2);
                }
                $(el.parents('tr')[0]).find('input[name*="sku_params['+id_num+']['+param+']"]').val(val);
            }
            //$("input[name=sku_values]").val(escapeHtml(JSON.stringify(GetSkuSelectedAll())));
        }
        $("#sku_selected .new").removeClass('new');
    }
});