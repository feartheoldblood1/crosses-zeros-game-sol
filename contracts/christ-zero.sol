pragma solidity >=0.5.0 <0.9.0;

contract CrossZero {

    address [] players;
    address winner;

    uint height;
    uint width;
    
    mapping(uint => mapping(uint => bool)) isOccupied;
    mapping(address => bool) isMoved;
    mapping(uint => mapping(uint => uint)) symbol;
    
    event Win(address winner);

    constructor (uint _height, uint _width)
        public
    {
        require((_height%2 == 1) && (_width%2 == 1) && (_height == _width),"");
        height = _height;
        width = _width;
    }

    function addPlayer(address _player)
        public
    {
        players.push(_player);
    }

    //duplication code change
    //check winner
    //tie between players
    //test does defineWinner() work or not
    function move(uint x, uint y)
        public
    {    
        defineWinner(height, width);
        require(!isOccupied[x][y], "part of field must not be occupied");
        if(msg.sender == players[0]) {
            require(!isMoved[msg.sender], "player1 cannot move");
            symbol[x][y] = 0;
            isOccupied[x][y] = true;
            isMoved[players[0]] = true;
            isMoved[players[1]] = false;
        }

        if(msg.sender == players[1]) {
            require(!isMoved[msg.sender], "player2 cannot move");
            symbol[x][y] = 1;
            isOccupied[x][y] = true;
            isMoved[players[1]] = true;
            isMoved[players[0]] = false;
        }
    }

    function defineWinner(uint _height, uint _width)
        private
        returns(string memory)
    {
        winner = countZerosCrosses(_height, _width);
        if (winner == players[0]){
            emit Win(winner);
            return "Winner is first player";
        }
        else if (winner == players[1]) {
            emit Win(winner);
            return "Winner is second player";
        }
        else {
            emit Win(winner);
            return "Tie between first player and second player";
        }
    }
    //dublication code
    function countZerosCrosses (uint _h, uint _w)
        private
        view
        returns(address)
    {
        //count vertial and horizontal lines
        uint countZeros = 0;
        uint countCrosses = 0;
        for (uint i = 0; i < _h; i++) {
            for(uint j = 0; j < _w; j++) {
                if(symbol[i][j] == 0) {
                    countZeros++;
                }
                else if(countZeros == _h) {
                    return players[0];
                }      
                if(symbol[i][j] == 1) {
                    countCrosses++;
                }
                else if(countCrosses == _h) {
                    return players[1];
                }    
            }
            countZeros = 0;
            countCrosses = 0;
        }
        countDiagonal(_h, _w);
    }
    //dublication code
    function countDiagonal(uint _h, uint _w)
        private
        view
        returns(address)
    {
        uint p = 0; 
        uint q = 0;
        uint countZeros = 0;
        uint countCrosses = 0;
        while((p < _h) && (q < _w)){
            if(symbol[p][q] == 0) {
                countZeros++;
            }
            else if (countZeros == _h) {
                return players[0];
            }

            if(symbol[p][q] == 1) {
                countCrosses++;
            }
            else if (countCrosses == _h) {
                return players[1];
            }
            p++;
            q++;
        }
    }
}