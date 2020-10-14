<cfoutput>
	<body onload="window_onload()" onunload="window_onUnload()">

	<cfif 0>
		<cfscript>
			binStr = Request.commonCode.readBinaryExeAsEncodedString('../blog/bin/jsmin.exe');
		</cfscript>
	
		<textarea class="textClass" cols="120" readonly rows="10" wrap="off">#binStr#</textarea><br><br>

		<cfscript>
		//	Request.commonCode.writeJSMinExe();
		</cfscript>
	</cfif>

		<cfscript>
			_site_menu_background_color = "##3081e4";
			_site_menu_text_color = "white";

			_driveLetter = GetProfileString(ExpandPath('AJAX/AJAX_functions.ini'), 'Defaults', 'driveLetter');
			if (Len(_driveLetter) eq 0) {
				_driveLetter = 'c:\@KLA-Tencore\T27ZB_49aci-combined\combined\051106163608_Devicet27zb_49aci_0611500LE-30V35nm25nAFLD_23';
			}
		</cfscript>		

		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			var currentParentSubMenu_id = -1;

			var global_previous_dispOrder = [];
			
			var global_htmlStream = '';
			
			var global_driveLetter = '#JSStringFormat(_driveLetter)#';

			var const_cf_html_container_symbol = '#Request.cf_html_container_symbol#';
			var const_loading_data_message_symbol = '<span class="ajaxLoadingStatusClass"><NOBR>&nbsp;Server Busy !</NOBR></span>';
			var const_system_ready_message_symbol = '<span class="normalStatusClass">&nbsp;Ready !</span>';
			var const_jsapi_loading_image = '#Request.const_jsapi_loading_image#';
			var const_busy_loading_image = '#Request.const_busy_loading_image#';
			var const_system_busy_message_symbol = '<span class="ajaxLoadingStatusClass"><NOBR>&nbsp;Busy !</NOBR></span>';
			
			var cf_AUTH_USER = '#Request.AUTH_USER#';

			var cf_Session_ID = '';
			<cfif (IsDefined("Session.sessid"))>cf_Session_ID = '#Session.sessid#';</cfif>
			
			var const_div_floating_debug_menu = '#Request.cf_div_floating_debug_menu#';

			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';
			var const_color_light_blue = '#Request.const_color_light_blue#';

			var const_add_button_symbol = '[+]';
			var const_edit_button_symbol = '[*]';
			var const_delete_button_symbol = '[-]';
			
			var const_jsapi_width_value = 200;

			var global_allow_loading_data_message = false;

			var url_sBasePath = 'http' + (('#CGI.SERVER_PORT#' == '443') ? 's' : '') + ':\/\/#CGI.HTTP_HOST#';

			url_sBasePath += '#Request.cfm_gateway_process_html#';
			
			// create the gateway object
			var oAJAXEngine = AJAXEngine.get$(url_sBasePath, false);
			oAJAXEngine.setMethodGet();
			oAJAXEngine.setReleaseMode(); // this overrides the oAJAXEngine.set_isServerLocal() setting...
			oAJAXEngine.isXmlHttpPreferred = false;
			oAJAXEngine.timeout = 240;
			oAJAXEngine.js_global_varName = 'js$';
			
			var global_echo_AJAX_commands = false;
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
		// place this on the page where you want the gateway to appear
			oAJAXEngine.create();
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			document.write('<div id="html_container" style="display: inline; position: absolute; top: 0px; left: ' + (clientWid$() - const_jsapi_width_value) + 'px">');
			document.write('</div>');
		// -->
		</script>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function handle_graphType_onchange(oObj) {
				if (!!oObj) {
					var sel = oObj.selectedIndex;
					if ( (sel > -1) && (oObj.options[sel].value > -1) ) {
						var _graphType = oObj.options[sel].value;
						doAJAX_func('getData', 'displayData(' + oAJAXEngine.js_global_varName + ')', 'graphType', _graphType);
					}
				}
			}

			var _DiagramImagesHref = window.location.href + 'images/DiagramBuilder/';
			
			function F1DiagramClick() { alert("Use your own function here."); }
			
			function displayData(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var i = -1;
				var n = -1;
				var argsDict = DictObj.get$();

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};

//	_alert(qObj);
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							qData.iterateRecObjs(anyErrorRecords);
							if (!bool_isAnyErrorRecords) {
								argsDict.intoNamedArgs();
							//	_alert(argsDict);
								var _graphType = argsDict.getValueFor('graphType');
								drawData(_graphType);
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}
			
			var disabled_buttons_stack = [];

			function handle_dismiss_scopeBrowser() {
				var btnObj = -1;
				var oO = $('div_scopeBrowser');
				if (!!oO) {
					if (oO.innerHTML.length > 0) flushCache$(oO);
					oO.style.display = const_none_style;
					oO.innerHTML = '';
					if (!!(btnObj = disabled_buttons_stack.pop())) {
						btnObj.disabled = false;
					}
				//	var oBtn = $('btn_dbProcess_DiskBrowserGUI');
				//	if (!!oBtn) {
				//		oBtn.disabled = false;
				//	}
					var oWaferName = $('input_DiskBrowserGUI_driveLetter');
					if (!!oWaferName) {
						var _waferName = oWaferName.value;
						doAJAX_func('getWaferFromDbStatus', 'handleWaferFromDbStatus(' + oAJAXEngine.js_global_varName + ')', 'waferName', _waferName);
					}
				}
			}

			function handle_dismiss_DiskBrowserGUI() {
				var btnObj = -1;
				var oO = $('form_diskBrowser');
				if (!!oO) {
					if (oO.innerHTML.length > 0) flushCache$(oO);
					oO.style.display = const_none_style;
					oO.innerHTML = '';
					if (!!(btnObj = disabled_buttons_stack.pop())) {
						btnObj.disabled = false;
					}
				}
			}

			function handle_submit_DiskBrowserGUI(btnObj) {
				var iObj = $('input_DiskBrowserGUI_driveLetter');
				if ( (!!btnObj) && (!!iObj) ) {
					btnObj.disabled = true;
					disabled_buttons_stack.push(btnObj);
					var ar = iObj.value.split('\\');
					global_baseFolderName = ar[0] + '\\';
					global_pathName = iObj.value;
					displayActivityBalloon('<center><b>This activity will take perhaps 1-2 minutes, please remain patient.</b></center>');
					doAJAX_func('getDiskDirectory', 'handleAJAXData(' + oAJAXEngine.js_global_varName + ')', 'driveLetter', iObj.value);
				}
			}
			
			function displayMetricsBrowserDiagramInterface() {
				var _html = '';
				var oO = $('div_scopeBrowser');
				if (!!oO) {
					_html += '<table width="800" bgcolor="##FFFFA8" border="1" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td align="left" valign="top">';

					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr bgcolor="silver">';
					_html += '<td width="90%" align="center" valign="top">';
					_html += '<span class="boldPromptTextClass">Metrics Data Browser</span>';
					_html += '</td>';
					_html += '<td width="*" align="right" valign="top">';
					_html += '<button class="buttonClass" id="btn_dismiss_scopeBrowser" onclick="handle_dismiss_scopeBrowser(); return false;">[X]</button>';
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';

					_html += '</td>';
					_html += '</tr>';

					_html += '<tr>';
					_html += '<td align="left" valign="top">';
					_html += '<span class="codeSmallerNoBorder">';

					_data = [];
					waferPoint.remove$s();
					alert('displayMetricsBrowserDiagramInterface() :: This function will not function until it is coded to use the new multi-wafer model.');
				//	global_waferStats.resetStats();

					var chCols = [];
					for (var i = 1; i <= 9; i++) {
						chCols.push('CHANNEL' + i);
					}

					_html += '<br><br>';
					_html += '<span class="normalSmallStatusBoldClass">Data Channel:</span>&nbsp;<select id="selection_channels" class="textEntryClass" title="Choose a Metrics Channel to Draw the Wafer..." onchange="global_tidChannel[drawWaferToScale] = setInterval(\'delayedAction(drawWaferToScale)\', 250); return false;">';
					_html += '<option value="-1">Choose...</option>';
					for (i = 0; i < chCols.length; i++) {
						_html += '<option value="' + chCols[i] + '">' + chCols[i] + '</option>';
					}
					_html += '</select>';
					
					_html += '&nbsp;<span class="normalSmallStatusBoldClass">Notch:</span>&nbsp;';
					_html += '<select id="selection_notch" class="textEntryClass" onchange="drawWaferToScale(); return false;">';
					_html += '<option value="L">Left</option>';
					_html += '<option value="R">Right</option>';
					_html += '<option value="T" selected>Top</option>';
					_html += '<option value="B">Bottom</option>';
					_html += '</select>';

					_html += '&nbsp;<span class="normalSmallStatusBoldClass">Measurement Points:</span>&nbsp;';
					_html += '<select id="selection_measurePoints" class="textEntryClass" onchange="drawWaferToScale(); return false;">';
					_html += '<option value="Y" selected>Yes</option>';
					_html += '<option value="N">No</option>';
					_html += '</select>';

					_html += '<br>';

					var oBtn = $('btn_pythonProcess_DiskBrowserGUI');
					if (!!oBtn) {
					//	oBtn.disabled = false;
					}

					_html += '<iframe id="iframe_diagramMetrics" frameborder="0" scrolling="Auto" width=440 height=250 name="F_diagramMetrics" style="display: none;"></iframe>';

					_html += '</span>';
					_html += '</td>';
					_html += '</tr>';

					_html += '</table>';
					
					if (oO.innerHTML.length > 0) flushCache$(oO);
					oO.innerHTML = _html;
					oO.style.display = const_inline_style;
				}
			}
			
			function htmlDiskBrowserGUI() {
				var _html = '';

				_html += '<table width="600" border="1" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td align="left" valign="top" bgcolor="##FFFFA8">';

				_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td bgcolor="silver" align="center" valign="top">';

				_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td width="90%" align="center" valign="top">';
				_html += '<span class="boldPromptTextClass">Disk Browser</span>';
				_html += '</td>';
				_html += '<td width="*" align="right" valign="top">';
				_html += '<button class="buttonClass" id="btn_dismiss_DiskBrowserGUI" onclick="handle_dismiss_DiskBrowserGUI(); return false;">[X]</button>';
				_html += '</td>';
				_html += '</tr>';
				_html += '</table>';

				_html += '</td>';
				_html += '</tr>';

				_html += '<tr>';
				_html += '<td align="left" valign="top">';

				_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td width="20%" align="left" valign="middle">';
				_html += '<span class="normalStatusBoldClass">Drive/UNC:</span>';
				_html += '</td>';
				_html += '<td width="*" align="left" valign="top">';
				_html += '<input id="input_DiskBrowserGUI_driveLetter" type="Text" class="textEntryClass" value="' + global_driveLetter + '" title="Enter a Drive Letter or UNC Path for the location of the data files you wish to work with." size="120" maxlength="255">';
				_html += '</td>';
				_html += '</tr>';
				_html += '</table>';

				_html += '</td>';
				_html += '</tr>';

				_html += '<tr>';
				_html += '<td align="left" valign="top">';
				_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td align="left" valign="top">';
				_html += '<button class="buttonClass" id="btn_submit_DiskBrowserGUI" disabled onclick="handle_submit_DiskBrowserGUI(this); return false;">[Submit]</button>';
				_html += '</td>';
				_html += '<td align="right" valign="top">';
				_html += '<button class="buttonClass" id="btn_faster_waferDisplay" disabled onclick="displayMetricsBrowserDiagramInterface(); return false;">[Show Wafer from Db]</button>';
				_html += '</td>';
				_html += '</tr>';
				_html += '</table>';
				_html += '</td>';
				_html += '</tr>';

				_html += '</table>';

				_html += '</td>';
				_html += '</tr>';

				_html += '<tr>';
				_html += '<td align="left" valign="top">';
				_html += '<div id="div_directory_DiskBrowserGUI"></div>';
				_html += '</td>';
				_html += '</tr>';

				_html += '';
				
				_html += '</table>';

				return _html;
			}

			function displayDiskBrowserGUI(btnObj) {
				var oO = $('form_diskBrowser');
				if (!!oO) {
					if (!!btnObj) {
						btnObj.disabled = true;
						disabled_buttons_stack.push(btnObj);
					}
					oO.innerHTML = htmlDiskBrowserGUI();
					oO.style.display = const_inline_style;

					var _waferName = '';
					var oInput = $('input_DiskBrowserGUI_driveLetter');
					if (!!oInput) {
						_waferName = oInput.value;
						oInput.disabled = true;
					}
					doAJAX_func('getWaferFromDbStatus', 'handleWaferFromDbStatus(' + oAJAXEngine.js_global_varName + ')', 'waferName', _waferName);
				}
			}
			
			function handle_dismiss_WaferRecordsBrowserGUI() {
				var oO = $('div_scopeBrowser');
				if (!!oO) {
					if (oO.innerHTML.length > 0) flushCache$(oO);
					oO.style.display = const_none_style;
					oO.innerHTML = '';
				}
				if (!!(btnObj = disabled_buttons_stack.pop())) {
					btnObj.disabled = false;
				}
			}
			
			function handle_onchange_select_waferRecords(oSel) {
				var i = -1;
				var _ids = [];
				if (!!oSel) {
					for (i = 0; i < oSel.options.length; i++) {
						if (oSel.options[i].selected) _ids.push(oSel.options[i].value);
					}
			//	_alert('handle_onchange_select_waferRecords(oSel = [' + oSel + '])' + ', _ids.length = [' + _ids.length + ']' + ', _ids = [' + _ids + ']');
					var oBtn = _$('btn_display_WaferRecordsBrowserGUI');
					if (!!oBtn) {
						oBtn.disabled = ((_ids.length == 1) ? false : true);
					}
					var oBtn = _$('btn_display_WafersRecordsBrowserGUI');
					if (!!oBtn) {
					//	_alert('window.location.href = [' + window.location.href + '], ' + window.location.href.toLowerCase().indexOf('/samples/'));
						if (window.location.href.toLowerCase().indexOf('/samples/') == -1) {
							oBtn.disabled = ((_ids.length > 1) ? false : true);
						} else {
							oBtn.disabled = ((_ids.length > 1) ? true : true);
						}
					}
				}
			}

			var global_arWaferAnalysisObjects = [];
