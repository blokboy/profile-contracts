pragma solidity ^0.4.19;


contract String is ProfileBase {

    function _changeHandle(string _newHandle, uint256 _id) internal {
        profiles[_id].handle = _newHandle;
    }

    /*
    function validString(string s) internal pure returns(bool) {
        // Check if name or handle is a valid string
    }
    */
}
