/* TEAM 10 Proposal Project : 

NAME: "MINT your VOTE!" - RANDOM~ELECTIONZ (RECZ) 

DESCRIPTION:

- Pizza or Beer ... Which is better?

1) MINT your VOTE, as an NFT - to your Wallet. "I Voted".

2) ELECTION RESULTS counted - at DEADLINE (endElection).

3) NFT MINT of ELECTION RESULTS, pizza or beer - into Wallet of VOTERS. 



KEY PRINCIPLES:

- minimalistic boilerplate (MVP) - Dramatically Simplified Voting System (DSVS)

- extensible, modular "stubs", to EXTEND implementation, with Strategy (later).

- anonymous, wallet address has the VOTE, for the wallet. [Triangle of trust (below)]

- MINT your VOTE! - NFTs minted(burned) - representing VOTE.

- Pseudo-Anonymous Random Elections. 


EXTENSION-EXAMPLES:

- Random Elections: Pirate or Ninja, Cake or Ice-cream.

- Random Election: Do Unicorns|Yeti|Aliens Exist?

- Random~Elections: | By Zipcode: Peanut Butter or Jelly?

DESCRIPTION:

- MINIMAL UI, and Web3.

    1) connect wallet
    2) Pizza... or Beer? VOTE!

    ADMIN: 
    1) start election 
    2) stop election


SIMPLIFICATIONS of COMPLEXITY "STUBS" - to extend (later) :

Identity Validation - simplified to ZIPCODE and WALLET ADDRESS

Quadratic Voting - simplified to Pizza or Beer (2 uints: 0 no vote, 1=pizza, 2=beer).

GeoLocation - simplified by allowing user entry zipcode in ui - on registration.

Dynamic Voting (config) - simplified to static: Pizza or Beer Random~Election.

High FIdelity information -  education, comments, feedback phase - add to vote view.

ZIPCODE - simplified to wallet address, as "trustless vote".

DEADLINE - simplified to endElection()

MINT on POLYGON - simplified to GOERLI TEST NET.

MINT on Web3 - simplified to MINT on DEPLOY, as TEST.

UNLIMITED VOTING - simplified by overwrite vote, change your vote - up until endElection().
                 - this can be used as a Quadratic Voting stub.

CUMULATIVE NFT MINTING - no need to BURN previouse votes - simplified.

//END SIMPLIFICATION STUBS.


TRIANGLE-OF-TRUST (simplified - anonymous voting)

1) VOTER from ZIPCODE, moved to COLORADO, gets WALLET address from COLORADO.

2) COLORADO has ELECTION, for ZIPCODE, Wallet Notified.

3) VOTER uses Wallet to cast VOTE in ELECTION.

- anonymous, only COLORADO knows the owner of address (zkProof).

5) ELECTION CHECKS with COLORADO - wallet address valid?


DESIGN: 

a) MINIMAL ADMIN

startElection(); //if election is not running, start accepting votes.

endElection(); //stop election, tabulate, mint, clean slate.

---------

b) MINIMAL VOTER UI

wallet, CHOICE. Submit.

mint NFT to wallet.

c) VOTING RESULTS

endElection(); tabulate votes and mint NFT VOTE RESULTS to all voters.

*/

