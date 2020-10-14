function drawData(graphicalChart, fxValue) {
	var typeof_graphicalChart = (typeof graphicalChart);
	graphicalChart = ((graphicalChart != null) ? ((typeof_graphicalChart.toUpperCase() == const_string_symbol.toUpperCase()) ? parseInt(graphicalChart) : ((typeof_graphicalChart.toUpperCase() == const_number_symbol.toUpperCase()) ? graphicalChart : -1)) : -1);
	var oDiagramFrame = $('iframe_diagram1');
	var oForm = $('form_diagram1');
	var oDiagram3D = $('iframe_diagram3D');
	if (graphicalChart != 11) {
		_DiagramTarget = window.frames["F1"];
		_DiagramTarget.document.open();
		_DiagramTarget.document.writeln('<html><head><link rel=stylesheet type="text/css" href="' + document.location.href + 'diagram.css" /></head><body bgcolor="#eeeeee">');
		var D = new Diagram();
		if (!!oDiagramFrame) oDiagramFrame.style.top = '100px';
		if ( (graphicalChart != 12) && (!!oForm) ) oForm.style.display = const_none_style;
	}
	if (!!oDiagram3D) oDiagram3D.style.display = const_none_style;
	switch (graphicalChart) {
		case 0:
			D.SetFrame(70, 30, 380, 200);
			D.SetBorder(10, 50, 0, 4);
			D.SetText("X-Label","Y-Label","Title");

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '440px';
				oDiagramFrame.style.height = '250px';
			}
		break;

		case 1:
			D.SetFrame(100, 150, 580, 460);
			D.SetBorder(1988, 2002, Math.log(Hosts[0])/Math.LN10, Math.log(Hosts[14])/Math.LN10);
			D.SetText("Year", "Hosts", "<B>Internet growth</B>");
			D.XGridDelta=2;
			D.XSubGrids=2;
			D.YGridDelta=1;
			D.YSubGrids=-1;
			D.YScale="function LogScale";
			D.SetGridColor("#FFFFFF", "#EEEEEE");
			D.Draw("#DDDDDD", "#000000", true);
			for (var n=1; n<Hosts.length; n++)
			{ new Line(D.ScreenX(1987+n), D.ScreenY(Math.log(Hosts[n-1])/Math.LN10), 
			           D.ScreenX(1988+n), D.ScreenY(Math.log(Hosts[n])/Math.LN10), "#0000ff", 2, "internet hosts");
			}
			for (n=0; n<Hosts.length; n++)
			{ new Dot(D.ScreenX(1988+n), D.ScreenY(Math.log(Hosts[n])/Math.LN10), 10, 1, "#ff0000", eval(1988+n)+": "+Hosts[n]+" hosts");
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '650px';
				oDiagramFrame.style.height = '520px';
			}
		break;

		case 2:
			D.SetFrame(80, 160, 520, 360);
			D.SetBorder(-1, 13, 0, 1000);
			D.SetText("","", "Website Hits 2001");
			D.XScale=0;
			var i, j, y;
			D.Draw("#FFFF80", "#004080", false);
			Month=new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
			for (i=0; i<12; i++)
			{ y=500+Math.random()*400;
			  j=D.ScreenX(i+0.5);
			  if (i%2==0) new Bar(j-15, D.ScreenY(y), j+15, D.ScreenY(0), "#0000FF", Month[i], "#FFFFFF", "Hits per month");
			  else new Bar(j-15, D.ScreenY(y), j+15, D.ScreenY(0), "#FF0000", Month[i], "#000000", "Hits per month");
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '600px';
				oDiagramFrame.style.height = '420px';
			}
		break;

		case 3:
			D.SetFrame(80, 160, 520, 360);
			D.SetBorder(Date.UTC(2000,11,15,0,0,0), Date.UTC(2001,11,15,0,0,0), 0, 1000);
			D.SetText("","", "Website Hits 2001");
			D.XScale=4;
			D.Draw("", "#004080", false);
			var i, j, y, y0=D.ScreenY(0);
			for (i=0; i<12; i++)
			{ y=D.ScreenY(500+Math.random()*400);
			  j=D.ScreenX(Date.UTC(2001,i,1,0,0,0));
			  if (i%2==0) new Box(j-12, y, j+12, y0, "#0000FF", "v_blue.gif", "#FFFFFF", 1, "#000000");
			  else new Box(j-12, y, j+12, y0, "#FF0000", "v_red.gif", "#000000", 1, "#000000");
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '580px';
				oDiagramFrame.style.height = '420px';
			}
		break;

		case 4:
			D.SetFrame(80, 160, 640, 460);
			D.SetBorder(6, 18, 0, 6);
			D.XGridDelta=1;
			D.SetGridColor("#808080");
			D.Draw("#FF80FF", "#000000", false);
			var Size, Type, x;
			Color=new Array("#000000","#FF0000","#0000FF","#000000","#FF0000","#0000FF");
			for (Size=6; Size<=18; Size++)
			{ x=D.ScreenX(Size);
			  new Dot(x, D.ScreenY(0), Size, 'smile.gif', "", "Type: smile.gif, Size:"+Size);
			  for (Type=1; Type<7; Type++)
			    new Dot(x, D.ScreenY(Type), Size, Type, Color[Type-1], "Type:"+Type+", Size:"+Size);
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '700px';
				oDiagramFrame.style.height = '520px';
			}
		break;

		case 5:
			D.SetFrame(80, 160, 540, 460);
			D.SetBorder(0, eval(2*Math.PI), -1, 1);
			D.SetText("", "", "<B>some functions</B>");
			D.XGridDelta=Math.PI/4;
			D.XScale="function MyXScale";
			D.YGridDelta=0.2;
			D.YSubGrids=2;
			D.SetGridColor("#FFFFFF", "#EEEEEE");
			D.Draw("#DDDDDD", "#000000", false);
			var i, j, x;
			for (i=80; i<=540; i++)
			{ x = D.RealX(i);
			  j= D.ScreenY(Math.sin(x));
			  new Pixel(i, j, "#FF0000");
			  j= D.ScreenY(Math.cos(x));
			  new Pixel(i, j, "#0000FF");
			}
			new Bar(560, 200, 680, 220, "#0000FF", "f(x)=cos(x)", "#FFFFFF");
			new Bar(560, 260, 680, 280, "#FF0000", "f(x)=sin(x)", "#000000");

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '680px';
				oDiagramFrame.style.height = '520px';
			}
		break;

		case 6:
			D.SetFrame(80, 160, 520, 360);
			D.SetBorder(6, 18, 20, 30);
			D.SetText("","", "temperature measured during the day");
			D.XScale=" h";
			D.YScale="° C";
			D.SetGridColor("#cccccc");
			D.Draw("#FFEECC", "#663300", false);
			var t, T0, T1;
			D.GetYGrid();
			_BFont="font-family:Verdana;font-size:10pt;line-height:13pt;";
			for (t=D.YGrid[0]; t<=D.YGrid[2]; t+=D.YGrid[1])
			  new Bar(D.right+6, D.ScreenY(t)-8, D.right+6, D.ScreenY(t)+8, "", Fahrenheit(t), "#663300");
			T1=22;
			for (t=6; t<18; t++)
			{ T0=T1;
			  T1=23-4*Math.cos(t/4)+Math.random();
			  new Line(D.ScreenX(t), D.ScreenY(T0), D.ScreenX(t+1), D.ScreenY(T1), "#cc9966", 2, "temperature");
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '580px';
				oDiagramFrame.style.height = '420px';
			}
		break;

		case 7:
			D.SetFrame(80, 160, 520, 360);
			D.SetBorder(Date.UTC(2000,11,15,0,0,0), Date.UTC(2001,11,15,0,0,0), -300, 1100);
			D.SetText("","", "profit/loss per day during the last year");
			D.XScale=4;
			D.YScale=" $";
			D.Draw("#FFFFCC", "#000000", false);
			var i, t0, t1, P0, P1, base=D.ScreenY(0);
			t1=D.ScreenX(Date.UTC(2000,11,15,0,0,0));
			P1=0;
			for (i=0; i<12; i++)
			{ t0=t1; P0=P1;
			  t1=D.ScreenX(Date.UTC(2001,i,15,0,0,0));
			  P1+=(i/5-Math.random())*100;
			  new Area(t0, D.ScreenY(P0), t1, D.ScreenY(P1), "ff0000", base, "profit/loss per day");
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '580px';
				oDiagramFrame.style.height = '420px';
			}
		break;

		case 8:
			D.SetFrame(60, 140, 300, 380);
			D.SetBorder(-1, 1, -1, 1);
			var i, x, y;
			for (i=0; i<11; i++)
			{ x=Math.sin((i+0.5)*2*Math.PI/11);
			  y=Math.cos((i+0.5)*2*Math.PI/11);
			  new Arrow(D.ScreenX(x/3), D.ScreenY(y/3), D.ScreenX(x), D.ScreenY(y), "#0000ff", i%5+1);
			}

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '360px';
				oDiagramFrame.style.height = '440px';
			}
		break;

		case 9:
			D.SetFrame(10, 140, 300, 380);
			P=new Array();
			P[0]=new Pie(100,240,10,80,0*3.6,10*3.6,"#ff6060");
			P[1]=new Pie(100,240,0,80,10*3.6,40*3.6,"#ffa000");
			P[2]=new Pie(100,240,0,80,40*3.6,100*3.6,"#f6f600");
			new Bar(200,190,280,210,"#ff6060","Apples","#000000","","void(0)","parent.MouseOver(0)","parent.MouseOut(0)");
			new Bar(200,230,280,250,"#ffa000","Oranges","#000000","","void(0)","parent.MouseOver(1)","parent.MouseOut(1)");
			new Bar(200,270,280,290,"#f6f600","Bananas","#000000","","void(0)","parent.MouseOver(2)","parent.MouseOut(2)");

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '360px';
				oDiagramFrame.style.height = '440px';
			}
		break;

		case 10:
			D.SetFrame(10, 140, 700, 920);

			var D1=new Diagram();
			D1.SetFrame(90, 170, 500, 390);
			D1.SetBorder(
			Date.UTC(2001,11,1,8,0,0), Date.UTC(2001,11,1,17,0,0),
			Date.UTC(2003,0,1,0,0,0), Date.UTC(2001,11,1,0,0,0));
			D1.XScale=2;
			D1.YScale=2;
			D1.SetText("","", "<B> Our Call Service 2002</B>");
			D1.Draw("#C0C080", "#004080", false,"Click on a bar to get the phone number");
			Name=new Array("Peter", "Paul", "Mike");
			Job=new Array("Project Manager", "Assistant", "Developer");
			Color=new Array("vFF0000" ,"#00FF00" ,"#0000FF");
			BGColor=new Array("#000000" ,"#000000" ,"#FFFFFF");
			Phone=new Array("000-11-23", "123-45-67", "333-66-99");
			for (var i=0; i<12; i++) new Bar(
			D1.ScreenX(Date.UTC(2001,11,1,8+random(4),30*random(2),0)), 
			D1.ScreenY(Date.UTC(2002,i,1,0,0,0))-8, 
			D1.ScreenX(Date.UTC(2001,11,1,13+random(4),30*random(2),0)), 
			D1.ScreenY(Date.UTC(2002,i,1,0,0,0))+8,
			Color[i%3], Name[i%3], BGColor[i%3], Job[i%3], "parent.ShowPhoneNum("+eval(i%3)+")");
			new Arrow(600,225,565,295,Color[0],2);
			new Arrow(565,325,635,375,"#000000",1);
			new Arrow(610,225,650,375,Color[2],3);
			new Box(570, 180, 640, 220, Color[0], Name[0]+"<br><img src='" + _DiagramImagesHref + "smile.gif'  width=20 height=20 border=0>", BGColor[0], 2, "#000000", Job[0], "parent.ShowPhoneNum(0)");
			new Box(530, 300, 600, 320, Color[1], Name[1], BGColor[1], 2, "#000000", Job[1], "parent.ShowPhoneNum(1)");
			new Box(610, 380, 680, 400, Color[2], Name[2], BGColor[2], 2, "#000000", Job[2], "parent.ShowPhoneNum(2)");
			
			//2nd diagram
			var D2=new Diagram();
			D2.SetFrame(90, 450, 500, 640);
			D2.SetBorder(Date.UTC(2001,11,1,0,0,0), Date.UTC(2001,11,17,0,0,0), 0, 80);
			D2.XScale=2;
			D2.YScale=" $";
			D2.SetText("","", "<B>prices of some selected goods</B>");
			D2.SetGridColor("#DDDDFF");
			D2.Draw("#C0C0FF", "#004080", false);
			Color=new Array("#FF0000","#FF8000","#FFFF00");
			Price=new Array(3);
			for (i=0; i<3; i++) Price[i]=new Array(17);
			for (i=0; i<3; i++)
			{ Price[i][0]=50-20*i+random(5);
			  new Dot(D2.ScreenX(Date.UTC(2001,11,1,0,0,0)), D2.ScreenY(Price[i][0]),
			    12, i, Color[i], Price[i][0]+" $");
			  for (j=1; j<17; j++)
			  { Price[i][j]=Price[i][j-1]+random(10)-4+2*i-random(2*i+2);
			    new Dot(D2.ScreenX(Date.UTC(2001,11,j+1,0,0,0)), D2.ScreenY(Price[i][j]),
			      12, i, Color[i], Price[i][j]+" $");
			  }
			}
			new Bar(520, 500, 600, 520, Color[0], "apples", "#000000");
			new Bar(520, 540, 600, 560, Color[1], "oranges", "#000000");
			new Bar(520, 580, 600, 600, Color[2], "bananas", "#000000");
			
			//3rd diagram
			var xmin, xmax, ymin, ymax, nInterval=21;
			PriceCount=new Array(3);
			for (i=0; i<3; i++) PriceCount[i]=new Array(nInterval);
			for (i=0; i<3; i++)
			{ for (j=0; j<nInterval; j++) PriceCount[i][j]=0;
			}
			xmin=Price[0][0];
			xmax=Price[0][0];
			for (i=0; i<3; i++)
			{ for (j=0; j<17; j++)
			  { if (xmin>Price[i][j]) xmin=Price[i][j];
			    if (xmax<Price[i][j]) xmax=Price[i][j];
			  }
			}
			i=xmax-xmin;
			xmin-=0.1*i;
			xmax+=0.1*i;
			var D3=new Diagram();
			D3.SetFrame(90, 690, 500, 880);
			D3.SetBorder(xmin, xmax, 0, 1);
			D3.XScale=" $";
			D3.GetXGrid();
			for (i=0; i<3; i++)
			{ for (j=0; j<17; j++)
			    PriceCount[i][GetInterval(D3.XGrid[0],D3.XGrid[1],D3.XGrid[2],Price[i][j])]++;
			}
			ymin=0; ymax=0; 
			for (i=0; i<nInterval; i++)
			{ if (ymax<PriceCount[0][i]+PriceCount[1][i]+PriceCount[2][i])
			    ymax=PriceCount[0][i]+PriceCount[1][i]+PriceCount[2][i];
			}
			ymax*=1.1;
			D3.SetBorder(xmin, xmax, ymin, ymax);
			D3.SetText("","", "<B>distribution of prices</B>");
			D3.Draw("#A0C0A0", "#004080", false);
			for (j=0; j<nInterval; j++)
			{ i=D3.ScreenX(D3.XGrid[0]+j*D3.XGrid[1]/2);
			  ymin=D3.ScreenY(0);
			  ymax=D3.ScreenY(PriceCount[0][j]);
			  if (PriceCount[0][j]>0) 
			    new Box(i-10,ymax,i+10,ymin,Color[0],"","#000000",1,"#0000ff",PriceCount[0][j]+" days");
			  ymin=ymax;
			  ymax=D3.ScreenY(PriceCount[0][j]+PriceCount[1][j]);
			  if (PriceCount[1][j]>0) 
			    new Box(i-10,ymax,i+10,ymin,Color[1],"","#000000",1,"#0000ff",PriceCount[1][j]+" days");
			  ymin=ymax;
			  ymax=D3.ScreenY(PriceCount[0][j]+PriceCount[1][j]+PriceCount[2][j]);
			  if (PriceCount[2][j]>0) 
			    new Box(i-10,ymax,i+10,ymin,Color[2],"","#000000",1,"#0000ff",PriceCount[2][j]+" days");
			}
			new Box(520, 740, 600, 760, Color[0], "apples", "#000000", 1, "#0000ff");
			new Box(520, 780, 600, 800, Color[1], "oranges", "#000000", 1, "#0000ff");
			new Box(520, 820, 600, 840, Color[2], "bananas", "#000000", 1, "#0000ff");
			
			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '720px';
				oDiagramFrame.style.height = '940px';
			}
		break;

		case 11:
			if (!!oDiagramFrame) {
				oDiagramFrame.style.display = const_none_style;
			}
			if (!!oForm) {
				var _html = '';
				_html += '<form name="inputform">';
				_html += '<TABLE border="0" CELLPADDING=2 CELLSPACING=2 WIDTH=720>';
				_html += '<TR><TD width=40></TD>';
				_html += '<TD width=50 align=right>x-min:</TD>';
				_html += '<TD width=80 align=left><input name="xmin" value="-4" size=8></TD>';
				_html += '<TD width=50 align=right>x-max:</TD>';
				_html += '<TD width=80 align=left><input name="xmax" value="4" size=8></TD>';
				_html += '<TD width=50 align=right>y-min:</TD>';
				_html += '<TD width=80 align=left><input name="ymin" value="-0.2" size=8></TD>';
 						_html += '<TD width=50 align=right>y-max:</TD>';
				_html += '<TD width=80 align=left><input name="ymax" value="0.5" size=8></TD>';
				_html += '<TD></TD>';
				_html += '</TR>';
				_html += '<TR><TD align=right>y=</TD>';
				_html += '<TD colspan=8 align=left><input id="input_fx" name="fx" value="1/sqrt(2*PI)*exp(-x*x/2)+sin(PI*x)/10" size=56></TD>';
				_html += '<TD><input type=button value="Draw" onClick="var oO = _$(\'input_fx\'); var _fxValue = -1; if (!!oO) { _fxValue = oO.value;  }; drawData(11, _fxValue); drawData(12, _fxValue); return false;"></TD>';
				_html += '</TR>';
				_html += '</TABLE>';
				_html += '</form>';

				oForm.innerHTML = _html;
				oForm.style.display = const_inline_style;
				
				if (!!fxValue) {
					var oO = _$('input_fx');
					if (!!oO) {
						oO.value = fxValue;
					}
				}
			}
		break;

		case 12:
			D.SetFrame(60, 175, 635, 500);
			D.SetBorder(-1, 1, -1, 1);
			D.SetText("x","y", "y=f(x)");
			D.SetGridColor("#808080", "#CCCCCC");
			D.Draw("#DDDDDD", "#000000", true);
			var i, j, x, y;
			j= D.ScreenY(0);
			P=new Array(636);
			for (i=60; i<=635; i++)
			  P[i]=new Pixel(i, j, "#0000FF");

			function Draw() { 
				if ((navigator.userAgent.search("Opera 5")>=0)||(navigator.userAgent.search("Opera 6")>=0)) { 
					alert("Sorry, this doesn't work with this version of Opera.\nUse Opera 7.x, IE 5.x or Netscape 6.x instead.");
			    	return;
			  	}
			  	if ((navigator.appName=="Netscape")&&(parseInt(navigator.appVersion)<5)) { 
					if (!confirm("This is not a safe operation with Netscape 4.x."+
			                " It can cause a crash of the browser."+
			                " Do you want to continue anyway?"))
			      	return;
			  	}
				var xmin=parseFloat(document.inputform.xmin.value);
				var xmax=parseFloat(document.inputform.xmax.value);
				var ymin=parseFloat(document.inputform.ymin.value);
				var ymax=parseFloat(document.inputform.ymax.value);
				if (isNaN(xmin)) { alert("x-min is not a number"); return; }
				if (isNaN(xmax)) { alert("x-max is not a number"); return; }
				if (isNaN(ymin)) { alert("y-min is not a number"); return; }
				if (isNaN(ymax)) { alert("y-max is not a number"); return; }
				D.SetBorder(xmin, xmax, ymin, ymax);
				D.SetText("x", "y", "y="+document.inputform.fx.value);
				D.SetGridColor("#808080", "#CCCCCC");
				D.Draw("#DDDDDD", "#000000", true, "y="+document.inputform.fx.value);
				var isEvalSafe=((window.EvalSafe)&&(EvalSafe("1+1")==2));
				window.status = 'fxValue = [' + fxValue + ']';
				for (i=60; i<=635; i++) { 
					x = D.RealX(i);
					if (isEvalSafe) { 
						y=EvalSafe(document.inputform.fx.value);
						if ((y=="")&&(isNaN(parseInt(y)))) { 
							alert(document.inputform.fx.value+" can not be evaluated for x="+x);
							return; 
						}
					} else { 
						with (Math) y=eval(document.inputform.fx.value);
					}
					if ((ymin<=y)&&(y<=ymax)) P[i].MoveTo(i, D.ScreenY(y));
					else P[i].SetVisibility(false);
				}
			}
			
			Draw();

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '700px';
				oDiagramFrame.style.height = '560px';
				oDiagramFrame.style.top = '200px';
			}
		break;

		case 13:
			D.SetFrame(70, 30, 380, 200);
			D.SetBorder(10, 50, 0, 4);
			D.Draw("#80FF80","#0000FF",false);
			B=new Array();
			for (var i=15; i<50; i+=5)
			  B[i]=new Bar(D.ScreenX(i)-10, D.ScreenY(i%3+1), D.ScreenX(i)+10, D.ScreenY(0), "#00cccc");

			if (!!oDiagramFrame) {
				oDiagramFrame.style.width = '440px';
				oDiagramFrame.style.height = '260px';
			}
		break;
	}
	if (graphicalChart != 11) {
		D.Draw("#80FF80","#0000FF",true,"Click on me !","parent.F1DiagramClick()");
		_DiagramTarget.document.writeln("</body></html>");
		_DiagramTarget.document.close();

		if (!!oDiagramFrame) {
			oDiagramFrame.style.display = const_inline_style;
		}
	}
}

