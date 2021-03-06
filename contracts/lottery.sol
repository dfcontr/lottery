pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    
    function Lottery() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > 0.01 ether);
        
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(sha3(block.difficulty, now, players));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance); // Current contract's money
        players = new address[](0); // Initial size of 0
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _; // Functions with this modifier are placed here
    }
    
    function getPlayers() public view returns (address[]) { // Do not attempt to save data
        return players;
    }
}