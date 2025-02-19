//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import "hardhat/console.sol";
import "./zombiefactory.sol";
import "./ownable.sol";

interface IKitty {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  IKitty kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = IKitty(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readytime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns(bool) {
    return (_zombie.readytime <= block.timestamp);
  }
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
        require(zombieToOwner[_zombieId] == msg.sender);
        Zombie storage myZombie = zombies[_zombieId];
        
        require(_isReady(myZombie));
        
        _targetDna = _targetDna % dnaDigits;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
        newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }
    
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}