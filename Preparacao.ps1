#############
#  Funções  #
#############
function Tirar-Foto($nomeSessao, [switch]$erro){

	if (!$nomeSessao)
	{
		return;
	}
	else
	{
		$imgDir = $PathDir + "`\img`\";
		[String]$dataHora = Get-Date -UFormat "%Y-%m-%d_%H-%M-%S";
		
		if($erro){
			[String]$LocalNome = -join ($imgDir,"_ERRO_",$dataHora,"_",$PORTAL,"_",$nomeSessao,".png")
		}
		else{
			[String]$LocalNome = -join ($imgDir,$dataHora,"_",$PORTAL,"_",$nomeSessao,".png")
		}
		$Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($script:ChromeDriver);
		$Screenshot.SaveAsFile($LocalNome, $script:ImageFormat);
	}
};

function Teste-Saida($retorno, $nomeSessao){

	if($retorno -ne 0)
	{
		Tirar-Foto "$nomeSessao" -erro;
		write-host "Erro: ($retorno). Abortando...";
		Pause;
		Parar-Driver;
		exit $retorno;
	}

}

function Esperar-Elemento($localizador, $tempoEmSegundos, $nomeSessao, [switch]$byClassName,[switch]$byName,[switch]$byCssSelector,[switch]$byXPath,[switch]$noTry){

    $webDriverWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($script:ChromeDriver, (New-TimeSpan -Seconds $tempoEmSegundos))	

    if(!$noTry){
	    Try{
		
	
            if($byClassName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::ClassName($localizador)))

            }elseif($byName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Name($localizador))) 

            }elseif($byXPath){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::XPath($localizador))) 

            }elseif($byCssSelector){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::CssSelector($localizador))) 

            }else{

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Id($localizador)))

            }
            return;
        }catch [System.Management.Automation.MethodInvocationException]{
            write-host "Tempo de espera pelo $localizador expirou";
		
		    Testar-Saida 1 "$nomeSessao_$localizador";
		
        }catch {
            write-host "O Selenium Wait não foi carregado corretamente, verifique o destino ou se a dll está no local adequado.";
		
		    Testar-Saida 12 "$nomeSessao";
        }

    }else
    {
        if($byClassName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::ClassName($localizador)))
            
            }elseif($byName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Name($localizador))) 
            
            }elseif($byXPath){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::XPath($localizador))) 
            
            }elseif($byCssSelector){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::CssSelector($localizador))) 
            
            }else{

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Id($localizador)))
           
            }
            
            return;
    }

};

function Procurar-Elemento($localizador, $tempoEmSegundos, $nomeSessao, [switch]$byClassName,[switch]$byName,[switch]$byCssSelector,[switch]$byXPath,[switch]$noTry){

    if(!$noTry){

	    Try{
	
            if($byClassName){

                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao -byClassName;

                return $script:ChromeDriver.findElementsbyClassName($localizador);

            }elseif($byName){

                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao -byName;

                return $script:ChromeDriver.findElementByName($localizador);

            }elseif($byXPath){
   
                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao -byXPath;

                return $script:ChromeDriver.findElementsByXPath($localizador);

            }elseif($byCssSelector){
                
                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao -byCssSelector;

                return $script:ChromeDriver.findElementsByCssSelector($localizador);

            }else{
                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao;

                return $script:ChromeDriver.findElementById($localizador);
            }

        }catch{
            write-host "Não foi possível encontrar o objeto referente ao $localizador.";
		
		    Testar-Saida 1 "$nomeSessao";
        }

    }else{

        if($byClassName){

                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao  -byClassName -noTry;

                return $script:ChromeDriver.findElementbyClassName($localizador);

            }elseif($byName){

                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao  -byName -noTry;

                return $script:ChromeDriver.findElementByName($localizador);

            }elseif($byXPath){
   
                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao  -byXPath -noTry;

                return $script:ChromeDriver.findElementByXPath($localizador);

            }elseif($byCssSelector){
                
                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao  -byCssSelector -noTry;

                return $script:ChromeDriver.findElementByCssSelector($localizador);

            }else{

                Esperar-Elemento $localizador $tempoEmSegundos $nomeSessao -noTry;

                return $script:ChromeDriver.findElementById($localizador);
            }
    }

};


