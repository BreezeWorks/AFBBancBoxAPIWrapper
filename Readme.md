# Objective-C library wrapper for the BancBox REST API #
BancBox offers an API-driven approach to enabling developers to offer banking services in their applications.
The AFBBancBoxAPIWrapper library encapsulates the BancBox REST API to simplify managing clients, accounts, and transactions.

# Requirements #

* AFNetworking
* Kiwi (for testing)

# Documentation #
__AFBBancBoxAPIWrapper/AFBBancBoxConnection.h__ contains abbreviated information on the BancBox API along with the corresponding methods. Full API documentation can be found on the [BancBox API documentation](http://www.bancbox.com/api/index) pages.

# Getting it #
Clone the GIT repo and drag the AFBBancBoxAPIWrapper.xcodeproj file into your project.

# Usage #
The BancBox authentication information (API key, API secret, and subscriber ID) must be added as defines into the file __AFBBancBoxAPIWrapper/AFBBancBoxPrivateAuthenticationItems.h__. This file is included in the .gitignore so your auth data doesn't get committed to the repo. The format of the defines is as follows:

```
// replace with your BancBox API key
#define BANCBOX_API_KEY @"apikey363732"

// replace with your BancBox API secret
#define BANCBOX_API_SECRET @"apisecret2727222"

// replace with your BancBox subscriber ID
#define BANCBOX_SUBSCRIBER_ID 000000
```

To use the library, at a minimum you will need to import __AFBBancBoxConnection.h__; import other headers as needed for access to the wrapper classes for clients, account, payments, and so on.

The library is set to use the BancBox sandbox server by default. To run against the product server, change the define line near the top of __AFBBancBoxConnection.h__.

# Tests #
A series of Kiwi integration test specs can be found in __Example/AFBBancBoxAPIWrapperTests__. The asynchronous nature of the BancBox API calls makes the tests more verbose than usual.

A private (gitignored) header file containing external bank/credit card/Paypal information is required to test the account creation routines. This file is called __AFBBancBoxPrivateExternalAccountData.h__ and must be visible to XCode for importing into specs. Its format is as follows:

```
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID @"gandalf@balrog.org"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID_2 @"tomb@withywindle.come"

#define BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER @"111000222"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER @"4444333222"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME @"Peregrin Took"

#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_NUMBER @"5544332299887766"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_EXPIRY_DATE @"09/09"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_TYPE @"MASTERCARD"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_NAME @"Sam Gamgee"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_CVV @"000"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ADDRESS_LINE1 @"100 Main St"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ADDRESS_CITY @"San Francisco"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ZIPCODE @"94100"
#define BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_STATE @"CA"
```

# Contributors #
AFBBancBoxAPIWrapper was written by Adam Block.

# License #
*All BancBox code and documentation is copyright (c) 2013 bancboxcrowd.com. All Rights Reserved.*

AFBBancBoxAPIWrapper is copyright (c) 2013 Adam Block

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.