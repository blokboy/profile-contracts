pragma solidity ^0.4.19;


contract StringFunctions is ProfileFactory {

    function changeName(string _newName, uint48 _profileId) internal {
        profiles[_profileId].name = _newName;
    }

    function changeHandle(string _newHandle, uint48 _profileId) internal {
        profiles[_profileId].handle = _newHandle;
    }

    function editBio(string _newBio, uint48 _profileId) internal {
        profiles[_profileId].bio = _newBio;
    }
}
