//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

}