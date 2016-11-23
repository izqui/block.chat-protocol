module.exports = function(deployer) {
  deployer.then(() => {
    console.log()
    if (BlockChat.address) {
      var currentStore = BlockChat.at(BlockChat.address).messageStore.call();
    }
    return currentStore || Promise.resolve('0x0');
  })
  .then((store) => {
    console.log('Deplying blockchat with store', store);
    return deployer.deploy(BlockChat, store, true);
  })
  .catch((e) => console.log('Error deploying BlockChat', e));
};
