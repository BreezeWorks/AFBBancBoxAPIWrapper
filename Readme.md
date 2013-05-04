# Objective-C library wrapper for the BancBox REST API #
BancBox offers an API-driven approach to enabling developers to offer banking services in their applications.
The AFBBancBoxAPIWrapper library encapsulates the BancBox REST API to simplify managing clients, accounts, and transactions.

# Requirements #

* AFNetworking
* Kiwi (for testing)

# Documentation #
__AFBBancBoxAPIWrapper/AFBBancBoxConnection.h__ contains abbreviated information on the BancBox API along with the corresponding methods. Full API documentation can be found on the [BancBox API documentation](http://www.bancbox.com/api/index) pages.

# Getting it #
Clone the GIT repo and drag the AFBBancBoxAPIWrapper.xcodeproj file into your project. At a minimum you will need to import AFBBancBoxConnection.h; import other headers as needed for access to the wrapper classes for clients, account, payments, and so on.

# Contributors #

AFBBancBoxAPIWrapper was written by Adam Block.

# License #
Copyright (c) 2013 Adam Block

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