// +++
			function handle_display_WafersRecordsBrowserGUI(oBtn) {
				var oSel = _$('select_waferRecords');
				var oDict = DictObj.get$();
				if ( (!!oBtn) && (!!oSel) ) {
					oBtn.disabled = true;

					// reset the objects bucket prior to use...
					for (var i = 0; i < global_arWaferAnalysisObjects.length; i++) {
						WaferAnalObj.remove$(global_arWaferAnalysisObjects[i].id);
					}
					global_arWaferAnalysisObjects = []; // clear this out before using it...

					for (i = 0; i < oSel.options.length; i++) {
						if (oSel.options[i].selected) {
							global_arWaferAnalysisObjects.push(WaferAnalObj.get$(oSel.options[i].text, oSel.options[i].value));
						//	_alert('oSel.options[' + i + '].text = [' + oSel.options[i].text + ']' + ', oSel.options[' + i + '].value = [' + oSel.options[i].value + ']');
							oDict.push(oSel.options[i].value, oSel.options[i].text);
						}
					}
				//	_alert('global_arWaferAnalysisObjects = [' + global_arWaferAnalysisObjects + ']');
					var idAR = [];
					for (var k = 0; k < global_arWaferAnalysisObjects.length; k++) {
						idAR.push(global_arWaferAnalysisObjects[k].waferID);
					}
					doAJAX_func('getWafersDataFromDb', 'handleProcessMetricsFile(' + oAJAXEngine.js_global_varName + ')', 'waferIds', idAR.join('|'), 'channelName', 'CHANNEL1');
				}
			}
// +++
			function handle_display_WaferRecordsBrowserGUI(oBtn) {
				var oSel = _$('select_waferRecords');
				var oDict = DictObj.get$();
				var bool = true;
				if ( (!!oBtn) && (!!oSel) ) {
					oBtn.disabled = true;

					// reset the objects bucket prior to use...
					for (var i = 0; i < global_arWaferAnalysisObjects.length; i++) {
						WaferAnalObj.remove$(global_arWaferAnalysisObjects[i].id);
					}
					global_arWaferAnalysisObjects = []; // clear this out before using it...

					for (i = 0; i < oSel.options.length; i++) {
						if (oSel.options[i].selected) {
				//			_alert('A. global_arWaferAnalysisObjects.length = [' + global_arWaferAnalysisObjects.length + ']' + ', oSel.options[' + i + '].text = [' + oSel.options[i].text + ']' + ', oSel.options[' + i + '].value = [' + oSel.options[i].value + ']');
							if (global_arWaferAnalysisObjects.length < 1) {
								global_arWaferAnalysisObjects.push(WaferAnalObj.get$(oSel.options[i].text, oSel.options[i].value));
							}
							oDict.push(oSel.options[i].value, oSel.options[i].text);
						}
					}
					if (oDict.length() > 1) {
						bool = confirm('You have selected too many wafers to display using the Display One Wafer method.  The wafer named "' + global_arWaferAnalysisObjects[0].waferName + '" will be displayed but the others will not. Click the cancel button to adjust your selections before trying again.');
					}
					if (bool) {
						try {
							doAJAX_func('getWaferDataFromDb', 'handleProcessMetricsFile(' + oAJAXEngine.js_global_varName + ')', 'waferName', global_arWaferAnalysisObjects[0].waferName, 'channelName', 'CHANNEL1');
						} catch(ee) {
							_alertError(jsErrorExplainer(ee, '101' + ', global_arWaferAnalysisObjects.length = [' + global_arWaferAnalysisObjects.length + ']'));
						} finally {
						}
					}
				}
			}

			function displayDbBrowserGUI(btnObj) {
				if (!!btnObj) {
					btnObj.disabled = true;
					disabled_buttons_stack.push(btnObj);
				}
				doAJAX_func('getWaferListFromDb', 'handleWaferListFromDb(' + oAJAXEngine.js_global_varName + ')');
			}

			function handleWaferListFromDb(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var i = -1;
				var n = -1;
				var _html = '';
				var argsDict = DictObj.get$();
				var dataDict = -1;

				function htmlWaferRecordsBrowserGUI() {
					var _html = '';
	
					_html += '<table width="600" border="1" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td align="left" valign="top" bgcolor="##FFFFA8">';
	
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td bgcolor="silver" align="center" valign="top">';
	
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td width="90%" align="center" valign="top">';
					_html += '<span class="boldPromptTextClass">Database Browser</span>';
					_html += '</td>';
					_html += '<td width="*" align="right" valign="top">';
					_html += '<button class="buttonClass" id="btn_dismiss_WaferRecordsBrowserGUI" onclick="handle_dismiss_WaferRecordsBrowserGUI(); return false;">[X]</button>';
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';
	
					_html += '</td>';
					_html += '</tr>';
	
					_html += '<tr>';
					_html += '<td align="left" valign="top">';
	
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td width="20%" align="left" valign="middle">';
					_html += '<span class="normalStatusBoldClass">Choose one or more Wafers:</span>';
					_html += '</td>';
					_html += '<td width="*" align="left" valign="top">';
					_html += '<select id="select_waferRecords" class="textEntryClass" size="30" multiple onchange="handle_onchange_select_waferRecords(this);"></select>';
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';
	
					_html += '</td>';
					_html += '</tr>';
	
					_html += '<tr>';
					_html += '<td align="left" valign="top">';
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td align="left" valign="top">';
					_html += '<button class="buttonClass" id="btn_display_WaferRecordsBrowserGUI" disabled onclick="handle_display_WaferRecordsBrowserGUI(this); return false;">[Display One Wafer]</button>';
					_html += '&nbsp;<button class="buttonClass" id="btn_display_WafersRecordsBrowserGUI" disabled onclick="handle_display_WafersRecordsBrowserGUI(this); return false;">[Display Many Wafers]</button>';
					_html += '</td>';
					_html += '<td align="right" valign="top">';
				//	_html += '<button class="buttonClass" id="btn_faster_waferDisplay" disabled onclick="displayMetricsBrowserDiagramInterface(); return false;">[Show Wafer from Db]</button>';
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';
					_html += '</td>';
					_html += '</tr>';
	
					_html += '</table>';
	
					_html += '</td>';
					_html += '</tr>';
	
					_html += '<tr>';
					_html += '<td align="left" valign="top">';
					_html += '<div id="div_WaferRecordsBrowserGUI"></div>';
					_html += '</td>';
					_html += '</tr>';
	
					_html += '';
					
					_html += '</table>';
	
					return _html;
				};

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};
				
				function displayRecords(_ri, _dict, _rowCntName) {
					var oSel = _$('select_waferRecords');
					if (!!oSel) {
						var id = _dict.getValueFor('ID');
						var wfn = _dict.getValueFor('WAFERNAME');
						oSel.options[oSel.options.length] = new Option( wfn, id);
					}
				};

