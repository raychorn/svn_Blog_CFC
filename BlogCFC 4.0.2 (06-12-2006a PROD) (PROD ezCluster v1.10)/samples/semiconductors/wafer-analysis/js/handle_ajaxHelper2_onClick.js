function handle_ajaxHelper2_onClick() {
	var cObj = $('td_ajaxHelperPanel2'); 
	var bObj = $('btn_helperPanel2'); 
	var tbObj = $('table_ajaxHelperPanel2');
	if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { 
		cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); 
		bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); 
		if (cObj.style.display == const_inline_style) { 
			tbObj.style.width = _global_clientWidth; 
		} else { 
		}; 
	};
}

