
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract EMUAI_NFTs is ERC721, Ownable {
    
    // Time of when the sale starts.
     /* TODO: FILL CORRECT TIMESTAMP */
    uint256 public constant SALE_START_TIMESTAMP = 162058790;

    // Maximum amount of EMUAI-NFTs in existance. Ever.
    uint16 public constant MAX_NFT_SUPPLY = 5000;

    // Token price in wei
    uint256 public constant TOKEN_PRICE = 50000000000000000;

    // Sascha gets a cut because of his collaboration. Thank you very much!
    /* TODO: FILL CORRECT ADDRESS */
    address constant sascha = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint constant sascha_share = 2; // 2%
    
    // Counts the supply of EMUs minted
    uint16 public totalSupply;
  
    constructor() ERC721("EMUAI", "EMU") {
        totalSupply = 0;
    }


    /**
    * @dev We don't want to give our ownership away by accident.
    */
    function renounceOwnership() public virtual onlyOwner override { }
    function transferOwnership(address newOwner) public virtual onlyOwner override { }


    function getBalance() public view onlyOwner returns(uint256){
        return address(this).balance;
    }


    /**
    * @dev The function that makes the URI based on the owner and IPNS.
    */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        //string memory baseURI = _baseURI();
        
        /**
         * return bytes(baseURI).length > 0
         * ? string(abi.encodePacked(baseURI, IPNS(tokenId + ownerOf(tokenId)))
         * : '';
         */
        return _baseURI();
    }

    /**
    * @dev Mints yourself an NFT. Or more. You do you.
    */
    function mintNFT(uint16 numberOfNFTs) public payable {
        // Some exceptions that need to be handled.
        require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet");
        require(totalSupply < MAX_NFT_SUPPLY, "Sale has already ended.");
        require(numberOfNFTs > 0, "You cannot mint 0 NFTs.");
        require(SafeMath.add(totalSupply, numberOfNFTs) <= MAX_NFT_SUPPLY, "Exceeds maximum NFTs supply. Please try to mint less EMUAI-NFTs.");
        require(SafeMath.mul(TOKEN_PRICE, numberOfNFTs) == msg.value, "Amount of Ether sent is not correct.");

        // Mint the amount of provided EMUAI-NFTs.
        for (uint i = 0; i < numberOfNFTs; i++) {
            uint mintIndex = totalSupply+1;
            _safeMint(msg.sender, mintIndex);
            //_setTokenURI(mintIndex, ""); TODO
            totalSupply ++;
        }
    }
    
    
    /**
    * @dev Withdraw ether from this contract (Callable by owner only)
    */
    function withdraw() onlyOwner public {
        uint balance = address(this).balance;
        uint256 sasha_ammount = balance * sascha_share / 100;
        payable(msg.sender).transfer(SafeMath.sub(balance, sasha_ammount));
        payable(sascha).transfer(sasha_ammount);
    }
}
