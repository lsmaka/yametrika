<?php

class PluginYametrika_ActionYametrika extends ActionPlugin {

	protected $ya_login = '';
	protected $ya_password = '';
	protected $ya_app_id = '';
	protected $ya_app_password = '';
	protected $ya_token = '';
	protected $ya_counter_id = '';
	protected $ya_update_time;
	protected $ya_stat_time;
	protected $ya_stat_group;
		
    public function Init() {
		$this->Lang_AddLangJs(array(
			'plugin.yametrika.yametrika_error_login',
			'plugin.yametrika.yametrika_error_file_get_contents',
			'plugin.yametrika.yametrika_error_system',
			
			'plugin.yametrika.yametrika_graf_label_date',
			'plugin.yametrika.yametrika_graf_label_visitors',
			'plugin.yametrika.yametrika_graf_label_visits',
			'plugin.yametrika.yametrika_graf_label_page_views',
			'plugin.yametrika.yametrika_graf_label_new_visitors',
			'plugin.yametrika.yametrika_graf_label_country',
			'plugin.yametrika.yametrika_graf_label_age',
			'plugin.yametrika.yametrika_graf_label_visits_percent',
			'plugin.yametrika.yametrika_graf_label_sex',
			
			'plugin.yametrika.yametrika_graf_geo_title',
			'plugin.yametrika.yametrika_graf_age_title',
			'plugin.yametrika.yametrika_graf_sex_title',
		));
        $this->SetDefaultEvent('stat');
    }

    protected function RegisterEvent() 
	{
		$this->AddEvent('stat','EventStat');
		$this->AddEvent('ajax','EventAjax');
    }
	protected function EventStat()
	{
		$this->SetTemplateAction('stat_'.Config::Get('plugin.yametrika.ya_stat_type'));
		
		// jqplot
		if(Config::Get('plugin.yametrika.ya_stat_type') == 'v3')
		{
			//line
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jquery.jqplot.min.js");	
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jqplot.highlighter.min.js");	
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jqplot.dateAxisRenderer.min.js");
			// krug	
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jqplot.pieRenderer.min.js");	
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jqplot.donutRenderer.min.js");	
			
			$this->Viewer_AppendStyle(Plugin::GetTemplatePath(__CLASS__)."css/external/jqplot/jquery.jqplot.css");
			
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/jqplot/jqplot_graf.js");
		}
		else if(Config::Get('plugin.yametrika.ya_stat_type') == 'v1')
		{
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/google/google_graf_v1.js");	
		}
		else if(Config::Get('plugin.yametrika.ya_stat_type') == 'v2')
		{
			$this->Viewer_AppendScript(Plugin::GetTemplatePath(__CLASS__)."js/external/google/google_graf_v2.js");
		}
	}
    protected function EventAjax()
    {
		$this->Viewer_SetResponseAjax('json');
		$this->initYandexData();
		
		//
		if(false === ($this->ya_token = $this->PluginYametrika_Yametrika_YaToken()))
		{
			if(false === ($this->ya_token = $this->PluginYametrika_Yametrika_YaLogin($this->ya_login, $this->ya_password, $this->ya_app_id, $this->ya_app_password, $this->ya_update_time)))
			{
				$this->Viewer_AssignAjax('aItems', $this->PluginYametrika_Yametrika_YaError());
				return;
			}	
		}

		$aMethods = array(
			'/stat/traffic/summary' => 'Summary', 
			'/stat/geo' => 'Geo',
			'/stat/demography/age_gender' => 'Demography'
			);
		list($date1, $date2) = $this->PluginYametrika_Yametrika_YaStatPeriod($this->ya_stat_time);	
		$aParams = array('id' => $this->ya_counter_id, 'date1' => $date1, 'date2' => $date2, 'group' => $this->ya_stat_group);
		
		if(false === ($aResult = $this->PluginYametrika_Yametrika_YaMetrikaQuery($aMethods, $aParams, $this->ya_token, $this->ya_update_time)))
		{
			$this->Viewer_AssignAjax('aItems', $this->PluginYametrika_Yametrika_YaError());
			return;
		}
		$this->Viewer_AssignAjax('aItems', $aResult);
    }
	
	//
	protected function initYandexData()
	{
		$this->ya_login = Config::Get('plugin.yametrika.ya_login');
		$this->ya_password = Config::Get('plugin.yametrika.ya_password');
		$this->ya_app_id = Config::Get('plugin.yametrika.ya_app_id');
		$this->ya_app_password = Config::Get('plugin.yametrika.ya_app_password');
		$this->ya_counter_id = Config::Get('plugin.yametrika.ya_counter_id');
		$this->ya_update_time = Config::Get('plugin.yametrika.ya_update_time');
		$this->ya_stat_time = Config::Get('plugin.yametrika.ya_stat_time');
		$this->ya_stat_group = Config::Get('plugin.yametrika.ya_stat_group');
	}
	//
}
?>
