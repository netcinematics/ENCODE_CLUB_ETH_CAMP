/* Add NFT with IPFS Behavior to Volcano coin */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract KBZ_set002_ENUM is ERC721Enumerable, Ownable {
  using Strings for uint256;
  uint256 public maxSupply = 22;
  uint256 public maxMintAmount = 22;
  uint256 public cost = 0.02 ether;
  string baseURI;
  bool public paused = false;
  constructor(string memory _name, string memory _symbol
  ) ERC721(_name, _symbol) {
    _name = "KryptoBitz set002";
    _symbol = "KBZ";
    setBaseURI("ipfs://QmPgP5z1Mu9BeWcCr5jaFoCLCFqFoxXTxKM2GrUhUd8cAx/");
    mint(maxSupply);
  }
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }
    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
        : "";
  }
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }
  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}