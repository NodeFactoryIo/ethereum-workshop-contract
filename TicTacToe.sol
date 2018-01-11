pragma solidity ^0.4.19;

contract TicTacToe {
    struct Game {
        bool ready;
        uint8[] board;
        address turn;
        mapping(address => uint8) players;
    }
    
    Game[] public games;
    
    event BoardState(uint256 gameId, uint8[] board, address turn);
    event GameResult(uint256 gameId, address winner);
    
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
    
    function joinGame(uint256 _gameId) payable inGame(_gameId) external returns (
        bool,
        uint8[],
        address,
        uint8
    )
    {
        
    }
    
    function move(uint256 _gameId, uint8 position) external inGame(_gameId) {
        
    }
}
