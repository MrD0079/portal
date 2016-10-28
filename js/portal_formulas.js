function getZaySum(zid,fid)
{
	var fd = new FormData();
	fd.append('param',  'getZaySum('+zid+','+fid+')');
	$.ajax({
		type: 'POST',
		url: '?action=bud_ru_zay_func_res&nohead=1',
		data: fd,
		processData: false,
		contentType: false,
		success: function(data) {
			var r=eval(data);
			r!=r?r=null:r=r.toFixed(3);
			$('#new_st_'+fid).val(r);
			$("input[name='new_st["+fid+"]']").val(r);
		}
	});
}

function getTPType(zid,fid)
{
	var fd = new FormData();
	fd.append('param',  'getTPType('+zid+','+fid+')');
	$.ajax({
		type: 'POST',
		url: '?action=bud_ru_zay_func_res&nohead=1',
		data: fd,
		processData: false,
		contentType: false,
		success: function(data) {
			var r=eval(data);
			r!=r?r=null:r=r.toFixed(3);
			$('#new_st_'+fid).val(r);
			$("input[name='new_st["+fid+"]']").val(r);
		}
	});
}

