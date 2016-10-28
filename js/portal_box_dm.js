
function box_dm_new()
{
if(
($('#box_dm_dm').val()=='')||
($('#box_dm_ag_problem').val()=='')||
($('#box_dm_cat_appeal').val()=='')||
($('#box_dm_text').val()=='')
){alert('Please fill in your message');return;}
var fd = new FormData();
fd.append('dm', $('#box_dm_dm').val());
fd.append('ag_problem', $('#box_dm_ag_problem').val());
fd.append('ag_send_db', $('#box_dm_ag_send_db').val());
fd.append('ag_fil', $('#box_dm_ag_fil').val());
fd.append('cat_appeal', $('#box_dm_cat_appeal').val());
fd.append('text', $('#box_dm_text').val());
jQuery.each($('#box_dm_files')[0].files, function(i, file) {
fd.append('files[]', file);
});
$('#box_dm_dm').attr('disabled',true);
$('#box_dm_ag_problem').attr('disabled',true);
$('#box_dm_ag_send_db').attr('disabled',true);
$('#box_dm_ag_fil').attr('disabled',true);
$('#box_dm_cat_appeal').attr('disabled',true);
$('#box_dm_text').attr('disabled',true);
$('#box_dm_result').text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dm_save&new=1&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dm_dm').attr('disabled',false);
$('#box_dm_ag_problem').attr('disabled',false);
$('#box_dm_ag_send_db').attr('disabled',false);
$('#box_dm_ag_fil').attr('disabled',false);
$('#box_dm_cat_appeal').attr('disabled',false);
$('#box_dm_text').attr('disabled',false);
$('#box_dm_result').html(data);
}
});
}

function box_dm_answer(box_id,text)
{
var fd = new FormData();
fd.append('box_id', box_id);
fd.append('text', text);
$('#box_dm_text'+box_id).attr('disabled',true);
$('#box_dm_result'+box_id).text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dm_save&answer=1&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dm_text'+box_id).attr('disabled',false);
$('#box_dm_result'+box_id).html(data);
}
});
}

function box_dm_close(box_id,who)
{
var fd = new FormData();
fd.append('box_id', box_id);
fd.append(who, who);
$('#box_dm_result'+box_id).text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dm_save&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dm_result'+box_id).html(data);
$('#box_dm_result'+box_id).parent().remove();
}
});
}
