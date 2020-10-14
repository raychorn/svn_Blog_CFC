var bool_isAnyErrorRecords = false;
var bool_isAnyPKErrorRecords = false;
var bool_isHTMLErrorRecords = false;

function anyErrorRecords(_ri, _dict, _rowCntName) {
	var errorMsg = '';
	var isPKerror = '';
	var isHTML = '';
	
	try {
		errorMsg = _dict.getValueFor('ERRORMSG');
		isPKerror = _dict.getValueFor('ISPKVIOLATION');
		isHTML = _dict.getValueFor('ISHTML');
	} catch(e) {
	} finally {
	}

	bool_isAnyErrorRecords = ( (!!errorMsg) && (errorMsg.length > 0) );
	bool_isAnyPKErrorRecords = ( (!!isPKerror) && (isPKerror.length > 0) );
	bool_isHTMLErrorRecords = ( (!!isHTML) && (isHTML.length > 0) );
	
	s_explainError = '';

	if ( (bool_isAnyErrorRecords) || (bool_isAnyPKErrorRecords) || (bool_isHTMLErrorRecords) ) {
		try {
			if (bool_isHTMLErrorRecords) {
				s_explainError += _dict.getValueFor('ERRORMSG');
			} else {
				s_explainError += _dict.getValueFor('ERRORMSG').stripHTML().stripSpacesBy2s().stripCrLfs().stripTabs(' ');
			}
		} catch(e) {
		} finally {
		}

		try {
			if (bool_isHTMLErrorRecords) {
				s_explainError += '\n' + _dict.getValueFor('MOREERRORMSG');
			} else {
				s_explainError += '\n' + _dict.getValueFor('MOREERRORMSG').stripHTML().stripSpacesBy2s().stripCrLfs().stripTabs(' ');
			}
		} catch(e) {
		} finally {
		}
	}
}

