pragma solidity ^0.4.19;

contract TicTacToe {
    struct Game {
        string name;
        bool ready;
        uint8[9] board;
        uint8 turn;
        mapping(uint8 => address) players;
    }
    
    uint8 constant X = 1;
    uint8 constant O = 2;
    uint8 constant EMPTY = 0;
    
    Game[] public games;
    
    event BoardState(uint256 gameId, uint8[9] board, uint8 turn);
    event GameResult(uint256 gameId, address winner);
    
    modifier inGame(uint256 _gameId) {
        require(games.length > _gameId);
        Game storage game = games[_gameId];
        require(game.players[X] == msg.sender || game.players[O] == msg.sender);
        _;
    }
    
    function getBoardPosition(uint _gameId, uint8 position) public view returns (uint8) {
        return games[_gameId].board[position];
    }
    
    function getPlayer(uint _gameId, uint8 _symbol) public view returns (address) {
        return games[_gameId].players[_symbol];
    }
    
    function getEmptyBoard() private pure returns (uint8[9]) {
        return [EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY];
    }
    
    function getNextPlayer(uint8 _turn) private pure returns (uint8) {
        if (_turn == X) {
            return O;
        } else {
            return X;   
        }
    }
    
    function createGame(string _name) payable external returns (
        uint256 gameId,
        bool ready,
        uint8[9] board,
        uint8 turn
    )
    {
        require(msg.value == 1);
        
        Game memory game = Game(_name, false, getEmptyBoard(), X);
        uint256 id = games.push(game) - 1;
        games[id].players[X] = msg.sender;
        
        return (id, game.ready, game.board, game.turn);
    }
    
    function joinGame(uint256 _gameId) payable external {
        require(msg.value == 1);
        require(games.length > _gameId);
        
        Game storage game = games[_gameId];
        game.players[O] = msg.sender;
        
        BoardState(_gameId, game.board, game.turn);
    }
    
    function winnerExists(uint8[9] board, uint8 symbol) private pure returns (bool finished) {
        uint8 horizontal_count = 0;
        uint8 vertical_count = 0;
        uint8 right_to_left_count = 0;
        uint8 left_to_right_count = 0;
        uint8 board_size = 3;
        
        for (uint8 x = 0; x < board_size; x++) {
            horizontal_count = vertical_count = 0;
            for (uint8 y = 0; y < board_size; y++) {
                // "0,1,2", "3,4,5", "6,7,8"
                if (board[x * board_size + y] == symbol) {
                    horizontal_count++;
                }
                
                if (board[y * board_size + x] == symbol) {
                    vertical_count++;
                }
            }
            
            // Check horizontal and vertical combination
    		if (horizontal_count == board_size || vertical_count == board_size) {
    			return true;	
    		}
    
    		// diagonal "0,4,8"
    		if (board[x * board_size + y] == symbol) {
    			right_to_left_count++;
    		}
    
    		// diagonal "2,4,6"
    		if (board[(board_size - 1) * (x+1)] == symbol) {
    			left_to_right_count++;
    		}
        }
		
		if (right_to_left_count == board_size || left_to_right_count == board_size) {
		    return true;
		}

        return false;
    }
    
    function isDraw(uint8[9] board) private pure returns (bool draw) {
        for (uint8 x = 0; x < board.length; x++) {
            if (board[x] == EMPTY) {
                return false;
            }
        }
        
        return true;
    }

    
    function move(uint256 _gameId, uint8 position) external inGame(_gameId) {
        Game storage game = games[_gameId];
        require(game.board[position] == EMPTY);
        require(game.players[game.turn] == msg.sender);
        
        game.board[position] = game.turn;
        
        if (winnerExists(game.board, game.turn)) {
            address winner = game.players[game.turn];
            winner.transfer(2);
            GameResult(_gameId, winner);
            return;
        }
        
        if (isDraw(game.board)) {
            GameResult(_gameId, 0);
        }
        
        game.turn = getNextPlayer(game.turn);
        BoardState(_gameId, game.board, game.turn);
    }
}
