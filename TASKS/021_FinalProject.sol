/* TEAM 10 Proposal Project : 

SETUP: paste code into Remix...

NAME: "MINT your VOTE!" - RANDOM~ELECTIONZ (RECZ) 

DESCRIPTION:

- Pizza or Beer ... Which is better?

1) MINT your VOTE, as an NFT - to your Wallet. "I Voted".

2) ELECTION RESULTS counted - at DEADLINE (endElection).

3) NFT MINT of ELECTION RESULTS (pizza or beer|pirate or ninja) into VOTER Wallet! 

4) (Pseudo-Anonymous) Random Elections.


KEY PRINCIPLES:

- minimalistic boilerplate (MVP) - Minimal Simplified Voting System (MSVS)

- extensible, modular "stubs", EXTEND implementation, with Strategy (described below).

- anonymous, wallet address VOTES. [Triangle of trust (below)]

- MINT your VOTE! - NFTs minted(burned) - representing VOTE.


Something that could be added later...
DYNAMIC - ELECTION - EXAMPLES:

- Random~Elections: Pirate or Ninja?

- Random Election: Do Unicorns|Yeti|Aliens Exist?

- Random~Elections: | By Zipcode: Peanut Butter or Jelly?


DESCRIPTION:

- GOAL: MINIMAL UI, and Web3.

    1) connect wallet
    2) Pizza... or Beer? VOTE!

    ADMIN: 
    1) start election 
    2) stop election


- WORKING: MINT the VOTE, to wallet, - of your preference.

- TODO: Unit Tests

- TODO: Start stop Election. 

- TODO: MINT RESULTS of Election.

- TODO: UI - What's YOUR VOTE - Pizza or Beer?

- TODO: NFT reciept of participation (I voted sticker)


Complexity "STUBS" : 

- Things simplified - to get to MVP - can extend later:

Identity Validation - simplified to ZIPCODE and WALLET ADDRESS

Quadratic Voting - simplified to Pizza or Beer (2 uints: 0 no vote, 1=pizza, 2=beer).

GeoLocation - simplified by allowing user entry zipcode in ui - on registration.

Dynamic Array of Proposals - simplified to static: Pizza or Beer Random~Election.

High FIdelity information, education, comments, feedback phase 

- simplified by RANDOM~ELECTIONS. Votes about nothing.

ZIPCODE - simplified to wallet address, as "unverified vote".

DEADLINE - simplified to endElection()

MINT on POLYGON - simplified to GOERLI TEST NET.

MINT on Web3 action - simplified to MINT on DEPLOY, as TEST.

UNLIMITED VOTING - simplified by overwrite vote, change your vote - up until endElection().

CUMULATIVE NFT MINTING - no need to BURN previouse votes - simplified.

//END SIMPLIFICATION STUBS.



TRIANGLE-OF-TRUST (simplified - anonymous voting) 

- This is one way anonymous voting could work...(with zkProof)

1) VOTER from ZIPCODE, moved to COLORADO, gets WALLET address from COLORADO.

2) COLORADO has ELECTION, for ZIPCODE, Wallet Notified.

3) VOTER uses Wallet to cast VOTE in ELECTION.

- all voted visible on blockchain, but anonymous, 
- if only COLORADO knows the owner of address 
- Name, Address, Identity - hidden by (zkProof).

5) ELECTION VALIDATES with COLORADO - wallet address in ZIPCODE? valid?



KEY-INTERACTIONS (use-cases):

1 - VOTER attaches Web3 Wallet to website on GitHub. WALLET ADDRESS(required).

2 - VOTER sees PIZZA or BEER buttons, chooses, and clicks VOTE. 

3 - VOTER receives Digital NFT VOTE.

4 - ELECTION CONTRACT, RUNS ELECTION - Pizza or Beer - up until endElection().

6 - At endElection(), votes tabulated, RESULTS NFT MINTED, and sent to VOTER Wallets.


----------------
a) MINIMAL ADMIN

startElection(); //if election is not running, start accepting votes.

endElection(); //stop election, tabulate, mint, clean slate.

---------

b) MINIMAL VOTER UI

wallet, CHOICE. Submit.

mint NFT to wallet.

-----------

c) VOTING RESULTS

endElection(); tabulate votes and mint NFT VOTE RESULTS to all voters.




*/

// PIZZAorBEER - absolute minimum voting system. ~ MINT YOUR VOTE 

