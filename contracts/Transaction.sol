pragma solidity 0.5.16;
// pragma experimental ABIEncoderV2;

import "./ERC721Full.sol";

contract Transaction is ERC721Full {
    
    
    

    mapping(address => uint256[]) public UserTransactionID;
    
    mapping(address => uint) public addressmap;

    struct Trans {
      uint256 ID;
      uint CID;
      address from;
      address to;
      uint value;
      uint time;
      
    }

    Trans[] public Transactions;
    

    constructor() ERC721Full("Transaction", "TRANSACTION") public {
      
    }

    // function HashCourse (
    //     uint courseID
        
    // ) 
    // view
    // private
    // returns(bytes32)
    
    // {
        
    //    bytes32 courseHash = keccak256(abi.encodePacked(courseID, msg.sender));
       
    //    return courseHash;
       
    // }
   
    // function getPrice() public view returns(uint256) {
    //   return price;
    // }

    function mint(uint _courseID, address _from, address _to, uint _value) public {
      // bytes32 hashed = HashCourse(_course);
      // require(!OwnerCheck[_courseID][_userID]);
      uint _id = Transactions.length;
      Transactions.push(Trans({
        ID: _id,
        
        CID: _courseID,
        value: _value,
        from: _from,
        to: _to,
        time: block.timestamp
      }));
      
      _mint(msg.sender, _id);
      UserTransactionID[_to].push(_id);
    }

    function getTx(address uad) public view returns(uint256[] memory) {
        return UserTransactionID[uad];
    }

    function getTotalTx(address uad) public view returns(uint) {
        return UserTransactionID[uad].length;
    }

    function burn(uint _tokenId) public {
      require(_isApprovedOrOwner(msg.sender, _tokenId));
      _burn(ownerOf(_tokenId), _tokenId); 
    }

}
