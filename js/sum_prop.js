
var cifir= new Array("��","��","���","�����","���","����","���","�����","�����");
var sotN=new Array("���","������","������","���������","�������","��������","�������","���������","���������");
var milion=new Array("��������","��������","�������","�����");
var anDan =new Array("","","","�����","","","","","���������");

function SP(XS){
(XS>0? this.XS=sumPROP(Math.floor(XS),Math.round((XS-Math.floor(XS))*100)) : this.XS="�����!" );
return this.XS;
}

function sumPROP(xx,xx1){
var scet=4;
var cifR='';
var cfR='';
var oboR=new Array(0);
//==========================
	if (xx>999999999999999) { cfR="�����!"; return cfR; }
	while(xx/1000>0){
		yy=Math.floor(xx/1000);
		delen=Math.round((xx/1000-yy)*1000);
		//-------------------------------
		sot=Math.floor(delen/100)*100;
		des=(Math.floor(delen-sot)>9?Math.floor((delen-sot)/10)*10:0);
		ed=Math.floor(delen-sot)-Math.floor((delen-sot)/10)*10;
		//-------------------------------
		forDes=(des/10==2?'�':'')
		forEd=(ed==1?'��': (ed==2?'�':'') );
		ffD=(ed>4?'�': (ed==1 || scet<3? (scet<3 && ed<2?'��': (scet==3?'��': (scet<4? (ed==2?'�':( ed==4?'�':'')) :'��') ) ) : (ed==2 || ed==4?'�':'') ) );
		forTys=(des/10==1? (scet<3?'��':'') : (scet<3? (ed==1?'': (ed>1 && ed<5?'�':'��') ) : (ed==1?'�': (ed>1 && ed<5?'�':'') )) );
		//===============================
			oprSot=(sotN[sot/100-1]!=null?sotN[sot/100-1]:'');
			oprDes=' '+(cifir[des/10-1]!=null? (des/10==1?'': (des/10==4 || des/10==9?anDan[des/10-1]:(des/10==2 || des/10==3?cifir[des/10-1]+forDes+'�����':cifir[des/10-1]+'������') ) ) :'');
			oprEd=' '+(cifir[ed-1]!=null? cifir[ed-1]+(des/10==1?forEd+'�������' : ffD ) : (des==10?'������':'') );
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
		(cfR.length<3?cfR='���� ':cfR);
		cfR+='���. '+xx1+' ���.';
		return cfR;
}
