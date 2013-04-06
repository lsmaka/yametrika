function drawChart_v1() 
{
	var param = {};
	ls.ajax(aRouter['yametrika']+'ajax/',param ,function(result)
	{
		if (!result.bStateError)
		{
			$('#yametrika_loader').html('');
			
			if(result.aItems == 'login_error')
			{
				$('#yametrika_error').html(ls.lang.get('plugin.yametrika.yametrika_error_login'));
				$('#yametrika_error').fadeIn('slow');
				return;
			}
			else if(result.aItems == 'file_get_contents_error')
			{
				$('#yametrika_error').html(ls.lang.get('plugin.yametrika.yametrika_error_file_get_contents'));
				$('#yametrika_error').fadeIn('slow');
				return;
			}	
			
			$('#yametrika_header').fadeIn('slow');
			
			for(sStatName in result.aItems)
			{
				if(sStatName == 'Summary')
				{
					var dataVisitorsVisits = new Array();
					var dataVisitorsPageView = new Array();
					var dataVisitorsNewVisitors = new Array();
					
					//for(key in result.aItems[sStatName]['data'])
					var key = result.aItems[sStatName]['data'].length-1;
					while(key >= 0)
					{
						//
						var re = /(\d{2})(\d{2})(\d{2})(\d{2})/;
						curdate = result.aItems[sStatName]['data'][key]['date'];
						var newdata = curdate.replace(re, "$4.$3.$2");
						//
						dataVisitorsVisits[dataVisitorsVisits.length] = [newdata, parseInt(result.aItems[sStatName]['data'][key]['visitors']), parseInt(result.aItems[sStatName]['data'][key]['visits'])];
						dataVisitorsPageView[dataVisitorsPageView.length] = [newdata, parseInt(result.aItems[sStatName]['data'][key]['visitors']), parseInt(result.aItems[sStatName]['data'][key]['page_views'])];
						dataVisitorsNewVisitors[dataVisitorsNewVisitors.length] = [newdata, parseInt(result.aItems[sStatName]['data'][key]['visitors']), parseInt(result.aItems[sStatName]['data'][key]['new_visitors'])];	
						
						key--;
					}
					
					// visitors  & visits begin	----------------------------------------------------------------------------------------------------------------------
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_date'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visits'));
								
					data.addRows(dataVisitorsVisits);

					// Set chart options
					var options = {
						curveType: "function",  
						//'width':800, 'height':400,
						legend: {position: 'top'},
						pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
						};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.LineChart(document.getElementById('yametrika_Summary_VisitorsVisits'));
					chart.draw(data, options);
					// visitors  & visits end ----------------------------------------------------------------------------------------------------------------------	

					// visitors  & new visitors begin	----------------------------------------------------------------------------------------------------------------------
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_date'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_new_visitors'));

					data.addRows(dataVisitorsNewVisitors);

					// Set chart options
					var options = {
						curveType: "function",  
						//'width':800, 'height':400,
						legend: {position: 'top'},
						pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
						};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.LineChart(document.getElementById('yametrika_Summary_VisitorsNewVisitors'));
					chart.draw(data, options);
					// visitors  & new visitors end ----------------------------------------------------------------------------------------------------------------------							
					
					// visits & page view  begin ----------------------------------------------------------------------------------------------------------------------
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_date'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visitors'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_page_views'));

					data.addRows(dataVisitorsPageView);

					// Set chart options
					var options = {
						curveType: "function",  
						//'width':800, 'height':400,
						legend: {position: 'top'},
						pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
						};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.LineChart(document.getElementById('yametrika_Summary_VisitorsPageView'));
					chart.draw(data, options);
					// visits & page view end ----------------------------------------------------------------------------------------------------------------------
				}
				else if(sStatName == 'Geo')
				{
					var dataGeo = new Array();
					for(key in result.aItems[sStatName]['data'])
					{
						dataGeo[dataGeo.length] = [result.aItems[sStatName]['data'][key]['name'], parseInt(result.aItems[sStatName]['data'][key]['visits'])];													
					}
					// visits & visitors begin	
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_country'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visits'));

					data.addRows(dataGeo);

					// Set chart options
					var options = {'title':ls.lang.get('plugin.yametrika.yametrika_graf_geo_title')};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.PieChart(document.getElementById('yametrika_Geo_Country'));
					chart.draw(data, options);					
				}
				else if(sStatName == 'Demography')
				{
					var dataDemographyAge = new Array();
					for(key in result.aItems[sStatName]['data'])
					{
						dataDemographyAge[dataDemographyAge.length] = [result.aItems[sStatName]['data'][key]['name'], parseFloat(result.aItems[sStatName]['data'][key]['visits_percent']) ];
					}
					// visits & visitors begin	
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_age'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visits_percent'));

					data.addRows(dataDemographyAge);

					// Set chart options
					var options = {'title':ls.lang.get('plugin.yametrika.yametrika_graf_age_title')};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.PieChart(document.getElementById('yametrika_Demography_Age'));
					chart.draw(data, options);		
					
				//
				//
					var dataDemographySex = [ 
						[ result.aItems[sStatName]['data_gender'][0]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][0]['visits_percent']) ],
						[ result.aItems[sStatName]['data_gender'][1]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][1]['visits_percent']) ]
						
						];	
					var data = new google.visualization.DataTable();
					data.addColumn('string', ls.lang.get('plugin.yametrika.yametrika_graf_label_sex'));
					data.addColumn('number', ls.lang.get('plugin.yametrika.yametrika_graf_label_visits_percent'));	
					data.addRows(dataDemographySex);
					
					var options = {'title':ls.lang.get('plugin.yametrika.yametrika_graf_sex_title')};

					// Instantiate and draw our chart, passing in some options.
					var chart = new google.visualization.PieChart(document.getElementById('yametrika_Demography_Sex'));
					chart.draw(data, options);
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