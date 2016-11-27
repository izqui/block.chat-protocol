pragma solidity ^0.4.4;

import "Interfaces.sol";

contract KeyStore is KeyStoreInterface {

  mapping (address => string) private publicKeys;
  mapping (string => address) private usernames;
  mapping (address => uint64) private registeredTimestamp;

  function KeyStore() {}

  function register(string username, string publicKey) {
    if (usernames[username] != 0x0) {
      throw;
    }

    usernames[username] = msg.sender;
    registeredTimestamp[msg.sender] = uint64(now);
    registerPublicKey(publicKey);
  }

  function registerPublicKey(string publicKey) {
    publicKeys[msg.sender] = publicKey;
  }

  function getPublicKeyForUsername(string username) constant returns (string) {
    return getPublicKeyForAddress(usernames[username]);
  }

  function getPublicKeyForAddress(address addr) constant returns (string) {
    return publicKeys[addr];
  }

  function () { throw; }
}
