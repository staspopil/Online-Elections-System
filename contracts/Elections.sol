
pragma solidity >=0.4.22 <0.9.0;

contract Election {

    //Evation End Time
    uint256 timePointToEnd = block.timestamp+(60*60*24*2);

    // constructor() public {
    //   timePointToEnd = uint32(block.timestamp+(60*60*24*2));   
    // }

    //predetermined address
    address owner = 0x1287f26179d27DDd83c48A24d12c26e73a13eeD6;
    
    event voteAccepted(uint16 vote);
    uint16 voteId = 0;

    struct candidate{
        uint16 PDM;
        uint16 PAS;
        uint16 PCRM;
        uint16 PSRM;
    }

    candidate result;
    mapping (uint16 => address) private idnpToAdress;
    mapping (uint16 => bool) internal ifVoted;
    mapping (uint16 => string) public cadidateById;




    //Modifiers
    modifier ownerCheck(){
        require(msg.sender == owner);
        _;
    }

    modifier checkClientAdress(uint16 _idnp){
        require(idnpToAdress[_idnp] == msg.sender);
        _;
    }

    modifier checkIfVoted(uint16 _idnp) {
        require(!ifVoted[_idnp]);
        _;
    }

    modifier checkTimeLimit() {
        require(block.timestamp<timePointToEnd);
        _;
    }

    //Vote Functions feDone
    //checkIfVoted(_idnp) checkTimeLimit() checkClientAdress(_idnp)
    function pasVote(uint16 idnp) public checkIfVoted(idnp) checkTimeLimit() checkClientAdress(idnp) returns(uint16)  {
        result.PAS++;
        voteId++;
        uint16 _voteId = voteId;
        cadidateById[voteId] = "PAS";
        voteRegistering(idnp);
        emit voteAccepted(_voteId);
    }

    function pdmVote(uint16 _idnp) public checkIfVoted(_idnp) checkTimeLimit() checkClientAdress(_idnp) returns(uint16)  {
        result.PDM++;
        voteId++;
        cadidateById[voteId] = "PDM";
        voteRegistering(_idnp);
        uint16 _voteId = voteId;
        emit voteAccepted(_voteId);
    }

    function psrmVote(uint16 _idnp) public checkIfVoted(_idnp) checkTimeLimit() checkClientAdress(_idnp) returns(uint16)  {
        result.PSRM++;
        voteId++;
        uint16 _voteId = voteId;
        cadidateById[voteId] = "PSRM";
        voteRegistering(_idnp);
        return _voteId;
    }

    function pcrmVote(uint16 _idnp) public checkIfVoted(_idnp) checkTimeLimit() checkClientAdress(_idnp) returns(uint16)  {
        result.PCRM++;
        voteId++;
        cadidateById[voteId] = "PCRM";
        voteRegistering(_idnp);
        return voteId;
    }

    function voteRegistering(uint16 _idnp) public {
        ifVoted[_idnp] = true;
    }
    
    //fe
    function getResult() public view returns(uint16[4] memory){
        uint16[4] memory res;
        res[0] = result.PAS;
        res[1] = result.PCRM;
        res[2] = result.PSRM;
        res[3] = result.PDM;
        return res;
    }

    function getCandidateById(uint16 id) public view returns(string memory){
        return cadidateById[id];
    }

    //Admin Panel For Test
    function addAdress(uint16 _idnp, address _client) public ownerCheck {
        idnpToAdress[_idnp] = _client;
    }

    function changeOwner(address _newOwner) public ownerCheck {
        owner = _newOwner;
    }

    function resetVoteForId(uint16 _idnp) public ownerCheck {
        ifVoted[_idnp] = false;
    }
}
