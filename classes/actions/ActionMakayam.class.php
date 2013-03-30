<?php

class PluginMakayam_ActionMakayam extends ActionPlugin {

	protected $ya_login = '';
	protected $ya_password = '';
	protected $ya_app_id = '';
	protected $ya_app_password = '';
	protected $ya_token = '';
	protected $ya_counter_id = '';
	
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

		$aMethods = array('/stat/traffic/summary' => 'Summary', '/stat/geo' => 'GeoSity');
		$aParams = array('id' => $this->ya_counter_id);
		
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
					$this->Cache_Set( $result, $cache_key );
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
		$this->aResult[$sMethodName] = json_decode($result, true);
	}
	//
}
?>
