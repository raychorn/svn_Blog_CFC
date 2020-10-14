function URLDecode(encoded) {
   var HEXCHARS = "0123456789ABCDEFabcdef"; 
   var plaintext = "";
   var i = 0;
   while (i < encoded.length) {
       var ch = encoded.charAt(i);
	   if (ch == "+") { plaintext += " "; i++;} else if (ch == "%") {
			if (i < (encoded.length-2) && (HEXCHARS.indexOf(encoded.charAt(i+1)) != -1) && (HEXCHARS.indexOf(encoded.charAt(i+2)) != -1) ) {
				plaintext += unescape( encoded.substr(i,3) ); i += 3;
			} else { plaintext += "%[ERROR]"; i++;}
		} else { plaintext += ch; i++;}
	} 
   return plaintext;
}

