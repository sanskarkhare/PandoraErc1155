// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";




contract GameNft is ReentrancyGuard,
    Initializable,
    ERC1155Upgradeable,
    OwnableUpgradeable,
     ERC1155SupplyUpgradeable
 {
    
   using Counters for Counters.Counter;
   //Counter for Tokens
      Counters.Counter private _tokenIds;

        address contractOwner ;
        function conOwner() view public returns (address){
            return contractOwner;
        }
     
      struct MarketItem {
        address payable seller;
        address payable owner;
        bool forSale;
        bool sold;
        uint256 tokenId;
        uint256 price;
        string uri;
    }

    event marketItemCreated(
        address owner,
        address seller,
        uint256 id,
        uint256 price
    );

    string public ipfsUri = "https://ipfs.infura.io/ipfs/{id}.json";
    

constructor() initializer {
        initialize();
    }
 //Initializer for Constructor
  function initialize() public initializer {
        __ERC1155_init(ipfsUri);
        __Ownable_init();
      contractOwner = msg.sender;
        
    }

      mapping(uint256 => MarketItem) private idToItem;
      mapping(uint256 => string) private _uris;
      mapping(address => uint256) private addToItemId;

      function setTokenURI(uint256 tokenId, string memory tokenUri) public {
        // require(bytes(_uris[tokenId]).length == 0, "URI can only be set once");

        _uris[tokenId] = tokenUri;
    }

//Function to mint NFTS
    function mint(
        uint256 amount,
        string memory tokenUri,
        uint256 price
    
    ) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId, amount, "0x00");
        setTokenURI(newItemId, tokenUri);
        
        safeTransferFrom(msg.sender, address(this), newItemId, amount, "");

        idToItem[newItemId] = MarketItem(
            payable(msg.sender),
            payable(msg.sender),
            true,
            false,
            newItemId,
            price,
            uri(newItemId)
        );
     
        return newItemId;
    }

    
   //Function to get URI of tokeIDs
 function uri(uint256 tokenId) public view override returns (string memory) {
        return _uris[tokenId];
    }

//Function to get nfts created by the user
 function fetchMy() public view returns (MarketItem[] memory){
        uint256 itemCount = 0;
        uint256 total = _tokenIds.current();
      
        for (uint256 i = 0; i < total; i++) {
            if(idToItem[i+1].seller == msg.sender|| idToItem[i+1].owner==msg.sender){
                itemCount+=1;
            }  
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        uint256 idx=0;
        for (uint256 i = 0; i < total; i++) {
            if(idToItem[i+1].owner == msg.sender||idToItem[i+1].seller == msg.sender) {
                 MarketItem storage currentItem = idToItem[i+1];
                items[idx] = currentItem;
                idx+=1;
             }
            
        }

        return items;
    }

//Fetch Item that are sellable in market
    function fetchForSaleMarketItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = 0;
        
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            if(idToItem[i+1].forSale == true){
                itemCount++;
                
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        uint256 idx=0;
        for(uint256 i=0; i< _tokenIds.current(); i++){
             if(idToItem[i+1].forSale == true){
                items[idx] = idToItem[i+1];
                idx+=1;
            }
        }

        return items;
    }


//Function to set Item for sale only done by the owner
function setItemForSale(uint256 id) public payable {
    require(idToItem[id].seller == msg.sender, "Unauthorised access");
    idToItem[id].forSale =  true;
}

//Function to remove Item from sale
function removeItemForSale(uint256 id) public payable {
    
    require(idToItem[id].seller == msg.sender || idToItem[id].owner == msg.sender, "Unauthorised access");
    idToItem[id].forSale =  false;
}

// Function to buy nft that is sellable by the owner
function userBuyNft(uint256 id, uint256 amount) public payable {
    require(idToItem[id].forSale == true, "Not for sale right now");
    require(balanceOf(address(this), id) >= amount, "Not enough Token near seller");
    uint price = idToItem[id].price;
    
     require(msg.value >= price, "Please submit the asking price in order to complete the purchase");
        
      
      
     this.safeTransferFrom(address(this), msg.sender, id, amount, "");
     idToItem[id].seller.transfer(msg.value);
    idToItem[id].owner = payable(msg.sender);
     emit marketItemCreated(  
        idToItem[id].owner,
        idToItem[id].seller,
        id,
        price
     );

}

//Inherited functions

   function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

 function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual returns (bytes4) {
        return this.onERC1155Received.selector;
    }
}

