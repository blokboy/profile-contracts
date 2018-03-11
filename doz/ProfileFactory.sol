pragma solidity ^0.4.19;


contract ProfileFactory is ERC721Token {

    string public name = "D-OZ Profile";
    string public constant SYMBOL = "DOZ";
    address public controller;
    uint256 public price;
    uint256 private profileId = 1;
    // profile IDs start at 1, just like arrays do :)

    struct Profile {
        string name; // Must be unique
        string handle; // Must be unique
        string bio; // bio
        mapping (string => string) public metadata;
        uint32 followerCount;
        uint32 followingCount;
        mapping (uint256 => bool) public followsU;
        // mapping that tracks whether a profileId follows you and returns a bool
        mapping (uint256 => bool) public uFollow; // mapping that tracks you follow profileId and returns a bool
        uint64 dateCreated;
    }

    Profile[] public profiles; // I want to avoid using an array
    mapping (uint256 => Profile) public profiles;
    // I don't know if I will be able to access the Profile's properties later if it's in a mapping
    
    mapping(uint256 => bool) public profileExists;
    mapping(string => uint256) public nameToProfileId; // Ties a profile's name to it's ID

    mapping(string => bool) public nameRegistered;
    mapping(string => bool) public handleRegistered;

    event ProfileMade(string _name, string _handle, uint256 _profileId);
    event ProfileDeleted(uint256 _profileId);

    function ProfileFactory() public {
        controller = msg.sender;
    }

    function createProfile(string _name, string _handle) public payable {
        require(msg.value >= price);
        require(!nameRegistered[_name]);
        require(!handleRegistered[_handle]);
        Profile memory profile = Profile({
            name: _name,
            handle: _handle,
            dateCreated: uint64(now)
        });

        profiles[profileId] = profile;
        profileExists[profileId] = true;
        nameRegistered[_name] = true;
        handleRegistered[_handle] = true;
        nameToProfileId[_name] = profileId;

        _mint(msg.sender, profileId);
        ProfileMade(_name, _handle, profileId);

        profileId = profileId.add(1);
    }

    function deleteProfile(string _name, string _handle, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(nameRegistered[_name]);
        require(handleRegistered[_handle]);

        profiles[_profileId] = 0; // What is the default value of a struct ?
        profileExists[_profileId] = false;
        nameRegistered[_name] = false;
        handleRegistered[_handle] = false;
        nameToProfileId[_name] = 0; // If a profile ID is 0 that means it does not exist

        _burn(msg.sender, _profileId);
        ProfileDeleted(_profileId);
    }

    function setPrice(uint256 _newPrice) public {
        require(msg.sender == controller);
        price = _newPrice;
    }

}
