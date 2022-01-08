# ERC-1155 NFT MARKET

A Metaverse Marketplace in which a user puts an item for sale, the ownership of the item will be transferred from the creator to the marketplace. When a user purchases an item, the purchase price will be transferred from the buyer to the seller and the item will be transferred from the marketplace to the buyer.

The marketplace owner will be able to set a listing fee. This fee will be taken from the seller and transferred to the contract owner upon completion of any sale, enabling the owner of the marketplace to earn recurring revenue from any sale transacted in the marketplace.

# Tools, Languages & Frameworks used ⚡️

Solidity, javascript
Next.js
Hardhat
Ethers.js
IPFS

# Running this project ☘️

To run this project locally, follow these steps.

Clone the project locally, change into the directory, and install the dependencies:
git clone https://github.com/sanskarkhare/PandoraErc1155.git

# install using NPM or Yarn
npm install

# or

Yarn install 

Start the local Hardhat node
npx hardhat node
With the network running, deploy the contracts to the local network in a separate terminal window
npx hardhat run scripts/deploy.js --network localhost
Start the app
npm start

# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
