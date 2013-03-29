{assign var="noSidebar" value='true'} 
{include file='header.tpl'}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<div id="makayam_Summary_VisitorsVisits"></div>
<div id="makayam_Summary_VisitorsPageView"></div>
<div id="makayam_GeoSity_Sity"></div>


<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


{include file='footer.tpl'}

{literal}
<script type="text/javascript">
//<![CDATA[
      // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['corechart']});
      
      // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table, 
      // instantiates the pie chart, passes in the data and
      // draws it.
	function getRandomArbitary(min, max)
	{
		return Math.random() * (max - min) + min;
	}
	  
    function drawChart() 
	{
		var param = {};
		ls.ajax(aRouter['makayam']+'ajax/',param ,function(result)
		{
			if (!result.bStateError)
			{	
				for(sStatName in result.aItems)
				{
					if(sStatName == 'Summary')
					{
						var dataVisitorsVisits = new Array();
						var dataVisitorsPageView = new Array();
						var dataVisitorsNewVisitors = new Array();
						
						for(key in result.aItems[sStatName]['data'])
						{
							dataVisitorsVisits[dataVisitorsVisits.length] = [result.aItems[sStatName]['data'][key]['date'], parseInt(result.aItems[sStatName]['data'][key]['visitors']*getRandomArbitary(1000,2000)), parseInt(result.aItems[sStatName]['data'][key]['visits']*getRandomArbitary(1000,2000))];
							dataVisitorsPageView[dataVisitorsPageView.length] = [result.aItems[sStatName]['data'][key]['date'], parseInt(result.aItems[sStatName]['data'][key]['visitors']*getRandomArbitary(1000,2000)), parseInt(result.aItems[sStatName]['data'][key]['page_views']*getRandomArbitary(1000,2000))];
							dataVisitorsNewVisitors[dataVisitorsNewVisitors.length] = [result.aItems[sStatName]['data'][key]['date'], parseInt(result.aItems[sStatName]['data'][key]['visitors']*getRandomArbitary(1000,2000)), parseInt(result.aItems[sStatName]['data'][key]['new_visitors']*getRandomArbitary(1000,2000))];	
							//dataDepthPageView[dataDepthPageView.length] = [result.aItems[sStatName]['data'][key]['date'], parseInt(result.aItems[sStatName]['data'][key]['depth']), parseInt(result.aItems[sStatName]['data'][key]['page_views'])];						
						}
						// visitors  & visits begin	----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'visitors');
						data.addColumn('number', 'visits');

						data.addRows(dataVisitorsVisits);

						// Set chart options
						var options = {'title':'visitors & visits',
									 'width':800,
									 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsVisits'));
						chart.draw(data, options);
						// visitors  & visits end ----------------------------------------------------------------------------------------------------------------------	

						// visitors  & new visitors begin	----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'visitors');
						data.addColumn('number', 'new visitors');

						data.addRows(dataVisitorsNewVisitors);

						// Set chart options
						var options = {'title':'visitors & new visitors',
									 'width':800,
									 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsVisits'));
						chart.draw(data, options);
						// visitors  & new visitors end ----------------------------------------------------------------------------------------------------------------------							
						
						// visits & page view  begin ----------------------------------------------------------------------------------------------------------------------
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Дата');
						data.addColumn('number', 'visitors');
						data.addColumn('number', 'page_views');

						data.addRows(dataVisitorsPageView);

						// Set chart options
						var options = {'title':'visitors & page_views',
									 'width':800,
									 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.LineChart(document.getElementById('makayam_Summary_VisitorsPageView'));
						chart.draw(data, options);
						// visits & page view end ----------------------------------------------------------------------------------------------------------------------
					}
					else if(sStatName == 'GeoSity')
					{
					
						var dataGeoSity = new Array();
						for(key in result.aItems[sStatName]['data'])
						{
							dataGeoSity[dataGeoSity.length] = [result.aItems[sStatName]['data'][key]['name'], parseInt(result.aItems[sStatName]['data'][key]['visits'])];													
						}
						// visits & visitors begin	
						var data = new google.visualization.DataTable();
						data.addColumn('string', 'Country');
						data.addColumn('number', 'visits');

						data.addRows(dataGeoSity);

						// Set chart options
						var options = {'title':'Country & visits',
									 'width':800,
									 'height':400};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.PieChart(document.getElementById('makayam_GeoSity_Sity'));
						chart.draw(data, options);					
					}
				}
			}
			else
			{
				$('#makayam').html('no data');
			}	
		});
		$('#makayam').html('Производиться загрузка данных... ожидайте');
    }
//]]>
</script>
{/literal}