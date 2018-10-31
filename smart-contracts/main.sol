
contract IdentiX {
    enum State { Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware, District of Columbia, Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New Hampshire, New Jersey, New Mexico, New York, North Carolina, North Dakota, Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina, South Dakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, West Virginia, Wisconsin, Wyoming }
    enum Institution_Type { }
    struct Institution {
        string name;
        string street_addr;
        string city;
        State state;
        Institution_Type institution_type;
        bool can_verify;
        
        address[] checked_in_clients;
    }
    
    enum Sex { Male, Female };
    enum Gender { Male, Female, Nonbinary, Other };
    enum ID_Type { No_ID, SSN, California_state_ID };
    
    struct Client {
        public string identifying_info; //first name, last name, and id number are encrypted for privacy
        public string identifying_info_for_inst;
        public address inst_checked_in_at;
        public uint256 date_of_birth;
        public Sex sex;
        public Gender gender;
        public ID_Type id_type;
    }
    
    struct Record_Meta {
        public address inst_pub_addr;
        public string permission_key_hash;
        public uint256 time_of_visit;
        public string ipfs_address;
    }
    
    address public admin;
    mapping(address => Institution) institution_map;
    mapping(address => Client) client_map;

    constructor() public {
        admin = msg.sender;
    }
    
    function add_institution(address inst_pub_addr, string name, string street_addr, string city, State state, Institution_Type institution_type, bool can_verify) external {
        require(msg.sender == admin, "Only the admin can add institutions.");
        Institution new_institution = new Institution();
        new_institution.name = name;
        new_institution.street_addr = street_addr;
        new_institution.city = city;
        new_institution.state = state;
        new_institution.institution_type = institution_type;
        new_institution.can_verify = can_verify;
        
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
        Client client = client_map[user_pub_addr];
        
        client.identifying_info = identifying_info;
        client.id_type = id_type;
    }
    
    function add_record(address client_pub_addr, string permission_key_hash, uint256 time_of_visit, string ipfs_address) {
        require(institution_map[msg.sender] > 0, "Only institutions can add records.");
        require(client_map[client_pub_addr] > 0, "Must be adding records to a client.");
        require(client_map[client_pub_addr].inst_checked_in_at == msg.sender, "Institutions may only add records to clients that are checked in with them.");
        
        Record_Meta new_record = new Record_Meta();
        
        new_record.inst_pub_addr = msg.sender;
        new_record.permission_key_hash = permission_key_hash;
        new_record.time_of_visit = time_of_visit;
        new_record.ipfs_address = ipfs_address;
    })
    
    function check_in(address inst_pub_addr, string identifying_info_for_inst) external {
        require(client_map[msg.sender] > 0, "Only clients can check in.");
        Client client = client_map[user_pub_addr];
        require(client.inst_checked_in_at == 0, "Client is already checked in. Check out to check in at a different institution.");
        
        client.identifying_info_for_inst = identifying_info_for_inst;
        client.inst_checked_in_at = inst_pub_addr;
        
        institution_map[inst_pub_addr].checked_in_clients.push(msg.sender);
    }
    
    function check_out_helper(address client_pub_addr) internal {
        Client client = client_map[client_pub_addr];
        clients_list = institution_map[client.inst_checked_in_at].checked_in_clients;
        i = 0;
        deleted = false;
        while (!deleted && i < clients_list.length) {
            if (clients_list[i] == msg.sender) {
                clients_list[i] = clients_list[clients_list.length-1];
                delete clients_list[clients_list.length-1];
                clients_list.length--;
                deleted = true;
            }
        }
        assert(deleted);

        client.identifying_info_for_inst = null;
        client.inst_checked_in_at = 0;
    }
    
    function client_self_check_out() external {
        require(client_map[msg.sender] > 0, "Only clients can self check out.");
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

