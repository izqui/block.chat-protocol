pragma solidity ^0.4.4;

// Solidity doesn't compile if it doesn't find a contract with the same name as the file.
contract Interfaces {}

contract BlockChatInterface {
  MessageStoreInterface public messageStore;
  KeyStoreInterface public keyStore;

  function sendMessage(string payload, uint64 timestamp, bytes32 recipientHash) public;
  function migrateContract(address newBlockchat) public;

  event NewMessage(address sender, uint256 messageID, uint64 timestamp, bytes32 recipientHash);
  event BlockChatMigrated(address newBlockchatAddress);
}

contract MessageStoreInterface {
  function getMessage(uint256 messageID) constant returns (address sender, string payload, uint64 timestamp, bytes32 recipientHash);
  function saveMessage(address sender, string payload, uint64 timestamp, bytes32 recipientHash) returns (uint256 messageID);
  function setNewBlockchat(address newBlockchat);
}

contract KeyStoreInterface {
  function register(string username, string publicKey);
  function registerPublicKey(string publicKey);

  function getPublicKeyForUsername(string username) constant returns (string);
  function getPublicKeyForAddress(address addr) constant returns (string);
}
