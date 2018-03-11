pragma solidity ^0.4.19;


contract MetaFunctions is ProfileFactory {

    function editMetadata(string metaKey, string metaValue, string namespace, uint48 _profileId) internal {
        // The code below works for both editing an existing key/value pair
        // and for creating a new pair as well
        // namespace is the app from which this metadata comes from. Ex: Social Dapp
        // metaKey is the key (a string) we will be looking up. Ex: website
        //metaValue is the value that search will return. Ex: https://ghiliweld.github.io
        // profiles[_profileId].metadata["Social Dapp:website"] = "https://ghiliweld.github.io"
        profiles[_profileId].metadata[namespace + ":" + metaKey] = metaValue;
    }

    function removeMetadata(string metaKey, string namespace, uint48 _profileId) internal {
        // The code below will delete a key/value pair from the metadata mapping
        delete profiles[_profileId].metadata[namespace + ":" + metaKey];
    }
    
}
