pragma solidity ^0.4.25;
import "./Ownable.sol";
import "./SafeMath.sol";

// Modify our code to import the contents of ownable.sol.

// ZombieFactory{} inherits from Ownable.sol. Then,
// 1) access will be restricted to the person who deployed the contract (msg.sender)
// 2) allows current owner to transfer ownership to another permissions
contract ZombieFactory is Ownable {

    using SafeMath for uint256; // The SafeMath library has 4 functions — add, sub, mul, and div.
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    // Declares the NewZombie event. Event will let the front-end know every time
    // a new zombie has been created, so the dApp can display the zombie.
    event NewZombie( uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        // Putting two compact uints together saves space.
        uint32 level;    // Compact uints (e.g. uint32 vs uint 64) saves space in structs.
        uint32 readyTime;// Cooldown timer to limit how often a zombie can feed.
        uint16 winCount; // Wins and losses of zombie battles are stored inside struct.
        uint16 lossCount;
    }

    // Public `Zombie` struct with array named `zombies`
    Zombie[] public zombies;
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) public ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal { // internal type so ZombieFeeding.sol can access
        // Creates a new `Zombie`, and adds it to the `zombies` array.
        // The name and dna for the new Zombie come from the function arguments.
        // zombies.push(Zombie(_name, _dna));

        // Zombie ID
        // array.push() returns a uint of the new length of the array.
        // Since the first item in an array has index 0, array.push() - 1 will be
        // the index of the zombie we just added.
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);

        // Fires the event to let the dApp know the new zombie was added to the `zombies` arrray.
        NewZombie(id, _name, _dna);
    } // end of function _createZombie()

    function _generateRandomDna(string _str) private view returns (uint) {
        // Takes the keccak256 hash of _str to:
        //   1) generate a pseudo-random hexidecimal,
        //   2) typecast it as a uint, and
        //   3) finally store the result in a uint called `rand`.
        uint rand = uint(keccak256(_str));

        // Will make the DNA string only 16 digits long.
        return rand % dnaModulus;
    } // end of function _generateRandomDna()

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    } // end of function createRandomZombie()

} // end of Contract.sol
