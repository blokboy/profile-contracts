pragma solidity ^0.4.19;


contract ProfileFactory is ERC721Token, Ownable {

    string public name = "D-OZ Profile";
    string public constant SYMBOL = "DOZ";

    uint48 private profileId = 1;
    // profile IDs start at 1, just like arrays do :)

    struct Profile {
        string name; // Must be unique
        string handle; // Must be unique
        string bio; // bio
        mapping (string => string) metadata;
        uint32 followerCount;
        uint32 followingCount;
        mapping (uint48 => bool) followsU;
        // mapping that tracks whether a profileId follows you and returns a bool
        mapping (uint48 => bool) uFollow; // mapping that tracks you follow profileId and returns a bool
        // **SPECIAL**
        mapping(string => bool) verifiedStatus;
        // Mapping that checks if a profile is verified, it's seperated in tiers (strings) and checks if it's true
        uint64 dateCreated;
    }

    mapping (uint48 => Profile) public profiles; // ties profileId to a Profile

    mapping(uint48 => bool) public profileExists;
    mapping(string => uint256) public nameToProfileId; // Ties a profile's name to it's ID

    mapping(string => bool) public nameRegistered;
    mapping(string => bool) public handleRegistered;

    function createProfile(string _name, string _handle) internal returns(uint48) {

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

        return profileId;

        incrementProfileId();
    }

    function deleteProfile(string _name, string _handle, uint48 _profileId) internal {

        delete profiles[_profileId]; // deletes all the properties in the struct
        profileExists[_profileId] = false;
        nameRegistered[_name] = false;
        handleRegistered[_handle] = false;
        nameToProfileId[_name] = 0; // If a profile ID is 0 that means it does not exist

        _burn(msg.sender, _profileId);
    }

    function incrementProfileId() internal {
        profileId = profileId.add(1);
    }

}
