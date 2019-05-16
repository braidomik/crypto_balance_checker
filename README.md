Coinbase Balance Checker
========================

![](https://img.shields.io/badge/language-Powershell-blue.svg) ![](https://img.shields.io/badge/buld-passing-brightgreen.svg)

The current version of Coinbase Balance Checker is **3.0**

Retrieve current price and wallet amount of cryptocurrencies from Coinbase account and coinbase API.
See Coinbase API documentation here: https://developers.coinbase.com/api/v2.

Installation
------------

From a ZIP file:

* Download the latest version of **Coinbase Balance Checker**
* Unzip anywhere

From a GIT repository:

* Clone repository with <b>git clone https://github.com/braidomik/crypto_balance_checker.git folder</b> command

After download:

* Run .\crypto_balance_checker.ps1 -api_key 1234567890abcdef -secret_key 1234567890abcdefghijklmnopqrstuv -basecurrency EUR -cryptos "BTC", "ETH", "LTC", "BCH"

Configuration
-------------

Simply change **api_key**, **secret_key** and **basecurrency** (to the default currency of your account) before running cryptobalance.ps1.
To create API and SECRET key go to your account preferences in Coinbase and follow the procedure.

Requirements
-------------

Powershell and Windows 7 at least.
