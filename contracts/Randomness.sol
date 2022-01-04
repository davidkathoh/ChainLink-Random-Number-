pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "hardhat/console.sol";
contract Randomness is VRFConsumerBase{

      bytes32 internal keyHash;
     uint256 internal fee;
   
     address internal link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
     event Result(Game game);
     struct Game{
         address player;
         uint8 playerGuess;
         uint8 randomNumber;
     }
    mapping(bytes32 => Game) public requests;

     constructor() VRFConsumerBase(0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,link){
         keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
         fee = 0.1*10**18;
     }
 
 /** 
     * Requests randomness 
     */
    function getRandomNumber(uint8 guess) payable public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        requestId = requestRandomness(keyHash, fee);
        requests[requestId] = Game(msg.sender, guess, 0);
        console.log("randomness recieved %s",string(abi.encodePacked(requestId)));
        console.log(string(abi.encodePacked(requestId)));
        return requestId;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        console.log("randomness recieved %s",string(abi.encodePacked(requestId)));
        requests[requestId].randomNumber = uint8((randomness % 100) + 1);
       emit Result(requests[requestId]);
    }

}