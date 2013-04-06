function drawChart_v3()
{
	var param = {};
	ls.ajax(aRouter['yametrika']+'ajax/',param ,function(result)
	{
		if (!result.bStateError)
		{
			$('#yametrika_loader').html('');

			$('#yametrika_header').fadeIn('slow');	
			
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
					var plot1 = $.jqplot('yametrika_Summary_VisitorsVisits', [dataVisitors, dataVisits], {
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
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'),
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_visits'),
									showLine: true, 
									showMarker: true
								}]
					});
					// end graf VisitorsVisits
					// begin graf VisitorsNewVisitors						
					var plot1 = $.jqplot('yametrika_Summary_VisitorsNewVisitors', [dataVisitors, dataNewVisitors], {
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
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'),
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_new_visitors'),
									showLine: true, 
									showMarker: true
								}]
					});
					// end graf VisitorsNewVisitors	
					// begin graf VisitorsPageView						
					var plot1 = $.jqplot('yametrika_Summary_VisitorsPageView', [dataVisitors, dataPageView], {
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
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'),
									showLine: true, 
									showMarker: true
								}, 
								{
									show: true,
									label : ls.lang.get('plugin.yametrika.yametrika_graf_label_page_views'),
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
					var plot1 = jQuery.jqplot ('yametrika_Geo_Country', [dataGeo], 
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
					var plot1 = jQuery.jqplot ('yametrika_Demography_Age', [dataDemographyAge], 
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
					var plot1 = jQuery.jqplot ('yametrika_Demography_Sex', [dataDemographySex], 
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
			$('#yametrika_error').html(ls.lang.get('plugin.yametrika.yametrika_error_system'));
			$('#yametrika_error').fadeIn('slow');
		}		
	});	
	$('#yametrika_loader').html('<img src="'+DIR_WEB_ROOT+'/plugins/yametrika/templates/skin/default/images/loader.gif">');	
}