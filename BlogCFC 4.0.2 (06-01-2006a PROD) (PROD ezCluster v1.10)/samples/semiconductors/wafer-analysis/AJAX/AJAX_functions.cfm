<cfsetting requesttimeout="120">
<!--- BEGIN: This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->
<!--- Request.qryStruct also contains the variables that were passed-in from the caller... --->
<cfinclude template="cfinclude_AJAX_Begin.cfm">
<!--- END! This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->

<cfscript>
	aRuntimeLicenseStruct = Request.commonCode.readRuntimeLicenseFile();
	RuntimeLicenseStatus = aRuntimeLicenseStruct.RuntimeLicenseStatus;
	bool_RuntimeLicenseStatus = (Len(aRuntimeLicenseStruct.RuntimeLicenseStatus) eq 0);
</cfscript>

<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
<cfif (IsDefined("Request.qryStruct.cfm"))>
	<cfscript>
		bool_onChangeSubMenu = false;
		Request.qryStruct.namedArgs = StructNew();
		if (IsDefined("Request.qryStruct.argCnt")) {
			try {
				for (i = 1; i lte Request.qryStruct.argCnt; i = i + 2) {
					argName = Request.qryStruct['arg' & i];
					argVal = Request.qryStruct['arg' & (i + 1)];
					Request.qryStruct.namedArgs[argName] = argVal;
				}
			} catch(Any e) {
			}
		}
		if (bool_RuntimeLicenseStatus) {
			switch (Request.qryStruct.cfm) {
				case 'getWaferListFromDb':
					_sql_statement = "SELECT id, waferName FROM Wafers ORDER BY waferName";
					Request.commonCode.safely_execSQL('Request.qGetWaferListFromDb', Request.DSN, _sql_statement);
					if (NOT Request.dbError) {
						Request.commonCode.registerQueryFromAJAX(Request.qGetWaferListFromDb); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...

					//	someXML = Request.commonCode.QueryToXMLString(Request.qGetWaferListFromDb);
					//	someStats = Request.commonCode.QueryStats(Request.qGetWaferListFromDb);
					//	someJS = Request.commonCode.QueryToJSCode(Request.qGetWaferListFromDb);
						
					//	writeOutput(Request.commonCode.cf_dump(someXML, 'someXML [#someStats#] [#Len(someJS)#]', false));
					//	writeOutput('<br><br><textarea style="font-size: 10px;" cols="120" readonly rows="15">#someJS#</textarea>');
						
					//	qObj = QueryNew('id, xmlBytes, someStats');
					//	QueryAddRow(qObj, 1);
					//	QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					//	QuerySetCell(qObj, 'xmlBytes', Len(someXML), qObj.recordCount);
					//	QuerySetCell(qObj, 'someStats', someStats, qObj.recordCount);
					//	Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
				// +++
				case 'getWafersDataFromDb':
					if ( (IsDefined("Request.qryStruct.namedArgs.waferIds")) AND (IsDefined("Request.qryStruct.namedArgs.channelName")) ) {
						if (FindNoCase('CHANNEL', Request.qryStruct.namedArgs.channelName) gt 0) {
							arIDs = ListToArray(Request.qryStruct.namedArgs.waferIds, '|');
							listIDs = ArrayToList(arIDs, ',');
	
							_sql_statement = "SELECT waferName FROM Wafers WHERE (id in (#listIDs#))";
							Request.commonCode.safely_execSQL('Request.qGetWaferNamesFromDb', Request.DSN, _sql_statement);
							if (NOT Request.dbError) {
								for (i = 1; i lte Request.qGetWaferNamesFromDb.recordCount; i = i + 1) {
									Request.commonCode.getWaferDataFromDb(Request.qGetWaferNamesFromDb.waferName[i], Request.qryStruct.namedArgs.channelName);
								}
							} else {
								qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
								QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
								QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
								QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
								Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'Invalid value for AJAX parm named channelName (#Request.qryStruct.namedArgs.channelName#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (waferIds or channelName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
				// +++
				case 'getWaferDataFromDb':
					if ( (IsDefined("Request.qryStruct.namedArgs.waferName")) AND (IsDefined("Request.qryStruct.namedArgs.channelName")) ) {
						if (FindNoCase('CHANNEL', Request.qryStruct.namedArgs.channelName) gt 0) {
							Request.commonCode.getWaferDataFromDb(Request.qryStruct.namedArgs.waferName, Request.qryStruct.namedArgs.channelName);
						} else {
							qObj = QueryNew('id, errorMsg');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'Invalid value for AJAX parm named channelName (#Request.qryStruct.namedArgs.channelName#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (waferName or channelName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
				
				case 'getWaferFromDbStatus':
					if (IsDefined("Request.qryStruct.namedArgs.waferName")) {
						_sql_statement = "SELECT id, waferName, waferFullName, DIE_PITCH_X, DIE_PITCH_Y, NUMBER_OF_DIES, ORGIN_DIE_X, ORGIN_DIE_Y, POINTS_PER_DIE FROM Wafers WHERE (waferName LIKE '#Right(Request.qryStruct.namedArgs.waferName, 900)#%')";
						Request.commonCode.safely_execSQL('Request.qGetWaferDefFromDb', Request.DSN, _sql_statement);
						if (NOT Request.dbError) {
							Request.commonCode.registerQueryFromAJAX(Request.qGetWaferDefFromDb); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (waferName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
				
				case 'processMetricsFileFromDb':
					if (IsDefined("Request.qryStruct.namedArgs.metricsFileName")) {
						_sql_statement = "SELECT id, waferName, waferFullName, DIE_PITCH_X, DIE_PITCH_Y, NUMBER_OF_DIES, ORGIN_DIE_X, ORGIN_DIE_Y, POINTS_PER_DIE FROM Wafers WHERE (waferName LIKE '#Right(Request.qryStruct.namedArgs.metricsFileName, 900)#%')";
						Request.commonCode.safely_execSQL('Request.qGetWaferDefFromDb', Request.DSN, _sql_statement);
						if (NOT Request.dbError) {
							Request.commonCode.registerQueryFromAJAX(Request.qGetWaferDefFromDb); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (metricsFileName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
	
				case 'processMetricsFile':
					if (IsDefined("Request.qryStruct.namedArgs.metricsFileName")) {
						if (FileExists(Request.qryStruct.namedArgs.metricsFileName)) {
							bool_isCachedMetricsValid = false;
							try {
								bool_isCachedMetricsValid = ( (IsStruct(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsStruct'])) AND (IsStruct(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsDataAR'])) );
								if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (metricsStruct / metricsDataAR) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
							} catch (Any e) {
								if (bool_canDebugHappen) writeOutput(Request.commonCode.cf_dump(e, '(metricsStruct / metricsDataAR) isCachedMetricsValid Test Failed !', false));
							}
							if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">B. (metricsStruct / metricsDataAR) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
							if (bool_isCachedMetricsValid) {
								if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (metricsStruct / metricsDataAR) Fetching cached Metrics data !</b><br>');
								metricsStruct = Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsStruct'];
								metricsDataAR = Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsDataAR'];
								Request.fileError = false;
							} else {
								// read the INI file and the Metrics file and pass data back to caller...
								Request.commonCode.cf_file('READ', Request.qryStruct.namedArgs.metricsFileName, 'Request.metricsData');
								// look for the .INI file and read it...
								arFN = ListToArray(Request.qryStruct.namedArgs.metricsFileName, '\');
								n_arFN = ArrayLen(arFN);
								if (n_arFN gt 1) {
									bool_doneReadingMetricsData = false;
		
									i = 2;
									tFolderName = arFN[1] & '\' & arFN[2] & '\';
									for (i = i + 1; i lte n_arFN; i = i + 1) {
										if (NOT bool_doneReadingMetricsData) {
											Request.commonCode.cf_directory('Request.qDir', tFolderName, '*.ini', false);
											if ( (NOT Request.directoryError) AND (IsQuery(Request.qDir)) AND (Request.qDir.recordCount gt 0) ) {
												
												iniFileName = tFolderName & Request.qDir.name;
												structINI = GetProfileSections(iniFileName);
												
												metricsStruct = StructNew();
												if (IsStruct(structINI)) {
													mainKeysAR = ListToArray(structINI['main'], ',');
													
													for (k = 1; k lte ArrayLen(mainKeysAR); k = k + 1) {
														anItem = GetProfileString(iniFileName, 'main', mainKeysAR[k]);
														
														metricsStruct['main'][mainKeysAR[k]] = anItem;
													}
													
													num_dies = metricsStruct['main']['number_of_dies'];
													num_points = metricsStruct['main']['points_per_die'];
													for (dieNum = 0; dieNum lt num_dies; dieNum = dieNum + 1) {
														for (ptNum = 0; ptNum lt num_points; ptNum = ptNum + 1) {
															keysAR = ListToArray(structINI['#dieNum#.#ptNum#'], ',');
															for (k = 1; k lte ArrayLen(keysAR); k = k + 1) {
																anItem = GetProfileString(iniFileName, '#dieNum#.#ptNum#', keysAR[k]);
																metricsStruct['#dieNum#.#ptNum#'][keysAR[k]] = anItem;
															}
														}
													}
												}
		
												bool_doneReadingMetricsData = true;
												break;
											} else {
												Request.metricsData = '(No INI File can be found in [#tFolderName#].) ' & chr(10) & Request.metricsData;
											}
											tFolderName = tFolderName & arFN[i] & '\';
										}
									}
									metricsDataAR = ListToArray(Request.metricsData, Chr(10));
									for (i = 1; i lte ArrayLen(metricsDataAR); i = i + 1) {
										newAR = ArrayNew(1);
										ar = ListToArray(Trim(metricsDataAR[i]), ' ');
										chNum = 1;
										for (j = 1; j lte ArrayLen(ar); j = j + 1) {
											ar[j] = Trim(ar[j]);
											if (Len(ar[j]) gt 0) {
												newAR[chNum] = ar[j];
												chNum = chNum + 1;
											}
										}
										metricsDataAR[i] = newAR;
									}
								} else {
									Request.metricsData = '(No INI File can be found.) ' & chr(10) & Request.metricsData;
								}
	
								try {
									if (NOT IsStruct(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName])) {
										Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
									}
								} catch (Any e) {
									if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">1. (metricsStruct) Creating Cached Metrics Struct !</b><br>');
									Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
								}
								if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">1. (metricsStruct) Saving Cached Metrics Struct !</b><br>');
								Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsStruct'] = metricsStruct;
								Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['metricsDataAR'] = metricsDataAR;
							}

							if (NOT Request.fileError) {
								bool_isCachedMetricsValid = false;
								try {
									bool_isCachedMetricsValid = (IsQuery(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ1']));
									if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (qObj) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
								} catch (Any e) {
									if (bool_canDebugHappen) writeOutput(Request.commonCode.cf_dump(e, '(qObj) isCachedMetricsValid Test Failed !', false));
								}
								if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">B. (qObj) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
								if (bool_isCachedMetricsValid) {
									if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (qObj) Fetching cached Metrics data !</b><br>');
									qObj = Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ1'];
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								} else {
									keys = StructKeyList(metricsStruct['main'], ',');
									keysAR = ListToArray(keys, ',');
									kiN = ArrayLen(keysAR);
									qObj = QueryNew('id, #keys#');
									QueryAddRow(qObj, 1);
									QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
									for (i = 1; i lte kiN; i = i + 1) {
										QuerySetCell(qObj, keysAR[i], metricsStruct['main'][keysAR[i]], qObj.recordCount);
									}
									try {
										if (NOT IsStruct(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName])) {
											Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
										}
									} catch (Any e) {
										if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">1. Creating Cached Metrics Struct !</b><br>');
										Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
									}
									Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ1'] = qObj;
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
	
								// determine if the data for this query is already in the Db or not...
								_sql_statement = "SELECT id, waferName, waferFullName, DIE_PITCH_X, DIE_PITCH_Y, NUMBER_OF_DIES, ORGIN_DIE_X, ORGIN_DIE_Y, POINTS_PER_DIE FROM Wafers WHERE (waferName = '#Right(Request.qryStruct.namedArgs.metricsFileName, 900)#')";
								Request.commonCode.safely_execSQL('Request.qGetWaferDefFromDb', Request.DSN, _sql_statement);
								if (NOT Request.dbError) {
									if (Request.qGetWaferDefFromDb.recordCount eq 0) {
										// put the data into the Db...
										_sql_statement = "INSERT INTO Wafers (waferName, waferFullName, DIE_PITCH_X, DIE_PITCH_Y, NUMBER_OF_DIES, ORGIN_DIE_X, ORGIN_DIE_Y, POINTS_PER_DIE) VALUES ('#Right(Request.qryStruct.namedArgs.metricsFileName, 900)#','#Request.qryStruct.namedArgs.metricsFileName#',#qObj.DIE_PITCH_X#,#qObj.DIE_PITCH_Y#,#qObj.NUMBER_OF_DIES#,#qObj.ORGIN_DIE_X#,#qObj.ORGIN_DIE_Y#,#qObj.POINTS_PER_DIE#); SELECT @@IDENTITY as 'id';";
										Request.commonCode.safely_execSQL('Request.qGetWaferDefFromDb', Request.DSN, _sql_statement);
										if (NOT Request.dbError) {
											qObj = QueryNew('id, status');
											QueryAddRow(qObj, 1);
											QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
											QuerySetCell(qObj, 'status', 'QOBJ1 OKay', qObj.recordCount);
											Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
										} else {
											qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
											QueryAddRow(qObj, 1);
											QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
											QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
											QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
											QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
											QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
											Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
										}
									}
								} else {
									qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
									QueryAddRow(qObj, 1);
									QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
									QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
									QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
									QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
									QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
								
								bool_isCachedMetricsValid = false;
								try {
									bool_isCachedMetricsValid = (IsQuery(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ2']));
									if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (QOBJ2) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
								} catch (Any e) {
									if (bool_canDebugHappen) writeOutput(Request.commonCode.cf_dump(e, '(QOBJ2) isCachedMetricsValid Test Failed !', false));
								}
								if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">B. (QOBJ2) bool_isCachedMetricsValid = [#bool_isCachedMetricsValid#]</b><br>');
								if (bool_isCachedMetricsValid) {
									if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">A. (QOBJ2) Fetching cached Metrics data !</b><br>');
									qObj = Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ2'];
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								} else {
									keys = StructKeyList(metricsStruct[0.0], ',');
									keysAR = ListToArray(keys, ',');
									kiN = ArrayLen(keysAR);
									qObj = QueryNew('id, dieNum, ptNum, #keys#, channel1, channel2, channel3, channel4, channel5, channel6, channel7, channel8, channel9');
									// channel data needs to be split away from the rest of the data because only the channel data changes from wafer to wafer...
									num_dies = metricsStruct['main']['number_of_dies'];
									num_points = metricsStruct['main']['points_per_die'];
									for (dieNum = 0; dieNum lt num_dies; dieNum = dieNum + 1) {
										for (ptNum = 0; ptNum lt num_points; ptNum = ptNum + 1) {
											QueryAddRow(qObj, 1);
											QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
											QuerySetCell(qObj, 'dieNum', dieNum, qObj.recordCount);
											QuerySetCell(qObj, 'ptNum', ptNum, qObj.recordCount);
											for (ki = 1; ki lte kiN; ki = ki + 1) {
												try {
													QuerySetCell(qObj, keysAR[ki], metricsStruct['#dieNum#.#ptNum#'][keysAR[ki]], qObj.recordCount);
												} catch (Any e) {
													if (bool_canDebugHappen) Request.commonCode.cf_dump(e, 'CF Error [#keysAR[ki]#]', false);
													if (bool_canDebugHappen) Request.commonCode.cf_dump(metricsStruct['#dieNum#.#ptNum#'], "metricsStruct['#dieNum#.#ptNum#']", false);
												}
											}
		
											anAR = metricsDataAR[qObj.recordCount];
											for (chNum = 1; chNum lte ArrayLen(anAR); chNum = chNum + 1) {
												QuerySetCell(qObj, 'channel#chNum#', anAR[chNum], qObj.recordCount);
											}
										}
									}
		
									try {
										if (NOT IsStruct(Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName])) {
											Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
										}
									} catch (Any e) {
										if (bool_canDebugHappen) writeOutput('<b style="font-size: 12px">2. Creating Cached Metrics Struct !</b><br>');
										Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName] = StructNew();
									}
									Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ2'] = qObj;
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
								// determine if the wafer data (this never changes) for this query is already in the Db or not...
								_sql_statement = "SELECT count(id) as cnt FROM WaferData";
								Request.commonCode.safely_execSQL('Request.qGetWaferDataCnt', Request.DSN, _sql_statement);
								if (NOT Request.dbError) {
									if (Request.qGetWaferDataCnt.recordCount eq 1) {
										if (Request.qGetWaferDataCnt.cnt eq 0) {
											// put the data into the Db...
											_sql_statement = "";
											recNum = 0;
											for (i = 1; i lte qObj.recordCount; i = i + 1) {
												_sql_statement = _sql_statement & "INSERT INTO WaferData (dieNum, ptNum, dieOriginX, dieOriginY, die_X, die_Y, imageX, imageY, Xrel, Yrel) VALUES (#qObj.DIENUM[i]#,#qObj.PTNUM[i]#,#qObj.DIEORIGINX[i]#,#qObj.DIEORIGINY[i]#,#qObj.DIE_X[i]#,#qObj.DIE_Y[i]#,#qObj.IMAGEX[i]#,#qObj.IMAGEY[i]#,#qObj.XREL[i]#,#qObj.YREL[i]#); ";
												recNum = recNum + 1;
											}
											Request.commonCode.safely_execSQL('Request.qPutWaferDataIntoDb', Request.DSN, _sql_statement);
											if (NOT Request.dbError) {
												qObj = QueryNew('id, status');
												QueryAddRow(qObj, 1);
												QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
												QuerySetCell(qObj, 'status', 'QOBJ2|cnt=#recNum#', qObj.recordCount);
												Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
											} else {
												qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
												QueryAddRow(qObj, 1);
												QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
												QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
												QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
												QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
												QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
												Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
											}
										} else {
											qObj = QueryNew('id, status');
											QueryAddRow(qObj, 1);
											QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
											QuerySetCell(qObj, 'status', 'QOBJ2|cnt=#Request.qGetWaferDataCnt.cnt#', qObj.recordCount);
											Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
										}
									}
								} else {
									qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
									QueryAddRow(qObj, 1);
									QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
									QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
									QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
									QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
									QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
									Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
								qObj = Application.cachedMetrics[Request.qryStruct.namedArgs.metricsFileName]['QOBJ2'];
								if (IsQuery(Request.qGetWaferDefFromDb)) {
									// determine if the wafer data (this never changes) for this query is already in the Db or not...
									_sql_statement = "SELECT id FROM WaferMetrics WHERE (waferID = #Request.qGetWaferDefFromDb.id#)";
									Request.commonCode.safely_execSQL('Request.qGetWaferMetrics', Request.DSN, _sql_statement);
									if (NOT Request.dbError) {
										if (Request.qGetWaferMetrics.recordCount eq 0) {
											// put the data into the Db...
											_sql_statement = "";
											recNum = 0;
											for (i = 1; i lte qObj.recordCount; i = i + 1) {
												_sql_statement = _sql_statement & "INSERT INTO WaferMetrics (waferID, rowNum, channel1, channel2, channel3, channel4, channel5, channel6, channel7, channel8, channel9) VALUES (#Request.qGetWaferDefFromDb.id#,#i#,#qObj.CHANNEL1[i]#,#qObj.CHANNEL2[i]#,#qObj.CHANNEL3[i]#,#qObj.CHANNEL4[i]#,#qObj.CHANNEL5[i]#,#qObj.CHANNEL6[i]#,#qObj.CHANNEL7[i]#,#qObj.CHANNEL8[i]#,#qObj.CHANNEL9[i]#); ";
												recNum = recNum + 1;
											}
											Request.commonCode.safely_execSQL('Request.qPutWaferMetricsIntoDb', Request.DSN, _sql_statement);
											if (NOT Request.dbError) {
												qObj = QueryNew('id, status');
												QueryAddRow(qObj, 1);
												QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
												QuerySetCell(qObj, 'status', 'QOBJ2a|cnt=#recNum#', qObj.recordCount);
												Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
											} else {
												qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
												QueryAddRow(qObj, 1);
												QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
												QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
												QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
												QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
												QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
												Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
											}
										}
									} else {
										qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
										QueryAddRow(qObj, 1);
										QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
										QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
										QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
										QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
										QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
										Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									}
								}
							} else {
								qObj = QueryNew('id, errorMsg');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', 'Cannot read file named (#Request.qryStruct.namedArgs.metricsFileName#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
								Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'Missing file named (#Request.qryStruct.namedArgs.metricsFileName#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (metricsFileName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
	
				case 'processPythonFile':
					if (IsDefined("Request.qryStruct.namedArgs.pythonFileName")) {
						if (FileExists(Request.qryStruct.namedArgs.pythonFileName)) {
							err_someCode = false;
							err_someCodeMsg = '';
							try {
							   Request.pythonCode = CreateObject("component", ListFirst(CGI.SCRIPT_NAME, '/') & ".cfc.pythonInterpreter").init(Request.qryStruct.namedArgs.pythonFileName);
							} catch(Any e) {
								err_someCode = true;
								err_someCodeMsg = '(1) The pythonInterpreter component has NOT been created. | Reason: [#e.message#] [#e.detail#]';
							}
							if (err_someCode) {
								qObj = QueryNew('id, errorMsg');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', '(#err_someCodeMsg#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
								Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							} else {
							//	aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(Request.pythonCode.vars, 'Request.pythonCode.vars', false));
							//	data = URLEncodedFormat(aContentStruct.htmlContent);
							
								aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(Request.pythonCode.pythonVars, 'Request.pythonCode.pythonVars', false));
								data = URLEncodedFormat(aContentStruct.htmlContent);
							
							//	data = Request.pythonCode.linesOfCodeAsHTML();
	
								qObj = QueryNew('id, statusMsg, scopeContents');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'statusMsg', 'Nominal', qObj.recordCount);
								QuerySetCell(qObj, 'scopeContents', data, qObj.recordCount);
								Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'Missing file named (#Request.qryStruct.namedArgs.pythonFileName#) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (pythonFileName) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
	
				case 'getDiskDirectory':
					if (IsDefined("Request.qryStruct.namedArgs.driveLetter")) {
						Request.commonCode.cf_directory('Request.qDir', Request.qryStruct.namedArgs.driveLetter, '*', false);
			
						if (NOT Request.directoryError) {
							SetProfileString(ExpandPath(ReplaceNoCase(CGI.SCRIPT_NAME, '.cfm', '.ini')), 'Defaults', 'driveLetter', Request.qryStruct.namedArgs.driveLetter);
							ar = ArrayNew(1);
							for (i = 1; i lte Request.qDir.recordCount; i = i + 1) {
								ar[ArrayLen(ar) + 1] = Request.qDir.directory[i] & '\' & Request.qDir.NAME[i] & '\metric.txt';
							}
							_sql_statement = "SELECT id, waferName FROM Wafers WHERE (waferName IN (#Request.commonCode.listToSQL_InList(ArrayToList(ar, ','))#))";
							Request.commonCode.safely_execSQL('Request.qGetWafersInDb', Request.DSN, _sql_statement);
				//	writeOutput(Request.commonCode.cf_dump(Request.qGetWafersInDb, 'Request.qGetWafersInDb [#_sql_statement#]', false));
							if (NOT Request.dbError) {
								ar = ArrayNew(1);
								for (i = 1; i lte Request.qDir.recordCount; i = i + 1) {
									_flagValue = 0;
									if (Request.qDir.TYPE[i] is 'Dir') {
										aName = Request.qDir.directory[i] & '\' & Request.qDir.NAME[i] & '\metric.txt';
										_sql_statement = "SELECT id FROM Request.qGetWafersInDb WHERE (waferName = '#aName#')";
										Request.commonCode.safely_execSQL('Request.qChkWafersInQuery', '', _sql_statement);
										if ( (NOT Request.dbError) AND (IsDefined("Request.qChkWafersInQuery")) AND (IsQuery(Request.qChkWafersInQuery)) AND (Request.qChkWafersInQuery.recordCount gt 0) ) {
											_flagValue = 1;
										}
									}
									ar[ArrayLen(ar) + 1] = _flagValue;
								}
								QueryAddColumn(Request.qDir, 'isInDb', 'Bit', ar);
				//	writeOutput(Request.commonCode.cf_dump(ar, 'ar', false));
				//	writeOutput(Request.commonCode.cf_dump(Request.qDir, 'Request.qDir', false));
								Request.commonCode.registerQueryFromAJAX(Request.qDir); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							} else {
								qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
								QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
								QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
								QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
								Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.directoryErrorMsg, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'Missing AJAX parm named (driveLetter) for #Request.qryStruct.cfm# in #CGI.SCRIPT_NAME#.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
	
				case 'getData':
					Request.dbError = false;
				//	_sql_statement = "sp_columns @table_name = 'AvnLayer', @table_owner = 'dbo'";
				//	Request.commonCode.safely_execSQL('Request.qGetLayerEditorMetaData', Request.DSN, _sql_statement);
		
					if (NOT Request.dbError) {
						qObj = QueryNew('id, status');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'status', -1, qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
			}
		} else {
			qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
			QueryAddRow(qObj, 1);
			QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
			QuerySetCell(qObj, 'errorMsg', RuntimeLicenseStatus, qObj.recordCount);
			QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);
			QuerySetCell(qObj, 'explainError', '', qObj.recordCount);
			QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);
			QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
			Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
		}
	</cfscript>
<cfelse>
	<cfoutput>
		bool_canDebugHappen = [#bool_canDebugHappen#]<br>
		<cfdump var="#URL#" label="URL Scope" expand="No">
		<cfdump var="#FORM#" label="FORM Scope" expand="No">
		<cfdump var="#CGI#" label="CGI Scope" expand="No">
	</cfoutput>
</cfif>
<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->

<!--- BEGIN: This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
<cfinclude template="cfinclude_AJAX_End.cfm">
<!--- END! This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
