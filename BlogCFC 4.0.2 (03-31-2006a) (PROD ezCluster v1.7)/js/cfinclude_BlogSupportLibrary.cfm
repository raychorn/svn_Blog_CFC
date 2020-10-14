<cfoutput>
	function _launchComment(id) {
		cWin = window.open("#application.rooturl#/addcomment.cfm?id="+id,"cWin","width=550,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
	}

	function launchComment(id, bool_showHide) {
		var _src = '';
		var cObj = $('div_addComments_' + id);
		var iObj = $('div_iframe_addComments_' + id);
		bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
		if ( (!!cObj) && (!!iObj) ) {
			cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
			if (bool_showHide == true) {
				_src = '#application.rooturl#/addcomment.cfm?id=' + id + '&uuid=' + uuid();
				iObj.innerHTML = '<iframe id="iframe_addComments_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
			} else {
				iObj.innerHTML = '';
			}
		}
	}
	
	function _launchTrackback(id) {
		cWin = window.open("#application.rooturl#/trackbacks.cfm?id="+id,"cWin","width=500,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}

	function launchTrackback(id, bool_showHide) {
		var _src = '';
		var cObj = $('div_addTrackback_' + id);
		var iObj = $('div_iframe_addTrackback_' + id);
		bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
		if ( (!!cObj) && (!!iObj) ) {
			cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
			if (bool_showHide == true) {
				_src = '#application.rooturl#/trackbacks.cfm?id=' + id + '&uuid=' + uuid();
				iObj.innerHTML = '<iframe id="iframe_addTrackback_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
			} else {
				iObj.innerHTML = '';
			}
		}
	}
	
	<cfif session.loggedin>
		function _launchBlogEditor(id) {
			eWin = window.open("#application.rooturl#/editor.cfm?id="+id,"eWin","width=550,height=700,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
		}
		
		function launchBlogEditor(bool_showHide, id) {
			var _src = '';
			var _id = '';
			id = (((!!id) && (id.toUpperCase() != 'NEW')) ? id : 'new');
			var cObj = $('div_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : ''));
			_id = 'div_iframe_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : '');
			var iObj = $(_id);
			bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
			if ( (!!cObj) && (!!iObj) ) {
				cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
				if (bool_showHide == true) {
					_src = '#application.rooturl#/editor.cfm?id=' + ((id.toUpperCase() != 'NEW') ? id : 'new') + '&uuid=' + uuid();
					iObj.innerHTML = '<iframe id="iframe_blog_editor_' + id + '" width="600" height="650" src="' + _src + '" frameborder="1"></iframe>';
				} else {
					iObj.innerHTML = '';
				}
			}
		}

		function launchCategoryEditor(bool_showHide, innerWidth) {
			var _src = '';
			var cObj = $('div_category_editor');
			var iObj = $('div_iframe_category_editor');
			bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
			if ( (!!cObj) && (!!iObj) ) {
				cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
				if (bool_showHide == true) {
					_src = '#application.rooturl#/category_editor.cfm' + '?uuid=' + uuid();
					iObj.innerHTML = '<iframe id="iframe_category_editor" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
				} else {
					iObj.innerHTML = '';
				}
			}
		}

		function launchCopyrightViolations(bool_showHide, innerWidth) {
			var _src = '';
			var cObj = $('div_copyright_violations');
			var iObj = $('div_iframe_copyright_violations');
			bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
			if ( (!!cObj) && (!!iObj) ) {
				cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
				if (bool_showHide == true) {
					_src = '#application.rooturl#/copyright_violations.cfm' + '?uuid=' + uuid();
					iObj.innerHTML = '<iframe id="iframe_copyright_violations" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
				} else {
					iObj.innerHTML = '';
				}
			}
		}

		function refreshHomePage(id, url) {
			launchBlogEditor(false, id);
			window.location.href = url;
		}
	</cfif>
	function expandBlogBody(id, divNamePrefix, btnNamePrefix) {
		var cObj = $(divNamePrefix + id);
		var bObj = $(btnNamePrefix + id);
		if ( (!!cObj) && (!!bObj) ) {
			cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style);
			bObj.value = ((cObj.style.display == const_none_style) ? 'Read Blog Post' : 'Hide Blog Post');
		}
	}
</cfoutput>
