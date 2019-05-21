$(window).load(function(){
    var $brand_select2 = $('.brand_select').select2({
        multiple: true,
        ajax: {
            url: "?action=sku_avk_brand&print=1&pdf=1",
            dataType: 'json',
            delay: 250,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            data: function (params) {
                return {
                    q: params.term, // search term
                    page: params.page
                };
            },
            processResults: function (data, params) {
                params.page = params.page || 1;
                for (key in data.items){
                    for (name in data.items[key]) {
                        if (name == "disabled") {
                            data.items[key][name] = data.items[key][name] == "1" ? true : false;
                        }
                    }
                }
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
        placeholder: 'Поиск бренда по имени или по id',
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
        var isDisabledClass = repo.status ? '' : 'field-disabled';
        var item = "<div class='sku_item_option "+isDisabledClass+"'>"+repo.name+"</div>";
        return item;
    }
    //text was show if option is selected
    function formatRepoSelection (repo) {
        return repo.name || repo.text;
    }
    // Fetch the preselected item, and add to the control
    $("input[name*='row_id[']").each(function(){
        var $select2 = $(this).parent().find(".brand_select");
        row_id_tmp = $(this).val();
        if(row_id_tmp != 0 && row_id_tmp != ""){
            //console.log(row_id);
            $.ajax({
                url: "?action=sku_avk_brand&print=1&pdf=1",
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                data: {row_id:row_id_tmp}
            }).then(function (data) {
                if(data.items[0].text && data.items[0].text.length > 0){
                    console.log("empty - "+row_id_tmp);
                }else{
                    AddBrand($select2,data.items);
                }
            });
        }
    });

    window.testLoadBrands = function(){
        $("input[name*='row_id[']").each(function(){
            var $select2 = $(this).parent().find(".brand_select");
            row_id_tmp = $(this).val();
            if(row_id_tmp != 0 && row_id_tmp != ""){
                //console.log(row_id);
                $.ajax({
                    url: "?action=sku_avk_brand&print=1&pdf=1",
                    dataType: 'json',
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    data: {row_id:row_id_tmp}
                }).then(function (data) {
                    if(data.items[0].text && data.items[0].text.length > 0){
                        console.log("empty - "+row_id_tmp);
                    }else{
                        AddBrand($select2,data.items);
                    }
                });
            }
        });
    }

    if($(".row_id").length > 0){
        $(".row_id").each(function(){
            if($(this).val() != ""){
                var row_id_tmp = $(this).val();
                $(this).load('?action=sku_avk_brand&print=1&pdf=1',{row_id:row_id_tmp},function(response, status, xhr) {
                    if(status == "success"){
                        var resp = JSON.parse(response);
                        var brands = [];
                        $.each(resp.items,function(k,v){
                            brands.push(v.name);
                        });
                        if(brands.length > 0)
                            $(this).parent().find(".brands").text(brands.join(", "));
                    }
                });
            }
        });
    }
    function AddBrand(select2,items){
        var brandsSelect = select2;
        $.each( items, function( key, value ) {
            // create the option and append to Select2
            var text = value.text;
            if(value.name)
                text = value.name;
            var option = new Option(text, value.id, true, true);
            brandsSelect.append(option).trigger('change');
        });
        // manually trigger the `select2:select` event
        brandsSelect.trigger({
            type: 'select2:select',
            params: {
                data: items
            }
        });
    }
});