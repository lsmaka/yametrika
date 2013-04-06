{assign var="noSidebar" value=true} 
{include file='header.tpl'}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<center>
	<div id="yametrika_header" style="display: none;">
		<h4>
			<u>
				{$aLang.plugin.yametrika.stat_title}
				{if $oConfig->get('plugin.yametrika.ya_stat_time') == 'w'}
					{$aLang.plugin.yametrika.stat_title_week}
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'm'} 	
					{$aLang.plugin.yametrika.stat_title_month}
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'k'}		
					{$aLang.plugin.yametrika.stat_title_quarter}
				{elseif $oConfig->get('plugin.yametrika.ya_stat_time') == 'y'}
					{$aLang.plugin.yametrika.stat_title_year}
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
<div id="yametrika_Summary_VisitorsVisits" style="width: 100%; height: 400px;"></div>
<div id="yametrika_Summary_VisitorsNewVisitors" style="width: 100%; height: 400px;"></div>
<div id="yametrika_Summary_VisitorsPageView" style="width: 100%; height: 400px;"></div>
<div id="yametrika_Demography_Age" style="width: 100%; height: 400px;"></div>
<div id="yametrika_Demography_Sex" style="width: 100%; height: 400px;"></div>
<div id="yametrika_Geo_Country" style="width: 100%; height: 400px;"></div>


<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
    google.load('visualization', '1.0', {'packages':['corechart']});
    google.setOnLoadCallback(drawChart_v1);
//]]>
</script>
{/literal}