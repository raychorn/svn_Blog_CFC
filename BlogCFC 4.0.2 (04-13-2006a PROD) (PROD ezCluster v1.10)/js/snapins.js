function openCodeFormatter() {
	var cObj = $('div_code_formatter');
	if (cObj != null) {
		cObj.style.display = const_inline_style;
	}
	
	var cObj = $('btn_formatCode');
	if (cObj != null) {
		cObj.disabled = true;
	}
}

function closeCodeFormatter() {
	var cObj = $('div_code_formatter');
	if (cObj != null) {
		cObj.style.display = const_none_style;
	}

	var cObj = $('btn_formatCode');
	if (cObj != null) {
		cObj.disabled = false;
	}
}

function replaceLeadingWhiteSpaceWithPadding(s) {
	var i = -1;
	var ch = -1;
	var d = '';
	var t = '';
	var lineBreakCnt = 1;
	var lineBreakDelta = 200;
	
	for (i = 0; i < s.length; i++) {
		ch = s.charCodeAt(i);
		if (ch <= 32) {
			t = '&nbsp;';
		} else {
			if (ch == 60) {
				t = '&lt;';
			} else if (ch == 62) {
				t = '&gt;';
			} else {
				t = s.substring(i,i + 1);
			}
		}
		d += t;
		if (d.length > lineBreakDelta) {
			d += '<br>';
			lineBreakCnt++;
			lineBreakDelta += 200;
		}
	}
	return d;
}

function performCodeFormatter() {
	var s = '';
	var i = -1;
	var a = -1;
	var fmtCode = '';
	var cObj = $('ta_code_to_format');
	var dObj = $('ta_formated_code');
	if ( (cObj != null) && (dObj != null) ) {
		s = cObj.value;
		a = s.split('\n');
		fmtCode = '';
		fmtCode += '<table width="100%" border="0" cellspacing="-1" cellpadding="-1" class="code">';
		for (i = 0; i < a.length; i++) {
			fmtCode += '<tr>';
			fmtCode += '<td>';
			fmtCode += replaceLeadingWhiteSpaceWithPadding(a[i]);
			fmtCode += '</td>';
			fmtCode += '</tr>';
			fmtCode += '\n';
		}
		fmtCode += '</table>';
		dObj.value = fmtCode;
	}
}
