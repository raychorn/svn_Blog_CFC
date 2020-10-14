//*** BEGIN: cross-browser getSelection() ***********************************************************************/

function _getSelection() {
	var txt = '';
	if (window.getSelection) {
		txt = window.getSelection();
	}
	else if (document.getSelection)	{
		txt = document.getSelection();
	}
	else if (document.selection) {
		var r = document.selection.createRange();
		txt = r.text;
	}
	else return;
}

//*** END! cross-browser getSelection() ***********************************************************************/
