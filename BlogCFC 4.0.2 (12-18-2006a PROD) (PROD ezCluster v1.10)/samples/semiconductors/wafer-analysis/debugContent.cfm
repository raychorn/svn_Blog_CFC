<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
	<cfoutput>
		<table width="100%" border="0" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80" style="margin-top: 20px;">
			<tr>
				<td>
					<table>
						<tr>
							<td>
								<table>
									<tr>
										<td align="left" valign="top">
											<button name="btn_getContents" disabled id="btn_getContents" class="buttonMenuClass" title="This is the slower method for getting data because this method has to read and parse data from flat files and convert them into database records." onclick="displayDiskBrowserGUI(this);  return false;">[?Get Data into Db]</button>
										</td>
										<td align="left" valign="top">
											<button name="btn_getContents2" id="btn_getContents2" class="buttonMenuClass" title="This is the faster method for getting data because this method simply reads the desired data from the Db without the need to read flat files or perform a parsing function." onclick="displayDbBrowserGUI(this);  return false;">[?Get Data from Db]</button>
										</td>
<cfif (Request.commonCode.isServerLocal()) OR 1>
										<td align="left" valign="top">
											<select name="" id="selection_graphType" class="textClass" onChange="handle_graphType_onchange(this); return false;">
												<option value="-1" SELECTED>Choose...</option>
												<option value="0">Default Chart</option>
												<option value="1">Logarithmic Scale</option>
												<option value="2">Bar Chart Sample</option>
												<option value="3">Box Chart Sample</option>
												<option value="4">Dot Object Sample</option>
												<option value="5">Pixel Object Sample</option>
												<option value="6">Line Object Sample</option>
												<option value="7">Area Object Sample</option>
												<option value="8">Arrow Object Sample</option>
												<option value="9">Pie Object Sample</option>
												<option value="10">Static Sample</option>
												<option value="11">Dynamic Sample</option>
												<option value="13">Relative Position Sample</option>
											</select>
										</td>
										<td align="left" valign="top">
											<button name="btn_3dContents" id="btn_3dContents" class="buttonMenuClass" disabled onclick="svgvml3d();  return false;">[3D]</button>
										</td>
</cfif>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
<cfif (1)>
		<div id="#Request.cf_div_floating_debug_menu#" style="display: inline;">
			<table width="*" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left" style="display: inline;">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td align="left">
									<span class="onholdStatusBoldClass">AJAX:</span>&nbsp;<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" title="Click this button to open the AJAX Debug Panel" onclick="var cObj = $('td_ajaxHelperPanel'); var bObj = $('btn_helperPanel'); var tbObj = $('table_ajaxHelperPanel'); if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; repositionBasedOnFloatingDebugPanel(tbObj); oAJAXEngine.setDebugMode(); } else { oAJAXEngine.setReleaseMode(); }; }; return false;">[>>]</button>&nbsp;
								</td>
	<cfif (Request.commonCode.isServerLocal())>
								<td align="left">
									<span class="onholdStatusBoldClass">Scopes:</span>&nbsp;<button name="btn_helperPanel2" id="btn_helperPanel2" class="buttonMenuClass" title="Click this button to open the Scopes Debug Panel" onclick="handle_ajaxHelper2_onClick(); return false;">[>>]</button>
								</td>
	</cfif>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		
		<table id="table_menuHelperPanel" width="100%" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_menuHelperPanel" style="display: none;" align="left" valign="top">
					<textarea id="ta_menuHelperPanel" readonly rows="5" cols="175" class="textClass"></textarea>
				</td>
			</tr>
		</table>
		
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td align="center" id="td_ajaxHelperPanel" style="display: none;">
					<table width="100%" bgcolor="##80FFFF" border="1" bordercolor="silver" cellspacing="-1" cellpadding="-1" id="table_ajaxHelperPanel" style="width: 800px;">
						<tr>
							<td>
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td align="center">
											<button name="btn_useDebugMode" id="btn_useDebugMode" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('DEBUG') != -1) { oAJAXEngine.setReleaseMode(); this.value = this.value.clipCaselessReplace('Debug', 'Release'); } else { oAJAXEngine.setDebugMode(); this.value = this.value.clipCaselessReplace('Release', 'Debug'); }; return false;">[Debug Mode]</button>
										</td>
										<td align="center">
											<button name="btn_useXmlHttpRequest" id="btn_useXmlHttpRequest" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('XMLHTTPREQUEST') == -1) { oAJAXEngine.isXmlHttpPreferred = false; this.value = this.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest'); } else { oAJAXEngine.isXmlHttpPreferred = true; this.value = this.value.clipCaselessReplace('XMLHTTPREQUEST', 'iFRAME'); }; return false;">[Use iFrame]</button>
										</td>
										<td align="center">
											<button name="btn_useMethodGetOrPost" id="btn_useMethodGetOrPost" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('GET') != -1) { oAJAXEngine.setMethodGet(); this.value = this.value.clipCaselessReplace('GET', 'Post'); } else { oAJAXEngine.setMethodPost(); this.value = this.value.clipCaselessReplace('POST', 'Get'); }; return false;">[Use Get]</button>
										</td>
										<td align="center">
											<button name="btn_hideShow_iFrame" id="btn_hideShow_iFrame" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('SHOW') != -1) { oAJAXEngine.showFrame(); this.value = this.value.clipCaselessReplace('show', 'Hide'); } else { oAJAXEngine.hideFrame(); this.value = this.value.clipCaselessReplace('hide', 'Show'); }; return false;">[Show iFrame]</button>
										</td>
										<td align="center">
											<input type="checkbox" id="cb_debugPanel_toggle_AJAX_echo" onclick="global_echo_AJAX_commands = ((global_echo_AJAX_commands) ? false : true); return true;">&nbsp;<a href="" onclick="simulateCheckBoxClick('cb_debugPanel_toggle_AJAX_echo'); return false;"><span class="textClass">Echo AJAX Commands</span></a>
										</td>
										<td align="center">
											<button name="btn_1" id="btn_1" class="buttonMenuClass" onclick="doAJAX_func('getTopLevelMenuNames'); return false;">[Test]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
	<cfif (Request.commonCode.isServerLocal())>
		<cfsavecontent variable="content_application_debug_panel">
			<cfoutput>
				#Request.commonCode.scopesDebugPanelContentLayout()#
			</cfoutput>
		</cfsavecontent>		
		
		<table id="table_ajaxHelperPanel2" style="width: 800px;" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_ajaxHelperPanel2" align="center" style="display: none;">
					<table border="1" cellspacing="-1" cellpadding="-1">
						<tr>
							<td align="center">
								#content_application_debug_panel#
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfif>
</cfif>
</cfoutput>

