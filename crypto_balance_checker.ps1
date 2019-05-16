<#
.SYNOPSIS 
Retrieve current price and wallet amount of cryptocurrencies from Coinbase account and coinbase API.
See Coinbase API documentation here: https://developers.coinbase.com/api/v2.
REQUIREMENTS: Powershell and Windows 7 at least.
Simply change api_key, secret_key and basecurrency (to the default currency of your account) before running cryptobalance.ps1.
To create API and SECRET key go to your account preferences in Coinbase and follow the procedure.

.EXAMPLE
Run .\crypto_balance_checker.ps1 -api_key 1234567890abcdef -secret_key 1234567890abcdefghijklmnopqrstuv -basecurrency EUR -cryptos "BTC", "ETH", "LTC", "BCH"

.NOTES 
Name: bitbalance.ps1
Author: Marco Braidotti 
Version History 
    3.0 - 21/02/2018
#>

Param(
    [Parameter(Mandatory=$true)][String] $api_key = '',  #change with your api key generated on your Coinbase account settings API section
    [Parameter(Mandatory=$true)][String] $secret_key = '', #change with your secret key generated on your Coinbase account settings API section
    [String] $basecurrency = 'EUR', #change with your desired fiat currency
    [String[]] $cryptos = @("BTC", "ETH", "LTC", "BCH", "XRP") #change with your desired criptos
    )

try {

    $totalbalance = 0

    foreach ($crypto in $cryptos) {

        $urlAPICryptoPrice = 'https://api.coinbase.com/v2/prices/' + $crypto + '-' + $basecurrency + '/spot'
        $CryptoPrice = ((Invoke-WebRequest $urlAPICryptoPrice | ConvertFrom-Json).data).amount

        $accounts = 'https://api.coinbase.com/v2/accounts'
        $time = 'https://api.coinbase.com/v2/time'
        $epochtime = [string]((Invoke-WebRequest $time | ConvertFrom-Json).data).epoch

        $method = 'GET'
        $requestpath = '/v2/accounts'

        $sign = $epochtime + $method + $requestpath
        $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $hmacsha.key = [Text.Encoding]::UTF8.GetBytes($secret_key)
        $computeSha = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($sign))

        $signature = ([System.BitConverter]::ToString($computeSha) -replace "-").ToLower()

        $header = @{
            "CB-ACCESS-SIGN"      = $signature
            "CB-ACCESS-TIMESTAMP" = $epochtime
            "CB-ACCESS-KEY"       = $api_key
        }

        $result = Invoke-WebRequest $accounts -Headers $header -Method Get -ContentType "application/json"
        $wallets = $result.Content | ConvertFrom-Json


        foreach ($wallet in $wallets.data.balance) {
            if ($wallet.currency -eq $crypto) {
                $total = [math]::Round([Double]$wallet.amount * $CryptoPrice, 2)
            }
        }

        $totalbalance += $total
        Write-Host $crypto "Current Price:" $CryptoPrice $basecurrency "- Wallet Amount:" $total $basecurrency -ForegroundColor Yellow

    }
    $totalfiat = (((Invoke-WebRequest $accounts -Headers $header -Method Get -ContentType "application/json").Content | ConvertFrom-Json).data | Where-Object {$_.type -match 'fiat'  } | Select-Object balance).balance.amount
    write-host "Fiat Total Amount:" $totalfiat $basecurrency -ForegroundColor Yellow

    $amount = $totalbalance + $totalfiat
    write-host "Wallet Total Amount:" $amount $basecurrency -ForegroundColor Green

}
catch [Exception] {
    Write-Host $_.Exception.Message
    exit
}