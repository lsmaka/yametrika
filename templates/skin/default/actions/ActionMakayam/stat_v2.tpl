{assign var="noSidebar" value=true} 
{include file='header.tpl'}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<center>
	<h4>
		<u>
			{$aLang.plugin.makayam.stat_title}
		</u>
	</h4>
</center>

<div id="makayam" style="width: 100%; text-align: center;"></div>
<div id="makayam_Summary_VisitorsVisits" style="width: 800px; height: 400px;"></div><br/><br/>
<div id="makayam_Summary_VisitorsNewVisitors" style="width: 800px; height: 400px;"></div><br/><br/>
<div id="makayam_Summary_VisitorsPageView" style="width: 800px; height: 400px;"></div><br/>
<div id="makayam_Demography_Age"></div>
<div id="makayam_Demography_Sex"></div>
<div id="makayam_Geo_Country"></div>


<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
      // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['corechart','annotatedtimeline']});
      
      // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawChart);

    function drawChart() 
	{
		var param = {};
		ls.ajax(aRouter['makayam']+'ajax/',param ,function(result)
		{
			if (!result.bStateError)
			{
				$('#makayam').html('');
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
							var re = /(\d{4})(\d{2})(\d{2})/;
							curdate = result.aItems[sStatName]['data'][key]['date']
							var dateArray = re.exec(curdate); 
							//
							dataVisitorsVisits[dataVisitorsVisits.length] = [new Date(dateArray[1], dateArray[2]-1 ,dateArray[3]), parseInt(result.aItems[sStatName]['data'][key]['visitors']), undefined,undefined, parseInt(result.aItems[sStatName]['data'][key]['visits']),undefined,undefined];
							dataVisitorsPageView[dataVisitorsPageView.length] = [new Date(dateArray[1], dateArray[2]-1 ,dateArray[3]), parseInt(result.aItems[sStatName]['data'][key]['visitors']), undefined,undefined, parseInt(result.aItems[sStatName]['data'][key]['page_views']), undefined,undefined];
							dataVisitorsNewVisitors[dataVisitorsNewVisitors.length] = [new Date(dateArray[1], dateArray[2]-1 ,dateArray[3]), parseInt(result.aItems[sStatName]['data'][key]['visitors']), undefined,undefined, parseInt(result.aItems[sStatName]['data'][key]['new_visitors']), undefined,undefined];	
							
							key--;
						}
						
						// visitors  & visits begin	----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('date', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('string', 'data1');
						data.addColumn('string', 'data2');
						data.addColumn('number', 'Визиты');
						data.addColumn('string', 'data4');
						data.addColumn('string', 'data5');
						
						data.addRows(dataVisitorsVisits);

						// Set chart options
						var options = {'dateFormat': 'dd MMMM, yyyy'};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('makayam_Summary_VisitorsVisits'));
						chart.draw(data, options);
						// visitors  & visits end ----------------------------------------------------------------------------------------------------------------------	

						// visitors  & new visitors begin	----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('date', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('string', 'data1');
						data.addColumn('string', 'data2');						
						data.addColumn('number', 'Новые посетители');
						data.addColumn('string', 'data1');
						data.addColumn('string', 'data2');						

						data.addRows(dataVisitorsNewVisitors);

						// Set chart options
						var options = {'dateFormat': 'dd MMMM, yyyy'};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('makayam_Summary_VisitorsNewVisitors'));
						chart.draw(data, options);
						// visitors  & new visitors end ----------------------------------------------------------------------------------------------------------------------							
						
						// visits & page view  begin ----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('date', 'Дата');
						data.addColumn('number', 'Посетители');
						data.addColumn('string', 'data1');
						data.addColumn('string', 'data2');							
						data.addColumn('number', 'Просмотры');
						data.addColumn('string', 'data1');
						data.addColumn('string', 'data2');							

						data.addRows(dataVisitorsPageView);

						// Set chart options
						var options = {'dateFormat': 'dd MMMM, yyyy'};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('makayam_Summary_VisitorsPageView'));
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
				$('#makayam').html('Ошибка получения данных. Пожалуйста обносите страницу !');
			}	
		});
		$('#makayam').html('<img src="plugins/makayam/templates/skin/default/images/loader.gif">');
    }
//]]>
</script>
{/literal}