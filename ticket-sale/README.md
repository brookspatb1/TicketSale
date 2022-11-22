### React-Starter

This is intended to be a starting point for React-based deployments of decentralized applications on a variety of EVM based architectures.

Prior to starting this make sure you have Truffle and React installed:

Truffle - ```npm install -g truffle```
  - The "-g" here will install truffle globally

To make things a lot easier, intall Homebrew with: ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```
  - Do this in your terminal.

After Homebrew is installed, install NodeJS: ```brew install node```
(Truffle doesn't play well with the newest versions of NodeJS. There may be some additional configuration to do on your machine.

##### To get started follow these instructions (MacOs):

Clone the repository and follow these steps:

1. Change directories to your newly created file: ```cd react-starter```
2. Change directories to the truffle directory: ```cd truffle```
3. As a precautionary step run: ```truffle init```
  - If everything is good this will ask to overwrite files. Opt to not overwrite the files.
4. Now compile your example contract: ```truffle compile```
5. Perform a test of the code: ```truffle test```
6. Open an additional terminal and run: ```ganache-cli``` or ```ganache```
  - This should start up your private instance of ganache. 
7. Now go back to your original terminal and run: ```truffle migrate```
8. Change back to the main directory: ```cd```
9. Change to the client directory: ```cd client```
10. Start up your React server: ```npm start```
  - I did not get this running with Safari but it otherwise should work. It started up in Brave just fine.

##### I had lots of issues with the production deployment of the contract. The best solution I found was to use ```truffle dashboard```.
This uses a local host to sign transactions with your browser (MetaMask). After running a separate terminal window with the dashboard command configure
your config file to the port provided.
