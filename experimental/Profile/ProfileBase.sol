pragma solidity ^0.4.19;


contract ProfileBase is ERC721Token {

    string public name = "D-OZ Profile";
    string public symbol = "DOZ";

    // number that determines the tokenId of a Profile, increments everytime
    uint256 internal id;

    function ProfileBase(uint256 _id, uint256 _price) public {
        id = _id;
        price = _price;
    }

    struct Profile {
        bytes32 handle;
        uint256 rank; // verified status
    }

    mapping (uint256 => Profile) internal profiles; // tracks profiles
    mapping (bytes32 => uint256) internal handleToId; // Ties a Profile to it's ID

    function _createProfile(string _handle) internal {
        handleToId[keccak256(_handle)] = id;
        Profile memory profile = Profile({
            handle: keccak256(_handle),
            rank: 0
        });
        profiles[id] = profile;
        _mint(msg.sender, id);
        id++;
    }

    function _deleteProfile(uint256 _id, string _handle) internal {
        delete handleToId[keccak256(_handle)];
        delete profiles[_id];
        _burn(msg.sender, _id);
    }

}
