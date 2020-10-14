<cfoutput>
	function _launchComment(id) {
		cWin = window.open("#application.rooturl#/addcomment.cfm?id="+id,"cWin","width=550,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
	}

	function launchComment(id, bool_showHide) {
		var cObj = getGUIObjectInstanceById('div_addComments_' + id);
		var iObj = getGUIObjectInstanceById('iframe_addComments_' + id);
		bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
		if ( (!!cObj) && (!!iObj) ) {
			cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
			if (bool_showHide == true) iObj.src = '#application.rooturl#/addcomment.cfm?id=' + id;
		}
	}
	
	function _launchTrackback(id) {
		cWin = window.open("#application.rooturl#/trackbacks.cfm?id="+id,"cWin","width=500,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}

	function launchTrackback(id, bool_showHide) {
		var cObj = getGUIObjectInstanceById('div_addTrackback_' + id);
		var iObj = getGUIObjectInstanceById('iframe_addTrackback_' + id);
		bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
		if ( (!!cObj) && (!!iObj) ) {
			cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
			if (bool_showHide == true) iObj.src = '#application.rooturl#/trackbacks.cfm?id=' + id;
		}
	}
	
	<cfif isUserInRole("admin")>
		function _launchBlogEditor(id) {
			eWin = window.open("#application.rooturl#/editor.cfm?id="+id,"eWin","width=550,height=700,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
		}
		
		function launchBlogEditor(bool_showHide, id) {
			id = (((!!id) && (id.toUpperCase() != 'NEW')) ? id : 'new');
			var cObj = getGUIObjectInstanceById('div_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : ''));
			var iObj = getGUIObjectInstanceById('iframe_blog_editor' + ((id.toUpperCase() != 'NEW') ? '_' + id : ''));
			bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
			if ( (!!cObj) && (!!iObj) ) {
				cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
				if (bool_showHide == true) iObj.src = '#application.rooturl#/editor.cfm?id=' + ((id.toUpperCase() != 'NEW') ? id : 'new');
			}
		}

		function launchCategoryEditor(bool_showHide) {
			var cObj = getGUIObjectInstanceById('div_category_editor');
			var iObj = getGUIObjectInstanceById('iframe_category_editor');
			bool_showHide = ((bool_showHide == true) ? bool_showHide : false);
			if ( (!!cObj) && (!!iObj) ) {
				cObj.style.display = ((bool_showHide == true) ? const_inline_style : const_none_style);
				if (bool_showHide == true) iObj.src = '#application.rooturl#/category_editor.cfm';
			}
		}

		function refreshHomePage(id, url) {
			launchBlogEditor(false, id);
			window.location.href = url;
		}
	</cfif>	
</cfoutput>
