pragma solidity ^0.4.19;

import "./DOZView.sol";
import "./FollowFunctions.sol";
import "./MetaFunctions.sol";
import "./StringFunctions.sol";
import "./Verified.sol";


contract DOZ is DOZView, FollowFunctions, MetaFunctions, StringFunctions, Verified {

    address public controller;
    uint256 public profilePrice;
    uint256 public cut = 5;

    // This contract is the heart of DOZ
    event ProfileMade(string _name, string _handle);
    event ProfileDeleted(uint256 _profileId);
    event NameChange(uint256 profileId, string newName);
    event HandleChange(uint256 profileId, string newHandle);
    event NewFollow(uint256 followingId, uint256 followedId);
    event NewUnfollow(uint256 unfollowingId, uint256 unfollowedId);
    event NewVerification(uint256 _tier, uint256 _profileId);
    event VerificationTransfered(uint256 _tier, uint256 _initiatorId, uint256 _targetId);

    mapping (address => bool) contractIsAuthorized;
    // The contracts that are authorized to do special operations

    function DOZ() public {
        controller = msg.sender;
        contractIsAuthorized[msg.sender] = true;
        profilePrice = 1500 szabo;
    }

    // PROFILE FUNCTIONS
    // Function will return the profile's profileId so that the user may note it or wtv
    function createProfile(string _name, string _handle, string _bio) public payable returns(uint256) {
        require(msg.value >= profilePrice);
        require(!handleRegistered[_handle]);
        _createProfile(_name, _handle, _bio);
        ProfileMade(_name, _handle);
    }

    function deleteProfile(string _handle, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        require(handleRegistered[_handle]);
        _deleteProfile(_handle, _profileId);
        ProfileDeleted(_profileId);
    }
    // PROFILE FUNCTIONS END

    // STRING FUNCTIONS
    function changeName(string _newName, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        _changeName(_newName, _profileId);
        NameChange(_profileId, _newName);
    }

    function changeHandle(string _newHandle, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        require(!handleRegistered[_newHandle]);
        _changeHandle(_newHandle, _profileId);
        HandleChange(_profileId, _newHandle);
    }

    function editBio(string _newBio, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        _editBio(_newBio, _profileId);
    }
    // STRING FUNCTIONS END

    // META FUNCTIONS
    function editMetadata(string metaKey, string metaValue, string space, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        // How do I make sure empty strings are not given ?
        // require(space != ""); // Makes sure space isn't an empty string
        // require(metaKey != ""); // Makes sure metaKey isn't an empty string
        _editMetadata(metaKey, metaValue, space, _profileId);
    }

    function removeMetadata(string metaKey, string space, uint256 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(profileExists[_profileId]);
        _removeMetadata(metaKey, space, _profileId);
    }
    // META FUNCTIONS END

    // FOLLOW FUNCTIONS
    // Follow functions must check if profiles exist in the first place
    function follow(uint256 _initiatorId, uint256 _targetId) public {
        require(msg.sender == ownerOf(_initiatorId));
        require(_initiatorId != _targetId); // make sure we're not following ourselves
        require(!uFollow[_initiatorId][_targetId]); // make sure we're not refollowing someone
        require(profileExists[_initiatorId] && profileExists[_targetId]); // the profiles must exist
        _follow(_initiatorId, _targetId);
        NewFollow(_initiatorId, _targetId);
    }

    function unfollow(uint256 _initiatorId, uint256 _targetId) public {
        require(msg.sender == ownerOf(_initiatorId));
        require(_initiatorId != _targetId); // make sure we're not following ourselves
        require(uFollow[_initiatorId][_targetId]); // make sure we're not unfollowing someone we don't follow
        require(profileExists[_initiatorId] && profileExists[_targetId]);
        _unfollow(_initiatorId, _targetId);
        NewUnfollow(_initiatorId, _targetId);
    }
    // FOLLOW FUNCTIONS END

    // VERIFY FUNCTIONS
    // Need to charge for verification
    function authorize(address _authorized) public {
        require(msg.sender == controller);
        contractIsAuthorized[_authorized] = true;
    }

    function setTier(uint8 _newTier, uint256 _price) public {
        require(msg.sender == controller);
        tierExists[_newTier] = true;
        tierToPrice[_newTier] = _price;
    }

    function vetoVerification(uint8 _tier, uint256 _profileId) public {
        require(msg.sender == controller); // allows me to verify profiles without paying anything
        require(profileExists[_profileId]);
        require(tierExists[_tier]);
        verification(_tier, _profileId);
    }

    function deleteTier(uint8 _tier) public {
        require(msg.sender == controller);
        delete tierExists[_tier];
        delete tierToPrice[_tier];
    }

    function verifyProfile(uint8 _tier, uint256 _profileId) public payable {
        require(contractIsAuthorized[msg.sender]); // only verified contracts (addresses) can verify profiles
        // This aspect is centralized
        require(profileExists[_profileId]);
        require(tierExists[_tier]);
        require(msg.value >= tierToPrice[_tier]);
        verification(_tier, _profileId);
        msg.sender.transfer(msg.value / cut);
        // the contract that verifies a profile can receive a cut (now 20%) of the payment
        NewVerification(_tier, _profileId);
    }

    function transferVerification(uint8 _tier, uint256 _initiatorId, uint256 _targetId) public {
        require(msg.sender == ownerOf(_initiatorId)); // need to own both profiles
        require(msg.sender == ownerOf(_targetId));
        require(verifiedStatus[_initiatorId] == _tier); // your initial profile needs to be verified
        require(verifiedStatus[_targetId] != _tier); // your final profile can't be verified
        require(profileExists[_initiatorId] && profileExists[_targetId]); // they both need to exist
        _transferVerification(_tier, _initiatorId, _targetId);
        VerificationTransfered(_tier, _initiatorId, _targetId);
    }
    // VERIFY FUNCTIONS END

    function setProfilePrice(uint256 _newPrice) public {
        require(msg.sender == controller);
        profilePrice = _newPrice;
    }

    function setCut(uint256 _newCut) public {
        require(msg.sender == controller);
        cut = _newCut;
    }

    function getBalance() public view returns(uint256) {
        require(msg.sender == controller);
        return address(this).balance;
    }

    // Withdraw the funds of the account from fees received by charging for profiles
    function withdraw() public {
        require(msg.sender == controller);
        controller.transfer(address(this).balance);
    }
}
