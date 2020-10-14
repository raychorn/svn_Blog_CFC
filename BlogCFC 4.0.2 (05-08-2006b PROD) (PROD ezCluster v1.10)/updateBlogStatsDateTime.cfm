<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfset diffT = 1>
<cfset periodT = (Minute(Now()) / 10)>
<cfif (periodT MOD 2) eq 0>
	<cfset diffT = -1>
</cfif>

<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	xx1 = 'There are currently #Ceiling((Hour(Now()) * 60) + ((diffT * 5) * periodT))# Users Online as of ';
	xx2 = '#DateFormat(Now(), "full")# #TimeFormat(Now(), "full")#';
	parent.refresh_blogStatsDateTimeFromAjax(xx1, xx2);
</script>
</cfoutput>

