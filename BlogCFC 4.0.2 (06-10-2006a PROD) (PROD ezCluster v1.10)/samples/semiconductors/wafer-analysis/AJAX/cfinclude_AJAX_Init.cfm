<cfparam name="_AUTH_USER" type="string" default="">

<cfparam name="bool_isServerLocal" type="boolean" default="#Request.commonCode.isServerLocal()#">

<cfset bool_using_xmlHttpRequest_viaGET = (isDefined("CGI.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(CGI.QUERY_STRING)) gt 0))>
<cfset bool_using_xmlHttpRequest_viaPOST = (isDefined("form.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(form.QUERY_STRING)) gt 0))>
<cfset bool_using_xmlHttpRequest = (bool_using_xmlHttpRequest_viaGET) OR (bool_using_xmlHttpRequest_viaPOST)>

<cfset bool_canDebugHappen = bool_isServerLocal AND 1>  <!---  AND isDebugMode() --->
