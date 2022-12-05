/* TEAM 10 Proposal Project : 

NAME: "MINT your VOTE!" - RANDOM~ELECTIONZ (RECZ) 

DESCRIPTION:

- Pizza or Beer ... Which is better?

1) MINT your VOTE, as an NFT - to your Wallet. "I Voted".

2) ELECTION RESULTS counted - at DEADLINE (endElection).

3) Historic, NFT MINT of ELECTION RESULTS, pizza or beer - into Wallet of VOTERS. 

4) (Pseudo-Anonymous) Random Elections


KEY PRINCIPLES:

- minimalistic boilerplate (MVP) - Dramatically Simplified Voting System (DSVS)

- extensible, modular "stubs", to EXTEND implementation, with Strategy (later).

- anonymous, wallet address has the VOTE, for the wallet. [Triangle of trust (below)]

- MINT your VOTE! - NFTs minted(burned) - representing VOTE.

POTENTIAL-EXAMPLES:

- Random Election: Do Unicorns|Yeti|Aliens Exist?

- Random~Elections: | By Zipcode: Peanut Butter or Jelly?

DESCRIPTION:

- GOAL: MINIMAL UI, and Web3.

    1) connect wallet
    2) Pizza... or Beer? VOTE!

    ADMIN: 
    1) start election 
    2) stop election


- GOAL: MINT the VOTE, of the team, - for your preference.

- GOAL: NFT reciept of participation - MINT RESULTS of Election.

- What's YOUR VOTE - Pizza or Beer?

- Peanut Butter or Jelly?

Complexity "STUBS" :

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

1) VOTER from ZIPCODE, moved to COLORADO, gets WALLET address

2) COLORADO has ELECTION, for ZIPCODE, Wallet Notified.

3) VOTER uses Wallet to cast VOTE in ELECTION.

- anonymous, only COLORADO knows the owner of address (zkProof).

5) ELECTION CHECKS with COLORADO - wallet address in ZIPCODE? valid?

6) ELECTION completed with valid votes - and is anonymous.



KEY-INTERACTIONS (use-cases):

1 - VOTER attaches Web3 Wallet to website on GitHub.

2 - VOTER enters PIZZA or BEER, clicks VOTE. ZIPCODE(optional), WALLET ADDRESS(required).

3 - VOTER receives Digital NFT VOTE Sticker. "I voted".

4 - VOTE goes to ELECTION-CONTRACT: wallet and zipcode.

5 - ELECTION CONTRACT, RUNS ELECTION - Pizza or Beer - up until (DEADLINE) endElection().

6 - At endElection(), votes tabulated, RESULTS NFT MINTED, and sent to VOTER Wallets.


ENTITY: 

NAME: RANDOM~ELECTIONS

DESIGN: 

a) MINIMAL ADMIN

startElection(); //if election is not running, start accepting votes.

endElection(); //stop election, tabulate, mint, clean slate.

---------

b) MINIMAL VOTER UI

wallet, CHOICE. Submit.


-----------
c) VOTING STICKER NFT

castVote(); //if election running, and zipcode, and hasnt voted yet. log vote.

mint NFT to wallet.

d) VOTING RESULTS

endElection(); tabulate votes and mint NFT VOTE RESULTS to all voters.




*/

// PIZZAorBEER - absolute minimum voting system.
// MINT YOUR VOTE - PIZZAorBEER.

// 1) wallet address connects to Web3, 
// 2) VOTER selects PIZZA or BEER, 
// 3) VOTER clicks VOTE button. Pizza or Beer is MINTED to VOTER Wallet.
// 4) when the election ends, ELECTION RESULTS MINTED as NFT - to VOTER Wallets.

