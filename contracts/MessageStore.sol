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

  address public blockchat;

  function MessageStore() {
    blockchat = msg.sender;
  }

  function setNewBlockchat(address newBlockchat) {
    if (msg.sender == blockchat) {
      blockchat = newBlockchat;
    }
  }

  function getMessage(uint256 messageID) constant returns (address sender, string payload, uint64 timestamp, bytes32 recipientHash) {
    var message = messages[messageID];
    return (message.sender, message.payload, message.timestamp, message.recipientHash);
  }

  function saveMessage(address sender, string payload, uint64 timestamp, bytes32 recipientHash) returns (uint256 messageID) {
    if (msg.sender != blockchat) {
      sender = msg.sender;
    }

    messageID = messageIndex;
    messages[messageID] = Message({sender: sender, payload: payload, timestamp: timestamp, recipientHash: recipientHash});

    messageIndex += 1;
    return;
  }

  function () { throw; }
}
