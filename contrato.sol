
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";


contract EMUAI_NFTs is ERC721, Ownable {
    
    // Time of when the sale starts.
     /* TODO: FILL CORRECT TIMESTAMP */
    uint256 public constant SALE_START_TIMESTAMP = 162058790;

    // Maximum amount of EMUAI-NFTs in existance. Ever.
    uint16 public constant MAX_NFT_SUPPLY = 5000;

    // Sascha gets a cut because of his collaboration. Thank you very much!
    /* TODO: FILL CORRECT ADDRESS */
    address sascha = 0x1F618d91dee238312552aEbA562956Cfd8915841;
    
    // Counts the supply of EMUs minted
    uint16 public totalSupply;
  
    constructor() ERC721("EMUAI", "EMU") {
        totalSupply = 0;
    }


    /**
    * @dev We don't want to give our ownership away by accident.
    */
    function renounceOwnership() public virtual onlyOwner override {}


    /**
    * @dev Mints yourself an NFT. Or more. You do you.
    */
    function mintNFT(uint16 numerOfNFTs) public payable {
        // Some exceptions that need to be handled.
        require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet");
        require(totalSupply < MAX_NFT_SUPPLY, "Sale has already ended.");
        require(numerOfNFTs > 0, "You cannot mint 0 NFTs.");
        require(SafeMath.add(totalSupply, numerOfNFTs) <= MAX_NFT_SUPPLY, "Exceeds maximum NFTs supply. Please try to mint less EMUAI-NFTs.");
        require(SafeMath.mul(50000000000000000, numerOfNFTs) == msg.value, "Amount of Ether sent is not correct.");

        // Mint the amount of provided EMUAI-NFTs.
        for (uint i = 0; i < numerOfNFTs; i++) {
            uint mintIndex = totalSupply;
            _safeMint(msg.sender, mintIndex);
            //_setTokenURI(mintIndex, "");
            totalSupply ++;
        }
    }
    
    
    /**
    * @dev Withdraw ether from this contract (Callable by owner only)
    */
    function withdraw() onlyOwner public {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance * 98 / 100);
        payable(sascha).transfer(balance * 2 / 100);
    }
}
