pragma solidity ^0.4.4;

// Solidity doesn't compile if it doesn't find a contract with the same name as the file.
contract Interfaces {}

contract BlockChatInterface {
  MessageStoreInterface public messageStore;
  
  function sendMessage(string payload, uint64 timestamp, bytes32 recipientHash) public;
  event NewMessage(address sender, uint256 messageID, uint64 timestamp, bytes32 recipientHash);
}

contract MessageStoreInterface {
  function getMessage(uint256 messageID) constant returns (address sender, string payload, uint64 timestamp, bytes32 recipientHash);
  function saveMessage(address sender, string payload, uint64 timestamp, bytes32 recipientHash) returns (uint256 messageID);
}
