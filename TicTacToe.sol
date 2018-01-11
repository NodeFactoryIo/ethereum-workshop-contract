pragma solidity ^0.4.19;

contract TicTacToe {
    struct Game {
        bool ready;
        uint8[] board;
        address turn;
        mapping(address => uint8) players;
    }
    
    Game[] public games;
    
    modifier inGame(uint256 _gameId) {
        require(games.length > _gameId);
        Game storage game = games[_gameId];
        require(game.players[msg.sender] != 0);
        _;
    }
    
    function createGame(string _name) payable external returns (
        uint256,
        bool,
        uint8[],
        address,
        uint8
    )
    {
        
    }
    
    function joinGame(uint256 _gameId) payable inGame(_gameId) returns (
        bool,
        uint8[],
        address,
        uint8
    )
    {
        
    }
}
