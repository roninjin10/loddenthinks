pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";

contract LoddenThinks is Ownable {
    struct Game {
        uint stakes;
        address[] players;
        uint8 lodden;
        string answer;
        uint8[] bids;
        bool[] didPay;
        uint blockNumber;
    }

    event newGame(
        uint stakes,
        address[] players
    )

    event gameEnded(
        uint gameId,
        uint stakes,
        address[] players,
        bool didStart players,
        address[] winners
    )

    Game[] public games;

    function cancelGame(_gameId) public onlyPlayers(_gameId) {
        Game memory _game = games[_gameId];
        
        require(block.number > _game.blockNumber + 60);
        require(!_game.didPay[0] || !_game.didPay[1] || !_game.didPay[2]);

        for (uint i; i < 3; i++) {
            if (_game.didPay[i]) {
                _game.players[i].transfer(_game.stakes);
            }
        }

        emit gameEnded(
            _gameId,
            _game.stakes,
            _game.players,
            false,
            _game.players
        )
    }

    function createGame(uint _stakes, address _player1, address _player2, address _player3) public payable {
        address[] _players = [_player1, _player2, _player3];
        uint8[] _bids;
        bool[] _didPay = [false, false, false];

        uint _id = games.push(Game(
            _stakes;
            _players,
            0,
            "",
            _bids,
            _didPay,
            block.number
        ));

        emit newGame(
          msg.value,
          msg.sender
        );
    }

    modifier onlyPlayers(_gameId) {
        require(games[_gameId].players[0] === msg.sender || games[_gameId].players[1] === msg.sender || games[_gameId].players[2] === msg.sender);
    }
}

