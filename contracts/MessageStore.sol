pragma solidity ^0.4.4;

import "Interfaces.sol";

contract MessageStore is MessageStoreInterface {

  struct Message {
    address sender;
    string payload;
    uint64 timestamp;
    bytes32 recipientHash;
  }

  mapping (uint256 => Message) private messages;
  uint256 messageIndex;

  function MessageStore() {}

  function getMessage(uint256 messageID) constant returns (address sender, string payload, uint64 timestamp, bytes32 recipientHash) {
    var message = messages[messageID];
    return (message.sender, message.payload, message.timestamp, message.recipientHash);
  }

  function saveMessage(address sender, string payload, uint64 timestamp, bytes32 recipientHash) returns (uint256 messageID) {
    messageID = messageIndex;
    messages[messageID] = Message({sender: sender, payload: payload, timestamp: timestamp, recipientHash: recipientHash});

    messageIndex += 1;
    return;
  }
}
