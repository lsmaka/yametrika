{assign var="noSidebar" value=true} 
{include file='header.tpl'}

<center>
	<div id="makayam_header" style="display: none;">
		<h4>
			<u>
				{$aLang.plugin.makayam.stat_title}
				{if $oConfig->get('plugin.makayam.ya_stat_time') == 'w'}
				(за неделю)
				{elseif $oConfig->get('plugin.makayam.ya_stat_time') == 'm'}
				(за месяц) 	
				{elseif $oConfig->get('plugin.makayam.ya_stat_time') == 'k'}
				(за три месяца) 				
				{elseif $oConfig->get('plugin.makayam.ya_stat_time') == 'y'}
				(за год)
				{/if}
			</u>
		</h4>
	</div>	
</center>

<br/>

<div id="makayam_loader" style="width: 100%; text-align: center;"></div>
<center>
	<div id="makayam_error" style="width: 400px; text-align: center; padding: 10px; border: 2px solid red; display: none;"></div>
</center>
<div id="makayam_Summary_VisitorsVisits"></div><br/><br/>
<div id="makayam_Summary_VisitorsNewVisitors"></div><br/><br/>
<div id="makayam_Summary_VisitorsPageView"></div><br/>

<div id="makayam_Geo_Country"></div>

<div id="makayam_Demography_Age" style="float: left; width:50%"></div>
<div id="makayam_Demography_Sex" style="float: left; width:50%"></div>




