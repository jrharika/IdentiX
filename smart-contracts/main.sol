pragma solidity ^0.4.25
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
        private string identifying_info; //first name, last name, and id number are encrypted for privacy
        public uint256 date_of_birth;
        public Sex sex;
        public Gender gender;
        public ID_Type id_type;
        public Institution checked_in_at;
        public string info_for_inst;
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
        require(!institution_map[msg.sender], "Address associated with institution. Cannot join as client.");
        require(!client_map[msg.sender], "Address already associated with a client. Cannot join as client again.");
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
    
    //need a function that undoes this
    function check_in(address inst_pub_addr, string identifying_info_that_inst_can_read) external {
        require(client_map[msg.sender], "Only clients can check in.");
        Client client = client_map[user_pub_addr];
        
        client.info_for_inst = identifying_info_that_inst_can_read;
        client.checked_in_at = institution_map[inst_pub_addr];
        
        institution_map[inst_pub_addr].checked_in_clients.push(msg.sender);
    }

    function client_check_out(address inst_pub_addr) external {
        require(client_map[msg.sender], "Only clients can self check out");
        Client client = client_map[msg.sender];
        
        client.checked_in_at = null;
        client.info_for_inst = null;
        
        institution_map[inst_pub_addr].checked_in_clients.remove(msg.sender);
    }
}