//	_alert(qObj);
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData1 = qObj.named('qData1');
					if (!!qData1) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							qData1.iterateRecObjs(anyErrorRecords);
							if (!bool_isAnyErrorRecords) {
								argsDict.intoNamedArgs();
								
								var oO = $('div_scopeBrowser');
								if (!!oO) {
									oO.innerHTML = htmlWaferRecordsBrowserGUI();
									oO.style.display = const_inline_style;
								}

								qData1.iterateRecObjs(displayRecords);
							//	_alert(argsDict);
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}
			
			function handleWaferFromDbStatus(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var i = -1;
				var n = -1;
				var argsDict = DictObj.get$();
				var dataDict = -1;

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};
				
				function searchRecords(_ri, _dict, _rowCntName) {
					var wfn = _dict.getValueFor('WAFERFULLNAME');
					if ( (dataDict == -1) && (!!wfn) ) {
						dataDict = DictObj.get$(_dict.asQueryString());
					}
				};

//	_alert(qObj);
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData1 = qObj.named('qData1');
					if (!!qData1) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							qData1.iterateRecObjs(anyErrorRecords);
							if (!bool_isAnyErrorRecords) {
								argsDict.intoNamedArgs();

								var oBtnA = $('btn_dbProcess_DiskBrowserGUI');
								var oBtnB = $('btn_pythonProcess_DiskBrowserGUI');
								if ( (!!oBtnA) && (!!oBtnB) ) {
									var dDict = DictObj.get$(oBtnB.title);
									var folderName = dDict.getValueFor('DIRECTORY');
									var fileName = dDict.getValueFor('NAME');
									var pName = folderName + ((folderName.charAt(folderName.length - 1) == '\\') ? '' : '\\') + fileName;
									qData1.iterateRecObjs(searchRecords);
									oBtnA.disabled = (( (dataDict != -1) && (dataDict.getValueFor('WAFERFULLNAME') == pName) ) ? false : true);
									oBtnB.disabled = ((oBtnA.disabled) ? false : true);
								} else {
									var oBtn1 = $('btn_submit_DiskBrowserGUI');
									var oBtn2 = $('btn_faster_waferDisplay');
									var oInput = $('input_DiskBrowserGUI_driveLetter');
									if ( (!!oBtn1) && (!!oBtn2) && (!!oInput) ) {
										if (qData1.recordCount() == 1) {
											oBtn1.disabled = false; // allow the user to navigate the disk drive looking for data to upload to the Db...
											qData1.iterateRecObjs(searchRecords);
											oBtn2.disabled = ((dataDict.getValueFor('WAFERFULLNAME') == argsDict.getValueFor('waferName')) ? false : true);
										} else {
											oBtn1.disabled = false;
											oBtn2.disabled = true;
										}
										oInput.disabled = false;
									}
								}
							//	_alert(argsDict);
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}

			function handle_dirDrillInto_DiskBrowserGUI(btnObj) {
				if (!!btnObj) {
					var ar = global_pathName.split('\\'.substr(0,1));
					ar[ar.length] = btnObj.value;
					global_pathName = removeEmptyItemsFromArray(ar).join('\\'.substr(0,1)).trim();
					var iObj = $('input_DiskBrowserGUI_driveLetter');
					if (!!iObj) {
						iObj.value = global_pathName;
					}
					displayActivityBalloon('<center><b>This activity will take perhaps 1-2 minutes, please remain patient.</b></center>');
					doAJAX_func('getDiskDirectory', 'handleAJAXData(' + oAJAXEngine.js_global_varName + ')', 'driveLetter', global_pathName);
				}
			}
			
			function handle_dirDrillOut_DiskBrowserGUI(btnObj) {
				if (!!btnObj) {
					var ar = global_pathName.split('\\'.substr(0,1));
					ar[ar.length - 1] = null;
					global_pathName = removeEmptyItemsFromArray(ar).join('\\'.substr(0,1)).trim();
					var iObj = $('input_DiskBrowserGUI_driveLetter');
					if (!!iObj) {
						iObj.value = global_pathName;
					}
					displayActivityBalloon('<center><b>This activity will take perhaps 1-2 minutes, please remain patient.</b></center>');
					doAJAX_func('getDiskDirectory', 'handleAJAXData(' + oAJAXEngine.js_global_varName + ')', 'driveLetter', global_pathName);
				}
			}

			function displayActivityBalloon(_html) {
				var oObj1 = $('div_activityBalloon');
				var oObj2 = $('span_activityBalloon_body');
				_html = ((!!_html) ? _html : '');
				if ( (!!oObj1) && (!!oObj2) ) {
					if (oObj2.innerHTML.length > 0) flushCache$(oObj2);
				//	oObj2.innerHTML = _html;
				//	oObj1.style.display = const_inline_style;
					oObj2.style.width = '600px';
					oObj2.style.height = '200px';
				}
			}
			
			function dismissActivityBalloon() {
				var oObj1 = $('div_activityBalloon');
				var oObj2 = $('span_activityBalloon_body');
				if ( (!!oObj1) && (!!oObj2) ) {
					if (oObj2.innerHTML.length > 0) flushCache$(oObj2);
					oObj1.style.display = const_none_style;
					oObj2.innerHTML = '';
				}
			}

			function handle_pythonProcess_DiskBrowserGUI(btnObj) {
				var iObj = $('input_DiskBrowserGUI_driveLetter');
				if ( (!!iObj) && (!!btnObj) ) {
					var ar = btnObj.value.split('"');
					var metricsFileName = iObj.value + '\\'.substr(0,1) + ((ar.length > 1) ? ar[1] : 'metric.txt');
					displayActivityBalloon('<center><b>This activity will take perhaps 2-3 minutes, please remain patient.</b></center>');
				//	doAJAX_func('processPythonFile', 'handleProcessPythonFile(' + oAJAXEngine.js_global_varName + ')', 'pythonFileName', pythonFileName);
					doAJAX_func('processMetricsFile', 'handleProcessMetricsFile(' + oAJAXEngine.js_global_varName + ')', 'metricsFileName', metricsFileName);
				}
			}

			function drawQuadraticCircle(oDiagram, hexColor, cx, cy, xl, xr, yt, yb, w, h) {
				if (!!oDiagram) {
					hexColor = ((!!hexColor) ? hexColor : _asColorHex(0x000000));
					var p1x = oDiagram.ScreenX(xr+cx), 
						p1y = oDiagram.ScreenY(yt+cy), 
						p2x = oDiagram.ScreenX(xr+cx), 
						p2y = oDiagram.ScreenY(yb+cy), 
						p3x = oDiagram.ScreenX(xl+cx), 
						p3y = oDiagram.ScreenY(yb+cy), 
						p4x = oDiagram.ScreenX(xl+cx), 
						p4y = oDiagram.ScreenY(yt+cy);

						new Pixel(p1x, p1y, "##" + hexColor);
						new Pixel(p2x, p2y, "##" + hexColor);
						new Pixel(p3x, p3y, "##" + hexColor);
						new Pixel(p4x, p4y, "##" + hexColor);
				}
			}
			
			function drawCircle(oDiagram, left, top, width, height, hexColor) {
				if (!!oDiagram) {
					var a = width>>1, b = height>>1,
						wod = width&1, hod = (height&1)+1,
						cx = left+a, cy = top+b,
						x = 0, y = b,
						ox = 0, oy = b,
						aa = (a*a)<<1, bb = (b*b)<<1,
						st = (aa>>1)*(1-(b<<1)) + bb,
						tt = (bb>>1) - aa*((b<<1)-1),
						w, h;
					hexColor = ((!!hexColor) ? hexColor : _asColorHex(0x000000));
					while (y > 0) {
						if (st < 0) {
							st += bb*((x<<1)+3);
							tt += (bb<<1)*(++x);
						} else if (tt < 0) {
							st += bb*((x<<1)+3) - (aa<<1)*(y-1);
							tt += (bb<<1)*(++x) - aa*(((y--)<<1)-3);
							w = x-ox;
							h = oy-y;
							if (w&2 && h&2) {
								drawQuadraticCircle(oDiagram, hexColor, cx, cy, -x+2, ox+wod, -oy, oy-1+hod, 1, 1);
								drawQuadraticCircle(oDiagram, hexColor, cx, cy, -x+1, x-1+wod, -y-1, y+hod, 1, 1);
							} else drawQuadraticCircle(oDiagram, hexColor, cx, cy, -x+1, ox+wod, -oy, oy-h+hod, w, h);
							ox = x;
							oy = y;
						} else {
							tt -= aa*((y<<1)-3);
							st -= (aa<<1)*(--y);
						}
					}
					new Pixel(oDiagram.ScreenX(cx-a), oDiagram.ScreenY(cy-oy), "##" + hexColor);
					new Pixel(oDiagram.ScreenX(cx+ox+wod), oDiagram.ScreenY(cy-oy), "##" + hexColor);
				}
			}

			var notchPosition = 'T';
			var notchX1 = -1, notchX2 = -1, notchY1 = -1, notchY2 = -1;

			function drawWaferToScale(jNum) {
				var oWaferAnalObj = ((jNum < global_arWaferAnalysisObjects.length) ? global_arWaferAnalysisObjects[jNum] : null);
				var oChannelsSel = $('selection_channels');
				var sel = -1;
				var selCoordsSource = -1;
				var dictMain = -1;
				var jj = -1;
				
				if ( (oWaferAnalObj == null) && (!confirm('The argument jNum (' + jNum + ') is invalid as passed into the function known as drawWaferToScale().')) ) {
					return;
				}
				
				function displayRecordsFast(_ri, _dict, _rowCntName) {
					var datum = -1;
					var realDatum = -1;
					var oPt = -1;
					var ar = [];
					var i = -1;

					function analyzeRecordFast(kPairAR, num) {
						if (typeof kPairAR != const_object_symbol) {
							var _kPairAR = [];
							_kPairAR.push(kPairAR);
							kPairAR = _kPairAR;
						}
						for (var i = 0; i < kPairAR.length; i++) {
							try { datum = _dict.getValueFor(kPairAR[i].toUpperCase()); } catch(e) { datum = null; jsErrorExplainer(e, '101', true); } finally { };
							if (!!datum) {
								realDatum = parseFloat(datum);
								if (kPairAR[i].toUpperCase().indexOf('X') != -1) {
									switch (num) {
										case 0:
											oWaferAnalObj.waferStats.minDieX = Math.min(oWaferAnalObj.waferStats.minDieX,realDatum);
											oWaferAnalObj.waferStats.maxDieX = Math.max(oWaferAnalObj.waferStats.maxDieX,realDatum);

											oPt.DieX = realDatum;
										break;

										case 1:
											oWaferAnalObj.waferStats.minImageX = Math.min(oWaferAnalObj.waferStats.minImageX,realDatum);
											oWaferAnalObj.waferStats.maxImageX = Math.max(oWaferAnalObj.waferStats.maxImageX,realDatum);

											oPt.ImageX = realDatum;
										break;

										case 2:
											oWaferAnalObj.waferStats.minOriginX = Math.min(oWaferAnalObj.waferStats.minOriginX,realDatum);
											oWaferAnalObj.waferStats.maxOriginX = Math.max(oWaferAnalObj.waferStats.maxOriginX,realDatum);

											oPt.OriginX = realDatum;
										break;
									}
								} else if (kPairAR[i].toUpperCase().indexOf('Y') != -1) {
									switch (num) {
										case 0:
											oWaferAnalObj.waferStats.minDieY = Math.min(oWaferAnalObj.waferStats.minDieY,realDatum);
											oWaferAnalObj.waferStats.maxDieY = Math.max(oWaferAnalObj.waferStats.maxDieY,realDatum);

											oPt.DieY = realDatum;
										break;

										case 1:
											oWaferAnalObj.waferStats.minImageY = Math.min(oWaferAnalObj.waferStats.minImageY,realDatum);
											oWaferAnalObj.waferStats.maxImageY = Math.max(oWaferAnalObj.waferStats.maxImageY,realDatum);

											oPt.ImageY = realDatum;
										break;

										case 2:
											oWaferAnalObj.waferStats.minOriginY = Math.min(oWaferAnalObj.waferStats.minOriginY,realDatum);
											oWaferAnalObj.waferStats.maxOriginY = Math.max(oWaferAnalObj.waferStats.maxOriginY,realDatum);

											oPt.OriginY = realDatum;
										break;
									}
								} else {
									oWaferAnalObj.waferStats.minVal = Math.min(oWaferAnalObj.waferStats.minVal,realDatum);
									oWaferAnalObj.waferStats.maxVal = Math.max(oWaferAnalObj.waferStats.maxVal,realDatum);
									oPt.value = realDatum;
								}
							}
						}
					}
					
					for (i = 0; i < ar.length; i++) {
						ar[i] = ar[i].split(',');
					}
					ar.push(oChannelsSel.options[sel].value);

					oPt = oWaferAnalObj._data[_ri - 1];
					for (i = 0; i < ar.length; i++) {
						analyzeRecordFast(ar[i], i);
					}
					oWaferAnalObj._data[_ri - 1] = oPt;
				};

				function displayRecords(_ri, _dict, _rowCntName) {
					var datum = -1;
					var realDatum = -1;
					var oPt = -1;
					var ar = ['DIE_X,DIE_Y','IMAGEX,IMAGEY','dieOriginX,dieOriginY'];
					var i = -1;

					function analyzeRecord(kPairAR, num) {
						if (typeof kPairAR != const_object_symbol) {
							var _kPairAR = [];
							_kPairAR.push(kPairAR);
							kPairAR = _kPairAR;
						}
					//	_alert('analyzeRecord(kPairAR = [' + kPairAR + '], num = [' + num + '])');
					//	_alert('kPairAR.length = [' + kPairAR.length + ']');
						for (var i = 0; i < kPairAR.length; i++) {
							try { datum = _dict.getValueFor(kPairAR[i].toUpperCase()); } catch(e) { datum = null; jsErrorExplainer(e, '101', true); } finally { };
					//		_alert('datum = [' + datum + ']');
							if (!!datum) {
								realDatum = parseFloat(datum);
					//			_alert('realDatum = [' + realDatum + ']');
					//			_alert('kPairAR[' + i + '] = [' + kPairAR[i] + ']');
								if (kPairAR[i].toUpperCase().indexOf('X') != -1) {
									switch (num) {
										case 0:
											oWaferAnalObj.waferStats.minDieX = Math.min(oWaferAnalObj.waferStats.minDieX,realDatum);
											oWaferAnalObj.waferStats.maxDieX = Math.max(oWaferAnalObj.waferStats.maxDieX,realDatum);

											oPt.DieX = realDatum;
										break;

										case 1:
											oWaferAnalObj.waferStats.minImageX = Math.min(oWaferAnalObj.waferStats.minImageX,realDatum);
											oWaferAnalObj.waferStats.maxImageX = Math.max(oWaferAnalObj.waferStats.maxImageX,realDatum);

											oPt.ImageX = realDatum;
										break;

										case 2:
											oWaferAnalObj.waferStats.minOriginX = Math.min(oWaferAnalObj.waferStats.minOriginX,realDatum);
											oWaferAnalObj.waferStats.maxOriginX = Math.max(oWaferAnalObj.waferStats.maxOriginX,realDatum);

											oPt.OriginX = realDatum;
										break;
									}
								} else if (kPairAR[i].toUpperCase().indexOf('Y') != -1) {
									switch (num) {
										case 0:
											oWaferAnalObj.waferStats.minDieY = Math.min(oWaferAnalObj.waferStats.minDieY,realDatum);
											oWaferAnalObj.waferStats.maxDieY = Math.max(oWaferAnalObj.waferStats.maxDieY,realDatum);

											oPt.DieY = realDatum;
										break;

										case 1:
											oWaferAnalObj.waferStats.minImageY = Math.min(oWaferAnalObj.waferStats.minImageY,realDatum);
											oWaferAnalObj.waferStats.maxImageY = Math.max(oWaferAnalObj.waferStats.maxImageY,realDatum);

											oPt.ImageY = realDatum;
										break;

										case 2:
											oWaferAnalObj.waferStats.minOriginY = Math.min(oWaferAnalObj.waferStats.minOriginY,realDatum);
											oWaferAnalObj.waferStats.maxOriginY = Math.max(oWaferAnalObj.waferStats.maxOriginY,realDatum);

											oPt.OriginY = realDatum;
										break;
									}
								} else {
									oWaferAnalObj.waferStats.minVal = Math.min(oWaferAnalObj.waferStats.minVal,realDatum);
									oWaferAnalObj.waferStats.maxVal = Math.max(oWaferAnalObj.waferStats.maxVal,realDatum);
									oPt.value = realDatum;
								}
							}
						}
					}
					
				//	_alert('ar.length = [' + ar.length + ']' + ', ar = [' + ar + ']');
					for (i = 0; i < ar.length; i++) {
						ar[i] = ar[i].split(',');
					}
					var _chName = '';
					if (!!oChannelsSel) {
						ar.push(oChannelsSel.options[sel].value);
					} else if (!!(_chName = oWaferAnalObj.qData[2].getValueFor('channelName'))) {
						ar.push(_chName);
					}

					oPt = waferPoint.get$();
					for (i = 0; i < ar.length; i++) {
						analyzeRecord(ar[i], i);
					}
					oPt.scaleFactor = _diagramScaleFactor;
				//	_alert('\noPt = [' + oPt + ']' + '\n\n');
					oWaferAnalObj._data.push(oPt);
				};
				
				function getMainDict(_ri, _dict, _rowCntName) {
					if (dictMain == -1) {
						dictMain = DictObj.get$(_dict.asQueryString());
					}
				};

				var oDiagramFrame = $('iframe_diagramMetrics' + jNum);
				if (!!oChannelsSel) {
					if (oChannelsSel.selectedIndex == 0) {
						oChannelsSel.selectedIndex = 1;
					}
				}

				try {
					if (!!oChannelsSel) {
						sel = oChannelsSel.selectedIndex;
					}
				} catch(e) {
					sel = -1;
				} finally {
				}
				if ( (oWaferAnalObj.qData.length > 1) && (!!oDiagramFrame) ) {
					try {
						try {
							initDiagram(); // this is only required when multiple graphs are being generated to be shown side by side...
							_DiagramTarget = window.frames['F_diagramMetrics' + jNum];
							_DiagramTarget.document.open();
							_DiagramTarget.document.writeln('<html><head><link rel=stylesheet type="text/css" href="' + document.location.href + 'diagram.css" />');
							_DiagramTarget.document.writeln('</head><body bgcolor="##eeeeee">');
		
							var _diagramScaleFactor = (1/10);
							var _diagramLeft = -100000 * _diagramScaleFactor;
							var _diagramRight = 100000 * _diagramScaleFactor;
							var _diagramBottom = -100000 * _diagramScaleFactor;
							var _diagramTop = 100000 * _diagramScaleFactor;
							var _diagramGradientSteps = 32; // must be 16, 32, 64, etc.
						} catch(e) {
							jsErrorExplainer(e, '121.2a', true);
						} finally {
						}
						
						try {
							if (oWaferAnalObj._data.length == 0) {
								oWaferAnalObj.qData[1].iterateRecObjs(displayRecords);
							} else {
								oWaferAnalObj.qData[1].iterateRecObjs(displayRecordsFast);
							}
						} catch(e) {
							jsErrorExplainer(e, '121.2b', true);
						} finally {
						}
// +++
						try {
							var D = new Diagram();
							var _dgWidth = 540;
							var _dgHeight = 460;
							var widthCorrectionFactor = ((global_arWaferAnalysisObjects.length > numPerRow) ? numPerRow : global_arWaferAnalysisObjects.length);
							if (global_arWaferAnalysisObjects.length > 1) {
								var _dgWidth = (clientWid$() / global_arWaferAnalysisObjects.length);
								var _dgHeight = (clientHt$() / global_arWaferAnalysisObjects.length);
								D.SetFrame(80, 10, _dgWidth - (widthCorrectionFactor * 140), _dgHeight);
							} else {
								D.SetFrame(80, 10, _dgWidth, _dgHeight);
							}
							D.SetBorder(_diagramLeft, _diagramRight, _diagramBottom, _diagramTop);
						//	D.SetGridColor("##D4D4D4", "##D4D4D4");
							D.Draw("##DDDDDD","##0000FF",true,"Click on me !","parent.F1DiagramClick()");
						} catch(e) {
							jsErrorExplainer(e, '121.2c', true);
						} finally {
						}

						try {
							oWaferAnalObj.qData[0].iterateRecObjs(getMainDict);
						} catch(e) {
							jsErrorExplainer(e, '121.2d', true);
						} finally {
						}

						try {
							var ORGIN_DIE_X = dictMain.getValueFor('ORGIN_DIE_X');
							if (!!ORGIN_DIE_X) {
								ORGIN_DIE_X = Math.ceil(parseFloat(ORGIN_DIE_X) * _diagramScaleFactor);
							}
							var ORGIN_DIE_Y = dictMain.getValueFor('ORGIN_DIE_Y');
							if (!!ORGIN_DIE_Y) {
								ORGIN_DIE_Y = Math.ceil(parseFloat(ORGIN_DIE_Y) * _diagramScaleFactor);
							}
							var DIE_PITCH_X = dictMain.getValueFor('DIE_PITCH_X');
							if (!!DIE_PITCH_X) {
								DIE_PITCH_X = Math.ceil(parseFloat(DIE_PITCH_X) * _diagramScaleFactor);
							}
							var DIE_PITCH_Y = dictMain.getValueFor('DIE_PITCH_Y');
							if (!!DIE_PITCH_Y) {
								DIE_PITCH_Y = Math.ceil(parseFloat(DIE_PITCH_Y) * _diagramScaleFactor);
							}
		
							pixel_width = 1;
							pixel_height = 1;
						} catch(e) {
							jsErrorExplainer(e, '121.2e', true);
						} finally {
						}

						try {
							var oSelNotch = $('selection_notch');
							if ( (!!oSelNotch) && (oSelNotch.selectedIndex > -1) ) {
								notchPosition = oSelNotch.options[oSelNotch.selectedIndex].value;
							}
						} catch(e) {
							notchPosition = 'T';
							jsErrorExplainer(e, '121.2', true);
						} finally {
						}
	
						if (notchPosition == 'L') {
							// left-side notch
							notchX1 = D.ScreenX(_diagramLeft);
							notchX2 = D.ScreenX(_diagramLeft + (DIE_PITCH_X / 2));
							notchY1 = D.ScreenY(-(DIE_PITCH_Y / 2));
							notchY2 = D.ScreenY((DIE_PITCH_Y / 2));
							new Line(notchX1, notchY1, notchX2, D.ScreenY(0), _asColorHex(0x000000), 1);
							new Line(notchX1, notchY2, notchX2, D.ScreenY(0), _asColorHex(0x000000), 1);
						}
						
						if (notchPosition == 'R') {
							// right-side notch
							new Line(D.ScreenX(_diagramRight), D.ScreenY(-(DIE_PITCH_Y / 2)), D.ScreenX(_diagramRight - (DIE_PITCH_X / 2)), D.ScreenY(0), _asColorHex(0x000000), 1);
							new Line(D.ScreenX(_diagramRight), D.ScreenY((DIE_PITCH_Y / 2)), D.ScreenX(_diagramRight - (DIE_PITCH_X / 2)), D.ScreenY(0), _asColorHex(0x000000), 1);
						}
						
						if (notchPosition == 'T') {
							// top notch
							new Line(D.ScreenX(-(DIE_PITCH_Y / 2)), D.ScreenY(_diagramTop), D.ScreenX(0), D.ScreenY(_diagramTop - (DIE_PITCH_Y / 2)), _asColorHex(0x000000), 1);
							new Line(D.ScreenX(DIE_PITCH_Y / 2), D.ScreenY(_diagramTop), D.ScreenX(0), D.ScreenY(_diagramTop - (DIE_PITCH_Y / 2)), _asColorHex(0x000000), 1);
						}
						
						if (notchPosition == 'B') {
							// bottom notch
							new Line(D.ScreenX(-(DIE_PITCH_Y / 2)), D.ScreenY(_diagramBottom), D.ScreenX(0), D.ScreenY(_diagramBottom + (DIE_PITCH_Y / 2)), _asColorHex(0x000000), 1);
							new Line(D.ScreenX(DIE_PITCH_Y / 2), D.ScreenY(_diagramBottom), D.ScreenX(0), D.ScreenY(_diagramBottom + (DIE_PITCH_Y / 2)), _asColorHex(0x000000), 1);
						}
						
						pixel_width = 2;
						pixel_height = 2;
	
						drawCircle(D, _diagramLeft, _diagramBottom, (_diagramRight - _diagramLeft), (_diagramTop - _diagramBottom), _asColorHex(0x000000));
	
						pixel_width = 1;
						pixel_height = 1;
						
						var colorMap = [];
						
						_diagramGradientSteps = (((_diagramGradientSteps == 64) || (_diagramGradientSteps == 32) || (_diagramGradientSteps == 16)) ? _diagramGradientSteps : 32);

						var rr = 0xff;
						var gg = 0x00;
						var bb = 0x00;
						var step = 256 / (_diagramGradientSteps / 2);
						var _focus = 1;
						var hh = '';
						for (_focus = 1; _focus < 3; ) {
							hh = '0x' + _asHex(rr) + _asHex(gg) + _asHex(bb);
							colorMap.push(_asColorHex(eval(hh)));
							switch (_focus) {
								case 1:
									rr -= step;
									gg += step;
									if (rr < 0) {
										rr = 0;
										gg = 0xff;
										_focus++;
									}
								break;
	
								case 2:
									gg -= step;
									bb += step;
									if (gg < 0) {
										gg = 0;
										bb = 0xff;
										_focus++;
									}
								break;
							}
						}
						hh = '0x' + _asHex(rr) + _asHex(gg) + _asHex(bb);
						colorMap.push(_asColorHex(eval(hh)));
						
						var bool_showMeasurePoints = true;
						try {
							oSelMeasurePoints = $('selection_measurePoints');
							if ( (!!oSelMeasurePoints) && (oSelMeasurePoints.selectedIndex > -1) ) {
								bool_showMeasurePoints = ((oSelMeasurePoints.options[oSelMeasurePoints.selectedIndex].value == 'Y') ? true : false);
							}
						} catch(e) {
						} finally {
						}
						
						var spreadVal = oWaferAnalObj.waferStats.maxVal - oWaferAnalObj.waferStats.minVal;
						var spreadDist = spreadVal / colorMap.length;
	
						var i = -1;
						var iPt = 1;
						var _tVal = 0;
						var tVal = 0;
						var cVal = -1;
						var _cVal = -1;
						var ii = -1;
						var _dataPts = '';
						var theLeft = -1, 
							theTop = -1, 
							theRight = -1, 
							theBottom = -1;
						var _ImageX = -1,
							_ImageY = -1;
						var _ImageX_ = -1,
							_ImageY_ = -1;
						var _ImageX$ = -1,
							_ImageY$ = -1;
						var _OriginX = -1,
							_OriginY = -1;
						var _CurrOriginXY = -1;
						var iX = -1,
							iY = -1;
						var _iPt = 1;
						var imagePtsStack = [];

						for (i = 0; i < oWaferAnalObj._data.length; i++) {
							tVal += oWaferAnalObj._data[i].value;
							_dataPts += '(' + oWaferAnalObj._data[i].value + ') ';
							_OriginX = Math.ceil(oWaferAnalObj._data[i].OriginX * _diagramScaleFactor);
							_OriginY = Math.ceil(oWaferAnalObj._data[i].OriginY * _diagramScaleFactor);
	
							_ImageX$ = oWaferAnalObj._data[i].ImageX;
							_ImageY$ = oWaferAnalObj._data[i].ImageY;
	
							_ImageX_ = Math.ceil(_ImageX$ * _diagramScaleFactor);
							_ImageY_ = Math.ceil(_ImageY$ * _diagramScaleFactor);
	
							_ImageX = D.ScreenX(_ImageX_);
							_ImageY = D.ScreenY(_ImageY_);
	
							if (_CurrOriginXY != (_OriginX + '.' + _OriginY)) {
								_tVal = (tVal / 2);
								_cVal = Math.ceil(Math.abs(_tVal - oWaferAnalObj.waferStats.minVal) / spreadDist) - 1;
								cVal = colorMap[_cVal];
								ii = Math.ceil(iPt / 2);
								theLeft = D.ScreenX(_OriginX);
								theBottom = D.ScreenY(_OriginY);
								theRight = D.ScreenX(Math.ceil(_OriginX + DIE_PITCH_X));
								theTop = D.ScreenY(Math.ceil(_OriginY + DIE_PITCH_Y));
								oWaferAnalObj.title[ii] = 'dieX/dieY = (' + oWaferAnalObj._data[i].DieX + ',' + oWaferAnalObj._data[i].DieY + ') ' + ', DIE_PITCH_X/DIE_PITCH_Y = (' + DIE_PITCH_X + ',' + DIE_PITCH_Y + ') ' + _dataPts + ', die total = (' + tVal + ')' + ', die mean = (' + _tVal + ')' + ', Color Index = (' + _cVal + ')'; 
								oWaferAnalObj.title[ii] += '\n' + '_diagramScaleFactor = [' + _diagramScaleFactor + ']' + ', _OriginX/_OriginX = (' + _OriginX + ',' + _OriginY + ') ';
								new Box(theLeft, theTop, theRight, theBottom, "##" + cVal, "", "##000000", 1, "##" + _asColorHex(0x000000), oWaferAnalObj.title[ii], "alert(parent.global_arWaferAnalysisObjects[" + jNum + "].title[" + ii + "])");
								
								tVal = 0;
								_dataPts = '';
								_CurrOriginXY = (_OriginX + '.' + _OriginY);
							}
							if (bool_showMeasurePoints) {
								oWaferAnalObj.titleImagePts[iPt] = '(' + iPt + ')' + ', dieX/dieY = (' + oWaferAnalObj._data[i].DieX + ',' + oWaferAnalObj._data[i].DieY + ') ' + ', imageX/imageY = (' + _ImageX_ + ',' + _ImageY_ + ') ' + ', Metrics Value = (' + oWaferAnalObj._data[i].value + ') '; 
								oWaferAnalObj.titleImagePts[iPt] += '\n' + '(raw) imageX/imageY = (' + _ImageX$ + ',' + _ImageY$ + ') ';
								imagePtsStack.push([_ImageX, _ImageY]);
							}
							iPt++;
						}
	
						if (bool_showMeasurePoints) {
							for (i = 0; i < imagePtsStack.length; i++) {
								_ImageX = imagePtsStack[i][0];
								_ImageY = imagePtsStack[i][1];
								new Box(_ImageX, _ImageY, _ImageX + 4, _ImageY + 8, "##" + _asColorHex(0xff0000), "", "##000000", 1, "##" + _asColorHex(0x000000), oWaferAnalObj.titleImagePts[i], "alert(parent.global_arWaferAnalysisObjects[" + jNum + "].titleImagePts[" + i + "])");
							}
						}

						var _x = _diagramRight * 1.2;
						var _dx = (_diagramRight - _diagramLeft) * 0.075;
						var _y = _diagramBottom;
						var _y0 = _y;
						var dy = Math.ceil((_diagramTop - _diagramBottom) / colorMap.length);
						var _dy = Math.ceil(dy * 0.8);
						for (var j = colorMap.length - 1; j >= 0; j--) {
							_y += _dy;
						}
						_y -= _dy;
						new Box(D.ScreenX(_x) - 1, D.ScreenY(_y) - 1, D.ScreenX(_x + _dx) + 1, D.ScreenY(_y0 - _dy) + 2, "", "", "", 1, "black", "", "");
	
						_y = _diagramBottom;
						for (j = colorMap.length - 1; j >= 0; j--) {
							new Box(D.ScreenX(_x), D.ScreenY(_y), D.ScreenX(_x + _dx), D.ScreenY(_y + dy), "##" + colorMap[j], "", "", "", "", "Color Index (" + j + ")" + ", ##" + colorMap[j], "");
							_y += _dy;
						}
											
						_DiagramTarget.document.writeln("</body></html>");
						_DiagramTarget.document.close();
// +++	
						if (!!oDiagramFrame) {
							oDiagramFrame.style.width = (_dgWidth + 140) + 'px';
							oDiagramFrame.style.height = (_dgHeight + 60) + 'px';
							if (global_arWaferAnalysisObjects.length > 1) { // each wafer needs to be adjusted since there are more than one of them...
								// jNum is the wafer number we are working with at the moment...
								var numPerRow = 3;
								var _jNum = (jNum + 1);
								var rowN = _int(jNum / numPerRow);
								var colN = (_jNum - (rowN * numPerRow)) - 1;

								oDiagramFrame.style.width = (parseInt(oDiagramFrame.style.width) - (widthCorrectionFactor * 140)) + 'px';
								
								oDiagramFrame.style.top = (rowN * parseInt(oDiagramFrame.style.height)) + 'px';
								oDiagramFrame.style.left = (colN * parseInt(oDiagramFrame.style.width)) + 'px';
								
					//			oDiagramFrame.style.height = (parseInt(oDiagramFrame.style.height) / global_arWaferAnalysisObjects.length) + 'px';

								oDiagramFrame.style.position = const_absolute_style;
							}
							if (0) {
								_alert('oDiagramFrame.id = [' + oDiagramFrame.id + ']' + ', oDiagramFrame.name = [' + oDiagramFrame.name + ']');
								_alert('numPerRow = [' + numPerRow + ']' + ', jNum = [' + jNum + ']' + ', _jNum = [' + _jNum + ']');
								_alert('rowN = [' + rowN + ']' + ', colN = [' + colN + ']');
								_alert('clientWid$() = [' + clientWid$() + ']' + ', clientHt$() = [' + clientHt$() + ']');
								_alert('_dgWidth = [' + _dgWidth + ']' + ', _dgHeight = [' + _dgHeight + ']');
								_alert('oDiagramFrame.style.top = [' + oDiagramFrame.style.top + ']' + ', oDiagramFrame.style.left = [' + oDiagramFrame.style.left + ']');
								_alert('oDiagramFrame.style.width = [' + oDiagramFrame.style.width + ']' + ', oDiagramFrame.style.height = [' + oDiagramFrame.style.height + ']');
								_alert('================================================================================\n');
							}
							oDiagramFrame.style.display = const_inline_style;
						}
					} catch(e) {
						jsErrorExplainer(e, 'JavaScript Error', true);
					} finally {
					}
				} else {
					alert('Cannot display the wafer due to some kind of problem...');
				}
			}

			function handleWaferDataFromDb(qObj) {
				var i, j;
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var _html = '';
				var argsDict = DictObj.get$();
				var waferDict = -1;

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};

				function displayRecords(_ri, _dict, _rowCntName) {
					var ar = ['metricsData'.toUpperCase(),'debugContent'.toUpperCase()];
					var html = '';
					
					var oO = $('div_scopeBrowser');
					if (!!oO) {
						for (var i = 0; i < ar.length; i++) {
							html = _dict.getValueFor(ar[i]);
							if (!!html) {
								_html += html.URLDecode();
							}
						}
					}
				};

				function determineWaferIDFromRecords(_ri, _dict, _rowCntName) {
					var _WAFERID = _dict.getValueFor('WAFERID');
					if (!!_WAFERID) {
						waferDict = DictObj.get$(_dict.asQueryString());
					}
				};

