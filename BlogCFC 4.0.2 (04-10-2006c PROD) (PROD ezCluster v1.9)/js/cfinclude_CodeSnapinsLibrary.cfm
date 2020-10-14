<cfsetting enablecfoutputonly="Yes">
<cfparam name="Request.CodeSnapinsLibraryPragma" type="string" default="">

<cfoutput>
	<cfif (UCASE(Request.CodeSnapinsLibraryPragma) eq "HEAD")>
		<cfscript>
			for (i = 1; i lte application.snapIns.count; i = i + 1) {
				try {
					if (IsCustomFunction(application.snapIns.snapIns[i].jsCodeForHead)) {
					//	application.snapIns.snapIns[i].init();
						writeOutput(application.snapIns.snapIns[i].jsCodeForHead());
					}
				} catch (Any e) {
				}
			}
		</cfscript>
		
		<cfif session.persistData.loggedin>
			<cfscript>
				for (i = 1; i lte application.snapIns.count; i = i + 1) {
					try {
						if (IsCustomFunction(application.snapIns.snapIns[i].jsCode)) {
							writeOutput(application.snapIns.snapIns[i].jsCode());
						}
					} catch (Any e) {
					}
				}
			</cfscript>
		</cfif>	
	<cfelseif (UCASE(Request.CodeSnapinsLibraryPragma) eq "BODY1")>
		<cfoutput>
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<cfscript>
								for (i = 1; i lte application.snapIns.count; i = i + 1) {
									try {
										if (IsCustomFunction(application.snapIns.snapIns[i].htmlActionButton)) {
											writeOutput(application.snapIns.snapIns[i].htmlActionButton());
										}
									} catch (Any e) {
									}
									try {
										if (IsCustomFunction(application.snapIns.snapIns[i].cgiEvent)) {
											writeOutput(application.snapIns.snapIns[i].cgiEvent());
										}
									} catch (Any e) {
									//	writeOutput(Request.cf_dump(e, 'ERROR (i=#i#)', false));
									}
								}
							</cfscript>
						</tr>
					</table>
				</td>
			</tr>
		</cfoutput>
	<cfelseif (UCASE(Request.CodeSnapinsLibraryPragma) eq "BODY2")>
		<cfscript>
			for (i = 1; i lte application.snapIns.count; i = i + 1) {
				try {
					if (IsCustomFunction(application.snapIns.snapIns[i].htmlCode)) {
						writeOutput(application.snapIns.snapIns[i].htmlCode());
					}
				} catch (Any e) {
				}
			}
		</cfscript>
	</cfif>
</cfoutput>
