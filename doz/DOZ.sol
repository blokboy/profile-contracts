pragma solidity ^0.4.19;

contract DOZ is FollowFunctions, MetaFunctions, StringFunctions, Verified {

    // This contract is the heart of DOZ
    event ProfileMade(string _name, string _handle, uint48 _profileId);
    event ProfileDeleted(uint48 _profileId);
    event NameChange(uint256 profileId, string newName);
    event HandleChange(uint256 profileId, string newHandle);
    event NewFollow(uint256 followingId, uint256 followedId);
    event NewUnfollow(uint256 unfollowingId, uint256 unfollowedId);

    mapping (address => bool) public contractCanVerify;
    // The contracts that are allowed to verify a user

    function DOZ() public {
        controller = msg.sender;
        contractCanVerify[msg.sender] = true;
    }

    // PROFILE FUNCTIONS
    // Function will return the profile's profileId so that the user may note it or wtv
    function createProfile(string _name, string _handle) public payable returns(uint48) {
        require(msg.value >= price);
        require(!nameRegistered[_name]);
        require(!handleRegistered[_handle]);
        super.createProfile(_name, _handle);
        ProfileMade(_name, _handle);
    }

    function deleteProfile(string _name, string _handle, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(nameRegistered[_name]);
        require(handleRegistered[_handle]);
        super.deleteProfile(_name, _handle, _profileId);
        ProfileDeleted(_profileId);
    }
    // PROFILE FUNCTIONS END

    // STRING FUNCTIONS
    function changeName(string _newName, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(!nameRegistered[_newName]);
        super.changeName(_newName, _profileId);
        NameChange(_profileId, _newName);
    }

    function changeHandle(string _newHandle, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(!handleRegistered[_newHandle]);
        super.changeHandle(_newHandle, _profileId);
        HandleChange(_profileId, _newHandle);
    }

    function editBio(string _newBio, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        super.editBio(_newBio, _profileId);
    }
    // STRING FUNCTIONS END

    // META FUNCTIONS
    function editMetadata(string metaKey, string metaValue, string namespace, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        require(namespace != ""); // Makes sure namespace isn't an empty string
        require(metaKey != ""); // Makes sure metaKey isn't an empty string
        super.editMetadata(metaKey, metaValue, namespace, _profileId);
    }

    function removeMetadata(string metaKey, string namespace, uint48 _profileId) public {
        require(msg.sender == ownerOf(_profileId));
        super.removeMetadata(metaKey, namespace, _profileId);
    }
    // META FUNCTIONS END

    // FOLLOW FUNCTIONS
    // Follow functions must check if profiles exist in the first place
    function newFollow(uint48 _initiatorId, uint48 _targetId) public {
        require(msg.sender == ownerOf(_initiatorId));
        require(_initiatorId != _targetId); // make sure we're not following ourselves
        require(!profiles[_initiatorId].uFollow[_targetId]); // make sure we're not refollowing someone
        require(profileExists[_initiatorId] && profileExists[_targetId]); // The profiles must exist
        super.newFollow(_initiatorId, _targetId);
        NewFollow(_initiatorId, _targetId);
    }

    function newUnfollow(uint48 _initiatorId, uint48 _targetId) public {
        require(msg.sender == ownerOf(_initiatorId));
        require(_initiatorId != _targetId); // make sure we're not following ourselves
        require(profiles[_initiatorId].uFollow[_targetId]); // make sure we're not unfollowing someone we don't follow
        require(profileExists[_initiatorId] && profileExists[_targetId]);
        super.newUnfollow(_initiatorId, _targetId);
        NewUnfollow(_initiatorId, _targetId);
    }
    // FOLLOW FUNCTIONS END

    // VERIFY FUNCTIONS
    // Need to charge for verification
    function makeVerifier(address _verifier) public {
        require(msg.sender == controller);
        contractCanVerify[_verifier] = true;
    }

    function verifyProfile(string _tier, uint48 _profileId) public {
        require(contractCanVerify[msg.sender]);
        profiles[_profileId].verifiedStatus[_tier] = true;
    }
    // VERIFY FUNCTIONS END

    function setPrice(uint256 _newPrice) public {
        require(msg.sender == controller);
        price = _newPrice;
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
