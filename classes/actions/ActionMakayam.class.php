<?php

class PluginMakayam_ActionMakayam extends ActionPlugin {

	protected $ya_login = '';
	protected $ya_password = '';
	protected $ya_app_id = '';
	protected $ya_app_password = '';
	protected $ya_token = '';
	protected $ya_counter_id = '';
	protected $ya_update_time;
	protected $ya_stat_time;
	protected $ya_stat_group;
	
	protected $aResult = array();
	
    public function Init() {
        $this->SetDefaultEvent('stat');
    }

    protected function RegisterEvent() 
	{
		$this->AddEvent('stat','EventStat');
		$this->AddEvent('ajax','EventAjax');
    }
	protected function EventStat()
	{

	}
    protected function EventAjax()
    {
		$this->Viewer_SetResponseAjax('json');
		$this->initYandexData();

		if(isset($_SESSION['makayam_token']))
		{
			$this->ya_token = $_SESSION['makayam_token'];
		}
		else
		{
			$this->yandexLogin();
		}		

		$aMethods = array(
			'/stat/traffic/summary' => 'Summary', 
			'/stat/geo' => 'Geo',
			'/stat/demography/age_gender' => 'Demography'
			);
		list($date1, $date2) = $this->__makayam_make_date();	
		$aParams = array('id' => $this->ya_counter_id, 'date1' => $date1, 'date2' => $date2, 'group' => $this->ya_stat_group);
		
		$this->yandexMetrikeQuery($aMethods, $aParams);
		$this->Viewer_AssignAjax('aItems',$this->aResult);
    }
	
	//
	protected function initYandexData()
	{
		$this->ya_login = Config::Get('plugin.makayam.ya_login');
		$this->ya_password = Config::Get('plugin.makayam.ya_password');
		$this->ya_app_id = Config::Get('plugin.makayam.ya_app_id');
		$this->ya_app_password = Config::Get('plugin.makayam.ya_app_password');
		$this->ya_counter_id = Config::Get('plugin.makayam.ya_counter_id');
		$this->ya_update_time = Config::Get('plugin.makayam.ya_update_time');
		$this->ya_stat_time = Config::Get('plugin.makayam.ya_stat_time');
		$this->ya_stat_group = Config::Get('plugin.makayam.ya_stat_group');
	}
	//
	protected function yandexLogin() {
		$url = 'https://oauth.yandex.ru/token';
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL,$url); // set url to post to
		curl_setopt($ch, CURLOPT_FAILONERROR, 0);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);// allow redirects
		curl_setopt($ch, CURLOPT_RETURNTRANSFER,1); // return into a variable
		curl_setopt($ch, CURLOPT_TIMEOUT, 9); 
		curl_setopt($ch, CURLOPT_POST, 1); // set POST method
		curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=password&username={$this->ya_login}&password={$this->ya_password}&client_id={$this->ya_app_id}&client_secret={$this->ya_app_password}"); 
		$result = curl_exec($ch); 
		$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		curl_close($ch);  
		
		$result_decode = json_decode($result, true);
		
		$_SESSION['makayam_token'] = $result_decode['access_token'];
		$this->ya_token = $result_decode['access_token'];
		
		return true;
	}
	//
	protected function yandexMetrikeQuery($aMethods, $aParams = array()) 
	{
		foreach($aMethods as $sMethodUrl => $sMethodName)
		{
			$sPath = "http://api-metrika.yandex.ru{$sMethodUrl}.json?";
			
			foreach ($aParams as $key=>$value) 
			{
				$sPath .= "{$key}={$value}&";
			}	
			$sPath .= "oauth_token=".$this->ya_token;
			
			$cache_key = $this->ya_token.'_'.$sMethodUrl;
			$result = '';
			if (false === ($result = $this->Cache_Get( $cache_key ))) 
			{
				if($result = @file_get_contents($sPath)) 
				{
					$this->Cache_Set( $result, $cache_key , array(), $this->ya_update_time);
				}
				else
				{
					unset($_SESSION['makayam_token']);
				}
			}
			$this->ya_success($sMethodName, $result);
		}
		return true;
	}	
	//
	protected function ya_success($sMethodName, $result)
	{
		$aResultOrigin = json_decode($result, true);
		
		// Для тестирования. Завышение показателей. По умолчанию данный файл отсутствует.		
		if (is_file(dirname(__FILE__) . '/bluff.php')) 
		{
			include(dirname(__FILE__) . '/bluff.php');
		}		
		//
		$this->aResult[$sMethodName] = $aResultOrigin;
	}
	//
	protected function __makayam_make_date()
	{
		$date1 = '';
		$date2 = date('Ymd');
		
		if($this->ya_stat_time == 'w')
		{
			$sWeek = 60*60*24*7;
			$date1 = date('Ymd', strtotime($date2) - $sWeek);
		}
		else if($this->ya_stat_time == 'm')
		{
			$sMonth = 60*60*24*30;
			$date1 = date('Ymd', strtotime($date2) - $sMonth);		
		}
		else if($this->ya_stat_time == 'y')
		{
			$date1 = date('Y').'0101';		
		}
		
		return array($date1, $date2);
	}
}
?>