// 1) wallet address connects to Web3, 
// 2) VOTER selects PIZZA or BEER, 
// 3) VOTER clicks VOTE button. Pizza or Beer is MINTED to VOTER Wallet.
// 4) when the election ends, ELECTION RESULTS MINTED as NFT - to VOTER Wallets.

//IMAGE-CREDITS | All CC0 SVG :
//https://www.svgrepo.com/svg/90628/pizza
//https://www.svgrepo.com/svg/30475/beer
//https://www.svgrepo.com/svg/7938/vote
//OpenZeppelin721: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
//OpenZeppelinEnumerable: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
//OpenZeppelinStorage: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; //total supply
import "@openzeppelin/contracts/access/Ownable.sol"; //TODO: needed?
import "@openzeppelin/contracts/utils/Base64.sol"; //Used for CASTVOTE NFT creation.
import "hardhat/console.sol";
/// @custom:security-contact netcinematics@protonmail.com
contract Random_Election is ERC721Enumerable, Ownable { //for totalSupply
// contract Random_Vote is ERC721, Ownable {
    using Strings for uint256;
    using Strings for uint8;

    mapping (address => uint8 ) public walletVotes; 
    bool electionRunning = false;
    /// @dev See: Storage
    mapping(uint256 => string) private _tokenURIs; // Optional mapping for token URIs
    /// @dev See: Enumerable
    uint256 public maxVoteSupply = 100;
    string public baseURI;
    bool public paused = false;

  constructor(string memory _name, string memory _symbol
  ) ERC721(_name, _symbol) {
    //SET FROM NFT.STORAGE:
    baseURI = "https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/";
    autoBatchMint();
  }

  function autoBatchMint() private {
    uint256 supply = totalSupply(); //See {IERC721Enumerable-totalSupply}.
    require(!paused);
    uint256 _mintAmount = 3;
    require(_mintAmount > 0);
    require(supply + _mintAmount <= maxVoteSupply); //less than maximum votes allowed.
    if (msg.sender != owner()) {
      //IF NOT OWNER value greater than cost by mintAmount
    //   require(msg.value >= cost * _mintAmount);
    } else {
        //AUTOMATIC BATCH MINT - for OPENSEA NFT TEST.
        for (uint8 i = 1; i <= _mintAmount; i++) {
            console.log(supply+ i);
            _safeMint(msg.sender, supply + i);
            setVoteTokenURI(supply + i, i); //STUB 1 or i = 1|2|3
        }
    }
  }

  function setVoteTokenURI(uint256 tokenId, uint8 vote) public returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
    string memory voteURL = "";
    walletVotes[msg.sender] = vote;  //overwritten, 1,2,3!
    //TODO: add token COUNTER?.
    voteURL = string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));  
    _setTokenURI(tokenId,voteURL);
    return voteURL;
  }

  /// @dev - require Storage to setTokenURI (very bottom).
  function castVote( uint8 vote ) public {
   string memory voteURL = "";
   walletVotes[msg.sender] = vote;
   string memory voteStr = "1"; //STUB
   voteURL = string(abi.encodePacked(baseURI, voteStr, ".json")); 
   _safeMint(msg.sender, totalSupply()+1);
   _setTokenURI(totalSupply(),voteURL);
}