//USE-CASES:
// PIZZAorBEER - minimum voting system. MINT YOUR VOTE.
// 1) wallet address connects to Web3, 
// 2) VOTER selects PIZZA or BEER button, 
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
// import "@openzeppelin/contracts/access/Ownable.sol"; //for onlyOwner and owner()
// import "@openzeppelin/contracts/utils/Counters.sol"; //unnecessary use totalSupply()+1
import "@openzeppelin/contracts/utils/Base64.sol"; //Used for CASTVOTE NFT creation.
import "hardhat/console.sol";
/// @custom:security-contact spazefalcon4@protonmail.com
// contract Random_Vote is ERC721Enumerable, Ownable { //Enumerable for totalSupply
contract Random_Vote is ERC721Enumerable { //Enumerable for totalSupply
// contract Random_Vote is ERC721, Ownable {
    using Strings for uint256; //for tokenId.toString()
    using Strings for uint8;   //for vote.toString()

    // using Counters for Counters.Counter; //dont neet because of supply()+1
    // Counters.Counter tokenIdCounter;

    mapping (address => uint8 ) public walletVotes; 
    // address[] public walletIndex = [address(0)]; //PROBLEMS with MAPPING (cant loop): at tokenId, put the wallet address. Use

    bool electionRunning = true; /// @dev default false - after dev TODO
    /// @dev See: Storage
    mapping(uint256 => string) private _tokenURIs; // mapping for token URIs: holds ipfs AND json.
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

  function autoBatchMint() private { // TEST MINTS. - run by constructor.
    uint256 supply = totalSupply(); //See {IERC721Enumerable-totalSupply}.
    require(!paused);
    uint256 _mintAmount = 3;
    require(_mintAmount > 0);
    require( totalSupply() <= maxVoteSupply); //MINT MAX
    require(supply + _mintAmount <= maxVoteSupply); //less than maximum votes allowed.
    //AUTOMATIC BATCH MINT
    for (uint8 i = 1; i <= _mintAmount; i++) {
        console.log(supply+ i);
        _safeMint(msg.sender, supply + i);
        setVoteTokenURI(supply + i, i); //STUB TEST 1 or i = 1|2|3
    }
  }

  /// @dev this is to test batch mint - remove in prod
  function setVoteTokenURI(uint256 tokenId, uint8 vote) public returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
    // require(baseURI,"no base.");
    string memory voteURL = "";
    walletVotes[msg.sender] = vote;  //overwritten, 1,2,3!
    // walletIndex.push(msg.sender); //TRACK INDEX fix for mapping no loop.
    voteURL = string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));  
    _setTokenURI(tokenId,voteURL);
    return voteURL;
  }

  function castNFTVote(address to, uint8 vote) public returns (string memory) {
      require(!paused);
      require(to != address(0), "bad address");
      require((vote ==1 || vote ==2), "bad vote");
      require( totalSupply() <= maxVoteSupply); //MINT MAX
      //---------------------------
      //PREPARE THE VOTE...MINT.
      string memory voteURL = "";
      string memory imageURLIPFS = "3";
      if(vote==1){ //selection 1 img
        imageURLIPFS = "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/1.jpg";
      } else if (vote==2){ //or selection2 img
        imageURLIPFS = "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/2.jpg";
      }
      walletVotes[to] = vote; //STUB (below also)
    //   walletIndex.push(to); //TRACK INDEX fix for mapping no loop.
      voteURL = string(abi.encodePacked(baseURI, vote.toString(), ".json")); 
      //------------------------------------
      // JSON - Encode Base64 - metadata-----------
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                    '{"name": "',
                    string( abi.encodePacked( "Vote", Strings.toString(totalSupply()+1) ) ),
                    '", "description": "descripto...", "image": "',
                    imageURLIPFS,
                    '"}'
                  )
              )
          )
      );
      // JSON - end encode-------------------------
      string memory finalJSONTokenUri = string( // Prefix: data:application/json;base64
          abi.encodePacked("data:application/json;base64,", json)
      );
      // MINT vote--------------------------------
      _safeMint(to, totalSupply()+1);
      _setTokenURI(totalSupply(),finalJSONTokenUri); //This is not URL, but json obj. Saved in _tokenURIs[];
      //LATER this JSON is retrieved with _tokenURIs[tokenId]; No actual IPFS url, but Base64 encoded JSON string!
      //END MINT vote-----------------------------
      return "Vote Minted!";
  }

  /// BELOVED - TOKENURI ----------------------------------------

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
    //Important: rely on _tokenURIs mapping.
    string memory _tokenURI = _tokenURIs[tokenId];
    return _tokenURI;
  }
 /// END BELOVED - TOKENURI---------------------------------------

 /// ADMIN -------------------------------------
  //START ELECTION: record votes.
  function startElection() public { //todo onlyadmin
      require(electionRunning, "Already running");
      electionRunning = true;
      //RESET all ELECTION memory. TODO.
  }

  function pause(bool _state) public { //TODO OnlyAdmin or onlyOwner
    paused = _state;
  }

  function endElection() public { //todo onlyadmin
      require(!electionRunning, "No election");
      electionRunning = false;
      //TABULATE ELECTION RESULTS
      //MINT NFT to all VOTERS.
      tabulateVOTEmintSVG(msg.sender); //TODO loop over walletVoters???
  }

