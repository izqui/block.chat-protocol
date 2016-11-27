pragma solidity ^0.4.4;

import "Interfaces.sol";

contract KeyStore is KeyStoreInterface {

  mapping (address => bytes32) private publicKeys;
  mapping (string => address) private usernames;
  mapping (address => uint64) private registeredTimestamp;

  function KeyStore() {}

  function register(string username, bytes32 publicKey) {
    if (usernames[username] != 0x0) {
      throw;
    }

    usernames[username] = msg.sender;
    registeredTimestamp[msg.sender] = uint64(now);
    registerPublicKey(publicKey);
  }

  function registerPublicKey(bytes32 publicKey) {
    publicKeys[msg.sender] = publicKey;
  }

  function getPublicKeyForUsername(string username) constant returns (bytes32) {
    return getPublicKeyForAddress(usernames[username]);
  }

  function getPublicKeyForAddress(address addr) constant returns (bytes32) {
    return publicKeys[addr];
  }

  function () { throw; }
}
