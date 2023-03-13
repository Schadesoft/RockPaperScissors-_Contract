pragma solidity ^0.8.0;

contract RockPaperScissors {
    address player1;
    address player2;
    uint256 public betAmount;
    mapping(address => bytes32) public hashedChoice;

    constructor() payable {
        player1 = msg.sender;
        betAmount = msg.value;
    }

    function joinGame(bytes32 _hashedChoice) public payable {
        require(player2 == address(0), "Game already has two players");
        require(msg.value == betAmount, "Please send the correct bet amount");
        player2 = msg.sender;
        hashedChoice[player2] = _hashedChoice;
    }

    function revealChoice(bytes32 _choice, bytes32 _secret) public {
        require(msg.sender == player1 || msg.sender == player2, "Only players can reveal their choices");
        require(keccak256(abi.encodePacked(_choice, _secret)) == hashedChoice[msg.sender], "Invalid secret");
        // rock: 0, paper: 1, scissors: 2
        uint256 playerChoice = uint256(_choice) % 3;
        if (msg.sender == player1) {
            player1Choice = playerChoice;
        } else {
            player2Choice = playerChoice;
        }
    }

    function declareWinner() public returns (address) {
        require(player2 != address(0), "Game has not started yet");
        require(player1Choice != 3 && player2Choice != 3, "Both players must reveal their choices");
        uint256 difference = (player1Choice - player2Choice + 3) % 3;
        if (difference == 0) {
            // draw, refund both players
            player1.transfer(betAmount);
            player2.transfer(betAmount);
            return address(0);
        } else if (difference == 1) {
            // player 1 wins, transfer funds to player 1
            player1.transfer(betAmount * 2);
            return player1;
        } else {
            // player 2 wins, transfer funds to player 2
            player2.transfer(betAmount * 2);
            return player2;
        }
    }
}
