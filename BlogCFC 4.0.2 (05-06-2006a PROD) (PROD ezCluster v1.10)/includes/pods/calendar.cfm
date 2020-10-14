<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : calendar
	Author       : Raymond Camden + Paul Hastings 
	Created      : February 11, 2003
	Last Updated : October 26, 2005
	History      : Reset history for version 4.0
	Purpose		 : Handles blog calendar
--->

<cfparam name="month" default="#month(now())#">
<cfparam name="year" default="#year(now())#">

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("calendar")#">

<cfscript>					
	// no idea why this was so hard to conceive	
	function getFirstWeekPAD(firstDOW) {
		var firstWeekPad=0;
		var weekStartsOn=application.localeutils.weekStarts();
		switch (weekStartsON) {
			case 1:
				firstWeekPAD=firstDOW-1;
			break;
			case 2:
				firstWeekPAD=firstDOW-2;
				if (firstWeekPAD LT 0) firstWeekPAD=firstWeekPAD+7; // handle leap years
			break;
			case 7:
				firstWeekPAD=7-abs(firstDOW-7);
				if (firstWeekPAD EQ 7) firstWeekPAD=0;
			break;
		}
		return firstWeekPAD;
	}
	
	localizedDays=application.localeutils.getLocalizedDays();
	localizedMonth=application.localeutils.getLocalizedMonth(month);
	localizedYear=application.localeutils.getLocalizedYear(year);
	firstDay=createDate(year,month,1);
	firstDOW=dayOfWeek(firstDay);
	dim=daysInMonth(firstDay);
	firstWeekPAD=getFirstWeekPAD(firstDOW);
	lastMonth=dateAdd("m",-1,firstDay);
	nextMonth=dateAdd("m",1,firstDay);	
	dayList=application.blog.getActiveDays(year,month);
	dayCounter=1;
	rowCounter=1;
</cfscript>


<!--- swap navigation buttons if BIDI is true --->
<cfoutput>
	<div class="header">
	
	<cfif application.localeutils.isBIDI()>
		<cfset prevURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month(nextMonth)#/year/#year(nextMonth)#")>
		<cfset thisURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month#/year/#year#")>
		<cfset nextURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month(lastMonth)#/year/#year(lastMonth)#")>

		<a href="#prevURL#" rel="nofollow">&lt;&lt;</a>
		<a href="#thisURL#" rel="nofollow">#localizedMonth# #localizedYear#</a>
		<a href="#nextURL#" rel="nofollow">&gt;&gt;</a>		
	<cfelse>
		<cfset prevURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month(lastMonth)#/year/#year(lastMonth)#")>
		<cfset thisURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month#/year/#year#")>
		<cfset nextURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/month/#month(nextMonth)#/year/#year(nextMonth)#")>

		<a href="#prevURL#" rel="nofollow">&lt;&lt;</a>
		<a href="#thisURL#" rel="nofollow">#localizedMonth# #localizedYear#</a>
		<a href="#nextURL#" rel="nofollow">&gt;&gt;</a>
	</cfif>

	</div>
</cfoutput>
<cfoutput>
<center><table border=0 class="calendar_table" width="90%">
<tr>
	<!--- emit localized days in proper week start order --->
	<cfloop index="i" from="1" to="#arrayLen(localizedDays)#">
	<td>#localizedDays[i]#</td>
	</cfloop>
</tr>
</cfoutput>
<!--- loop until 1st --->
<cfoutput><tr></cfoutput>
<cfloop index="x" from=1 to="#firstWeekPAD#">
	<cfoutput><td>&nbsp;</td></cfoutput>
</cfloop>

<!--- note changed loop to start w/firstWeekPAD+1 and evaluated vs dayCounter instead of X --->
<cfloop index="x" from="#firstWeekPAD+1#" to="7">
	<cfset _url = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/day/#dayCounter#/month/#month#/year/#year#")>
	<cfoutput><td <cfif month(now()) eq month and dayCounter eq day(now()) and year(now()) eq year> class="calendar_today"</cfif>><cfif listFind(dayList,dayCounter)><a href="#_url#" rel="nofollow">#dayCounter#</a><cfelse>#dayCounter#</cfif></td></cfoutput>
	<cfset dayCounter = dayCounter + 1>
</cfloop>
<cfoutput></tr></cfoutput>
<!--- now loop until month days --->
<cfloop index="x" from="#dayCounter#" to="#dim#">
	<cfif rowCounter is 1>
		<cfoutput><tr></cfoutput>
	</cfif>
	<cfoutput>
		<td <cfif month(now()) eq month and x eq day(now()) and year(now()) eq year> class="calendar_today"</cfif>>
		<cfset _url = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/calendar/day/#x#/month/#month#/year/#year#")>
		<cfif listFind(dayList,x)><a href="#_url#" rel="nofollow">#x#</a><cfelse>#x#</cfif>
		</td>
	</cfoutput>
	<cfset rowCounter = rowCounter + 1>
	<cfif rowCounter is 8>
		<cfoutput></tr></cfoutput>
		<cfset rowCounter = 1>
	</cfif>
</cfloop>
<!--- now finish up last row --->
<cfif rowCounter GT 1> <!--- test if ran out of days --->
	<cfloop index="x" from="#rowCounter#" to=7>
		<cfoutput><td>&nbsp;</td></cfoutput>
	</cfloop>
	<cfoutput></tr></cfoutput>
</cfif>
<cfoutput>
</table></center>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>