function Esperar-Texto($localizador,$valorEsperado, $tempoEmSegundos, $nomeSessao, [switch]$byClassName,[switch]$byName,[switch]$byXPath,[switch]$noTry){
	
    $webDriverWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($script:ChromeDriver, (New-TimeSpan -Seconds $tempoEmSegundos))
    
    if(!$noTry){

	    Try{
	
            if($byClassName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::ClassName($localizador), $valorEsperado))
            
            }elseif($byName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::Name($localizador), $valorEsperado)) 
            
            }elseif($byXPath){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::XPath($localizador), $valorEsperado)) 
            
            }else{

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::Id($localizador), $valorEsperado))
            
            }

            return;

        }catch [System.Management.Automation.MethodInvocationException]{
            write-host "Tempo de espera pelo valor $valorEsperado expirou";
		
		    Testar-Saida 1 "$nomeSessao";
		
        }catch {
            write-host "O Selenium Wait não foi carregado corretamente, verifique o destino ou se a dll está no local adequado.";
		
		    Testar-Saida 12 "$nomeSessao";
        }

    }else
    {
    
        if($byClassName){
                
                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::ClassName($localizador), $valorEsperado))
            
            }elseif($byName){

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::Name($localizador), $valorEsperado)) 
            
            }elseif($byXPath){

                
                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::XPath($localizador), $valorEsperado)) 
            }else{

                $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::textToBePresentInElementLocated( [OpenQA.Selenium.by]::Id($localizador), $valorEsperado))
            
            }
            return;
    }
};

function Trocar-Pagina ($idPag, $script){

    $script:ChromeDriver.SwitchTo().DefaultContent() | Out-Null;

    Esperar-Elemento "menuPrincipal" 5 $idPag;

    $script:ChromeDriver.ExecuteScript($script)  | Out-Null;

    Esperar-Elemento "conteudo" 5 $idPag;

    $script:ChromeDriver.SwitchTo().frame("conteudo") | Out-Null;
}

function Parar-Driver (){

    Write-Host "Parando Sistema...";

    $ChromeDriver.Manage().Cookies.DeleteAllCookies()

    Start-Sleep -Seconds 2;

    #Esperar-Elemento "//settings-ui" 10 "limpar-cache" -byXPath;

    Function Stop-ChromeDriver {Get-Process -Name chromedriver -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue};

    $ChromeDriver.Close();

    $ChromeDriver.Quit() ;

    Stop-ChromeDriver;

    Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); Clear-Host

}

#############
# Preparação#
#############



