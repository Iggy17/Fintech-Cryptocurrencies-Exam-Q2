pragma solidity^0.5.0;


//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";


//imports all required contracts
import "openzeppelin-solidity/Ownable.sol";
import "openzeppelin-solidity/ERC20.sol";
import "openzeppelin-solidity/ERC721Metadata.sol";

contract CoToken is Ownable, ERC20 {
    address admin;

    //initialize variables
    uint256 public _purchasePrice;
    uint256 public _tokenSupply = 0;
    uint256 public _sellPrice;

    //functions to establish the buy price based on the number of tokens to be purchased and the bonding curve
    function buyPrice(uint256 _numberOfTokens) public {
        // y = 0.01x + 0.2 ; normalised to wei
        _purchasePrice = ((5*(10**15))*(_numberOfTokens)*(_numberOfTokens)) + ((2*10**17)*(_numberOfTokens));

    }
    //functions to establish the buy price based on the number of tokens to be purchased and the bonding curve
    function sellPrice(uint256 _numberOfTokens) public{
        // y = 0.01x + 0.2 ; normalised to wei
        _sellPrice = ((5*(10**15))*(_numberOfTokens)*(_numberOfTokens)) + ((2*10**17)*(_numberOfTokens));
    }

    //mint tokens
    function mint(uint256 _tokenstoMint) public payable {
        // ensure that the value of the transaction is equivalent to the corresponding tokens to be minted
        // implemented from ERC721
        admin = msg.sender;
        require(msg.value == _purchasePrice, "Amount does not correspond to the number of tokens to be minted");
        _mint(msg.sender, _tokenstoMint);
        // add minted tokens to the total supply
        _tokenSupply = _tokenSupply + _tokenstoMint;
    }

    //burn tokens
    function burn(uint256 _tokensToBurn) onlyOwner public payable {
      // ensure that the value of the transaction is equivalent to the corresponding tokens to be burnt
      // implemented from ERC721
      require(msg.value == _sellPrice, "Amount does not correspond to the number of tokens to be burnt");
      _burn(msg.sender, _tokensToBurn);
      //reduce the number of tokens supplied in total by the burned amount
      _tokenSupply = _tokenSupply - _tokensToBurn;

    }

    //self destruct function
    function destroy() public onlyOwner {
        require(msg.sender == admin);
        selfdestruct(msg.sender);
    }

}
