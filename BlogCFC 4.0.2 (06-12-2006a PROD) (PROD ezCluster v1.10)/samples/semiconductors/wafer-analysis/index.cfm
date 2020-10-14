<cfsetting showdebugoutput="No">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>(Welcome to the Semiconductor Industry Sample AJAX-Powered Wafer Analysis Tools !)</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
		
		<cfset cfJavaScriptSourceCodeFName = "javascript.js">

		<cfscript>
			bool_recompileJavaScript = false;
			Request.commonCode.cf_directory('Request.qDir', ExpandPath('js'), '*.js', false);
			if ( (NOT Request.directoryError) AND (IsQuery(Request.qDir)) AND (Request.qDir.recordCount gt 0) ) {
				_sql_statement = "SELECT * FROM Request.qDir ORDER BY DATELASTMODIFIED DESC";
				Request.commonCode.safely_execSQL('Request.qDir2', '', _sql_statement);
				if (NOT Request.dbError) {
	
					_path = GetDirectoryFromPath(GetCurrentTemplatePath());
					Request.commonCode.cf_directory('Request.qDirH', _path, cfJavaScriptSourceCodeFName, false);
					if ( (NOT Request.directoryError) AND (IsQuery(Request.qDirH)) AND (Request.qDirH.recordCount gt 0) ) {
						bool_recompileJavaScript = (DateCompare(Request.qDir2.DATELASTMODIFIED[1], Request.qDirH.DATELASTMODIFIED[1]) gt 0);
					}
				}
			}
		</cfscript>

		<cfset fullyQualified_cfJavaScriptSourceCodeFName = ExpandPath(cfJavaScriptSourceCodeFName)>
		<cfset bool_rebuildCfJavaScriptSourceCodeFile = (bool_recompileJavaScript) OR (NOT FileExists(fullyQualified_cfJavaScriptSourceCodeFName))>
		
		<cfif (bool_rebuildCfJavaScriptSourceCodeFile)>
			<cfsavecontent variable="someContent">
				<cfoutput>
					<cfset Request.jsCodeObfuscationIndex = 1>
					<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
					<cfset _jsCodeList = "decontextmenu.js,initAJAXEngine.js,doAJAX_func.js,ajaxSupport.js,AJaxContextObj.js,AJAXObj.js,AJAXEngine.js">
					<cfset jsCodeList = "../../../js/433511201010924803.dat,../../../js/decontextmenu.js,js/object_destructor.js,js/constants.js,js/events.js,js/misc.js,js/clientHt$.js,js/clientWid$.js,js/flushCache$.js,js/_$.js,js/$.js,js/simulateCheckBoxClick.js,js/setFocusSafely.js,js/setFocusSafelyById.js,js/disableAllButtonsLike.js,js/URLEncode.js,js/URLDecode.js,js/_int.js,js/StringPrototypeFormatForWidth.js,js/StringPrototypeIsAlpha.js,js/StringPrototypeIsNumeric.js,js/StringPrototypeFilterInAlpha.js,js/StringPrototypeFilterInNumeric.js,js/StringPrototypeStripHTML.js,js/StringPrototypeStripSpacesBy2s.js,js/StringPrototypeStripIllegalChars.js,js/StringPrototypeURLEncode.js,js/StringPrototypeURLDecode.js,js/StringPrototypeStripTabs.js,js/StringPrototypeStripCrLfs.js,js/StringPrototypeReplaceSubString.js,js/StringPrototypeClipCaselessReplace.js,js/StringPrototypeTrim.js,js/ArrayPrototypeCfString.js,js/setStyle.js,js/toCamelCase.js,js/getStyle.js,js/Style2String.js,js/insertArrayItem.js,js/removeArrayItem.js,js/locateArrayItems.js,js/removeEmptyItemsFromArray.js,js/handle_ajaxHelper2_onClick.js,js/clickRadioButton.js,js/jsErrorExplainer.js,js/objectExplainer.js,js/_displaySysMessages.js,js/DictObj.js,js/QObj.js,js/GUIActsObj.js,js/initAJAXEngine.js,js/doAJAX_func.js,js/window_onload.js,js/window_onUnload.js,js/windowOnresize.js,js/windowOnscroll.js,js/anyErrorRecords.js,js/ajaxSupport.js,js/AJaxContextObj.js,js/AJAXObj.js,js/AJAXEngine.js,js/waferPoint.js,js/waferStats.js,js/DiagramBuilder331_dom.js,js/DiagramBuilder331_nav.js,js/DiagramBuilder331_support.js,js/DiagramBuilderSamples.js,js/drawData.js,js/svgvml3d.js,js/WaferAnalObj.js">
					<cfset nItems = ListLen(jsCodeList, ",")>
					var x$ = [];
					<cfloop index="_i" from="1" to="#nItems#">
						<cfset anItem = ListGetAt(jsCodeList, _i, ",")><cfsavecontent variable="_jscode"><cfoutput>#Request.commonCode.readAndObfuscateJSCode(anItem, ListFindNoCase(_jsCodeList, ListLast(anItem, '/'), ",") gt 0)#</cfoutput></cfsavecontent>
						x$.push("#URLEncodedFormat(_jscode)#");
					</cfloop>
					var isSiteHavingProblems = 0; for (i=0; i < x$.length; i++) { eval(unescape(x$[i])); };
					<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
						#Request.jsCodeObfuscationDecoderAR[_i]#
					</cfloop>
					if (isSiteHavingProblems > 0) alert('This site is experiencing a malfunction, kindly return later on.')
				</cfoutput>
			</cfsavecontent>
			
			<cfif (FileExists(fullyQualified_cfJavaScriptSourceCodeFName))>
				<cffile action="DELETE" file="#fullyQualified_cfJavaScriptSourceCodeFName#">
			</cfif>
			<cffile action="WRITE" file="#fullyQualified_cfJavaScriptSourceCodeFName#" output="#Request.commonCode.jsMinifier(someContent)#" addnewline="No" fixnewline="No">
		</cfif>

		<script language="JavaScript1.2" type="text/javascript" src="#cfJavaScriptSourceCodeFName#"></script>
	</head>

	<cfinclude template="cfinclude_index_body.cfm">
		
	</html>
</cfoutput>