Try{
	#$PathDir = "$PSScriptRoot";

	$WebDriverPath = "$PathDir\Lib\WebDriver\lib\net45\WebDriver.dll" ;

	Unblock-File $WebDriverPath -ErrorAction Stop;

	Add-Type -path $WebDriverPath -ErrorAction Stop;

	$WebDriverSupportPath = "$PathDir\Lib\WebDriver.Support\lib\net45\WebDriver.Support.dll";

	Unblock-File $WebDriverSupportPath -ErrorAction Stop;

	Add-Type -path $WebDriverSupportPath -ErrorAction Stop;

	$env:PATH += ";$PathDir";

	[OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png;
}catch{
	write-host "Falha ao carregar DLLS, verifique se os arquivos estão no diretório correto."
	
	Testar-Saida 13;
}

#[iniciando-headless-mode]##################################################

Try{

	$chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions;

	#$chromeOptions.addArguments('headless');

	#$chromeOptions.addArguments('window-size=1920,1080');

	$chromeOptions.addArguments("user-data-dir=C:\Users\$env:username\AppData\Local\Google\Chrome\User Data\Default");

    $chromeOptions.addArguments([System.Collections.Generic.List[string]]@(<#'--allow-running-insecure-content', '--disable-infobars', '--enable-automation', '--kiosk',#> "--lang=${locale}","--ignore-certificate-errors", "--ignore-ssl-errors=yes", "--disable-logging"))

    #$chromeOptions.AddUserProfilePreference('credentials_enable_service', $false)

    #$chromeOptions.AddUserProfilePreference('profile.password_manager_enabled', $false)

}catch{

	Write-Host "Houve uma falha ao carregar e/ou configurar o chrome headless... ";
	
	Testar-Saida 11;

}

##########################################################################

Try{
	$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeOptions);

	$Login = "$PathDir\Login.txt";

	$id = Get-Content $Login | Select -Index 0 -ErrorAction Stop;

	$username = Get-Content $Login | Select -Index 1 -ErrorAction Stop;

	$PassWordFile = get-content $Login | Select -Index 2 -ErrorAction Stop;

	$keyFile = get-content $Login | select -Index 3 -ErrorAction Stop;

	$key = Get-Content $KeyFile -ErrorAction Stop;

	$Credencial = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (Get-Content $PasswordFile |ConvertTo-SecureString -key $key) -ErrorAction Stop;

	$Credencial | Add-Member -NotePropertyName id -NotePropertyValue $id -ErrorAction Stop;

	$Credencial;

}catch [System.Management.Automation.PSArgumentException]{
	write-host "O chromeDriver não foi iniciado corretamente, verifique o destino ou se a dll está no local adequado...";
	
	Testar-Saida 10;
}catch [System.Management.Automation.ItemNotFoundException]{
	write-host "O arquivo para leitura das credenciais não foi encontrado...";
	
	Testar-Saida 2;
}catch [System.Management.Automation.MethodInvocationException]{
	write-host "A versão do chrome e chromedriver são imcompatíveis...";
	
	Testar-Saida 6;

}<#catch [System.Management.Automation.ParameterBindingValidationException]{
	write-host "A variável de credencial não foi criada corretamente..."
	
	Testar-Saida 3;
}#>




#[Saidas-de-erros]###########################################################
# 
# [1]: O objeto referente ao ID ou valor não foi encontrado.
# [2]: Não foi encontrado nenhum arquivo no destino (falha de leitura).
# [3]: Variável mal definida.
# [4]: Usuario ou senha errados.
# [5]: O teste não se comportou como esperado.
# [6]: Chromedrive imcompatível com a versão do navegador chrome
# [7]:
# [8]:
# [9]:
# [10]: O ChromeDriver wait não foi configurado corretamente.
# [11]: O Chrome headless não foi configurado ou carregado corretamente.
# [12]: O Selenium Wait não foi configurado corretamente.
# [13]: Falha ao carregar DLLs.
# [14]: Não foi possível encontrar o objeto referente ao $localizador.
# [15]:
#
#
#
#
#
#
#
#
##############################################################################


















#############
#  Features #
#############
#
############### Screenshot ######################
#
#$ss = $ChromeDriver.GetScreenshot()
#$b64      = $ss.AsBase64EncodedString
#$ArqImg = 'C:\Local\Para\Arquivo'
#
#$bytes = [Convert]::FromBase64String($b64)
#[IO.File]::WriteAllBytes($ArqImg, $bytes)
#
#
#
################ Screenshot 2 (atualmente utilizado) ######################
#
#[OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png
#
#$Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($ChromeDriver)
#$Screenshot.SaveAsFile("$PathDir\img\Selenium-Headless#1.png", $ImageFormat)
#
#################### ETC ###########################
#
#comandos uteis para chrome options: --disable-gpu --headless --window-size=1280,1696
#$seleniumOptions.AddArguments(@('--start-maximized', '--allow-running-insecure-content', '--disable-infobars', '--enable-automation', '--kiosk', "--lang=$language"))
#
#################################################
#$chromeOptions.addArguments("user-data-dir=C:\Users\thalys\AppData\Local\Google\Chrome\User Data\Default")
#
#
#
#
#comandos uteis para chrome options: --disable-gpu --headless --window-size=1280,1696
#$seleniumOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
#
#$language = "pt-BR"
#
#
#$seleniumOptions.AddArguments(@('--headless', '--disable-gpu', '--window-size=800,600', '--allow-running-insecure-content', '--disable-infobars', '--enable-automation', "--lang=$language")) 
#
#$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
#$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#$env:LC_ALL='C.UTF-8'



#$ChromeDriver.navigate().GoToUrl('chrome://settings/clearBrowserData');
#$ChromeDriver.FindElementByXPath("//settings-ui").sendkeys([OpenQA.Selenium.Keys]::Enter)