
var cifir= new Array("од","дв","три","четыр","п€т","шест","сем","восем","дев€т");
var sotN=new Array("сто","двести","триста","четыреста","п€тьсот","шестьсот","семьсот","восемьсот","дев€тьсот");
var milion=new Array("триллион","миллиард","миллион","тыс€ч");
var anDan =new Array("","","","сорок","","","","","дев€носто");

function SP(XS){
(XS>0? this.XS=sumPROP(Math.floor(XS),Math.round((XS-Math.floor(XS))*100)) : this.XS="ѕусто!" );
return this.XS;
}

function sumPROP(xx,xx1){
var scet=4;
var cifR='';
var cfR='';
var oboR=new Array(0);
//==========================
	if (xx>999999999999999) { cfR="√усто!"; return cfR; }
	while(xx/1000>0){
		yy=Math.floor(xx/1000);
		delen=Math.round((xx/1000-yy)*1000);
		//-------------------------------
		sot=Math.floor(delen/100)*100;
		des=(Math.floor(delen-sot)>9?Math.floor((delen-sot)/10)*10:0);
		ed=Math.floor(delen-sot)-Math.floor((delen-sot)/10)*10;
		//-------------------------------
		forDes=(des/10==2?'а':'')
		forEd=(ed==1?'ин': (ed==2?'е':'') );
		ffD=(ed>4?'ь': (ed==1 || scet<3? (scet<3 && ed<2?'ин': (scet==3?'на': (scet<4? (ed==2?'а':( ed==4?'е':'')) :'на') ) ) : (ed==2 || ed==4?'е':'') ) );
		forTys=(des/10==1? (scet<3?'ов':'') : (scet<3? (ed==1?'': (ed>1 && ed<5?'а':'ов') ) : (ed==1?'а': (ed>1 && ed<5?'и':'') )) );
		//===============================
			oprSot=(sotN[sot/100-1]!=null?sotN[sot/100-1]:'');
			oprDes=' '+(cifir[des/10-1]!=null? (des/10==1?'': (des/10==4 || des/10==9?anDan[des/10-1]:(des/10==2 || des/10==3?cifir[des/10-1]+forDes+'дцать':cifir[des/10-1]+'ьдес€т') ) ) :'');
			oprEd=' '+(cifir[ed-1]!=null? cifir[ed-1]+(des/10==1?forEd+'надцать' : ffD ) : (des==10?'дес€ть':'') );
			oprTys=' '+(milion[scet]!=null && delen>0 ?milion[scet]+forTys:'');
		//-------------------------------
		cifR=(oprSot.length>1?oprSot:'')+
			 (oprDes.length>1?oprDes:'')+
             (oprEd.length>1?oprEd:'')+
			 (oprTys.length>1?oprTys:'');
		oboR[oboR.length]=cifR;
		xx=Math.floor(xx/1000);
		scet-=1;
		if ( Math.floor(xx)<1 ) {	break;	}
	}
		oboR.reverse();
		for (i=0; i<oboR.length; i++){
			cfR+=oboR[i]+' ';
		}
		(cfR.length<3?cfR='ноль ':cfR);
		cfR+='грн. '+xx1+' коп.';
		return cfR;
}