//IMAGE-CREDITS | All CC0 SVG :
//https://www.svgrepo.com/svg/90628/pizza
//https://www.svgrepo.com/svg/30475/beer
//https://www.svgrepo.com/svg/7938/vote
//illustration/concept by spazefalcon 2022
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
contract Random_Vote is ERC721Enumerable, Ownable { //for totalSupply
// contract Random_Vote is ERC721, Ownable {
    using Strings for uint256;
    using Strings for uint8;

    mapping (address => uint8 ) public walletVotes; 
    bool electionRunning = false;
    /// @dev See: Storage
    mapping(uint256 => string) private _tokenURIs; // Optional mapping for token URIs
    /// @dev See: Enumerable
    // Array with all token ids, used for enumeration
    // uint256[] public _allVoteTokens;  //TODO make this private
    // mapping(uint256 => uint256) public _allVoteTokensIndex;   // Mapping from token id to position in the allTokens array
    uint256 public maxVoteSupply = 100;
    string public baseURI;
    bool public paused = false;

  constructor(string memory _name, string memory _symbol
  ) ERC721(_name, _symbol) {
    //console.log("CONSTRUCTOR-TIME");
    // _name = "1Random~Electionz";
    // _symbol = "2PIZZAorBEER";
    //SET FROM NFT.STORAGE:
    baseURI = "https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/";
    //https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/1.json
    // setBaseURI("https://nftstorage.link/ipfs/bafybeiffqgslzarimnslbctkbnxdaffy7djrorvqic7bbdvrpspnqnxu4q/");
    // setBaseURI("ipfs://QmPgP5z1Mu9BeWcCr5jaFoCLCFqFoxXTxKM2GrUhUd8cAx/"); //broke.
    // autoBatchMint(maxSupply);
    autoBatchMint();
  }

  function autoBatchMint() private {
    console.log("AUTOBATCH");
    uint256 supply = totalSupply(); //See {IERC721Enumerable-totalSupply}.
    console.log(supply);
    require(!paused);
    uint256 _mintAmount = 3;
    require(_mintAmount > 0);
    // require(_mintAmount <= maxVoteSupply);
    // require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxVoteSupply); //less than maximum votes allowed.
    if (msg.sender != owner()) {
      //IF NOT OWNER value greater than cost by mintAmount
    //   require(msg.value >= cost * _mintAmount);
    } else {
        console.log('minting');
        //AUTOMATIC BATCH MINT
        for (uint8 i = 1; i <= _mintAmount; i++) {
            console.log(supply+ i);
            _safeMint(msg.sender, supply + i);
            setVoteTokenURI(supply + i, i); //STUB 1 or i = 1|2|3
        }
    }
  }

  function setVoteTokenURI(uint256 tokenId, uint8 vote) public returns (string memory){
    require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
    // string memory currentBaseURI = _baseURI();
    //IF BASEURI then CONCATENATE else "" - return STRING.
    // require(baseURI,"no base.");
    console.log('build Vote URI');
    console.log(vote);
    string memory voteURL = "";
    // if(bytes(baseURI)){
        // if(vote == 1){
            console.log(tokenId.toString());
            walletVotes[msg.sender] = vote;  //overwritten, 1,2,3!
            // voteURL = string(abi.encodePacked(baseURI, vote, ".json"));
            // voteURL = string(abi.encodePacked(baseURI, "2", ".json")); //worked?  
            //TODO: add token COUNTER?.
            voteURL = string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));  
            //MINT NFT "I Voted Sticker"
            // _safeMint(msg.sender, tokenId);
            // console.log(totalSupply()+1);
            //params: tokenID, URI
            _setTokenURI(tokenId,voteURL);

        // }
        
    // }
    console.log(voteURL);
    // return bytes(baseURI).length > 0 //IF BASE URI, then pack
    //     ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
    //     : "";
    return voteURL;
  }

  /// @dev - require Storage to setTokenURI (very bottom).
  function castVote( uint8 vote ) public {
      //Check msg.sender
            console.log("cast vote");
          string memory voteURL = "";
    //   require(msg.sender,"bad sender");
      //Check vote is either 1 or 2.
    //   if(!_exists(voterAddr)){
        //  votes[voterAddr] = vote;
    //   } else {
        walletVotes[msg.sender] = vote;
    //   }
        string memory voteStr = "1"; //STUB
        voteURL = string(abi.encodePacked(baseURI, voteStr, ".json")); 

        // if(voteStr == string(1)){
            // console.log(tokenId.toString());
            // votes[msg.sender] = vote;
              
        // }

    //   require(vote == 1 || vote == 2, "invalid vote");
      //Check msg.sender didn't already vote
      //Add msg.sender to vote role with vote number.
      
      //MINT NFT "I Voted Sticker"
      _safeMint(msg.sender, totalSupply()+1);
      // console.log(totalSupply()+1);
      //params: tokenID, URI
      _setTokenURI(totalSupply(),voteURL);
  }

  // function castVOTENFT(uint256 tokenId, uint8 vote) public returns (string memory) {
  function castNFTVote(address to, uint8 vote, uint256 tokenId) public returns (string memory) {
       //TEST PARAMS: (0x46f, 2, 4|5|6)
        // if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
       // if(vote not 1,2,3) revert //TODO
      //---------------------------
      //PREPARE THE VOTE...MINT.
      string memory voteURL = "";
      // walletVotes[msg.sender] = 2;  //vote; //STUB (below also)
      walletVotes[to] = 2;  //vote; //STUB (below also)
      string memory voteStr = "1"; //STUB
      voteURL = string(abi.encodePacked(baseURI, voteStr, ".json")); 
      //------------------------------------



      // JSON - Encode Base64 - metadata-----------
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(

                        // '{"name": "',
                        // string(
                        //     abi.encodePacked(
                        //         "Placeholder NFT (ERC721A) #",
                        //         Strings.toString(tokenId)
                        //     )
                        // ),
                        // '", "description": "ion.", "image": "data:image/svg+xml;base64,PHNOTYg=="}'
  

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
      console.log("minting to");
      // console.log(msg.sender);
      console.log(to);
      
      console.log(totalSupply()+1);
      //params: tokenID, URI
      _safeMint(msg.sender, totalSupply()+1);
      _setTokenURI(totalSupply(),finalJSONTokenUri); //This is not URL, but json obj. Saved in _tokenURIs[];
      //LATER this JSON is retrieved with _tokenURIs[tokenId]; No actual IPFS url!
      //END MINT vote-----------------------------
      return "Vote Minted!";

  }

  function castVOTESVG() public view { //todo remove
    console.log("Minting...");
    // uint256 newItemId = _tokenIds.current(); //TODO.

    // string memory first = pickRandomFirstWord(newItemId);
    // string memory second = pickRandomSecondWord(newItemId);
    // string memory third = pickRandomThirdWord(newItemId);
    // string memory combinedWord = string(abi.encodePacked(first, second, third));
    // console.log(combinedWord);
    // string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = ""; //Base64.encode(
      //   bytes(
      //         string(
      //             abi.encodePacked(
      //                 '{"name": "',
      //                 // We set the title of our NFT as the generated word.
      //                 combinedWord,
      //                 '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
      //                 // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
      //                 Base64.encode(bytes(finalSvg)),
      //                 '"}'
      //             )
      //         )
      //     )
      // );

      // Just like before, we prepend data:application/json;base64, to our data.
      string memory finalTokenUri = string(
          abi.encodePacked("data:application/json;base64,", json)
      );

      console.log("\n-----FinalURI---------------");
      console.log(finalTokenUri);
      console.log("--------------------\n");

      // _safeMint(msg.sender, newItemId);
      
      // // Update your URI!!!
      // _setTokenURI(newItemId, finalTokenUri);
    
      // _tokenIds.increment();
      // console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
  }

  /// - SVG NFT
// function tokenURI(uint256 tokenId) public view override returns (string memory) {
//     _requireMinted(tokenId);

    // Point[] memory points = new Point[](NUM_POLYS * NUM_POINTS_PER_POLY);

    // (uint256 randX, uint256 randY) = multiply(tokenId, 888, 777);

    // for (uint256 i = 1; i <= NUM_POLYS * 3; i++) {
    //   (uint256 pX, uint256 pY) = multiply(randX, randY, i);
    //   points[i - 1] = Point({ x: pX, y: pY });
    // }

    // string memory allPolys = "";
    // for (uint256 i = 0; i < NUM_POLYS; i++) {
    //   string memory coordinates = "";
    //   for (uint256 j = 0; j < NUM_POINTS_PER_POLY; j++) {
    //     coordinates = string(abi.encodePacked(coordinates, Strings.toString(points[i * NUM_POINTS_PER_POLY + j].x), ',', Strings.toString(points[i * NUM_POINTS_PER_POLY + j].y), ','));
    //   }
    //   allPolys = string(abi.encodePacked(allPolys, "<polygon points='", coordinates, "' fill='hsla(", Strings.toString(points[i * NUM_POINTS_PER_POLY].x % 59), ",100%,", Strings.toString((points[i * NUM_POINTS_PER_POLY].x % 20) + 50), "%,0.5)' stroke='none' />"));
    // }

    // string memory svgImage = string(
    //   abi.encodePacked(
    //     '<?xml version="1.0" encoding="UTF-8"?>',
    //     '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="350px" height="350px" viewBox="0 0 997 997" style="background-color:#fff">',
    //       allPolys,
    //     '</svg>'
    //   )
    // );

    // string memory base64Image = Base64.encode(bytes(svgImage));

    // https://github.com/karooolis/placeholder-nft/blob/main/contracts/contracts/PlaceholderNFTERC721.sol
    // string memory metadata = Base64.encode(
    //   bytes(
    //     string(
    //       abi.encodePacked(
    //         '{"name": "',
    //         string(
    //             abi.encodePacked(
    //                 "Volcano NFT #",
    //                 Strings.toString(tokenId)
    //             )
    //         ),
    //         '", "attributes": [], "description": "Volcano NFTs are randomly generated images of an erupting volcano!", "image": "data:image/svg+xml;base64,', base64Image, '"}'
    //       )
    //     )
    //   )
    // );

    // return string(abi.encodePacked("data:application/json;base64,", metadata));
  // }



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
    // string memory currentBaseURI = _baseURI();
    //IF BASEURI then CONCATENATE else "" - return STRING.
    // console.log('tokenuri');
    // console.log(string(abi.encodePacked(baseURI, tokenId.toString(), ".json")));
  // if(tokenId==4){
    //LOOK UP JSON METADATA from base64? _tokenURIs[tokenId]; testURILookUp
        _requireMinted(tokenId);

        //TEST 1: rely on _tokenURIs mapping.
        string memory _tokenURI = _tokenURIs[tokenId];
        // string memory base = _baseURI();
        console.log("token4");
        console.log(_tokenURI);
       return _tokenURI;

       //TEST 2: ask the super class?
       // return super.tokenURI(tokenId);


        // If there is no base URI, return the token URI.
        // if (bytes(base).length == 0) {
        //     return _tokenURI;
        // }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        // if (bytes(_tokenURI).length > 0) {
        //     return string(abi.encodePacked(base, _tokenURI));
        // }

        // return super.tokenURI(tokenId);

      // } else {
      //     return bytes(baseURI).length > 0
      //       ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
      //       : "";
      // }
    //TODO need to look up URI set in votes[addr] = 0|1|2 //tokenId.toString()
    // return bytes(baseURI).length > 0
    //     ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
    //     : "";
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


//   function setCost(uint256 _newCost) public onlyOwner {
//     cost = _newCost;
//   }
//   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
//     maxMintAmount = _newmaxMintAmount;
//   }

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