//	_alert(qObj);				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = -1;
					for (i = 1; i <= nRecs; i++) {
						qData = qObj.named('qData' + i.toString());
						qData.iterateRecObjs(determineWaferIDFromRecords);
						if (waferDict != -1) {
							for (j = 0; j < global_arWaferAnalysisObjects.length; j++) {
								if (global_arWaferAnalysisObjects[j].waferID == waferDict.getValueFor('WAFERID')) {
									global_arWaferAnalysisObjects[j].add_qData(qData);
								}
							}
						}
						qData.iterateRecObjs(anyErrorRecords);
					}
					if ( (!!qData) && (!bool_isAnyErrorRecords) ) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							argsDict.intoNamedArgs();
						}
						for (j = 0; j < global_arWaferAnalysisObjects.length; j++) {
							global_arWaferAnalysisObjects[j].add_qData(DictObj.get$(argsDict.asQueryString()));
						}
						for (j = 0; j < global_arWaferAnalysisObjects.length; j++) {
					//	_alert('BEFORE: global_arWaferAnalysisObjects[' + j + '] = [' + global_arWaferAnalysisObjects[j] + ']');
					//	_alert('\n====================================================================================================\n');
					//	_alert('drawWaferToScale(' + j + ') !');
							drawWaferToScale(j);
					//	_alert('AFTER: global_arWaferAnalysisObjects[' + j + '] = [' + global_arWaferAnalysisObjects[j] + ']');
						}

						var oObj = $('selection_channels');
						if (!!oObj) {
							oObj.disabled = false;
						}
						var oObj = $('selection_notch');
						if (!!oObj) {
							oObj.disabled = false;
						}
						var oObj = $('selection_measurePoints');
						if (!!oObj) {
							oObj.disabled = false;
						}
					} else if (bool_isAnyErrorRecords) {
						if (bool_isHTMLErrorRecords) {
							_alertHTML(s_explainError);
						} else {
							_alert(s_explainError);
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}

			var global_tidChannel = [];
			
			function delayedAction(aFunc, bool_suppressBusy) {
				bool_suppressBusy = ((bool_suppressBusy == true) ? bool_suppressBusy : false);
				if (global_tidChannel[aFunc] != null) {
					clearInterval(global_tidChannel[aFunc]);
					global_tidChannel[aFunc] = null;
				}
				if (typeof aFunc == 'function') {
					if (!bool_suppressBusy) {
						var oObj = $('selection_channels');
						if (!!oObj) {
							oObj.disabled = true;
						}
						var oObj = $('selection_notch');
						if (!!oObj) {
							oObj.disabled = true;
						}
						var oObj = $('selection_measurePoints');
						if (!!oObj) {
							oObj.disabled = true;
						}
					//	showAJAXBegins(const_system_busy_message_symbol, const_busy_loading_image, '90%');
						aFunc();
					//	showAJAXEnds();
					}
				} else {
					alert('Programming Error - missing value for parm known as (' + aFunc + ') in delayedAction().');
				}
			}

			function handleProcessMetricsFileFromDb(qObj) {
				_alert(qObj);				
			}
			
			function handleProcessMetricsFile(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var _html = '';
				var argsDict = DictObj.get$();

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};

				function displayRecords(_ri, _dict, _rowCntName) {
					var ar = ['metricsData'.toUpperCase(),'debugContent'.toUpperCase()];
					var html = '';
					
					var oO = $('div_scopeBrowser');
					if (!!oO) {
						for (var i = 0; i < ar.length; i++) {
							html = _dict.getValueFor(ar[i]);
							if (!!html) {
								_html += html.URLDecode();
							}
						}
					}
				};

//	_alert(qObj);				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = -1;
					for (i = 1; i <= nRecs; i++) {
						qData = qObj.named('qData' + i.toString());
						qData.iterateRecObjs(anyErrorRecords);
					}
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							argsDict.intoNamedArgs();
						}
