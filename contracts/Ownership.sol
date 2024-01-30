pragma solidity 0.5.16;
// pragma experimental ABIEncoderV2;

import "./ERC721Full.sol";

contract Ownership is ERC721Full {
    
    
    enum State {
        Purchased,
        OnSale
    }

    mapping(uint => address) public usermap;
    mapping(address => uint) public addressmap;

    struct CourseOwn {
      uint256 ID;
      uint UID;
      uint CID;
      uint Batch;
      uint BatchID;
      uint price;
      uint time;
      State state;
    }

    CourseOwn[] public Ownerships;
    mapping(uint => CourseOwn[]) OwnershipsBatch;
    uint public totalBatch;
    // mapping
    mapping(uint => CourseOwn[]) OwnershipByBatch;
    mapping(uint => uint[]) OwnershipByUser;
    mapping(uint => uint[]) OwnerByCourse;
    mapping(uint => mapping(uint => bool)) OwnerCheck;
    mapping(uint => mapping(uint => mapping(uint => CourseOwn))) OwnerSearch;

    constructor() ERC721Full("Ownership", "OWNERSHIP") public {
      totalBatch = 0;
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

    function mint(uint _courseID, uint _userID, uint _batch, uint _batchID, uint _price) public {
      // bytes32 hashed = HashCourse(_course);
      // require(!OwnerCheck[_courseID][_userID]);
      uint _id = Ownerships.length;
      Ownerships.push(CourseOwn({
        ID: _id,
        UID: _userID,
        CID: _courseID,
        Batch: _batch,
        BatchID: _batchID,
        price: _price,
        time: 0, 
        state: State.OnSale
      }));
      
      _mint(msg.sender, _id);
      OwnerSearch[_courseID][_batch][_batchID] = Ownerships[Ownerships.length-1];
      OwnershipByUser[_userID].push(_id);
      OwnerByCourse[_courseID].push(_userID);
      OwnershipsBatch[_batch].push(Ownerships[Ownerships.length-1]);
    }

    function batch_mint(uint batch_size, uint _courseID, uint _price) public {
      totalBatch = totalBatch+1;
      
      for(uint i = 0; i < batch_size; ++i) {
            mint(_courseID, 0, totalBatch, i, _price);
            
      }
      
    }


    function getOwnershipByUser(uint UID) public view returns(uint[] memory) {
      return OwnershipByUser[UID];
    }

    function getTotalOwnedCourse(uint UID)public view returns(uint){
      return OwnershipByUser[UID].length;
    }

    function createUser(uint UID, address uad) public {
      usermap[UID] = uad;
      addressmap[uad] = UID;

    }

    function getOwnerByCourse(uint CID) public view returns(uint[] memory) {
      return OwnerByCourse[CID];
    }

    function update (uint _userID, uint id) public payable{
      Ownerships[id].UID = _userID;
      Ownerships[id].state = State.Purchased;
      Ownerships[id].time = now;
      OwnershipByUser[_userID].push(id);
      OwnerByCourse[id].push(_userID);
      

      

    } 

    function addUser (uint _userID, address userAddress) public {
      usermap[_userID] = userAddress;
    }

    function burn(uint _tokenId) public {
      require(_isApprovedOrOwner(msg.sender, _tokenId));
      _burn(ownerOf(_tokenId), _tokenId); 
    }

}
