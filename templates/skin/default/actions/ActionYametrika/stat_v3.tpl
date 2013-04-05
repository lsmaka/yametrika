{assign var="noSidebar" value=true} 
{include file='header.tpl'}

<center>
	<div id="yametrika_header" style="display: none;">
		<h4>
			<u>
				{$aLang.plugin.yametrika.stat_title}
				{if $oConfig->get('plugin.yametrika.ya_stat_time') == 'w'}
				(за неделю)
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'm'}
				(за месяц) 	
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'k'}
				(за три месяца) 				
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'y'}
				(за год)
				{/if}
			</u>
		</h4>
	</div>	
</center>

<br/>

<div id="yametrika_loader" style="width: 100%; text-align: center;"></div>
<center>
	<div id="yametrika_error" style="width: 400px; text-align: center; padding: 10px; border: 2px solid red; display: none;"></div>
</center>
<div id="yametrika_Summary_VisitorsVisits"></div><br/><br/>
<div id="yametrika_Summary_VisitorsNewVisitors"></div><br/><br/>
<div id="yametrika_Summary_VisitorsPageView"></div><br/>

<div id="yametrika_Geo_Country"></div>

<div id="yametrika_Demography_Age" style="float: left; width:50%"></div>
<div id="yametrika_Demography_Sex" style="float: left; width:50%"></div>




<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
$(document).ready(drawChart_v3);
//]]>
</script>
{/literal}