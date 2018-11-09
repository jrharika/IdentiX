pragma solidity ^0.4.25;
contract IdentX {
    enum State { Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware, District_of_Columbia, Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New_Hampshire, New_Jersey, New_Mexico, New_York, North_Carolina, North_Dakota, Ohio, Oklahoma, Oregon, Pennsylvania, Rhode_Island, South_Carolina, South_Dakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, West_Virginia, Wisconsin, Wyoming }
    enum Institution_Type { basic }
    struct Institution {
        string name;
        string street_addr;
        string city;
        State state;
        Institution_Type institution_type;
        bool can_verify;
        
        address[] checked_in_clients;
    }
    
    enum Sex { Male, Female }
    enum Gender { Male, Female, Nonbinary, Other }
    enum ID_Type { No_ID, SSN, California_state_ID }
    
    struct Client {
        string identifying_info; //first name, last name, and id number are encrypted for privacy
        string identifying_info_for_inst;
        address inst_checked_in_at;
        uint256 date_of_birth;
        Sex sex;
        Gender gender;
        ID_Type id_type;
    }
    
    struct Record_Meta {
        address inst_pub_addr;
        string permission_key_hash;
        uint256 time_of_visit;
        string ipfs_address;
    }
    
    address public admin;
    mapping(address => Institution) institution_map;
    mapping(address => Client) client_map;

    constructor() public {
        admin = msg.sender;
    }
    
    function add_institution(address inst_pub_addr, string name, string street_addr, string city, State state, Institution_Type institution_type, bool can_verify) external {
        require(msg.sender == admin, "Only the admin can add institutions.");
        Institution storage new_institution = Institution({name: name, street_addr: street_addr, city: city, state: state, institution_type: institution_type, can_verify: can_verify, checked_in_clients: address[]});
        
        institution_map[inst_pub_addr] = new_institution;
    }
    
    function join_as_client(string identifying_info, uint256 date_of_birth, Sex sex, Gender gender, ID_Type id_type) external {
        require(institution_map[msg.sender] == 0, "Address associated with institution. Cannot join as client.");
        require(client_map[msg.sender] == 0, "Address already associated with a client. Cannot join as client again.");
        Client new_client = new Client();
        
        new_client.identifying_info = identifying_info;
        new_client.date_of_birth = date_of_birth;
        new_client.sex = sex;
        new_client.gender = gender;
        new_client.id_type = id_type;
        
        client_map[msg.sender] = new_client;
    }
    
    function verify_exisiting_client(address client_pub_addr, string identifying_info, ID_Type id_type) external {
        require(institution_map[msg.sender].can_verify, "Only institutions with verification privileges can verify clients.");
        Client client = client_map[client_pub_addr];
        
        client.identifying_info = identifying_info;
        client.id_type = id_type;
    }
    
    function add_record(address client_pub_addr, string permission_key_hash, uint256 time_of_visit, string ipfs_address) external {
        require(institution_map[msg.sender] > 0, "Only institutions can add records.");
        require(client_map[client_pub_addr] > 0, "Must be adding records to a client.");
        require(client_map[client_pub_addr].inst_checked_in_at == msg.sender, "Institutions may only add records to clients that are checked in with them.");
        
        Record_Meta new_record = new Record_Meta();
        
        new_record.inst_pub_addr = msg.sender;
        new_record.permission_key_hash = permission_key_hash;
        new_record.time_of_visit = time_of_visit;
        new_record.ipfs_address = ipfs_address;
    }
    
    function check_in(address inst_pub_addr, string identifying_info_for_inst) external {
        require(client_map[msg.sender] > 0, "Only clients can check in.");
        Client client = client_map[msg.sender];
        require(client.inst_checked_in_at == 0, "Client is already checked in. Check out to check in at a different institution.");
        
        client.identifying_info_for_inst = identifying_info_for_inst;
        client.inst_checked_in_at = inst_pub_addr;
        
        institution_map[inst_pub_addr].checked_in_clients.push(msg.sender);
    }
    
    function check_out_helper(address client_pub_addr) internal {
        Client client = client_map[client_pub_addr];
        address[] clients_list = institution_map[client.inst_checked_in_at].checked_in_clients;
        int i = 0;
        bool deleted = false;
        while (!deleted && i < clients_list.length) {
            if (clients_list[i] == msg.sender) {
                clients_list[i] = clients_list[clients_list.length-1];
                delete clients_list[clients_list.length-1];
                clients_list.length--;
                deleted = true;
            }
        }
        assert(deleted);

        client.identifying_info_for_inst = "";
        client.inst_checked_in_at = 0;
    }
    
    function client_self_check_out() external {
        require(client_map[msg.sender] > 0, "Only clients can self check out.");
        Client client = client_map[msg.sender];
        require(client.inst_checked_in_at > 0, "Client not checked in. Cannot check out.");
        
        check_out_helper(msg.sender);
    }
    
    function inst_client_check_out(address client_pub_addr) {
        require(institution_map[msg.sender] > 0, "Only institutions can check out their clients.");
        require(client_map[client_pub_addr] > 0, "Must be checking out a client.");
        require(client_map[client_pub_addr].inst_checked_in_at == msg.sender, "Institutions may only check out clients that are checked in with them.");
        
        check_out_helper(client_pub_addr);
    }
    
}

