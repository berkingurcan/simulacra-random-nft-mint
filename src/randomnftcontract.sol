pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract simplenft is ERC721Enumerable, Ownable {
    using Strings for uint256;

    uint[] array = [1,2,3,4,5,6,7,8];

    string baseExtension = ".gif";
    string _baseTokenURI;
    uint256 private _price = 0.02 ether;
    bool public _paused = true;

    constructor(string memory baseURI) ERC721("sims", "SIM")  {
        setBaseURI(baseURI);
    }
    //RANDOM GENERATING

    function remove(uint index) private returns(uint[] memory) {
        if (index >= array.length) return array;

        for (uint i = index; i<array.length-1; i++){
            array[i] = array[i+1];
        }
        array.pop();
        return array;
    }

        function get_date() private returns (uint256) {
        uint256 now_date = block.timestamp;
        return now_date;
    }

    //RANDOM GENERATING
    uint nonce = 0;

    //Get sims
    mapping(address => uint) addToSim;
    function seeLatestSim() public view returns(uint){
        require(addToSim[msg.sender]>0, "You don't have any sim");
        return addToSim[msg.sender];
    }

    function buySim() public payable {
        nonce++;
        uint rand_number = uint(keccak256(abi.encodePacked(get_date(), msg.sender, nonce))) % array.length;
        uint256 supply = totalSupply();
        require( !_paused,                              "Sale paused" );
        require( supply + 1 < 9,      "Exceeds maximum sim supply" );

        _safeMint( msg.sender, array[rand_number]);
        addToSim[msg.sender] = array[rand_number];
        remove(rand_number);

    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getPrice() public view returns (uint256){
        return _price;
    }

    function pause(bool val) public onlyOwner {
        _paused = val;
    }
}

