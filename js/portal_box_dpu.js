
function box_dpu_new()
{
if(($('#box_dpu_subj').val()=='')||($('#box_dpu_text').val()=='')){alert('Please fill in your message');return;}
var fd = new FormData();
fd.append('subj', $('#box_dpu_subj').val());
fd.append('text', $('#box_dpu_text').val());
$('#box_dpu_subj').attr('disabled',true);
$('#box_dpu_text').attr('disabled',true);
$('#box_dpu_result').text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dpu_save&new=1&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dpu_subj').attr('disabled',false);
$('#box_dpu_text').attr('disabled',false);
$('#box_dpu_result').html(data);
}
});
}

function box_dpu_answer(box_id,text)
{
var fd = new FormData();
fd.append('box_id', box_id);
fd.append('text', text);
$('#box_dpu_text'+box_id).attr('disabled',true);
$('#box_dpu_result'+box_id).text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dpu_save&answer=1&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dpu_text'+box_id).attr('disabled',false);
$('#box_dpu_result'+box_id).html(data);
}
});
}

function box_dpu_close(box_id,who)
{
var fd = new FormData();
fd.append('box_id', box_id);
fd.append(who, who);
$('#box_dpu_result'+box_id).text('');
$.ajax({
type: 'POST',
url: '?action=main_box_dpu_save&nohead=1',
data: fd,
processData: false,
contentType: false,
success: function(data) {
$('#box_dpu_result'+box_id).html(data);
$('#box_dpu_result'+box_id).parent().remove();
}
});
}
