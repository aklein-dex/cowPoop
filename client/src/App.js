import React, { Component } from "react";
import CowPoopContract from "./contracts/CowPoop.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = CowPoopContract.networks[networkId];
      const instance = new web3.eth.Contract(CowPoopContract.abi, 
        deployedNetwork && deployedNetwork.address);

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert('Failed to load web3, accounts, or contract. Check console for details.');
      console.error(error);
    }
  };

  getLotteryPrizePool = async() => {
    const { accounts, contract } = this.state;
    const response = await contract.methods.getLotteryPrizePool(100).call();
    console.log(`Res: ${response}`);
  };

  createLottery = async () => {
    const { accounts, contract } = this.state;
    const lotteryId = await contract.methods.createNewLottery(1,1619180295, 1619184095).send({ from: accounts[0] });
    console.log(`Lottery id: ${JSON.stringify(lotteryId)}`);
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value, 5 by default.
    await contract.methods.set(5).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.get().call();

    // Update state with the result.
    this.setState({ storageValue: response });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Cow Poop</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 40</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div>
        <button onClick={this.createLottery}>Create lottery</button>
        <button onClick={this.getLotteryPrizePool}>Prize pool</button>
      </div>
    );
  }
}

export default App;