//	_alert('argsDict = [' + argsDict + ']');
						var oWaferName = $('input_DiskBrowserGUI_driveLetter');
						var oO = $('div_scopeBrowser');
						if (!!oO) {
							_html = '';
							
							_html += '<table width="800" bgcolor="##FFFFA8" border="1" cellpadding="-1" cellspacing="-1">';
							_html += '<tr>';
							_html += '<td align="left" valign="top">';

							_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
							_html += '<tr bgcolor="silver">';
							_html += '<td width="90%" align="center" valign="top">';
							_html += '<span class="boldPromptTextClass">Metrics Data Browser</span>';
							_html += '</td>';
							_html += '<td width="*" align="right" valign="top">';
							_html += '<button class="buttonClass" id="btn_dismiss_scopeBrowser" onclick="handle_dismiss_scopeBrowser(); return false;">[X]</button>';
							_html += '</td>';
							_html += '</tr>';
							_html += '</table>';

							_html += '</td>';
							_html += '</tr>';

							_html += '<tr>';
							_html += '<td align="left" valign="top">';
							_html += '<span class="codeSmallerNoBorder">';

							if (!bool_isAnyErrorRecords) {

							//	_data = [];
								waferPoint.remove$s();
							//	alert('handleProcessMetricsFile() :: This function will not function until it is coded to use the new multi-wafer model.');
							//	global_waferStats.resetStats();

								var cols = ''; // global_qData[1].columnList();
								
								var chCols = [];
								var ar = cols.toString().split(',');
								for (var i = 0; i < ar.length; i++) {
									if (ar[i].toUpperCase().indexOf('CHANNEL') != -1) {
										chCols.push(ar[i]);
									}
								}

								if (!!oWaferName) {
									_html += '<br><br>';
									_html += '<span class="normalSmallStatusBoldClass">Data Channel:</span>&nbsp;<select id="selection_channels" class="textEntryClass" title="Choose a Metrics Channel to Draw the Wafer..." onchange="global_tidChannel[drawWaferToScale] = setInterval(\'delayedAction(drawWaferToScale)\', 250); return false;">';
									_html += '<option value="-1">Choose...</option>';
									for (i = 0; i < chCols.length; i++) {
										_html += '<option value="' + chCols[i] + '">' + chCols[i] + '</option>';
									}
									_html += '</select>';
									
									_html += '&nbsp;<span class="normalSmallStatusBoldClass">Notch:</span>&nbsp;';
									_html += '<select id="selection_notch" class="textEntryClass" onchange="drawWaferToScale(); return false;">';
									_html += '<option value="L">Left</option>';
									_html += '<option value="R">Right</option>';
									_html += '<option value="T" selected>Top</option>';
									_html += '<option value="B">Bottom</option>';
									_html += '</select>';
	
									_html += '&nbsp;<span class="normalSmallStatusBoldClass">Measurement Points:</span>&nbsp;';
									_html += '<select id="selection_measurePoints" class="textEntryClass" onchange="drawWaferToScale(); return false;">';
									_html += '<option value="Y" selected>Yes</option>';
									_html += '<option value="N">No</option>';
									_html += '</select>';
	
									_html += '<br>';
								}

								var oBtn = $('btn_pythonProcess_DiskBrowserGUI');
								if (!!oBtn) {
								//	oBtn.disabled = false;
								}
								
								for (var kk = 0; kk < global_arWaferAnalysisObjects.length; kk++) {
									_html += '<iframe id="iframe_diagramMetrics' + kk + '" frameborder="1" scrolling="Auto" width=440 height=250 name="F_diagramMetrics' + kk + '" style="display: none;"></iframe>';
								}					
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}

							_html += '</span>';
							_html += '</td>';
							_html += '</tr>';

							_html += '</table>';
							
							dismissActivityBalloon();
							
							oO.innerHTML = _html;
							oO.style.display = const_inline_style;

							if (!!oWaferName) {
								var _waferName = oWaferName.value;
							} else {
								try {
									handleWaferDataFromDb(qObj);
								} catch(e) {
									jsErrorExplainer(e, '121', true);
								} finally {
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}

			function handleProcessPythonFile(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var _html = '';
				var argsDict = DictObj.get$();

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};

				function displayRecords(_ri, _dict, _rowCntName) {
					var html = _dict.getValueFor('SCOPECONTENTS');

					var oO = $('div_scopeBrowser');
					if ( (!!oO) && (!!html) ) {
						_html += html.URLDecode();
					}
				};
//	_alert(qObj);				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							qData.iterateRecObjs(anyErrorRecords);
							if (!bool_isAnyErrorRecords) {
								argsDict.intoNamedArgs();

								var oO = $('div_scopeBrowser');
								if (!!oO) {
									_html = '';
									
									_html += '<table width="800" border="1" cellpadding="-1" cellspacing="-1">';
									_html += '<tr>';
									_html += '<td align="left" valign="top">';

									_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
									_html += '<tr bgcolor="silver">';
									_html += '<td width="90%" align="center" valign="top">';
									_html += '<span class="boldPromptTextClass">Scopes Browser</span>';
									_html += '</td>';
									_html += '<td width="*" align="right" valign="top">';
									_html += '<button class="buttonClass" id="btn_dismiss_scopeBrowser" onclick="handle_dismiss_scopeBrowser(); return false;">[X]</button>';
									_html += '</td>';
									_html += '</tr>';
									_html += '</table>';

									_html += '</td>';
									_html += '</tr>';

									_html += '<tr>';
									_html += '<td align="left" valign="top">';
									
									qData.iterateRecObjs(displayRecords);
									_html += '</td>';
									_html += '</tr>';

									_html += '</table>';
									
									oO.innerHTML = _html;
									oO.style.display = const_inline_style;
								}
							//	_alert(qData);
							//	_alert(argsDict);
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}

			var global_baseFolderName = '';
			var global_pathName = '';
			
			function handleAJAXData(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _id = '';
				var i = -1;
				var n = -1;
				var _html = '';
				var dontShowCols = ['ATTRIBUTES', 'DIRECTORY', 'DATELASTMODIFIED', 'MODE', 'TYPE', 'ISINDB', 'SIZE'];
				var argsDict = DictObj.get$();

				function searchForArgRecs(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						argsDict.push(n.trim(), v);
					}
				};

				function beginTableFor(qQ) {
					var i = -1;
					var isInsideFolder = false;
					if (!!qQ) {
						var cols = qQ.columnList();
						_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
						_html += '<tr bgcolor="silver">';
						isInsideFolder = (global_baseFolderName.toUpperCase() != global_pathName.toUpperCase());
						if (isInsideFolder) {
							_html += '<td align="center" valign="top" colspan="2">';
							_html += '<button id="btn_dirDrillOut_DiskBrowserGUI" class="buttonClass" onclick="this.disabled = true; handle_dirDrillOut_DiskBrowserGUI(this); return false;">[UP]</button>';
							_html += '</td>';
						}
						_html += '</tr>';
						_html += '<tr bgcolor="silver">';
						for (i = 0; i < cols.length; i++) {
							if (locateArrayItems(dontShowCols, cols[i]) == -1) {
								_html += '<td align="center" valign="top">';
								_html += '<span class="normalStatusBoldClass">' + cols[i] + '</span>';
								_html += '</td>';
							}
						}
						_html += '</tr>';
					}
				};

				function displayDirectoryRecords(_ri, _dict, _rowCntName, qQ) {
					var ar = -1;
					var btnLabel = _dict.toString();
					var isName = false;
					var isFolder = false;
					var isPythonFile = false;
					var datum = -1;
					var oObj = -1;
					var cols = qQ.columnList();
					var _isFolder = (_dict.getValueFor('TYPE').toUpperCase() == 'Dir'.toUpperCase());
					var _f = _dict.getValueFor('ATTRIBUTES').toUpperCase().indexOf('H');
					_html += '<tr bgcolor="' + (((_ri % 2) == 0) ? const_paper_color_light_yellow : const_color_light_blue) + '">';
					var _isInDb = (parseInt(_dict.getValueFor('ISINDB')) == 1);
					ar = btnLabel.split('(');
					if (ar.length > 2) {
						btnLabel = '(' + ar[2];
					}
					for (i = 0; i < cols.length; i++) {
						if (_f == -1) {
							if (locateArrayItems( dontShowCols, cols[i]) == -1) {
								isName = (cols[i].toUpperCase() == 'NAME');
								isFolder = ( (_isFolder) && (isName) );
								datum = _dict.getValueFor(cols[i]);
								isPythonFile = ( (isName) && (datum.toUpperCase().indexOf('metric.txt'.toUpperCase()) != -1));
								_html += '<td align="' + ((isName) ? 'center' : 'center') + '" valign="top">';
								_html += '<span class="normalStatusBoldClass">' + ((isFolder) ? '<button id="btn_dirDrillInto_DiskBrowserGUI_' + _ri + '" class="buttonClass"' + ((_isInDb) ? ' style="color: ##BCBCBC;"' : '') + ' title="' + btnLabel + '" onclick="disableAllButtonsLike(\'btn_dirDrillInto_DiskBrowserGUI_\'); handle_dirDrillInto_DiskBrowserGUI(this); return false;">' : ((isPythonFile) ? '<button id="btn_pythonProcess_DiskBrowserGUI" disabled class="buttonClass" value="' + datum + '" title="\n' + _dict.asQueryString() + '" onclick="this.disabled = true; handle_pythonProcess_DiskBrowserGUI(this); return false;">[Store "' : '')) + datum + ((isFolder) ? '</button>' : (isPythonFile ? '" in Db]</button>' : '')) + ((isPythonFile) ? '&nbsp;&nbsp;<button id="btn_dbProcess_DiskBrowserGUI" disabled class="buttonClass" title="\n' + _dict.asQueryString() + '" onclick="this.disabled = true; displayMetricsBrowserDiagramInterface(); return false;">[Show Wafer from Db]</button>' : '') + '</span>';
								_html += '</td>';
							}
						}
					}
					_html += '</tr>';
				};

				function endTableFor(d) {
					if (!!d) {
						_html += '</table>';
					}
				};
								
//	_alert(qObj);				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForArgRecs);
							qData.iterateRecObjs(anyErrorRecords);
							if (!bool_isAnyErrorRecords) {
								argsDict.intoNamedArgs();

								var btnObj = -1;
								if (!!(btnObj = disabled_buttons_stack.pop())) {
									btnObj.disabled = false;
								}

							//	_alert(qData);
								beginTableFor(qData);
								qData.iterateRecObjs(displayDirectoryRecords);
								endTableFor(qData);
								var oO = $('div_directory_DiskBrowserGUI');
								if (!!oO) {
									if (oO.innerHTML.length > 0) flushCache$(oO);
									oO.innerHTML = _html;

									dismissActivityBalloon();

									var oBtnFaster = $('btn_faster_waferDisplay');
									var oBtnSlower = $('btn_pythonProcess_DiskBrowserGUI');
									var oWaferName = $('input_DiskBrowserGUI_driveLetter');
								//	alert('oBtnFaster = [' + oBtnFaster + ']' + ', oBtnSlower = [' + oBtnSlower + ']' + ', oWaferName = [' + oWaferName + ']');
									if ( (!!oBtnFaster) && (!!oBtnSlower) && (!!oWaferName) ) {
										var oDict = DictObj.get$(oBtnSlower.title);
										var _waferName = oWaferName.value;
									//	oBtnSlower.disabled = (oWaferName.value.toUpperCase() == oDict.getValueFor('DIRECTORY') ? true : false);

									//	alert('AJAX gets status about buttons for wafer named "' + oDict.getValueFor('DIRECTORY') + '".');
										doAJAX_func('getWaferFromDbStatus', 'handleWaferFromDbStatus(' + oAJAXEngine.js_global_varName + ')', 'waferName', _waferName);
									}
								}
								if (global_baseFolderName.length == 0) {
									global_baseFolderName = argsDict.getValueFor('driveLetter');
									global_pathName = global_baseFolderName;
								}
							//	_alert(argsDict);
							} else {
								if (bool_isHTMLErrorRecords) {
									_alertHTML(s_explainError);
								} else {
									_alert(s_explainError);
								}
							}
						}
					}
				}
				DictObj.remove$(argsDict.id);
			}
		// -->
		</script>

		<b>Welcome to the Semiconductor Industry Sample AJAX-Powered Wafer Analysis Tools !</b>
		<br>
		
		<cfinclude template="debugContent.cfm">
		
		<div id="div_activityBalloon" style="display: none;">
			<table width="*" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80">
				<tr>
					<td>
						<table width="*" cellspacing="-1" cellpadding="-1">
							<tr>
								<td colspan="2">
									<span id="span_activityBalloon_body" class="textClass"></span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>

		<div id="form_diagram1" style="position: absolute; top: 70px; left: 10px; width: 720px; height: 100px; display: none;"></div>
		<iframe id="iframe_diagram1" frameborder="0" scrolling="Auto" width=440 height=250 name="F1" style="position: absolute; top: 100px; left: 10px; display: none;"></iframe>
		<iframe id="iframe_diagram3D" frameborder="0" scrolling="Auto" width=440 height=250 name="F2" style="position: absolute; top: 100px; left: 10px; display: none;"></iframe>

		<div id="form_diskBrowser" style="position: absolute; top: 70px; left: 10px; width: 720px; height: 100px; display: none;"></div>
		<div id="div_scopeBrowser" style="position: absolute; top: 70px; left: 10px; width: 800px; height: 100px; display: none;"></div>
		
		<div id="div_sysMessages" style="display: none;">
			<table width="*" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80">
				<tr>
					<td>
						<table width="*" cellspacing="-1" cellpadding="-1">
							<tr id="div_sysMessages_titleBar_tr" bgcolor="silver">
								<td align="center">
									<span id="span_sysMessages_title" class="boldPromptTextClass"></span>
								</td>
								<td align="right">
									<button class="buttonClass" title="Click this button to dismiss this pop-up." onclick="dismissSysMessages(); return false;">[X]</button>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<span id="span_sysMessages_body" class="textClass"></span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oAJAXEngine.hideFrame();
			var cObj = $('btn_hideShow_iFrame');
			if (!!cObj) {
				if (oAJAXEngine.visibility == 'visible') {
					cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
				}
			}

			var cObj = $('btn_useXmlHttpRequest');
			if (!!cObj) {
				if (oAJAXEngine.isXmlHttpPreferred == false) {
					cObj.value = cObj.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest');
				}
			}

			var cObj = $('btn_useMethodGetOrPost');
			if (!!cObj) {
				if (oAJAXEngine.isMethodGet()) {
					cObj.value = cObj.value.clipCaselessReplace('GET', 'Post');
				}
			}

			var cObj = $('btn_useDebugMode');
			if (!!cObj) {
				if (oAJAXEngine.isReleaseMode() == true) {
					cObj.value = cObj.value.clipCaselessReplace('Debug', 'Release');
				}
			}

			var cObj = $(const_cf_html_container_symbol);
			var dObj = $(const_div_floating_debug_menu);
			if ( (!!cObj) && (!!dObj) ) {
				if (dObj.style.display == const_none_style) {
					dObj.style.position = cObj.style.position;
					dObj.style.top = parseInt(cObj.style.top) + 25 + 'px';
					dObj.style.left = (clientWid$() - 75) + 'px';
					dObj.style.display = const_inline_style;
				}
			}

			var _msg = '#Request.RuntimeLicenseStatus#';
			if (_msg.length > 0) {
				_alertHTMLError(_msg);
			}
			
			window.onscroll();			
		// -->
		</script>
		
	</body>
</cfoutput>
