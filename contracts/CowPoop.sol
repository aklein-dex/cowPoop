// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;
pragma experimental ABIEncoderV2;

// I'm just trying to learn solidity! Sorry for the messi code, I'm trying stuff

// https://github.com/PatrickAlphaC/chainlink_defi/blob/master/src/components/App.js
/**
 * 
 * https://github.com/paulrberg/create-eth-app
 * https://www.dappuniversity.com/
 */
 
 // https://github.com/pancakeswap/lottery-contract/blob/master/contracts/Lottery.sol

// https://blog.chain.link/random-number-generation-solidity/
// https://docs.chain.link/docs/fund-your-contract
contract CowPoop {
    address public adminAddress;
    
     // Represents the status of the lottery
    enum Status { 
        NotStarted,     // The lottery has not started yet
        Open,           // The lottery is open for ticket purchases 
        Closed,         // The lottery is no longer open for ticket purchases
        Completed       // The lottery has been closed and the numbers drawn
    }
    
    struct Lottery {
        uint256 lotteryId;
        Status status;
        uint256 prizePool;
        uint256 costPerTicket;
        uint256 startingTimestamp;      // Block timestamp for star of lotto
        uint256 closingTimestamp;       // Block timestamp for end of entries
        uint16 winningNumber;     // The winning number
        mapping(uint256 => address payable[]) field; // the field containing the position of players
    }
    
    // Lottery ID's to info
    mapping(uint256 => Lottery) public lotteries;

    // Counter for lottery IDs 
    uint256 private lotteryIdCounter_;
    
    event CreateLottery(address indexed _from, uint256 _ts, uint256 _now);
    
    // event when sending the prize to the winner
    event Winner(address indexed _winner, uint _prize);
    
    constructor(address _admin) {
        adminAddress = _admin;
        lotteryIdCounter_ = 0;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "admin: wut?");
        _;
    }
    
    function createNewLottery (uint256 _costPerTicket, uint256 _startingTimestamp, uint256 _closingTimestamp) public onlyAdmin returns(uint256) {
        require( _costPerTicket != 0,  "Cost cannot be 0");
        require(_startingTimestamp != 0 && _startingTimestamp < _closingTimestamp, "Timestamps for lottery invalid");
        
        emit CreateLottery(msg.sender, _startingTimestamp, block.timestamp);
        
        // Incrementing lottery ID 
        lotteryIdCounter_ = lotteryIdCounter_ + 1;
        uint256 lotteryId = lotteryIdCounter_;
        Status lotteryStatus;
        
        if (_startingTimestamp < block.timestamp) {
            lotteryStatus = Status.Open;
        } else {
            lotteryStatus = Status.NotStarted;
        }
        
        Lottery storage newLottery = lotteries[lotteryId];
        newLottery.lotteryId = lotteryId;
        newLottery.status = lotteryStatus;
        newLottery.prizePool = 0;
        newLottery.costPerTicket = _costPerTicket;
        newLottery.startingTimestamp = _startingTimestamp;
        newLottery.closingTimestamp = _closingTimestamp;
        
        return lotteryId;
    }
    
    
    // https://medium.com/@tiagobertolo/how-to-safely-generate-random-numbers-in-solidity-contracts-bd8bd217ff7b
    // random https://github.com/wheelspinio/wheelspin-io-contracts
    function poopTime(uint256 _lotteryId) public onlyAdmin {
        uint winnerPosition = 2; // todo random
        
        require(lotteries[_lotteryId].closingTimestamp <= block.timestamp, "Cannot set winning numbers during lottery");
        require(lotteries[_lotteryId].status == Status.Open, "Lottery is not open");
        lotteries[_lotteryId].status = Status.Closed;
        
        address payable[] memory winners = lotteries[_lotteryId].field[winnerPosition];
        uint balance = address(this).balance;
        uint prizePerWinner = balance / winners.length;
        for (uint256 i = 0; i < winners.length; i++) {
            emit Winner(winners[i], prizePerWinner);
            winners[i].transfer(prizePerWinner);
        }
        lotteries[_lotteryId].status = Status.Completed;
    }
    
    function getPrize(uint256 _lotteryId) view public returns(uint) {
        return lotteries[_lotteryId].prizePool;
    }
    
    function withdraw() public {
        msg.sender.transfer(address(this).balance);
    }

    /**
     * it’s a better practice to have the function take as a parameter the amount 
     * to be transferred and then to test that that’s the actual amount transferred. 
     * This allows the contract to reject transactions that may be erroneous:
     */
    function deposit(uint256 _lotteryId, uint256 amount, uint256 position) payable public {
        require(msg.value == amount, "amount is invalid");
        // https://programtheblockchain.com/posts/2017/12/15/writing-a-contract-that-handles-ether/
        
        if (lotteries[_lotteryId].status == Status.NotStarted) {
            if (lotteries[_lotteryId].startingTimestamp >= block.timestamp) {
                lotteries[_lotteryId].status = Status.Open;
            }
        }
        
        require(lotteries[_lotteryId].status == Status.Open, "Lottery is not open");
        lotteries[_lotteryId].field[position].push(msg.sender);
    }
    
    function getLotteryPrizePool(uint256 _lotteryId) view public returns (uint256) {
        return lotteries[_lotteryId].prizePool;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function getPlayersCountAt(uint256 _lotteryId, uint256 position) view public returns (uint256) {
        return lotteries[_lotteryId].field[position].length;
    }
    
    // function getMyNumber(uint256 _lotteryId) view public returns (uint256) {
    //     for (uint256 i = 0; i < lotteries[_lotteryId].players.length; i++) {
    //         if (lotteries[_lotteryId].players[i] == msg.sender) {
    //             return i;
    //         }
    //     }
    //     return 0; // todo return some kind of error
    // }
}