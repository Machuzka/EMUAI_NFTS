// SPDX-License-Identifier: MIT
/*                                                 :=*#%@@@@@@@@@%%%#**+=-:::: '*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+                           
*                                               .+@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*+:     ............................................................                                  
*          -*#%%#+:.                           :%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#+-.. '*#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#-                                  
*        :+@@@@@@@@@@%#*+=-:.                 .@@@@@@@@@%===#==#+=+%=**=@*==*@=*@@@@@@@@@#*=-.       ..........................................                                      
*     .-======+*#@@@@@@@@@@@@@@@%##*+==--::::+@@@@@@@@@@: =%-  : .*: = == : *- %@@@@@@@@@@@@@@@@*=.   -*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+.                                      
*                 .:=+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@= *#+.= - +: * -= - :+ #@@@@@@@@@@@@@@@*-   .:::::::::::::::::::::::::::::::::::::::                                          
*                        :=.-+#%%@@@@@@@@@@@@@@@@@@@@@%===%=#=*+*%===**=#+=#=+@@@@@@@@@@@@@%=   .=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#=                                           
*                                 :=#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*-...  .:---------------------------------------.                                              
*                                     .--:-=*#@@@@%+#%@@@@@@@@@@@@@@@@@@@@@@@@@@@#+=:          .:=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*+.                                               
*                                              :..:    .-+*#@@@@@@%#%@%@@@@@@@@%+::.                ..  =++++++++++++++++++++++++=.                                               
*                                           =#%*%#*+===--::.  .-#@@%:   .-===+++**%@%-           .*-.+* :=======================-                                                    
*                                          .%#: .=%=.:-=+*###%%%#@@@@*.            .-+%%*=:      :#+-=@- @@@@@@@@@@@@@@@@@@@@@@-                                                       
*                                            :+:                .::-:                  .=*%@#+===*%%*=.  -------------------:                                                        
*                                                                                          .::--:.                                                                                   
*                                                                                                                                                               
*  Welcome to the EMU NFTs sale for the EMUAI Solar Car proyect. Each of these NFTs are going to represent ownership of one 1.5 by 1.5 centimeter sqaure
*  of our solar car's vitual model surface and of our physical car once it is built (with the help of the funding of this campaign). 
*  This representation will also be called an EMU.
*  
*  The Owner of each particular EMU will be able to upload an image to that space for the world to see!!
*  Our car will compete in many races around the globe and appear in countless media (we have lots of contacts).
*
*  Thank you very much for your contribution and for making this proyect possible. 
*/


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Ownable.sol";


contract EMUAI_NFTs is ERC721, Ownable {

    // Time of when the sale starts and ends.
    uint256 public SALE_START_TIMESTAMP = 1620928800; // Thursday, May 13, 2021 6:00:00 PM GMT
    uint256 public SALE_END_TIMESTAMP = 1625097600; // Sat, 1 Jul 2021 00:00:00 GMT

    // Maximum amount of EMUAI-NFTs in existance. Ever.
    uint16 public constant MAX_NFT_SUPPLY = 5940;

    // Maximum amount of EMUAI-NFTs to be minted in one transaction. This is to avoid hitting the block gas limit.
    uint16 public constant MAX_TRANSACTION_MINT = 250;
    
    // Token price in wei
    uint256 public constant TOKEN_PRICE = 50000000000000000;

    // Counts the supply of EMUs minted
    uint16 public totalSupply;

    //Stores the base URI
    string private baseURI;

    constructor(string memory OriginalBaseURI) ERC721("EMUAI_NFTs", "EMU") {
        totalSupply = 0;
        changeBaseURI(OriginalBaseURI);
    }


    /**
    * @dev Changes the start and end timestamps if needed (Callable by owner only).
    */
    function setSaleTimestamps(uint256 start, uint256 end) onlyOwner public{
        SALE_START_TIMESTAMP = start;
        SALE_END_TIMESTAMP = end;
    }


    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }


    /**
    * @dev Mints yourself an NFT. Or more. You do you.
    */
    function mintEMU(uint16 numberOfNFTs) public payable {
        // Some exceptions that need to be handled.
        require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet.");
        require(totalSupply < MAX_NFT_SUPPLY && block.timestamp <= SALE_END_TIMESTAMP, "Sale has already ended.");
        require(numberOfNFTs <= MAX_TRANSACTION_MINT, "Exceeds maximum ammount.");
        require(totalSupply + numberOfNFTs <= MAX_NFT_SUPPLY, "Exceeds maximum EMUs supply.");
        require(TOKEN_PRICE * numberOfNFTs == msg.value, "Amount of Ether sent is not correct.");

        // Mint the amount of provided EMUAI-NFTs.
        for (uint i = 0; i < numberOfNFTs; i++) {
            uint mintIndex = totalSupply+1;
            _safeMint(msg.sender, mintIndex);
            totalSupply ++;
        }
    }


    /**
    * @dev Withdraw ether from this contract (Callable by owner only)
    */
    function withdraw() onlyOwner public {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }


    /**
    * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
    */
    function changeBaseURI(string memory newBaseURI) onlyOwner public {
       baseURI = newBaseURI;
    }
}
