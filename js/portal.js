$iterator=0;

function init_number(mode)
{
	$(function() {$('input.number').autoNumeric(mode, {aSep: '', mDec: 2, vMin: -99999999999999.99, vMax: 99999999999999.99});});
	$(function() {$('input.number3').autoNumeric(mode, {aSep: '', mDec: 3, vMin: -99999999999999.999, vMax: 99999999999999.999});});
	$(function() {$('input.number5').autoNumeric(mode, {aSep: '', mDec: 5, vMin: -99999999999999.99999, vMax: 99999999999999.99999});});
	$(function() {$('input.number_int').autoNumeric(mode, {aSep: '', mDec: 0, vMin: -99999999999999, vMax: 99999999999999});});
	$('input.number,input.number3,input.number5,input.number_int').bind('paste', function (e) {
		var self = this;
		var target = e.target;
		setTimeout(function(e) {
			var str = $(self).val(); 
			str = str.replace(/,/g, ".");
			str = str.replace(/ /g, "");
			if (Number($(self).val())!=Number(str))
			{
				//console.log($(self).val()+'=>'+str);
				$(target).val(str);
			}
		}, 0);
	});
}

var DisabledDates={"period":[{ "from": "01/01/1999", "to": "01/01/1999" }]};
/*var DisabledDates ={"period":[{ "from": "01/06/2015", "to": "05/06/2015" },{ "from": "08/06/2015", "to": "12/06/2015" }]};*/
function DateDisabled(date){var i, num, period, start, startArray, end, endArray;num = DisabledDates.period.length;for(i=0;i<num;i++){period = DisabledDates.period[i];startArray = period.from.split('/');start = new Date(startArray[2]-0, startArray[1]-1, startArray[0]-0);endArray = period.to.split('/');end = new Date(endArray[2]-0, endArray[1]-1, endArray[0]-0);if(date>=start && date<=end){return true;}}return false;}
//function DPInit(){$(".datepicker").datepicker({beforeShowDay:function(date){return[!DateDisabled(date)];}});}

function init_form()
{
	$(function($){
		$("input:submit", "" ).button();
		$('.datepicker').mask('99.99.9999');
		$('.timepicker').mask('99:99:99');
		$.datepicker.setDefaults(
			{
				dateFormat: 'dd.mm.yy',
			}
		);
		$.datepicker._gotoToday = function (id) {
			$(id).datepicker('setDate', new Date()).datepicker('hide').blur();
			//$(id).datepicker('setDate', new Date()).datepicker('hide').click();
			$(id).trigger("change");
			//console.log(id);
		};
		$(".datepicker").not(".hasDatepicker").datepicker();
		$(".datepicker").datepicker({beforeShowDay:function(date){return[!DateDisabled(date)];}});
		$(".datepicker").datepicker( "option", "showOtherMonths", true);
		$(".datepicker").datepicker( "option", "showButtonPanel", true);
		$(".datepicker").datepicker( "option", "beforeShow", function( input ) {
			setTimeout(function() {
				var buttonPane = $( input )
				.datepicker( "widget" )
				.find( ".ui-datepicker-buttonpane" );
				$( "<button>", {
					text: "Clear",
					click: function() {
						$.datepicker._clearDate( input );
					}
				}).appendTo( buttonPane ).addClass("ui-datepicker-clear ui-state-default ui-priority-primary ui-corner-all");
			}, 1 );
		});
		$(".datepicker").datepicker( "option", "onChangeMonthYear", function( year, month, instance ) {
			setTimeout(function() {
				var buttonPane = $( instance )
				.datepicker( "widget" )
				.find( ".ui-datepicker-buttonpane" );
				$( "<button>", {
					text: "Clear",
					click: function() {
						$.datepicker._clearDate( instance.input );
					}
				}).appendTo( buttonPane ).addClass("ui-datepicker-clear ui-state-default ui-priority-primary ui-corner-all");
			}, 1 );
		});
//$(".ui-datepicker-clear").hide();
		/*
		{literal}
		$(
			function()
			{
				var dt = new Date();
				dt.setMonth(dt.getMonth()-1);
				$(".datepicker_prev1").datepicker( "option", "minDate", dt);
			}
		)
		{/literal}
		*/
		$(".datepicker_3_0").datepicker( "option", "minDate", -3);
		$(".datepicker_3_0").datepicker( "option", "maxDate", +0);
		$(".datepicker_7_0").datepicker( "option", "minDate", -7);
		$(".datepicker_7_0").datepicker( "option", "maxDate", +0);
		$(".datepicker").attr('readonly','readonly');
	});
}

init_form();

$(function(){$("form").submit(function(){var error=0;$(this).find(":input").each(function(){if(!$(this).attr("disabled")&&$(this).attr("required")&&!$(this).val()){/*$(this).css('border', 'red 1px solid');*/error=1;}else{/*$(this).css('border', 'gray 1px solid');*/}});if(error==0){return true;}else{var error_msg = "Please fill in the required fields";alert(error_msg);return false;}});});
function blink_text(el){op=.9;/*$('#'+el).html('<p id="loadwait">Load data ...</p>');*/x=setInterval(function(){op=.9-op;$('#'+el).animate({opacity:.1+op});},500);return x;}
function loadwait_show(el){op=.9;$('#'+el).html('<p id="loadwait"><img src="/design/AVK_Logo_37x18.png"></p>');x=setInterval(function(){op=.9-op;$('#loadwait').animate({opacity:.1+op});},500);return x;}
function loadwait_hide(x){clearInterval(x);}

$(document).on('ready ajaxComplete',
	function()
	{
		$(document).keyup(function(e){if(e.keyCode == 27){$('.hov').css('visibility','hidden');}});
		$('.pics').mouseover(function(){$('.hov').css('visibility','hidden');$(this).find('.hov').css('visibility','visible');});
		$('.hov').mouseout(function(){$(this).css('visibility','hidden');});
		$('.hov').click(function(){$(this).css('visibility','hidden');});
		init_form();
		init_number('init');
		/*init_number('update');*/
		$(window).scroll(function(){if($(window).scrollTop()>=500&&$(window).width()>=1200){$('#toTop').fadeIn();}else{$('#toTop').fadeOut();}});
		$('#toTop').click(function(){$("body,html").animate({scrollTop:0},300);});
	}
);

$.getScript("https://ps.avk.ua/js/portal_box_dpu.js");
$.getScript("https://ps.avk.ua/js/portal_box_dm.js");
$.getScript("https://ps.avk.ua/js/portal_formulas.js");

function advance_save(m,tn,val,cur_id,elem)
{
$('#'+elem).css('background-color','red');
var fd = new FormData();
fd.append('m',  m);
fd.append('tn',  tn);
fd.append('val',  val);
fd.append('cur_id',  cur_id);
$('#adv_result').text('');
$.ajax({
  type: 'POST',
  url: '?action=main_adv&nohead=1',
  data: fd,
  processData: false,
  contentType: false,
  success: function(data) {
    $('#adv_result').html(data);
    $('#'+elem).css('background-color','white');
  }
});
}



