pragma solidity ^0.4.25;
import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {

  uint randNonce = 0;
  uint attackVictoryProbability = 70; // Attacking zombie has a 70% chance of winning.

  // Function randMond() creates a random number that will be used to determine
  // zombie battle outcomes.
  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);

    // keccak256 takes  hash of now, msg.sender, and randNonce.
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;

  } // end of function randMod()

  // If the attacking zombie wins, it levels up and spawns a new zombie.
  // If it loses, nothing happens (except its lossCount incrementing).
  // Whether it wins or loses, the attacking zombie's cooldown time will begin.

  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {

    // Sets 'Zombie storage' named 'myZombie'.
    Zombie storage myZombie = zombies[_zombieId];

    // Sets 'Zombie storage' named 'enemyZombie'.
    Zombie storage enemyZombie = zombies[_targetId];

    // A pseudo-random number between 0 and 99 determines the battle outcome.
    uint rand = randMod(100);

    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level++ = myZombie.level.add(1);;
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      // Function in ZombieFeeding.sol will call _createZombie using newDna.
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie"); // function takes enemy zombie's dna _not_ _targetId.
    } else {
      // The 30% case if user's zombie loses.
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie); // Note: I guess the user doesn't lose their zombie under feedAndMultiply().
    } // end if (rand <= attackVictoryProbability)
  } // end of function attack()

} // end of Contract ZombieBattle {}
