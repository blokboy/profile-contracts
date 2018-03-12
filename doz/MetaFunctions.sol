pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract MetaFunctions is ProfileFactory {

    function _editMetadata(string metaKey, string metaValue, string space, uint256 _profileId) internal {
        // The code below works for both editing an existing key/value pair
        // and for creating a new pair as well
        // space is the app from which this metadata comes from. Ex: Social Dapp
        // metaKey is the key (a string) we will be looking up. Ex: website
        //metaValue is the value that search will return. Ex: https://ghiliweld.github.io
        // metadata[profileId][space][metaKey] = metaValue

        metadata[_profileId][space][metaKey] = metaValue;
    }

    function _removeMetadata(string metaKey, string space, uint256 _profileId) internal {
        // The code below will delete a key/value pair from the metadata mapping

        delete metadata[_profileId][space][metaKey];
    }

}
