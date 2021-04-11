// SPDX-License-Identifier: MIT
/*
*
*                                                                                     ------------------------------------------------------------------------------               
*                                                      :=*#%@@@@@@@@@@@%%##**+==-:::-=+*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*:              
*                                                   :*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*=-.     ..................................................................                   
*          =*#%%#+-.                               =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*=:.:=+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*-                   
*       .-#@@@@@@@@@@@%#*+=-::.                   *@@@@@@@@@@#==+%==*#==#*=#+=@%===@#=*@@@@@@@@@@#*=-:.       ..............................................                        
*    .-=======+*#%@@@@@@@@@@@@@@@@%##*++==--::::-%@@@@@@@@@@* .*%:  -. =* .= =* : :#. %@@@@@@@@@@@@@@@@@%+-    :+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*                       
*                  .-=*#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@# :#%:.= -..* .* -= .. #..%@@@@@@@@@@@@@@@@%+.   .............................................                            
*                         :=::=*#%%@@@@@@@@@@@@@@@@@@@@@@@@+==*#=#=**=%*===#*=##=**=#@@@@@@@@@@@@@@@+.   :+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*                             
*                                   :=*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+-...   :-------------------------------------------:                                 
*                                        :=-:-=+#@@@@@#*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+=:            .%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*+-                                  
*                                                 .- .:     :=+*%@@@@@@@##%@#%@@@@@@@@#=::.                  .:  -+++++++++++++++++++++++++++=.                                     
*                                              -#%##%**+====--::.  .-*@@@+    .:-==++++**%@@+:            :*=.=#..===========================                                       
*                                              #@-  .+%-.:--=+*###%%%#%@@@@+               :=*@%*=:       -#+=-%* %@@@@@@@@@@@@@@@@@@@@@@@*.                                          
*                                               .=-. .                .:--:                    .=*%@%*===+*@%#+:  :---------------------   
*
*
*
*  Welcome to the EMU NFTs sale for the EMUAI Solar Car proyect. Each of these NFTs are going to represent ownership of one 1 by 1 centimeter of our solar car's 
*  vitual model surface and on our physical car once it is built (with the help of the funding of this campaign). This representation will also be called an EMU.
*  
*  The Owner of each particular EMU will be able to upload an image to that space for the world to see!!
*  Our car will compete in many races around the globe and appear in countless media (we have lots of contacts).
*
*  Thank you very much for your contribution and for making this proyect possible.
*/


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract EMUAI_NFTs is ERC721, Ownable {
    
    // Time of when the sale starts.
     /* TODO: FILL CORRECT TIMESTAMP */
    uint256 public SALE_START_TIMESTAMP = 162058790; // Sat, 1 May 2021 18:00:00 GMT: 1619892000
    uint256 public SALE_END_TIMESTAMP = 1625097600; // Sat, 1 Jul 2021 00:00:00 GMT: 1625097600

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
    
    //Stores the base URI
    string private baseURI;
  
    constructor(string memory OriginalBaseURI) ERC721("EMUAI_NFTs", "EMU") {
        totalSupply = 0;
        changeBaseURI(OriginalBaseURI);
    }


    /**
    * @dev We don't want to give our ownership away by accident.
    */
    function renounceOwnership() public virtual onlyOwner override { }
    function transferOwnership(address newOwner) public virtual onlyOwner override { }


    /**
    * @dev Changes the start and end timestamps if needed (only owner).
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
    function mintNFT(uint16 numberOfNFTs) public payable {
        // Some exceptions that need to be handled.
        require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet.");
        require(block.timestamp <= SALE_END_TIMESTAMP, "Sale has already ended.");
        require(totalSupply < MAX_NFT_SUPPLY, "Sale has already ended.");
        require(SafeMath.add(totalSupply, numberOfNFTs) <= MAX_NFT_SUPPLY, "Exceeds maximum NFTs supply. Please try to mint less EMUAI-NFTs.");
        require(SafeMath.mul(TOKEN_PRICE, numberOfNFTs) == msg.value, "Amount of Ether sent is not correct.");

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
        uint256 sasha_ammount = balance * sascha_share / 100;
        payable(msg.sender).transfer(SafeMath.sub(balance, sasha_ammount));
        payable(sascha).transfer(sasha_ammount);
    }


    /**
    * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
    */
    function changeBaseURI(string memory newBaseURI) onlyOwner public {
       baseURI = newBaseURI;
    }
}