<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
$(document).ready(function(){
	var param = {};
	ls.ajax(aRouter['makayam']+'ajax/',param ,function(result)
	{
		if (!result.bStateError)
		{
			$('#makayam_loader').html('');

			$('#makayam_header').fadeIn('slow');	
			
			for(sStatName in result.aItems)
			{
				if(sStatName == 'Summary')
				{
					var dataVisitors = new Array();
					var dataVisits = new Array();
					var dataPageView = new Array();
					var dataNewVisitors = new Array();
					
					var key = result.aItems[sStatName]['data'].length-1;
					while(key >= 0)
					{
						//
						var re = /(\d{2})(\d{2})(\d{2})(\d{2})/;
						curdate = result.aItems[sStatName]['data'][key]['date'];
						var newdata = curdate.replace(re, "$3-$4-$1$2");
						//
						dataVisitors.push( [newdata, parseInt(result.aItems[sStatName]['data'][key]['visitors'])] );
						dataVisits.push( [newdata, parseInt(result.aItems[sStatName]['data'][key]['visits'])] );
						dataPageView.push( [newdata, parseInt(result.aItems[sStatName]['data'][key]['page_views'])] );
						dataNewVisitors.push( [newdata, parseInt(result.aItems[sStatName]['data'][key]['new_visitors'])] );
						
						key--;
					}

					// begin graf VisitorsVisits						
					var plot1 = $.jqplot('makayam_Summary_VisitorsVisits', [dataVisitors, dataVisits], {
						title:'',
						//
						axes:{
							xaxis:{
								renderer:$.jqplot.DateAxisRenderer,
								tickOptions:{
								formatString:'%Y-%m-%d'
								} 
							},
							yaxis:{
							  tickOptions:{
								formatString:'%d'
								}
							}
						},
						highlighter: {
							show: true,
							sizeAdjust: 7.5
						},
						legend: {
							show: true,
							location: 'nw',     // compass direction, nw, n, ne, e, se, s, sw, w.
							xoffset: 10,        // pixel offset of the legend box from the x (or x2) axis.
							y2offset: 10,        // pixel offset of the legend box from the y (or y2) axis.
						},	
						//
						series:[{
									show: true,
									label : 'Посетители',
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : 'Визиты',
									showLine: true, 
									showMarker: true
								}]
					});
					// end graf VisitorsVisits
					// begin graf VisitorsNewVisitors						
					var plot1 = $.jqplot('makayam_Summary_VisitorsNewVisitors', [dataVisitors, dataNewVisitors], {
						title:'',
						//
						axes:{
							xaxis:{
								renderer:$.jqplot.DateAxisRenderer,
								tickOptions:{
								formatString:'%Y-%m-%d'
								} 
							},
							yaxis:{
							  tickOptions:{
								formatString:'%d'
								}
							}
						},
						highlighter: {
							show: true,
							sizeAdjust: 7.5
						},
						legend: {
							show: true,
							location: 'nw',     // compass direction, nw, n, ne, e, se, s, sw, w.
							xoffset: 10,        // pixel offset of the legend box from the x (or x2) axis.
							y2offset: 10,        // pixel offset of the legend box from the y (or y2) axis.
						},	
						//
						series:[{
									show: true,
									label : 'Посетители',
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : 'Новые посетители',
									showLine: true, 
									showMarker: true
								}]
					});
					// end graf VisitorsNewVisitors	
					// begin graf VisitorsPageView						
					var plot1 = $.jqplot('makayam_Summary_VisitorsPageView', [dataVisitors, dataPageView], {
						title:'',
						//
						axes:{
							xaxis:{
								renderer:$.jqplot.DateAxisRenderer,
								tickOptions:{
								formatString:'%Y-%m-%d'
								} 
							},
							yaxis:{
							  tickOptions:{
								formatString:'%d'
								}
							}
						},
						highlighter: {
							show: true,
							sizeAdjust: 7.5
						},
						legend: {
							show: true,
							location: 'nw',     // compass direction, nw, n, ne, e, se, s, sw, w.
							xoffset: 10,        // pixel offset of the legend box from the x (or x2) axis.
							y2offset: 10,        // pixel offset of the legend box from the y (or y2) axis.
						},	
						//
						series:[{
									show: true,
									label : 'Посетители',
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : 'Просмотры',
									showLine: true, 
									showMarker: true
								}]
					});
					// end graf VisitorsPageView										
				}	
				else if(sStatName == 'Geo')
				{
					var dataGeo = new Array();
					for(key in result.aItems[sStatName]['data'])
					{
						dataGeo.push( [result.aItems[sStatName]['data'][key]['name'], parseInt(result.aItems[sStatName]['data'][key]['visits'])]);													
					}	
					
//
					var plot1 = jQuery.jqplot ('makayam_Geo_Country', [dataGeo], 
					{ 
						seriesDefaults: 
						{
							// Make this a pie chart.
							renderer: jQuery.jqplot.PieRenderer, 
							rendererOptions: 
							{
								// Put data labels on the pie slices.
								// By default, labels show the percentage of the slice.
								showDataLabels: true
							}
						}, 
						legend: { show:true, location: 'ne' }
					});
//					
				}
				else if(sStatName == 'Demography')
				{
					var dataDemographyAge = new Array();
					for(key in result.aItems[sStatName]['data'])
					{
						dataDemographyAge.push( [result.aItems[sStatName]['data'][key]['name'], parseFloat(result.aItems[sStatName]['data'][key]['visits_percent']) ]);
					}
					//
					var plot1 = jQuery.jqplot ('makayam_Demography_Age', [dataDemographyAge], 
					{ 
						seriesDefaults: 
						{
							// Make this a pie chart.
							renderer: jQuery.jqplot.PieRenderer, 
							rendererOptions: 
							{
								// Put data labels on the pie slices.
								// By default, labels show the percentage of the slice.
								showDataLabels: true
							}
						}, 
						legend: { show:true, location: 'ne' }
					});
					//
					var dataDemographySex = [ 
							[ result.aItems[sStatName]['data_gender'][0]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][0]['visits_percent']) ],
							[ result.aItems[sStatName]['data_gender'][1]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][1]['visits_percent']) ]
							
							];	
					var plot1 = jQuery.jqplot ('makayam_Demography_Sex', [dataDemographySex], 
					{ 
						seriesDefaults: 
						{
							// Make this a pie chart.
							renderer: jQuery.jqplot.PieRenderer, 
							rendererOptions: 
							{
								// Put data labels on the pie slices.
								// By default, labels show the percentage of the slice.
								showDataLabels: true
							}
						}, 
						legend: { show:true, location: 'ne' }
					});								
				}	
			}			
		}
		else
		{
			$('#makayam_error').html('Системная ошибка. Обратись к администратору или зайдите позже !');
			$('#makayam_error').fadeIn('slow');
		}		
	});	
	$('#makayam_loader').html('<img src="plugins/makayam/templates/skin/default/images/loader.gif">');	
});
//]]>
</script>
{/literal}