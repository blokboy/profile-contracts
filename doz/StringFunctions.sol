pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract StringFunctions is ProfileFactory {

    function _changeName(string _newName, uint256 _profileId) internal {
        profiles[_profileId].name = _newName;
    }

    function _changeHandle(string _newHandle, uint256 _profileId) internal {
        profiles[_profileId].handle = _newHandle;
    }

    function _editBio(string _newBio, uint256 _profileId) internal {
        profiles[_profileId].bio = _newBio;
    }

    /*
    function validString(string s) internal pure returns(bool) {
        // Check if name or handle is a valid string
    }
    */
}
