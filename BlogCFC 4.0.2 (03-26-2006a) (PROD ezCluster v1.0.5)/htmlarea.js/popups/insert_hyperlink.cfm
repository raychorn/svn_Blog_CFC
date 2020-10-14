<cfif 1>
	<cfsetting showdebugoutput="No">
<cfelse>
	<cfsetting showdebugoutput="Yes">
</cfif>

<cfset _MathAndStringExtend_js = "../../js/MathAndStringExtend.js">
<cfset _mytextsize_js = "../../components/my-textsize.js/my-textsize.js">

<cfoutput>
<html>
 <head>
  <title>Select Phrase</title>
	<script language="JavaScript1.2" src="#_MathAndStringExtend_js#" type="text/javascript"></script>

	<script language="JavaScript1.2" type="text/javascript">
	<!--
	var const_http_symbol = 'http://';
	var const_https_symbol = 'https://';
	var const_ftp_symbol = 'ftp://';
	var const_mailto_symbol = 'mailto:';
	var const_other_symbol = '(other)';
	
	var const_mailto_template = 'mailto:[sbcuid]?subject=[subject goes here]';

	var linkType_array = [];
	linkType_array.push(const_mailto_symbol);
	linkType_array.push(const_ftp_symbol);
	linkType_array.push(const_https_symbol);
	linkType_array.push(const_http_symbol);
	
	var a_array = window.dialogArguments;

	var const_cgi_script_name_symbol = washPoppedString(a_array.pop());
//alert('const_cgi_script_name_symbol = ' + const_cgi_script_name_symbol);
	var const_currentPage_symbol = washPoppedString(a_array.pop());
//alert('const_currentPage_symbol = ' + const_currentPage_symbol);
	var h_array = a_array.pop();
	var _urlPrompt = washPoppedString(h_array.pop());
//alert('_urlPrompt = ' + _urlPrompt);
	var _url = washUrl(washPoppedString(h_array.pop()));
//alert('_url = ' + _url);
	var _GetCurrentContent_notLinkables = washPoppedString(a_array.pop());
//alert('_GetCurrentContent_notLinkables = ' + _GetCurrentContent_notLinkables);
	var _GetCurrentContent_pageList = washPoppedString(a_array.pop());
//alert('_GetCurrentContent_pageList = ' + _GetCurrentContent_pageList); // +++
	var myTitle = washPoppedString(a_array.pop());