function castNFTVote(address to, uint8 vote, uint256 tokenId) public returns (string memory) {
      string memory voteURL = "";
      walletVotes[to] = 2;  //vote; //STUB (below also)
      string memory voteStr = "1"; //STUB
      voteURL = string(abi.encodePacked(baseURI, voteStr, ".json")); 
      // JSON - Encode Base64 - metadata-----------
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                      '{"name": "',
                      string( abi.encodePacked( "vote", Strings.toString(tokenId) )),
                      '", "description": "descripto...", "image": "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/2.jpg"}'
                  )
              )
          )
      );
      // JSON - end encode-------------------------
      string memory finalJSONTokenUri = string( // Prefix: data:application/json;base64
          abi.encodePacked("data:application/json;base64,", json)
      );
      // MINT vote--------------------------------
      _safeMint(msg.sender, totalSupply()+1);
      _setTokenURI(totalSupply(),finalJSONTokenUri); //This is not URL, but json obj. Saved in _tokenURIs[];
      //LATER this JSON is retrieved with _tokenURIs[tokenId]; No actual IPFS url!
      //END MINT vote-----------------------------
      return "Vote Minted!";
  }

  function castVOTESVG() public view { //todo remove
    console.log("Minting...");
    string memory json = ""; //Base64.encode(
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
  }

  /// BELOVED - TOKENURI ----------------------------------------
  function _getTokenURI(uint256 tokenId) public view returns (string memory) {
    return _tokenURIs[tokenId]; //use this to TEST URL and JSON STORAGE.
  }

  /// @dev See {IERC721Storage-settokenURI}.
  function _setTokenURI(uint256 tokenId, string memory _tokenURI) public {
      require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
      _tokenURIs[tokenId] = _tokenURI;
  }
  /// @dev See {IERC721Metadata-tokenURI}.
  //RETURN CONCANTENATED URL to JSON. Where is tokenURI called?
  function tokenURI(uint256 tokenId) public view override returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
        _requireMinted(tokenId);
        //TEST 1: rely on _tokenURIs mapping.
        string memory _tokenURI = _tokenURIs[tokenId];
       return _tokenURI;
  }
 /// END BELOVED - TOKENURI---------------------------------------

  //START ELECTION: record votes.
  function startElection() public onlyOwner {
      require(electionRunning, "Already running");
      electionRunning = true;
      //RESET all ELECTION memory.
  }
  function endElection() public onlyOwner {
      require(!electionRunning, "No election");
      electionRunning = false;
      //TABULATE ELECTION RESULTS
      //MINT NFT to all VOTERS.
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
}

//TEST-CASES
//PARAMS: "Random~Electionz", "PIZZAorBEER"
//X - DEPLOY-goerli -true
//> 1) Constructor - TEST MINTS
//Assert - 3 NFTs.
//X - NAME & SYMBOL //true with PARAM
//X - totalSupply() = 3 //true
//X - ownerOf(1|2|3) = 0x97 //true
//X - balanceOf(0x97) = 3 //true  //VOTES CAST.
//X - walletVotes[0x97] = 1 (3)? //true 1,2,3
//O - _getTokenURI(1|2|3) tokenID
//View - 3 NFTs on goerli test net?
//X - tokenURI[1|2|3] = "nft/ipfs/bafy/1.json = true
//TEST URLS: TAKE Deploy CONTRACT ID, 0x6774D9218d5d4211836c8F39833432Ac7B0D6773
//X - GOERLI-TESTNET-ETHERSCAN:https://goerli.etherscan.io/address/0x6774d9218d5d4211836c8f39833432ac7b0d6773
//X - RARIBLE-TESTNET:https://testnet.rarible.com/collection/0x6774d9218d5d4211836c8f39833432ac7b0d6773/items
//X - OPENSEA - COLLECTION:https://testnets.opensea.io/collection/a11 //working. 
//X - OPENSEA - ITEM: https://testnets.opensea.io/assets/goerli/0xe3d083ae3c23e644e34c424ca892ffe94e312c90/1 //working
//X - BASEURI = "https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/"
//> 2) OWNER - TEST MINTS - change votes... 
//X - castVote(2)
//X - walletVotes[0x97] = 2 //WAIT for IT! //true.
//X - tokenByIndex(ox97,0|1|2) = 1|3; //vote //true
//X - totalSupply() = 4 //true
//X - OpenSea - COLLECTION - actually minted pizza!
//LOOK UP JSON METADATA from base64? _tokenURIs[tokenId]; testURILookUp
//> 3)  castNFTVote - TEST MINTS 0xf2063EFAA0eae66BdEC949Ab268Dcf9D074185Bf
//O - castVOTENFT (0xf2, 2, 4|5|6) //(addr to, vote, tokenID)
//O - _getTokenURI(4) tokenID
//0 - MINT, new Vote... Open Sea?
//X - OPENSEA - ITEM: https://testnets.opensea.io/assets/goerli/0xe3d083ae3c23e644e34c424ca892ffe94e312c90/4
//0 - totalSupply() = 5 //?
//0 - REPEAT VOTE, change URI?
//O - COUNTER at TEST and castVOTE?

//TODO:

//Add Token COUNTER #244 and castVote #324

//startRandomElection()

//endRandomElection()

//changeURI - Change VOTE, changes URI?
//changeVote() - reset URL

//generate REMIX tests

//721 does not need balance for vote?

//"ABC", "DEF" - token tracker and transfer ABC (DEF) - A11 is COLLECTION.

//Make Functions and Variables private.



