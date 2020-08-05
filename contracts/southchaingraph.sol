pragma solidity >=0.4.22 <0.7.0;

contract NetworkRegistry {
  event NewNetwork(uint id, address owner, string displayName, string imageUrl);
  event UpdatedGravatar(uint id, address owner, string displayName, string imageUrl);

  struct Network {
    address owner;
    string displayName;
    string imageUrl;
  }

  Network[] public networks;

  mapping (uint => address) public gravatarToOwner;
  mapping (address => uint) public ownerToGravatar;

  function createGravatar(string _displayName, string _imageUrl) public {
    require(ownerToGravatar[msg.sender] == 0);
    uint id = networks.push(Network(msg.sender, _displayName, _imageUrl)) - 1;

    gravatarToOwner[id] = msg.sender;
    ownerToGravatar[msg.sender] = id;

    emit NewNetwork(id, msg.sender, _displayName, _imageUrl);
  }

  function getGravatar(address owner) public view returns (string, string) {
    uint id = ownerToGravatar[owner];
    return (networks[id].displayName, networks[id].imageUrl);
  }

  function updateGravatarName(string _displayName) public {
    require(ownerToGravatar[msg.sender] != 0);
    require(msg.sender == networks[ownerToGravatar[msg.sender]].owner);

    uint id = ownerToGravatar[msg.sender];

    networks[id].displayName = _displayName;
    emit UpdatedGravatar(id, msg.sender, _displayName, networks[id].imageUrl);
  }

  function updateNetworkImage(string _imageUrl) public {
    require(ownerToGravatar[msg.sender] != 0);
    require(msg.sender == networks[ownerToGravatar[msg.sender]].owner);

    uint id = ownerToGravatar[msg.sender];

    networks[id].imageUrl =  _imageUrl;
    emit UpdatedGravatar(id, msg.sender, networks[id].displayName, _imageUrl);
  }

  // the gravatar at position 0 of gravatars[]
  // is fake
  // it's a mythical gravatar
  // that doesn't really exist
  // dani will invoke this function once when this contract is deployed
  // but then no more
  function setNetwork() public {
    require(msg.sender == 0x8d3e809Fbd258083a5Ba004a527159Da535c8abA);
    networks.push(Network(0x0, " ", " "));
  }
}

