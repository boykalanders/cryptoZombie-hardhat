//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import "hardhat/console.sol";
import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieLength, string zombieName, uint zombieDNA);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readytime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner; 
    mapping (address => uint) ownerZombieCount;
    
    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime)));
        zombieToOwner[zombies.length-1] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(zombies.length-1, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
