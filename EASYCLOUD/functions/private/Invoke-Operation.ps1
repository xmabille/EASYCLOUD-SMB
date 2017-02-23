function Invoke-Operation {
            [cmdletbinding()]
            param(
                [switch] $Wait,
                [scriptblock] $Code ={},
                [hashtable] $Parameters,
                 [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [hashtable] $SyncHash,
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $Root,
                 [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $Log
            )
            try {
                if(!$Root){
                    if($SyncHash.Root){
                        $Root = $SyncHash.Root
                    } else {
                        throw "Invalid Root"
                    }
                }
                if(!$Log){
                    if($SyncHash.Log){
                        $Log = $SyncHash.Log
                    } else {
                        throw "Invalid Log"
                    }
                }
                $Runspace = [runspacefactory]::CreateRunspace()
                $Runspace.ApartmentState = "STA"
                $Runspace.ThreadOptions = "ReuseThread"
                $Runspace.Open()
                $Runspace.SessionStateProxy.SetVariable("SyncHash",$SyncHash)
                $Runspace.SessionStateProxy.SetVariable("Code",$Code)
                $Runspace.SessionStateProxy.SetVariable("Parameters",$Parameters)
                $Runspace.SessionStateProxy.SetVariable("Runspace",$Runspace)
                $Runspace.SessionStateProxy.SetVariable("Log",$Log)
                $SyncHash.Root = $Root
                $SyncHash.Log = $Log
                [scriptblock] $_Code = {}
              <#  if($GUI){
                    $_Code = {
                        try{
                            $Code|out-file c:\temp\invoke-operation_GUI.txt
                            $SyncHash.GUI.Dispatcher.invoke(
                                "Render",
                                [action]$Code
                            )
                            $SyncHash.GUI.Dispatcher.invoke(
                                "Render",
                                {}
                            )
                        } catch {
                           
                        }
                    }
                } else { #>
                    $_Code = $Code
                  #  }

                $PSinstance = [powershell]::Create()
                $null = $PSInstance.AddScript({
               <#     . $SyncHash.LogFunction
                    . $SyncHash.OperationFunction
                    . $SyncHash.PopupFunction #>
                      foreach($Item in (get-childitem -Path $SyncHash.Root -Include "*.ps1" -Recurse -Force)){
                    . $Item.FullName
                }
                if(($Log -ne $null) -and ((test-path $Log) -ne $false)){
			
		        } else {
			        $Log = Start-Log
		        }
                $PSDefaultParameterValues = @{"Write-Log:Log"="$Log"}
                  #  . $SyncHash.ClassFunction
                    Register-Classes
                    Set-ModuleVariable
                    
                    }
                )
                $null = $PSInstance.AddScript($_Code)
                $null = $PSInstance.AddScript({
                    $RunSpace.Close()
                    $Runspace.Dispose()
                }
                    
                )
                $PSInstance.Runspace = $Runspace
     
                $job = $null
                if($Wait){
                    $job = $PSinstance.Invoke()
                } else {
                    $job = $PSinstance.BeginInvoke()
                }
                return $job
            } catch {
                 write-log -message "Error while invoking operation: $_" -type Error
            
             }


        }