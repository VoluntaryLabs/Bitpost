
About Bitpost
==========

Bitpost is a user friendly Bitmessage client for OSX. 

The official website for the project is:
* http://voluntary.net/bitpost


What's Bitmessage?
--------------------------

Bitmessage is a decentralized messaging system. Instead of connecting to centralized servers (like Facebook, gmail, etc) or federated servers (like email, IRC, Jabber), when you run a Bitmessage client it connects to other clients directly forming a network which can relay messages with no central control. 

Your address is a public encryption key that others can use to encrypt messages to you in a way that only you can decrypt. Messages are sent to the network over Tor (another decentralized network that hides the source of network requests) in order to conceal the location of the sender.

Bitmessage adopts some standards from Bitcoin such as sharing a similar binary protocol, similar node discovery and message sharing systems, and address format but it has no "blockchain". Messages are simply shared between nodes and cached for two days before being deleted (though your client will keep any messages sent to you).

For more info see:

* https://bitmessage.org


Tech details
-----------------
The UI launches a local pybitmessage node in the background which uses Tor to connect to the Bitmessage network. 

The local bitmessage node is run with custom node and API ports so it doesn't interfere with other bitmessage clients. The app uses it's own bitmessage keys.dat file for the app which is stored in ~/Library/Application Support/Bitpost. 


Importing keys
------------------

Dropping in your current bitmessage-qt keys.dat file may not work as the .dat file format changes between pybitmessage releases. You may be able to import a key pair by:

* making sure the Bitpost app is not running
* make a backup copy of the Bitpost keys.dat
* open the Bitpost keys.dat and copy in your identity key pair
* close the keys.dat file and try starting Bitpost

If this doesn't work, replace the Bitpost keys.dat file with the backup copy.


Compiling
-------------

In the same folder that you put this project's folder, 
you'll need to clone the following repos:

* git clone https://github.com/stevedekorte/BitmessageKit.git
* git clone https://github.com/stevedekorte/NavKit.git
* git clone https://github.com/stevedekorte/NavNodeKit.git
* git clone  https://github.com/stevedekorte/FoundationCategoriesKit.git

After they've been cloned, the app should build. Note: the BitmessageKit comes with some precompiled binaries for tor, and static-python. You'll want to download and build those yourself if you're verifying the build. 


License
----------

The code is open source under an MIT license. 


Contributing
---------------

We would welcome your contributions.


Credits 
---------

* Chris Robinson - Designer
* Steve Dekorte - Lead & UI Developer
* Adam Thorsen - Generalist (Tor and Python intergration)
* Dru Nelson - Unix Guru





