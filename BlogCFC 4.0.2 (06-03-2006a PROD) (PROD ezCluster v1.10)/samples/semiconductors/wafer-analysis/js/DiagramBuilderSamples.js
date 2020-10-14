Hosts=new Array(28174, 80000, 290000, 500000, 727000, 1200000, 2217000, 4852000, 9472000, 16146000, 29670000, 43230000, 72398092, 109574429, 147344723);
function LogScale(vv)
{ if ((vv>3)||(vv<-3)) return("10<sup>"+vv+"</sup>");
  if (vv>=0) return(Math.round(Math.exp(vv*Math.LN10)));
  else return(1/Math.round(Math.exp(-vv*Math.LN10)));
}

function MyXScale(xx)
{ var vv=Math.round(xx*4/Math.PI);
  if (vv==0) return(0);
  if (vv==4) return("<img src=\"" + _DiagramImagesHref + "pi.gif\">");
  if (vv==8) return("2 <img src=\"" + _DiagramImagesHref + "pi.gif\">");
  if (vv%2==0) return(eval(vv/2)+"/2 <img src=\"" + _DiagramImagesHref + "pi.gif\">");
  return(vv+"/4 <img src=\"" + _DiagramImagesHref + "pi.gif\">");
}

function Fahrenheit(vv){ return("<nobr>"+Math.round(vv*18+320)/10+"° F</nobr>"); }

function MouseOver(i) { P[i].MoveTo("","",10); }
function MouseOut(i) { P[i].MoveTo("","",0); }

function GetInterval(mmin,ddelta,mmax,vvalue)
{ var ii, nn=0;
  for (ii=mmin; ii<mmax; ii+=ddelta/2)
  { if (vvalue<ii+ddelta/4) return(nn);
    nn++;
  }
  return(nn);
}

function random(vv)
{ return(Math.floor(Math.random()*vv));
}

function ShowPhoneNum(ii)
{ alert("Dial "+Phone[ii]+" to speak with "+Name[ii]+".");
}

