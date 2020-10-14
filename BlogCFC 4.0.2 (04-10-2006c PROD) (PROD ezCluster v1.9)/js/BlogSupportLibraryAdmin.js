function launchBlogEditor(bool_showHide, id) {
	var _id = '';
	id = (((!!id) && (id.toUpperCase() != 'NEW')) ? id : 'new');
	var cObj = $('div_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : ''));
	_id = 'div_iframe_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : '');
	var iObj = $(_id);
	bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
	if ( (!!cObj) && (!!iObj) ) {
		cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
		if (bool_showHide == true) {
			var _src = js_launchBlogEditorURL + '&id=' + ((id.toUpperCase() != 'NEW') ? id : 'new');
			try {
				iObj.innerHTML = '<iframe id="iframe_blog_editor_' + id + '" width="600" height="650" src="' + _src + '" frameborder="1"></iframe>';
			} catch(e) {
			} finally {
			}
		} else {
			iObj.innerHTML = '';
		}
	}
}

function launchCategoryEditor(bool_showHide, innerWidth) {
	var cObj = $('div_category_editor');
	var iObj = $('div_iframe_category_editor');
	bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
	if ( (!!cObj) && (!!iObj) ) {
		cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
		if (bool_showHide == true) {
			var _src = js_launchBlogEditorURL;
			try {
				iObj.innerHTML = '<iframe id="iframe_category_editor" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
			} catch(e) {
			} finally {
			}
		} else {
			iObj.innerHTML = '';
		}
	}
}

function launchCopyrightViolations(bool_showHide, innerWidth) {
	var cObj = $('div_copyright_violations');
	var iObj = $('div_iframe_copyright_violations');
	bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
	if ( (!!cObj) && (!!iObj) ) {
		cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
		if (bool_showHide == true) {
			var _src = js_launchCopyrightViolationsURL;
			try {
				iObj.innerHTML = '<iframe id="iframe_copyright_violations" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
			} catch(e) {
			} finally {
			}
		} else {
			iObj.innerHTML = '';
		}
	}
}

function refreshHomePage(id, url) {
	launchBlogEditor(false, id);
	window.location.href = url;
}
