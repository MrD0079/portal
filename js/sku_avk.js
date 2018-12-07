$(window).load(function(){
    $('#sku_select').select2({
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
        if(repo.type_name != null && repo.weight != null)
            item_table += '<tr>'+
            '<td>Упаковка</td>'+
            '<td>'+repo.weight+' '+repo.type_name+'</td>'+
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
            if($.isArray(repo)){
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
            if($("input[name=sku_values]").val() != "") {
                var sku_list = JSON.parse($("input[name=sku_values]").val());
                $.each(sku_list,function(k,v){
                    if(arr['id'] == v.id){
                        arr['total_volume_q'] = v.total_volume_q;
                        return false;
                    }
                });
            }
        }
        for(name in arr){
            if(arr[name] === "undefined" || arr[name] == null)
                arr[name] = Math.floor((Math.random() * 10) + 1);
        }
        return arr;
    }
    //delete sku item from table
    // $('#sku_select').on("select2:unselect", function (e) {
    //     RemoveSkuHTML(e.params.data.id);
    // });
    $('#sku_select').on('select2:unselecting', function (e) {
        if (confirm('Удалить товар из списка ?')) {
            RemoveSkuHTML(e.params.args.data.id);
        }else{
            e.preventDefault();
        }
    });

    // Fetch the preselected item, and add to the control
    console.log("zid: "+zid);
    if(zid != null && zid != 0 && zid != ""){
        $.ajax({
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {get_list:1,z_id:zid}
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

    function LoadSkuListValues(sku_list){
        $.ajax({
            url: "?action=sku_avk&print=1&pdf=1",
            dataType: 'json',
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: {
                net_id: ($("#net").val() != "") ? $("#net").val() : 0,
                q:0,
                sku_list: sku_list
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
    if($("input[name=sku_values]").val() != ""){
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
            '<td>'+
            '<input type="text" name="sku_params[tag_id][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.tag_id+'">'+
            '<input type="hidden" name="sku_params[id][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.id+'">'+
            '<input type="hidden" name="sku_params[logistic_expens_m_plan][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.logistic_expens_m_plan+'">'+
            '<input type="hidden" name="sku_params[all_company_expenses][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.all_company_expenses+'">'+
            '<input type="hidden" name="sku_params[mark_cost_plan_cur_m][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.mark_cost_plan_cur_m+'">'+
            '</td>'+
            '<td>'+sku.name_brand;
        outputHTML +=    "<input type='hidden' name='sku_params[name_brand][]' size='7' style='text-align: center;' disabled='disabled' value='"+sku.name_brand+"'>";
        outputHTML += '</td>'+
            '<td>'+sku.name;
        outputHTML +=    "<input type='hidden' name='sku_params[name][]' size='7' style='text-align: center;' disabled='disabled' value='"+sku.name+"'>";
        outputHTML += '</td>'+
            '<td><input type="text" name="sku_params[weight][]" size="3" style="text-align: center;" disabled="disabled" value="'+sku.weight+'"></td>'+
            '<td><input type="text" name="sku_params[price_ss][]" size="7" style="text-align: center;" disabled="disabled" value="'+sku.price_ss+'"></td>'+
            '<td><input type="text" name="sku_params[price_urkaine][]" size="3" style="text-align: center;" disabled="disabled" value="'+sku.price_urkaine+'"></td>'+
            '<td><input type="text" name="sku_params[price_s_kk][]" size="3" style="text-align: center;" disabled="disabled" value="'+sku.price_s_kk+'"></td>'+
            '<td><input type="text" name="sku_params[price_one][]" size="3" style="text-align: center;" disabled="disabled" value="'+sku.price_one+'"></td>';
        outputHTML += '<td class="type2"><input type="text" name="sku_params[price_one_discount][]" size="3" style="text-align: center;" disabled="disabled" value="'+sku.price_one_discount+'"></td>';
        sku.total_volume_q = (typeof sku.total_volume_q !== "undefined") ? sku.total_volume_q : 0;
        outputHTML += '<td><input type="text" class="new" name="sku_params[total_volume_q][]" size="7" style="text-align: center;" value="'+sku.total_volume_q+'"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[total_volume_price][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[total_volume_price_one][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML += '<td class="type2"><input type="text" class="calc-input" name="sku_params[total_volume_price_one_discount][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML += '<td><input type="text" class="calc-input" name="sku_params[ss_volume][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[expected_vp][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[bonus_net][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML += '<td class="type1"><input type="text" class="calc-input" name="sku_params[akc_expenses][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML += '<td><input type="text" class="calc-input" name="sku_params[share_expenses][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[logistics_expenses][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[company_expenses][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td><input type="text" class="calc-input" name="sku_params[net_clear][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML += '<td class="type2"><input type="text" class="calc-input" name="sku_params[prom_costs_discount][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>'+
            '<td class="type2"><input type="text" class="calc-input" name="sku_params[total_network_costs][]" size="3" style="text-align: center;" disabled="disabled" value="0"></td>';
        outputHTML +=  '</tr>';
        $("#sku_selected tbody").append($(outputHTML));
        SkuSelectedInit();
        ChangeAkciyaType(akc_type);
    }

    function RemoveSkuHTML(sku_id){
        $("#sku_selected tr[data-sku-id='"+sku_id+"']").remove();
    }
    function SetAkciyaTypeToSelect(){
        var akc_type = $("#akciya_type").val();
        if(akc_type != ""){
            $(".akc_type_base").val($(".akc_type_base option[data-type='"+akc_type+"']").val());
        }
    }
    function SetAkciyaTypeFromSelect(akc_type){
        if(akc_type !== "undefined")
            $("#akciya_type").val(akc_type);
    }
    SetAkciyaTypeToSelect();
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
            $('#sku_selected .colspan5').prop("colspan","5");
        }else{
            $('#sku_selected .type2').css("display","");
            $('#sku_selected .type1').css("display","none");
            $('#sku_selected .colspan5').prop("colspan","4");
        }
        if(recalc)
            reCalculateSkuAll();
    }
    function reCalculateSkuAll(){
        $('#sku_selected input[name*="sku_params[total_volume_q]"]').each(function(){
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
    SkuSelectedInit();
    function SkuSelectedInit(){
        // --- Actions
        var wto;
        var inputWeight = function(){
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
        $('#sku_selected input.new[name*="sku_params[total_volume_q]"]').on("input change",inputWeight);

        //get object with all sku items values as assoc. array
        window.GetSkuSelectedAll = function (){
            var result = [];
            $('#sku_selected tbody').find('tr').each(function(){
                var res = {};
                $(this).find('input[name*="sku_params"]').not(".calc-input").each(function(){
                    res[$(this).prop('name').split(/sku_params\[([a-z_]*)/)[1]] = $(this).val();
                });
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
                result[$(this).prop('name').split(/sku_params\[([a-z_]*)/)[1]] = ($(this).val() !== "undefined" ) ? $(this).val() : 0;
            });
            return result;
        }

        window.CalculateSku = function(el){
            var sku = GetSkuSelectedOne($(el));
            var akc_type = $("#akciya_type").val() ? $("#akciya_type").val() : 1,
                bonus_net_perc = $("#bonus_net_perc").val() ? $("#bonus_net_perc").val() : 0,
                bonus_distr_pers = $("#bonus_distr_pers").val() ? $("#bonus_distr_pers").val() : 0,
                akciya_expences_perc = $("#akciya_expences_perc").val() ? $("#akciya_expences_perc").val() : 0;

            ChangeAkciyaType(akc_type,false);
            var sku_values = [];
            //sku.total_volume_q;//объем продаж шт.
            sku_values['total_volume_price'] = sku.total_volume_q*sku.weight;//объем продаж кг.
            sku_values['total_volume_price_one'] = sku.total_volume_q*sku.price_one;//объем продаж грн
            sku_values['price_one_discount'] = sku.price_one - ((sku.price_one*akciya_expences_perc)/100);
            sku_values['total_volume_price_one_discount'] = sku.total_volume_q*sku_values['price_one_discount'];//объем продаж грн. СКИДКА
            sku_values['ss_volume'] = sku.total_volume_q*sku.price_ss;//СС на объем отгрузки
            if(akc_type == 1){
                sku_values['expected_vp'] = sku_values['total_volume_price_one']-sku_values['ss_volume'];//Ожидаемая ВП
                sku_values['bonus_net'] = sku_values['total_volume_price_one']*bonus_net_perc;//бонус сети
            }else{
                sku_values['expected_vp'] = sku_values['total_volume_price_one_discount']-sku_values['ss_volume'];//Ожидаемая ВП
                sku_values['bonus_net'] = sku_values['total_volume_price_one_discount']*bonus_net_perc;//бонус сети
            }
            sku_values['share_expenses'] = sku.price_urkaine*sku.total_volume_q*bonus_distr_pers;//Бонус дистриб
            sku_values['akc_expenses'] = sku_values['total_volume_price_one']*akciya_expences_perc;//затраты по акции б/н
            sku_values['logistics_expenses'] = sku_values['total_volume_price']*sku.logistic_expens_m_plan;//Расходы по логистике
// --- Расходы компании: (все расходы компании)+(маркетинг к себестоимости из плана тек. месяца)
            //sku.all_company_expenses + sku.mark_cost_plan_cur_m
            sku_values['company_expenses'] = (sku.all_company_expenses + sku.mark_cost_plan_cur_m)*sku_values['ss_volume'];//Расходы компании
            sku_values['net_clear'] = sku_values['expected_vp']-sku_values['logistics_expenses']-sku_values['company_expenses'];//чистая прибыль
            if(akc_type == 1)
                sku_values['net_clear'] -= sku_values['akc_expenses'];//чистая прибыль
            sku_values['prom_costs_discount'] = sku_values['total_volume_price_one']-sku_values['total_volume_price_one_discount'];//Расходы по акции в скидке
            sku_values['total_network_costs'] = sku_values['bonus_net']+sku_values['share_expenses']+sku_values['logistics_expenses']+sku_values['company_expenses']+sku_values['prom_costs_discount'];//Всего затрат по сети
            SetCalculateField(el,sku_values);
        }
        function ClearCalculatedFields(el){
            $(el.parents('tr')[0]).find('input.calc-input').val('0');
        }
        function SetCalculateField(el,data){
            for (var param in data) {
                $(el.parents('tr')[0]).find('input[name*="sku_params['+param+']"]').val(data[param]);
            }
        }
    }
});