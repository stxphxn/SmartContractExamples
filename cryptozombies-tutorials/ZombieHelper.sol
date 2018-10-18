pragma solidity ^0.4.25;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    // Requires struct zombies[_zombieId].level is greater than or equal to _level.
    require(zombies[_zombieId].level >= _level);
    _;
  } // end of modifier aboveLevel

  // Function withdraw() uses modifier onlyOwner and address variable 'owner'.
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  } // end of function withdraw()

  // Function setLevelUpFee() allows owner to change the levelUpFee.
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  } // end of function setLevelUpFee()

  // A fee of 0.001 Ether is required from the user to increase their zombie's level +1.
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level = zombies[_zombiesId].level.add(1);
  } // end of function levelUp()

  // For zombies level 2 and higher, users will be able to change their name.
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
    // v-- Replaced with modifier onlyOwnerOf(). --v
    // require(msg.sender == zombieToOwner[_zombieId]); //check if user is zombie owner
    zombies[_zombieId].name = _newName;
  } // end of function changeName()

  // For zombies level 20 and higher, users will be able to give them custom DNA.
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    // v-- Replaced with modifier onlyOwnerOf(). --v
    // require(msg.sender == zombieToOwner[_zombieId]); //check if user is zombie owner
    zombies[_zombieId].dna = _newDna;
  } // end of function changeDna()

  // Function getZombiesByOwner() will return a user's entire zombie army, uint[] (an array of uint variables).
  function getZombiesByOwner(address _owner) external view returns(uint[]) {

    // Declares a uint[] memory variable 'result'. This new uint array will be
    // declared of length equal to how many zombies the user owns. Generic declaration for 3 items:
    //      uint[] memory values = new uint[](3);
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        // Adds the zombie's ID to our result array by setting result[counter] equal to i.
        result[counter] = i;
        counter++;
      } // end if (zombieToOwner[i] == _owner)
    } // end for (i < zombies.length)
    return result;
  } // end of function getZombiesByOwner()

} // end of contract ZombieHelper{}
