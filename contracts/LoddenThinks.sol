pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";

contract LoddenThinks is Ownable {
    struct Game {
        uint stakes;
        address[] players;
        string answer;
        bool[] didPay;
        uint blockNumber;
        uint8[] bids;
        uint8 lodden;
        uint8 bidder;
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
    )

    Game[] public games;

    function submitAnswer(string _answer) public onlyLodden(_gameId) {
        games[_gameId].answer = _answer;

    }

    function buyin(uint _gameId) public payable onlyPlayers(_gameId) {
        Game memory _game = games[_gameId];

        require(msg.value == _game.stakes);
        
        for (uint i; i < 3; i++) {
            if (msg.sender == players[i]) {
                didPay[i] = true;
            }
        }
    }

    function cancelGame(Game _game) private {
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
        )
    }

    function cancelGamePlayer(uint _gameId) public onlyPlayers(_gameId) {
        Game memory _game = games[_gameId];

        if (block.number < _game.blockNumber + 300) {
            require(block.number > _game.blockNumber + 60);
            require(!_game.didPay[0] || !_game.didPay[1] || !_game.didPay[2]);
        }

        cancelGame(_game);
    }

    function cancelGameAdmin(uint _gameId) public onlyOwner {
        Game memory _game = games[_gameId];

        require(block.number > _game.blockNumber + 300);

        cancelGame(_game);
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

    modifier onlyLodden(_gameId) {
        require(games[_gameId].lodden == msg.sender);
        _;
    }

    modifier onlyBidder(_gameId) {
        require(games[_gameId].bidder == msg.sender);
        _;
    }

    modifier onlyPlayers(_gameId) {
        Game memory _game = games[_gameId];
        require(_game.players[0] === msg.sender || _game.players[1] === msg.sender || _game.players[2] === msg.sender);
        _;
    }

    modifier gameStarted(_gameId) {
        Game memory _game = games[_gameId];
        for (i = 0; i < 3; i++) {
            require(_game.didPay[i]);
        }
    }
}

