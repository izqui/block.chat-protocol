pragma solidity ^0.4.4;

import "Interfaces.sol";
import "MessageStore.sol";

contract BlockChat is BlockChatInterface {

  MessageStoreInterface public messageStore;
  address deployer;
  bool changeableStore;

  function BlockChat(address currentStore, bool _changeableStore) {
    deployer = msg.sender;
    changeableStore = _changeableStore;
    
    // If a store is provided set it, if not deploy new store
    setMessageStore(currentStore != 0x0 ? currentStore : address(new MessageStore()));
  }

  function setMessageStore(address newAddress) {
    // Only deployer, when changes are allowed or store hasn't been set yet
    if (msg.sender == deployer && changeableStore || address(messageStore) == 0x0) {
      messageStore = MessageStoreInterface(newAddress);
    } else {
      throw;
    }
  }

  function sendMessage(string payload, uint64 timestamp, bytes32 recipientHash) {
    var messageID = messageStore.saveMessage(msg.sender, payload, timestamp, recipientHash);
    NewMessage(msg.sender, messageID, timestamp, recipientHash);
  }

  // In case someone transfer funds to the contract, transfer to deployer as donation.
  function donate() payable {
    if (!deployer.send(msg.value)) { throw; }
  }

  function () payable { donate(); }
}
