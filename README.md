# Cow Poop

# Install

## Ganache

[Ganache](https://www.trufflesuite.com/ganache) allows you to run a local blockchain.

Follow the steps here to install it: https://www.trufflesuite.com/docs/ganache/quickstart

Note for Ubuntu, after downloading the file:
- Right click on the file (ganache-2.5.4-linux-x86_64.AppImage)
- Click on **Properties**
- Click on **Permissions** tab
- check the **Allow executing file as a program** checkbox
- Double click on the file to run


After launching Ganache:
- Select **Quickstart workspace** on Etherum


## Truffle

[Truffle](https://www.trufflesuite.com/docs/truffle/overview) is a development environment for smart contracts.

To install it you need nodejs.

```
npm install -g truffle
```

note: do i really need to install globally?

Only need to run this command for the first time in order to create some files:
```
truffle unbox react

Commands:

  Compile:              truffle compile
  Migrate:              truffle migrate
  Test contracts:       truffle test
  Test dapp:            cd client && npm test
  Run dev server:       cd client && npm run start
  Build for production: cd client && npm run build

```

## Metamask

[Metamask](https://metamask.io) is a wallet integrated in your web browser. Simply install the extension.

Be default Metamask will use the real Ethereum network. So you need to select your local Ganache blockchain network.
Sometimes the port is 8545 or 7545. Look at your Ganache window to see the port.

In Ganache, on one of the user account, click on key icon to get the private key.
After that, in Metamask, click on your icon (top right) and click on `Import Account`.
Paste the private key.
Now you should be able to use your local account with Metamask.

# Compile

Run:
```
truffle compile
```

# Migrate

Make sure the file `truffle-config.js` is setup correctly.
To deploy your smart contract on the blockchain:
```
truffle migrate
truffle migrate --reset
```

# Console

```
truffle console
> todoList = await TodoList.deployed()
> todoList
> todoList.address
> count = await todoList.taskCount()
> count.toNumber()
> task = await tl.tasks(1)
> task.id.toNumber()
> task.content
```