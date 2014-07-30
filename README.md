
About
--------

This is a project to create a user friendly Bitmessage client for OSX.


How it works
-----------------
The UI launches a local pybitmessage node in the background which uses Tor to connect to the Bitmessage network. 

The local bitmessage node is run with custom node and API ports so it does not interfere with other bitmessage clients. The app uses it's own bitmessage keys.dat file for the app which is stored in ~/Library/Application Support/Bitpost. 

Importing keys from Bitmessage-QT
---------------------------------------------

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

After they've been cloned, the app should build.

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





