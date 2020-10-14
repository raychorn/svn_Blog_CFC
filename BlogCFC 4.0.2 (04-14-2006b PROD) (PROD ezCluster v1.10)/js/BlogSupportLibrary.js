function launchComment(id, bool_showHide, aUrl) {
	var cObj = $('div_addComments_' + id);
	var iObj = $('div_iframe_addComments_' + id);
	bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
	if ( (!!cObj) && (!!iObj) ) {
		cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
		if (bool_showHide == true) {
			var _src = js_launchCommentURL + '&id=' + id;
			try {
				iObj.innerHTML = '<iframe id="iframe_addComments_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
			} catch(e) {
			} finally {
			}
		} else {
			iObj.innerHTML = '';
		}
	}
	if (!!aUrl) window.location.href = aUrl;
}

function launchTrackback(id, bool_showHide) {
	var cObj = $('div_addTrackback_' + id);
	var iObj = $('div_iframe_addTrackback_' + id);
	bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
	if ( (!!cObj) && (!!iObj) ) {
		cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
		if (bool_showHide == true) {
			var _src = js_launchTrackbackURL + '&id=' + id;
			try {
				iObj.innerHTML = '<iframe id="iframe_addTrackback_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
			} catch(e) {
			} finally {
			}
		} else {
			iObj.innerHTML = '';
		}
	}
}

function expandBlogBody(id, divNamePrefix, btnNamePrefix) {
	var cObj = $(divNamePrefix + id);
	var bObj = $(btnNamePrefix + id);
	if ( (!!cObj) && (!!bObj) ) {
		cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style);
		bObj.value = ((cObj.style.display == const_none_style) ? 'Read Blog Post' : 'Hide Blog Post');
	}
}
