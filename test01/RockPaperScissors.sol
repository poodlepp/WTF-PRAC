// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;


contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }
    
    struct Player {
        address addr;
        bytes32 commitment;
        Move move;
    }
    
    Player[2] public players;
    uint public revealDeadline;
    uint public betAmount;
    bool public gameStarted;
    
    modifier onlyPlayers() {
        require(msg.sender == players[0].addr || msg.sender == players[1].addr, "Not a player");
        _;
    }
    
    function startGame(address _player2, uint _betAmount) external payable {
        require(!gameStarted, "Game already started");
        require(msg.value == _betAmount, "Incorrect bet amount");
        
        players[0] = Player(msg.sender, bytes32(0), Move.None);
        players[1] = Player(_player2, bytes32(0), Move.None);
        betAmount = _betAmount;
        gameStarted = true;
    }

    // there is some problem here,all the players should to pay the betAmount 
    
    function commitMove(bytes32 _commitment) external onlyPlayers {
        require(players[0].commitment == bytes32(0) || players[1].commitment == bytes32(0), "Moves already committed");
        
        if (msg.sender == players[0].addr) {
            require(players[0].commitment == bytes32(0), "Player 1 already committed");
            players[0].commitment = _commitment;
        } else {
            require(players[1].commitment == bytes32(0), "Player 2 already committed");
            players[1].commitment = _commitment;
        }
        
        if (players[0].commitment != bytes32(0) && players[1].commitment != bytes32(0)) {
            revealDeadline = block.timestamp + 1 days;
        }
    }
    
    function revealMove(Move _move, bytes32 _salt) external onlyPlayers {
        require(block.timestamp < revealDeadline, "Reveal period over");
        
        bytes32 commitment = keccak256(abi.encodePacked(_move, _salt));
        if (msg.sender == players[0].addr) {
            require(players[0].commitment == commitment, "Invalid commitment for player 1");
            players[0].move = _move;
        } else {
            require(players[1].commitment == commitment, "Invalid commitment for player 2");
            players[1].move = _move;
        }
        
        if (players[0].move != Move.None && players[1].move != Move.None) {
            _determineWinner();
        }
    }
    
    function _determineWinner() internal {
        // Logic to determine the winner
        uint winnerIndex;
        if (players[0].move == players[1].move) {
            // Draw, refund both players
            payable(players[0].addr).transfer(betAmount);
            payable(players[1].addr).transfer(betAmount);
        } else if (
            (players[0].move == Move.Rock && players[1].move == Move.Scissors) ||
            (players[0].move == Move.Paper && players[1].move == Move.Rock) ||
            (players[0].move == Move.Scissors && players[1].move == Move.Paper)
        ) {
            // Player 1 wins
            winnerIndex = 0;
        } else {
            // Player 2 wins
            winnerIndex = 1;
        }
        
        if (winnerIndex == 0 || winnerIndex == 1) {
            payable(players[winnerIndex].addr).transfer(2 * betAmount);
        }
        
        _resetGame();
    }
    
    function _resetGame() internal {
        delete players[0];
        delete players[1];
        gameStarted = false;
    }
    
    function forfeit() external onlyPlayers {
        require(block.timestamp >= revealDeadline, "Reveal period not over");
        
        if (msg.sender == players[0].addr && players[1].move == Move.None) {
            payable(players[0].addr).transfer(2 * betAmount);
        } else if (msg.sender == players[1].addr && players[0].move == Move.None) {
            payable(players[1].addr).transfer(2 * betAmount);
        }
        
        _resetGame();
    }
}