//alert('myTitle = ' + myTitle);
	
	document.title = myTitle.trim();

	function washUrl(s) {
		var p = s.trim();
		if (isInternalUrl(p) == true) {
			// strip the server name from this URL... only if this is an internal url...
			var a = s.split(':');
			if (a.length > 1) {
				var s = a[1];
				var _f = a[1].indexOf('//');
				if (_f != -1) {
					s = a[1].substring(_f + 2, a[1].length);
				}
				var b = s.split('/');
				p = '';
				for (var i = 1; i < b.length; i++) {
					p += b[i] + ((i != (b.length - 1)) ? '/' : '');
				}
			}
		}
		return p.trim();
	}

	function washPoppedString(s) {
		if (s == null) {
			s = '';
		}
		return s.trim();
	}

	function makeAnchor(u, t, p) {
		var s = '';
		var b = (u.trim().toUpperCase().indexOf(const_mailto_symbol.trim().toUpperCase()) != -1);
		if (b) {
			var a = u.split('?');
			var xx = '';
			if (a.length > 0) {
				var aa = a[0].split(':');
				var x = '';
				if (aa.length > 0) {
					x = aa[1];
				}
				xx = a[1];
			}
			var m = 'mailto:' + x + '?subject=' + xx.clipCaselessReplace('subject=', '');
			s = '<a href="' + m + '">' + x + '</a>';
		} else {
			s = '<a href="' + u + '" target="' + t + '">' + p + '</a>';
		}
		return s;
	}

	function returnSelected() {
		var iObj = document.getElementById('_menu_item_editor_internal');
		var pgObj = document.getElementById('menu_item_editor_pageList');
		var txtObj = document.getElementById('linkUrl');
		if ( (iObj != null) && (pgObj != null) && (txtObj != null) ) {
			if (iObj.checked == true) {
				pname = pgObj.options[pgObj.selectedIndex].text.trim();
				var url = const_cgi_script_name_symbol + const_currentPage_symbol + pname;
				window.returnValue = makeAnchor(url, '_top', _urlPrompt);
			} else {
				var s = txtObj.value.trim();
				if (s.toUpperCase().indexOf(const_http_symbol.trim().toUpperCase()) == -1) {
					s = const_http_symbol.trim() + s;
				}
				window.returnValue = makeAnchor(s, '_blank', _urlPrompt);
			}
			window.close();
		}
	}
	
	function selectedLinkType() {
		var obj = document.getElementById('linkType');
		var txtObj = document.getElementById('linkUrl');
		if ( (obj != null) && (txtObj != null) ) {
			var idx  = obj.selectedIndex;
			var text = obj[idx].value;
			var bool_nothing_extra = ((text.trim().length > 0) ? false : true);
			var a = txtObj.value.split(':');
			var b = text.split(':');
			if ( (a.length == 2) && (b.length > 0) ) {
				txtObj.value = b[0] + ':' + a[1];
				if ( (b.length == 2) && (b[1].length == 0) ) {
					txtObj.value = txtObj.value.replace(/\//ig, "");
				} else if ( (a[1].indexOf('\/\/') == -1) && (b[0].trim().length > 0) ) {
					txtObj.value = b[0] + ':\/\/' + a[1];
				}
			} else {
				txtObj.value = text.trim();
			}
			if (bool_nothing_extra) {
				txtObj.value = txtObj.value.clipCaselessReplace(':\/\/', '');
			}
			var _f = txtObj.value.trim().toUpperCase().indexOf(const_mailto_symbol.trim().toUpperCase());
			if (_f != -1) {
				txtObj.value = txtObj.value.trim().replaceSubString(_f, (_f + const_mailto_symbol.trim().length), const_mailto_template);
			}
		}
	}
	
	function isInternalUrl(u) {
		var b2 = (u.trim().toUpperCase().indexOf(const_currentPage_symbol.trim().toUpperCase()) != -1);
		return b2;
	}

	function isExternalUrl(u) {
		// if it is not an internal url then it must be an external url by definition regardless of the form the url takes...
		return (isInternalUrl(u) == false);
	}

	function refreshMenuItemEditorSaveButton() {
		var iObj = document.getElementById('_menu_item_editor_internal');
		var pgObj = document.getElementById('menu_item_editor_pageList');
		var sbObj = document.getElementById('menu_item_editor_saveButton');
		var hObj = document.getElementById('linkUrl');
		if ( (iObj != null) && (pgObj != null) && (sbObj != null) && (hObj != null) ) {
			if (iObj.checked == true) {
				if (pgObj.selectedIndex != -1) {
					sbObj.disabled = false;
				} else {
					sbObj.disabled = true;
				}
			} else {
				if (isExternalUrl(hObj.value)) {
					sbObj.disabled = false;
				} else {
					sbObj.disabled = true;
				}
			}
		}
	}

	function processMenuEditorCheckLinkType() {
		var iObj = document.getElementById('_menu_item_editor_internal');
		var eObj = document.getElementById('_menu_item_editor_external');
		var pObj = document.getElementById('menu_item_editor_pageList_pane');
		var phObj = document.getElementById('menu_item_editor_http_pane');
		var pgObj = document.getElementById('menu_item_editor_pageList');
		if ( (iObj != null) && (eObj != null) && (pObj != null) && (phObj != null) && (pgObj != null) ) {
			pObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			pgObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			phObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
			refreshMenuItemEditorSaveButton();
		}
	}

	//-->
	</script>

</head>
<body bgcolor="##FFFFFF" topmargin=15 leftmargin=0>

<cfparam name="_url" type="string" default="">

<cfset _style = 'style="font-size: 12px;"'>
<form method=get onSubmit="Set(document.all.ColorHex.value); return false;">
<table width="100%" bgcolor="##c0c0c0" cellpadding="-1" cellspacing="-1">
	<tr>
		<td>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td id="xxx" width="25%">
									<cfset title_menu_item_editor_internal = "Internal Links are those that remain within the boundaries of this website.">
									<input type="radio" checked id="_menu_item_editor_internal" name="menu_item_editor_InternalOrExternal" value="INTERNAL" title="#title_menu_item_editor_internal#" onClick="processMenuEditorCheckLinkType(); return true;">&nbsp;
									#CommonCode.osStyleRadioButtonCaption( "False", title_menu_item_editor_internal, "_menu_item_editor_internal", '<NOBR><font id="_menu_item_editor_internal_font" size="1"><small><b>Internal Link</b></small></font></NOBR>', 'processMenuEditorCheckLinkType();')#
								</td>
								<td width="25%">
									<cfset title_menu_item_editor_external = "External Links are those that do not remain within the boundaries of this website and may reference the Internet, Intranet or Extranet.">
									<input type="radio" id="_menu_item_editor_external" name="menu_item_editor_InternalOrExternal" value="EXTERNAL" title="#title_menu_item_editor_external#" onClick="processMenuEditorCheckLinkType(); return true;">&nbsp;
									#CommonCode.osStyleRadioButtonCaption( "False", title_menu_item_editor_external, "_menu_item_editor_external", '<NOBR><font id="_menu_item_editor_external_font" size="1"><small><b>External Link</b></small></font></NOBR>', 'processMenuEditorCheckLinkType();')#
								</td>
								<td width="25%">
									<input type="button" id="menu_item_editor_saveButton" value=" OK " #_style# title="Click this button to use the web link you have defined using this dialog." onClick="returnSelected(); return false;">
								</td>
								<td width="25%">
									<input type="button" value=" Cancel " #_style# title="Click this button to cancel this dialog and make no changes." onClick="window.close(); return false;">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<div id="menu_item_editor_pageList_pane" style="display: none;">
							<select id="menu_item_editor_pageList" size="6" style="font-size: 10px; line-height: 10px;" title="Choose an item from this list to define a link to an internal page of content from the database.  You may not define a link to a content page that has been linked via the site menu editor unless that page of content was linked here first." onchange="refreshMenuItemEditorSaveButton(); return true;">
							</select>
						</div>
						<div id="menu_item_editor_http_pane" style="display: none;">
							<table cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<small><b>Type:</b></small>
									</td>
									<td>
										<select id="linkType" #_style# title="Choose an item from this list to define or change the link type." onchange="selectedLinkType(); return false;">
										</select>
									</td>
								</tr>
								<tr>
									<td>
										<small><b>Url:</b></small>
									</td>
									<td>
										<textarea name="linkUrl" id="linkUrl"cols="80" rows="4" title="Enter or edit the desired url here. URLs that are entered without http:// will be made into http:// link by default." #_style# onkeyup="refreshMenuItemEditorSaveButton(); return true;"></textarea>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
</body>
</html>

<script language="JavaScript1.2" type="text/javascript">
<!--
	function initPageLists(u) {
		var eObj = document.getElementById('menu_item_editor_pageList');
		var sbObj = document.getElementById('menu_item_editor_saveButton');
		var hObj = document.getElementById('_menu_item_editor_internal_href');
		if ( (eObj != null) && (sbObj != null) && (hObj != null) ) {
			var s = _GetCurrentContent_pageList;
			var sn = _GetCurrentContent_notLinkables;

			var pn = '';
			if (isExternalUrl(u) == false) {
				var aa = u.split('?');
				if (aa.length > 1) {
					var bb = aa[1].split('&');
					if (bb.length > 0) {
						var cc = bb[0].split('=');
						if (cc.length > 1) {
							pn = cc[1];
						}
					}
				}
			}

			var a = s.split(',');
			for (var i = 0; i < a.length; i++) {
				oObj = new Option( a[i], a[i]);
				var j = eObj.options.length;
				eObj.options[j] = oObj;
				eObj.options[j].selected = ((pn.trim().toUpperCase() == a[i].trim().toUpperCase()) ? true : false);
			}
			sbObj.disabled = true;

			// if this feature becomes necessary then it would be necessary to dynamically create the anchor tags that this message is for or make a mouseover to display this tooltip.			
			var _title = '';
			if (eObj.options.length == 0) {
				_title = ' (This list is empty because there are no pages of content that can be used that are not already linked via the Menu Editor.  You may create a new page of content by using the Menu Editor to Add a New Page. See your /Security Manager to gain access to the Menu Editor or to have a new page created for you.)';
			} else {
				_title = ' (Choose an internal page of content from this list to be used to make an internal link to this site.  Internal links are those that reference pages of content that are being managed by this system as opposed to external links that reference pages of content that are not managed by this system.)';
			}
			eObj.title += _title;
			hObj.title += _title;
		}
	}

	function initLinkTypes(u) {
		var lstObj = document.getElementById('linkType');
		if (lstObj != null) {
			var b_internal = isInternalUrl(u);
			if (b_internal == true) {
				oObj = new Option( const_other_symbol, '');
				var j = lstObj.options.length;
				lstObj.options[j] = oObj;
				lstObj.options[j].selected = true; // this is an internal url that cannot possibly have a selected item from this link type list...
			}
			var b = false;
			for (var i = 0; i < linkType_array.length; i++) {
				var x = linkType_array[i];
				oObj = new Option( x, x);
				var j = lstObj.options.length;
				lstObj.options[j] = oObj;
				if (b_internal == false) {
					b = (u.trim().toUpperCase().indexOf(x.trim().toUpperCase()) != -1);
				}
				lstObj.options[j].selected = ((b) ? true : false);
			}
		}
	}

	function initUrl() {
		var iObj = document.getElementById('_menu_item_editor_internal');
		var eObj = document.getElementById('_menu_item_editor_external');
		var taObj = document.getElementById('linkUrl');
		if ( (iObj != null) && (eObj != null) && (taObj != null) ) {
			taObj.value = _url.trim();
			if (isExternalUrl(taObj.value)) {
				iObj.checked = false;
				eObj.checked = true;
			} else {
				iObj.checked = true;
				eObj.checked = false;
			}
		}
	}

	initLinkTypes(_url);
	initPageLists(_url);
	initUrl();
	processMenuEditorCheckLinkType();
//-->
</script>

</cfoutput>
