pragma solidity ^0.4.19;

import "./ERC721Token.sol";
import "./Ownable.sol";


contract ProfileFactory is ERC721Token, Ownable {
    using SafeMath for uint256;

    string public name = "D-OZ Profile";
    string public constant SYMBOL = "DOZ";

    uint256 private profileId = 1;
    // profile IDs start at 1, just like arrays do :)

    // metadata[profileId][space][metaKey] = metaValue
    mapping (uint256 => mapping (string => mapping (string => string))) metadata;

    // followsU[profileId][profileId] = true/false
    // checks if a profileId follows your profileId, returns bool
    mapping (uint256 => mapping (uint256 => bool)) followsU;

    // uFollow[profileId][profileId] = true/false
    // checks if your profileId follows a profileId, returns bool
    mapping (uint256 => mapping (uint256 => bool)) uFollow;

    // verifiedStatus[profileId][tierId] = true/false
    // checks if your profileId is verified at a certain tier
    // 0 = not verified, 1 = regular verification, 2 = V.I.P.
    mapping (uint256 => mapping (uint256 => bool)) verifiedStatus;

    // set a price for a particular tier
    mapping (uint256 => uint256) tierToPrice;

    // checks if a tier exists
    mapping (uint256 => bool) tierExists;

    struct Profile {
        string name; // Must be unique
        string handle; // Must be unique
        string bio; // bio
        uint256 followerCount;
        uint256 followingCount;
        uint64 dateCreated;
    }

    mapping (uint256 => Profile) profiles; // ties profileId to a Profile

    mapping(uint256 => bool) profileExists;
    mapping(string => uint256) handleToProfileId; // Ties a profile's name to it's ID

    mapping(string => bool) nameRegistered;
    mapping(string => bool) handleRegistered;

    function _createProfile(string _name, string _handle, string _bio) internal returns(uint256) {

        Profile memory profile = Profile({
            name: _name,
            handle: _handle,
            bio: _bio,
            followerCount: 0,
            followingCount: 0,
            dateCreated: uint64(now)
        });

        profiles[profileId] = profile;
        profileExists[profileId] = true;
        nameRegistered[_name] = true;
        handleRegistered[_handle] = true;
        handleToProfileId[_handle] = profileId;
        verifiedStatus[profileId][0] = true;

        _mint(msg.sender, profileId);

        uint256 currentProfileId = profileId;
        incrementProfileId();

        return currentProfileId;
    }

    function _deleteProfile(string _name, string _handle, uint256 _profileId) internal {

        delete profiles[_profileId]; // deletes all the properties in the struct
        profileExists[_profileId] = false;
        nameRegistered[_name] = false;
        handleRegistered[_handle] = false;
        handleToProfileId[_handle] = 0; // If a profile ID is 0 that means it does not exist

        _burn(_profileId);
    }

    function incrementProfileId() internal {
        profileId = profileId.add(1);
    }

}
