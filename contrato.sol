// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract EMUAI_NFTs is ERC721, Ownable {

    // This is the original provenance record of all EMUAI NFTs in existence at the time.
    string public constant ORIGINAL_PROVENANCE = ""; // TODO: Check openzeppelin docs for them funcs
    
    // Time of when the sale starts.
    uint256 public constant SALE_START_TIMESTAMP = 162016767;

    // Maximum amount of EMUAI-NFTs in existance. Ever.
    uint256 public constant MAX_NFT_SUPPLY = 5000;


    // Sascha gets a cut because of his collaboration. Thank you very much!
    /* TODO: FILL CORRECT ADDRESS */
    address sascha = "0xDEADBEEF"; 
  
    constructor(string memory name, string memory symbol, string memory baseURI) ERC721(name, symbol) {
        _setBaseURI(baseURI);
    }

    /**
    * @dev Mints yourself an NFT. Or more. You do you.
    */
    function mintNFT(uint256 numerOfNFTs) public payable {
        // Some exceptions that need to be handled.
        require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended.");
        require(numerOfNFTs > 0, "You cannot mint 0 NFTs.");
        require(SafeMath.add(totalSupply(), numerOfNFTs) <= MAX_NFT_SUPPLY, "Exceeds maximum NFTs supply. Please try to mint less EMUAI-NFTs.");
        require(SafeMath.mul(50000000000000000, numerOfNFTs) == msg.value, "Amount of Ether sent is not correct.");

        // Mint the amount of provided EMUAI-NFTs.
        for (uint i = 0; i < numerOfNFTs; i++) {
            uint mintIndex = totalSupply();
            _safeMint(msg.sender, mintIndex);
        }
    }
    
    /**
    * @dev Withdraw ether from this contract (Callable by owner only)
    */
    function withdraw() onlyOwner public {
        uint balance = address(this).balance;
        msg.sender.transfer(SafeMath.mul(balance, 0.98));
        sascha.transfer(SafeMath.mul(balance, 0.02));
    }

    /**
    * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
    */
    function changeBaseURI(string memory baseURI) onlyOwner public {
       _setBaseURI(baseURI);
    }
}