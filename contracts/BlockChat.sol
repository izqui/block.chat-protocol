pragma solidity ^0.4.4;

import "Interfaces.sol";
import "MessageStore.sol";
import "KeyStore.sol";

contract BlockChat is BlockChatInterface {

  MessageStoreInterface public messageStore;
  KeyStoreInterface public keyStore;

  address deployer;
  bool changeableStores;

  function BlockChat(address _messageStore, address _keyStore, bool _changeableStores) {
    deployer = msg.sender;
    changeableStores = _changeableStores;

    // If a store is provided set it, if not deploy new store
    setMessageStore(_messageStore != 0x0 ? _messageStore : address(new MessageStore()));
    setKeyStore(_keyStore != 0x0 ? _keyStore : address(new KeyStore()));
  }

  function migrateContract(address newBlockchat) {
    if (msg.sender != deployer) {
      throw;
    }

    messageStore.setNewBlockchat(newBlockchat);
    BlockChatMigrated(newBlockchat);

    suicide(deployer);
  }

  function setMessageStore(address newAddress) {
    // Only deployer, when changes are allowed or store hasn't been set yet
    if (msg.sender == deployer && changeableStores || address(messageStore) == 0x0) {
      messageStore = MessageStoreInterface(newAddress);
    } else {
      throw;
    }
  }

  function setKeyStore(address newAddress) {
    // Only deployer, when changes are allowed or store hasn't been set yet
    if (msg.sender == deployer && changeableStores || address(keyStore) == 0x0) {
      keyStore = KeyStoreInterface(newAddress);
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
