<cfset _launchCommentURL = Request.commonCode.makeLinkToSelfBase("addcomment.cfm")>
<cfset _launchTrackbackURL = Request.commonCode.makeLinkToSelfBase("trackbacks.cfm")>
<cfset _launchBlogEditorURL = Request.commonCode.makeLinkToSelfBase("editor.cfm")>
<cfset _launchCategoryEditorURL = Request.commonCode.makeLinkToSelfBase("category_editor.cfm")>
<cfset _launchCopyrightViolationsURL = Request.commonCode.makeLinkToSelfBase("copyright_violations.cfm")>

<cfoutput>
	function launchComment(id, bool_showHide, aUrl) {
		var cObj = $('div_addComments_' + id);
		var iObj = $('div_iframe_addComments_' + id);
		bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
		if ( (!!cObj) && (!!iObj) ) {
			cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
			if (bool_showHide == true) {
				var _src = '#_launchCommentURL#' + '&id=' + id;
				try {
					flushGUIObjectChildrenForObj(iObj);
					iObj.innerHTML = '<iframe id="iframe_addComments_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
				} catch(e) {
				} finally {
				}
			} else {
				try {
					flushGUIObjectChildrenForObj(iObj);
				} catch(e) {
				} finally {
				}
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
				var _src = '#_launchTrackbackURL#' + '&id=' + id;
				try {
					flushGUIObjectChildrenForObj(iObj);
					iObj.innerHTML = '<iframe id="iframe_addTrackback_' + id + '" width="580" height="500" src="' + _src + '" frameborder="1"></iframe>';
				} catch(e) {
				} finally {
				}
			} else {
				try {
					flushGUIObjectChildrenForObj(iObj);
				} catch(e) {
				} finally {
				}
				iObj.innerHTML = '';
			}
		}
	}
	
	<cfif session.persistData.loggedin>
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
					var _src = '#_launchBlogEditorURL#' + '&id=' + ((id.toUpperCase() != 'NEW') ? id : 'new');
					try {
						flushGUIObjectChildrenForObj(iObj);
						iObj.innerHTML = '<iframe id="iframe_blog_editor_' + id + '" width="600" height="650" src="' + _src + '" frameborder="1"></iframe>';
					} catch(e) {
					} finally {
					}
				} else {
					try {
						flushGUIObjectChildrenForObj(iObj);
					} catch(e) {
					} finally {
					}
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
					var _src = '#_launchBlogEditorURL#';
					try {
						flushGUIObjectChildrenForObj(iObj);
						iObj.innerHTML = '<iframe id="iframe_category_editor" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
					} catch(e) {
					} finally {
					}
				} else {
					try {
						flushGUIObjectChildrenForObj(iObj);
					} catch(e) {
					} finally {
					}
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
					var _src = '#_launchCopyrightViolationsURL#';
					try {
						flushGUIObjectChildrenForObj(iObj);
						iObj.innerHTML = '<iframe id="iframe_copyright_violations" width="' + innerWidth + '" height="350" src="' + _src + '" frameborder="1"></iframe>';
					} catch(e) {
					} finally {
					}
				} else {
					try {
						flushGUIObjectChildrenForObj(iObj);
					} catch(e) {
					} finally {
					}
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
