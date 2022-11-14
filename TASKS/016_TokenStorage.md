# Create IPFS behaviors with NFT.STORAGE

login with github account

upload a file.
https://bafybeiawcouoxiegpe7cu6irabklzyjbln4ihfsi6kvhmhihfwe4iwjlcu.ipfs.nftstorage.link/

A CAR is a Content Addressed Archive that allows you to pre-compute the root CID for your assets. You can pack your assets into a CAR with the ipfs-car CLI or via https://car.ipfs.io.


NOTES on how to build a 721 NFT CONTRACT!

Starting with 4 examples:
1) KryptoBitz set002 - currently in production on OpenSea
2) MyEpicNFT - example 1 from encode
3) Minty - example 2 from encode
4) "INTERACTIVE NFT" - code from: 
https://levelup.gitconnected.com/how-to-create-an-interactive-nft-4aeeed979138
5) VolcanoCoin examples from Encode Camp.

START:
Review the 721 CONTRACT:
https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC721

looking for tokenURI, never seen how that works..

```cpp
    /**
     * @dev See {IERC721Metadata-tokenURI (below)}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId); 
        //takes a TOKEN ID (ordinal 1,2,3,4,5)
        string memory baseURI = _baseURI(); //get BASE URL in baseURI.
        //TRICKY if URI concat, else ""        
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    //Safe Mint is only safe because it will revert if not RECIEVED.
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );

    //which contains this:
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }

//VERY IMPORTANT: _setTokenURI exists in STORAGEURI.
//where it sets a MAPPING of ID uint256 to STRING (url).
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
//The URL can then be looked up by tokenID
```

3) CONVERT THE JSON MetaData...

4) Upload AVATARZ with NFTUp (upload directories easily with NFTUP)


  NFT.Storage NFTUp
  CID: bafybeibhy5qvncbwmbhp3mqo67e6or2hxcymimyrk5wbnb5ipuevzatzqe
  IPFSURL: ipfs://bafybeibhy5qvncbwmbhp3mqo67e6or2hxcymimyrk5wbnb5ipuevzatzqe
  Gateway: https://nftstorage.link/ipfs/bafybeibhy5qvncbwmbhp3mqo67e6or2hxcymimyrk5wbnb5ipuevzatzqe

  CID to AUTHORCARD: bafybeiawcouoxiegpe7cu6irabklzyjbln4ihfsi6kvhmhihfwe4iwjlcu
  IPFS to AUTHORCARD:  ipfs://bafybeiawcouoxiegpe7cu6irabklzyjbln4ihfsi6kvhmhihfwe4iwjlcu
  Gate to AUTHORCARD: https://nftstorage.link/ipfs/bafybeibhy5qvncbwmbhp3mqo67e6or2hxcymimyrk5wbnb5ipuevzatzqe



  IMAGES ONLY:
  ipfs://bafybeigmwudzobi2aycjxdg3dgddppsfo35cososzhivskfphho5ul7k6m

  DATA ONLY:
  CID: bafybeic66bfn42pik2y6puchu3f3cwxitaj2tuwllkkppao4m7ei2ht7z4
  IPFS: ipfs://bafybeic66bfn42pik2y6puchu3f3cwxitaj2tuwllkkppao4m7ei2ht7z4
  Gateway: https://nftstorage.link/ipfs/bafybeic66bfn42pik2y6puchu3f3cwxitaj2tuwllkkppao4m7ei2ht7z4

  NFTCLICK: 
  (HTML NEXT TEST)
  bafybeih4mlfmnyulv72bplkmmeregtidmrz32u6ercb72jpuqhxkztpcg4
https://nftstorage.link/ipfs/bafybeih4mlfmnyulv72bplkmmeregtidmrz32u6ercb72jpuqhxkztpcg4
