module.exports = function(deployer) {
  var oldBlockchat;

  deployer.then(() => {
    if (BlockChat.address) {
      oldBlockchat = BlockChat.at(BlockChat.address);
      var currentStores = [oldBlockchat.messageStore.call(), oldBlockchat.keyStore.call()];
    }
    return Promise.all(currentStores || ['0x0', '0x0']);
  })
  .then(([messageStore, keyStore]) => {
    if (messageStore == '0x') messageStore = '0x0';
    if (keyStore == '0x') keyStore = '0x0';

    console.log('Deploying blockchat with stores', messageStore, keyStore);
    return deployer.deploy(BlockChat, messageStore, keyStore, true);
  })
  .then(() => {
    if (oldBlockchat)
      console.log('Suiciding and migrating old blockchat permissions...')
      return oldBlockchat.migrateContract(BlockChat.deployed().address);
    return Promise.resolve();
  })
  .catch((e) => console.log('Error deploying BlockChat', e));
};
