pragma solidity ^0.4.19;

contract TicTacToe {

    //X player code
    uint8 constant X = 1;
    //O player code
    uint8 constant O = 2;
    //empty board field symbol
    uint8 constant EMPTY = 0;

    //player entry fee in wei (winner reward is 2 x ENTRY_FEE)
    uint256 public constant ENTRY_FEE = 1;

    // Waiting - after the game is created, only one player is int the game
    // Ready - both players are in the game, game is progressing
    // Finished - after we announce the winner player
    enum GameStatus { Waiting, Ready, Finished }

    // Game object
    struct Game {
        //only serves as label for waiting room
        string name;
        //current game status
        GameStatus status;
        //represents 3x3 board
        //at the beginning each field should be EMPTY
        uint8[9] board;
        //symbol of player which should make his move
        uint8 turn;
        //provides info about which player(address) has what symbol
        mapping(uint8 => address) players;
    }

    //all contract games
    Game[] public games;

    //should be broadcasted after each move(except for last)
    event BoardState(uint256 gameId, uint8[9] board, uint8 turn);
    //should be broadcasted if somebody has won or is draw
    //winner address should be 0 if it's a draw
    event GameResult(uint256 gameId, address winner);

    //Utility method for frontend so it can retrieve all games from array
    //should return number of elements in game array
    function getGamesCount() public view returns(uint256 count) {
        //your implementation here
    }

    //first player creates game giving only the game label
    //method should check if there is enough of ether sent
    //caller should be set as player X and set to be first
    //return game position in array as game id (becareful array push returns new length or array)
    function createGame(string _name) payable external returns (
        uint256 gameId,
        uint8[9] board,
        uint8 turn
    )
    {
        //your implementation here
    }

    //second player joins game by giving game id
    //method should check if enough ether is sent
    //method should set caller as player O
    //method should change game status to ready
    //method should broadcast BoardState event to notify player X
    function joinGame(uint256 _gameId) payable external {
        //your implementation here
    }

    //method for making current player move
    //if it's a winning move or draw, broadcast GameResult event and returns
    //in case of winning move, 2xENTRY_FEE should be transferred to winner address
    //in case of draw, each player should get his ENTRY_FEE back
    //updates next player in game object
    //saves current player symbol on board at given position
    //broadcasts BoardState event
    function move(uint256 _gameId, uint8 position) external inGame(_gameId) {

        //your implementation

    }


    //utility function to help you with determine if given symbol has won
    //true if given symbol has won, false otherwise
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
        		if (board[x * board_size + x] == symbol) {
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
}
