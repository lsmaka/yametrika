{assign var="noSidebar" value=true} 
{include file='header.tpl'}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>

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
<div id="makayam_Summary_VisitorsVisits"></div>
<div id="makayam_Summary_VisitorsNewVisitors"></div>
<div id="makayam_Summary_VisitorsPageView"></div>
<div id="makayam_Demography_Age"></div>
<div id="makayam_Demography_Sex"></div>
<div id="makayam_Geo_Country"></div>


<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
      // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['corechart']});
      
      // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawChart);

    function drawChart() 
	{
		var param = {};
		ls.ajax(aRouter['makayam']+'ajax/',param ,function(result)
		{
			if (!result.bStateError)
			{
				$('#makayam_loader').html('');
				
				if(result.aItems == 'login_error')
				{
					$('#makayam_error').html('Не могу соединиться с Yandex Метрикой. Обратитесь к администратору системы.');
					$('#makayam_error').fadeIn('slow');
					return;
				}
				else if(result.aItems == 'file_get_contents_error')
				{
					$('#makayam_error').html('Не могу получить данные. Попробуйте обновить страницу.');
					$('#makayam_error').fadeIn('slow');
					return;
				}	
				
				$('#makayam_header').fadeIn('slow');
				
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
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('number', 'Визиты');
									
						data.addRows(dataVisitorsVisits);

						// Set chart options
						var options = {
							curveType: "function",  
							'width':800, 'height':400,
							legend: {position: 'top'},
							pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
							};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsVisits'));
						chart.draw(data, options);
						// visitors  & visits end ----------------------------------------------------------------------------------------------------------------------	

						// visitors  & new visitors begin	----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('number', 'Новые посетители');

						data.addRows(dataVisitorsNewVisitors);

						// Set chart options
						var options = {
							curveType: "function",  
							'width':800, 'height':400,
							legend: {position: 'top'},
							pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
							};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsNewVisitors'));
						chart.draw(data, options);
						// visitors  & new visitors end ----------------------------------------------------------------------------------------------------------------------							
						
						// visits & page view  begin ----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('number', 'Просмотры');

						data.addRows(dataVisitorsPageView);

						// Set chart options
						var options = {
							curveType: "function",  
							'width':800, 'height':400,
							legend: {position: 'top'},
							pointSize: 5, hAxis: {textStyle: {fontSize: 9}}
							};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsPageView'));
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
						data.addColumn('string', 'Страны');
						data.addColumn('number', 'Визиты');

						data.addRows(dataGeo);

						// Set chart options
						var options = {'title':'Распределение по странам', 'width':800, 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.PieChart(document.getElementById('makayam_Geo_Country'));
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
						data.addColumn('string', 'Возраст');
						data.addColumn('number', 'Доля визитов');

						data.addRows(dataDemographyAge);

						// Set chart options
						var options = {'title':'Распределение по возрасту', 'width':800, 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.PieChart(document.getElementById('makayam_Demography_Age'));
						chart.draw(data, options);		
						
					//
					//
						var dataDemographySex = [ 
							[ result.aItems[sStatName]['data_gender'][0]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][0]['visits_percent']) ],
							[ result.aItems[sStatName]['data_gender'][1]['name'] , parseFloat(result.aItems[sStatName]['data_gender'][1]['visits_percent']) ]
							
							];	
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Пол');
						data.addColumn('number', 'Доля визитов');	
						data.addRows(dataDemographySex);
						
						var options = {'title':'Распределение по полу', 'width':800, 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.PieChart(document.getElementById('makayam_Demography_Sex'));
						chart.draw(data, options);
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
    }
//]]>
</script>
{/literal}