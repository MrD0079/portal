function del_fil(id)
{
save_fil(id,'id',id);
$('#tr_'+id).remove();
}

function save_fil(id,field,val)
{
$('#div_'+id+'_'+field).css('background-color','red');
var fd = new FormData();
fd.append('id', id);
fd.append('field', field);
fd.append('val', val);
$.ajax({
  type: 'POST',
  url: '?action=bud_fil_save&print=1&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
   $('#div_'+id+'_'+field).css('background-color','white');
  }
});
}

function copy_passport(from,to)
{
	$('.passport').html('');
	var fd = new FormData();
	fd.append('from', from);
	fd.append('to', to);
	$.ajax({
		type: 'POST',
		url: '?action=bud_fil_passport_copy&print=1&nohead=1',
		data: fd,
		processData: false,
		contentType: false,
		success: function(data) {
			show_passport(to);
		}
	});
}

function save_contact(id,field,val)
{
$('#divc_'+id+'_'+field).css('background-color','red');
var fd = new FormData();
fd.append('id', id);
fd.append('field', field);
fd.append('val', val);
$.ajax({
  type: 'POST',
  url: '?action=bud_fil_save_contact&print=1&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
   $('#divc_'+id+'_'+field).css('background-color','white');
  }
});
}

function del_contact(id)
{
save_contact(id,'id',id);
$('#trc_'+id).remove();
}

function add_contact(id)
{
var fd = new FormData();
fd.append('parent', id);
$.ajax({
  type: 'POST',
  url: '?action=bud_fil_passport_new_contact&print=1&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
  $('#tcontacts_'+id+'>tbody:last').append(''+data+'');
  init_form();
  }
});
}

function del_contract(id)
{
var fd = new FormData();
fd.append('id', id);
$.ajax({
  type: 'POST',
  url: '?action=bud_fil_passport_del_contract&print=1&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
  $('#trcr_'+id).remove();
  }
});
}

function add_contract(id)
{
if ($('#fn_'+id)[0].files.length==0) {return;}
var fd = new FormData();
fd.append('parent', id);
jQuery.each($('#fn_'+id)[0].files, function(i, file) {
fd.append('img['+i+']', file);
});
$.ajax({
  type: 'POST',
  url: '?action=bud_fil_passport_new_contract&print=1&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
  $('#tcontracts_'+id+'>tbody:last').append(''+data+'');
  init_form();
  }
});
}