/// - END ELECTION TALLY and LIVE STATISTICS --------------------------------
//   function electionStats() public returns (string memory){ //TODO return count of voters and count of votes.
//     string memory statsJSON = "";
//     uint256 totalVotes = totalSupply();
//     address addressTGT = address(0);
//     uint8 voteTGT = 0;
//     // uint8 uniqueVoters = 0;
//     // uint8 totalVoters = walletVotes.length;
//     uint8 totalVotes1 = 0;
//     uint8 totalVotes2 = 0;
//     //uset tokenId to get vote
//     // walletIndex.push(msg.sender); //TRACK INDEX fix for mapping no loop.
//     for (uint8 i = 1; i <= totalVotes; i++) {
//       addressTGT = walletIndex[i]; //use tokenId to get vote, from mapping.
//       voteTGT = walletVotes[addressTGT];
//       if(voteTGT == 1){
//         totalVotes1++;
//       } else if (voteTGT == 2){
//         totalVotes2++;
//       }
//     }
//     // statsJSON = string.concat("{",'"abc"',":",'"123"',"}"); //solidy no worky need abi :)
//     return statsJSON;
//   }

  function tabulateVOTEmintSVG(address to) public view returns (string memory) { 
      //GET VOTE from tokenID
      require(!paused);
      require(to != address(0), "bad address");
    //   require((vote ==1 || vote ==2), "bad vote");
      //---------------------------
    //   //PREPARE THE VOTE...MINT.
    //   string memory voteURL = "";
    //   string memory imageURLIPFS = "3";
    //   if(vote==1){
    //     imageURLIPFS = "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/1.jpg";
    //   } else if (vote==2){
    //     imageURLIPFS = "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/2.jpg";
    //   }
    //   // walletVotes[msg.sender] = 2;  //vote; //STUB (below also)
    //   walletVotes[to] = vote; //STUB (below also)
    //   // string memory voteStr = "1"; //STUB
    //   // voteURL = string(abi.encodePacked(baseURI, voteStr, ".json")); 
    //   voteURL = string(abi.encodePacked(baseURI, vote.toString(), ".json")); 
    //   console.log(voteURL);
    //   //------------------------------------
    //   // JSON - Encode Base64 - metadata-----------
    //   string memory json = Base64.encode(
    //       bytes(
    //           string(
    //               abi.encodePacked(

    //                     // '{"name": "',
    //                     // string(
    //                     //     abi.encodePacked(
    //                     //         "Placeholder NFT (ERC721A) #",
    //                     //         Strings.toString(tokenId)
    //                     //     )
    //                     // ),
    //                     // '", "description": "ion.", "image": "data:image/svg+xml;base64,PHNOTYg=="}'
  

    //                 '{"name": "',
    //                 string( abi.encodePacked( "Vote", Strings.toString(totalSupply()+1) ) ),
    //                 '", "description": "descripto...", "image": "',
    //                 imageURLIPFS,
    //                 '"}'
    //               )
    //           )
    //       )
    //   );
    //                 // string( abi.encodePacked( "vote", Strings.toString(tokenId) ) ),
    //                   // '", "description": "descripto...", "image": "ipfs://bafybeicymzff6xcetv7egchzx4j5l5h5yuoso33ydruflixq6kdodqj2b4/2.jpg"}'                      
    //   // JSON - end encode-------------------------

    //   string memory finalJSONTokenUri = string( // Prefix: data:application/json;base64
    //       abi.encodePacked("data:application/json;base64,", json)
    //   );

    //   // MINT vote--------------------------------
    //   _safeMint(to, totalSupply()+1);
    //   // _safeMint(msg.sender, totalSupply()+1);      
    //   _setTokenURI(totalSupply(),finalJSONTokenUri); //This is not URL, but json obj. Saved in _tokenURIs[];
      //LATER this JSON is retrieved with _tokenURIs[tokenId]; No actual IPFS url!
      //END MINT vote-----------------------------
      return "ELECTION-FINAL!";
  }


}

//TEST-CASES
//PARAMS: "Random~Electionz", "PIZZAorBEER"
//X - DEPLOY-goerli -true
//> 1) Constructor - TEST MINTS
//Assert - 3 NFTs.
//X - NAME & SYMBOL //true with PARAM
//X - totalSupply() = 3 //true
//X - ownerOf(1|2|3) = 0x97 //true //not part of ownable
//X - balanceOf(0x97) = 3 //true  //VOTES CAST. //not part of ownable
//X - walletVotes[0x97] = 1 (3)? //true 1,2,3
//X - _getTokenURI(1|2|3) tokenID //true //TODO remove
//X - tokenURI(1|2|3) = "nft/ipfs/bafy/1.json = true
//View - 3 NFTs on goerli test net?
//TEST URLS: TAKE Deploy CONTRACT ID, 0x6774D9218d5d4211836c8F39833432Ac7B0D6773
//X - GOERLI-TESTNET-ETHERSCAN:https://goerli.etherscan.io/address/0x6774d9218d5d4211836c8f39833432ac7b0d6773
//X - RARIBLE-TESTNET:https://testnet.rarible.com/collection/0x6774d9218d5d4211836c8f39833432ac7b0d6773/items
//X - OPENSEA - COLLECTION:https://testnets.opensea.io/collection/a11 //working. 
//X - OPENSEA - ITEM: https://testnets.opensea.io/assets/goerli/0xe3d083ae3c23e644e34c424ca892ffe94e312c90/1 //working
//X - BASEURI = "https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/"
//> 3)  castNFTVote - TEST MINTS 0x97
//X - castVOTENFT (0xf2, 1|2) //(addr to, vote, tokenID)
//X - tokenURI(4) tokenID
//X - MINT to COLLECTION - new Vote... Open Sea?
//X - OPENSEA - ITEM: https://testnets.opensea.io/assets/goerli/0xe3d083ae3c23e644e34c424ca892ffe94e312c90/4
//X - totalSupply() = 4 //true
//> 4) multiple castVoteNFT
//X - totalSupply() = 5 //true
//X - 3 pizza and 3 beer
//X - totalSupply() = 7 //true

//TODO:

// tally voters and votes on endElection

// MINT NFT of results on endElection

//electionStats() - return election state. 

//REPEAT VOTE, change URI?

//startRandomElection() - test cases, error cases?
//endRandomElection() - test cases, error cases?

//generate REMIX tests

//Extend to Dynamic Election

//Mapping Loop issues and string encode JSON issues.
//721 does not need balance for vote? 

//remove batch vote test.

//Security tasks

//add more require around vote

//onlyAdmin replacement for onlyOwner

//Make Functions and Variables private.

//mint limits? maxVoteSupply

//pausible


//PRESENTATION:

//-confirm test script (mints)
//-add end election functionality