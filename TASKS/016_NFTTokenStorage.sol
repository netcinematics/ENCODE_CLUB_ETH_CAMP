/*  

    Use this Token to Experiment with STORAGE.

    X get an account on STORAGE.
    X upload image for volcano nft

    X NFT Metadata traits for OpenSea
    X how to automate image generation?
    X store the NFT Metadata on chain, with [Base64]

    Base64.encode - is used to create METADATA json, then 
    abi.encodePacked string finalTokenUri

    ENCODE CAMP and this TUTORIAL
    https://levelup.gitconnected.com/how-to-create-an-interactive-nft-4aeeed979138

    GOAL: run this and MINT 7 avatar IMGS.
    - can we see these NFTs any where?

*/

// SPDX-License-Identifier: MIT
/* do not use this in production */
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
contract AVATARZ_set001_EStore is ERC721Enumerable, Ownable {
  using Strings for uint256;
  uint256 public maxSupply = 7;
//   uint256 public maxMintAmount = 4;
  uint256 public cost = 0.02 ether;
  string baseURI;
//   console.log("Cant log here?");
  bool public paused = false;
  constructor(string memory _name, string memory _symbol
  ) ERC721(_name, _symbol) {
    console.log("CONSTRUCTOR-TIME");
    _name = "SpazeFalcon_AVATARZ set001";
    _symbol = "SPAZEFALCON";
    //SET FROM IPFS TO STORAGE.api:AVATARZ001data/1.json
    setBaseURI("ipfs://bafybeic66bfn42pik2y6puchu3f3cwxitaj2tuwllkkppao4m7ei2ht7z4/");
    // setBaseURI("ipfs://QmPgP5z1Mu9BeWcCr5jaFoCLCFqFoxXTxKM2GrUhUd8cAx/");
    autoBatchMint(maxSupply);
  }
  function _baseURI() internal view virtual override returns (string memory) {
    console.log("RUNTIME");
    return baseURI;
  }
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    console.log("RUNTIME");
    baseURI = _newBaseURI; //This stays in BLOCKCHAIN RUNTIME???
  }
  function autoBatchMint(uint256 _mintAmount) private {
    console.log("AUTOBATCH");
    uint256 supply = totalSupply(); //See {IERC721Enumerable-totalSupply}.
    require(!paused);
    require(_mintAmount > 0);
    // require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    if (msg.sender != owner()) {
      //IF NOT OWNER value greater than cost by mintAmount
      require(msg.value >= cost * _mintAmount);
    }
    //AUTOMATIC BATCH MINT FUNCTION
    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  //TODO: add usermint.
  //RETURN CONCANTENATED URL to JSON. Where is tokenURI called?
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
    string memory currentBaseURI = _baseURI();
    //IF BASEURI then CONCATENATE else "" - return STRING.
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
        : "";
  }
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }
//   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
//     maxMintAmount = _newmaxMintAmount;
//   }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}

/*
EXAMPLE: METADATA
{
  "identity": "1:10.2:6.3:1.4:6",
  "cardNum": 1,
  "print_date": "2021-12-20T08:56:47.929Z",
  "name": "KRYPTOBITZ #001",
  "description": "NFT Generative Art Project, 2021. HEROZ from KRYPTOSPAZE!\n NFT Collectible by spazeFalcon. All Rights Reserved 2021.",
  "image": "ipfs://QmTfu65XeZPb1aXCvhF1JbpQouaQyajbFESUPVbVRqtF4b/1.png",
  "external_url": "https://netcinematics.github.io/KRYPTOSPAZE/",
  "firstLast": 1,
  "attributes": [
    {
      "trait_type": "sky",
      "value": "SunAndMoon"
    },
    {
      "trait_type": "background",
      "value": "DarkRoad"
    },
    {
      "trait_type": "HERO",
      "value": "SPAZEBOT"
    },
    {
      "trait_type": "NAME",
      "value": "OrbyOrbot"
    },
    {
      "display_type": "boost_number",
      "trait_type": "RainboPower",
      "value": 88
    },
    {
      "display_type": "boost_percentage",
      "trait_type": "ZoomVision",
      "value": 33
    },
    {
      "trait_type": "frame_color",
      "value": "red"
    },
    {
      "trait_type": "STATUS",
      "value": "RARE",
      "display_type": "boost_percentage"
    },
    {
      "trait_type": "SLVR",
      "value": "SILVER-CARD",
      "display_type": "boost_percentage"
    },
    {
      "display_type": "boost_number",
      "trait_type": "RARE-GRADE",
      "value": "0.93"
    },
    {
      "display_type": "boost_percentage",
      "trait_type": "RARE-RATIO",
      "value": 0.07
    }
  ],
  "signature_date": "2021-12-20T09:14:01.444Z"
}
*/

/*
EXAMPLE: INTERACTIVE CUBE
// SPDXxx-License-Identifier: MIT
pragmaaa solidity ^0.8.10;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/Counters.sol";
contract InteractiveCube is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    constructor() ERC721 ("InteractiveCube", "CUBE") {}
    function mint(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenIds.increment();
        return newItemId;
    }
}
*/