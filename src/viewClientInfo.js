// import Web3 from ‘web3’;
var Web3 = require('web3');
// import React, { Component } from 'react';
// var React = require('react');
// var Component = React.Component;

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
const myContractAddress = "0x998BE4D82e8Ca21fDA413bA39fe751A24fE92797";
const myABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "inst_pub_addr",
				"type": "address"
			},
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "street_addr",
				"type": "string"
			},
			{
				"name": "city",
				"type": "string"
			},
			{
				"name": "state",
				"type": "uint8"
			},
			{
				"name": "institution_type",
				"type": "uint8"
			},
			{
				"name": "can_verify",
				"type": "bool"
			}
		],
		"name": "add_institution",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "client_pub_addr",
				"type": "address"
			},
			{
				"name": "permission_key_hash",
				"type": "string"
			},
			{
				"name": "time_of_visit",
				"type": "uint256"
			},
			{
				"name": "ipfs_address",
				"type": "string"
			}
		],
		"name": "add_record",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "inst_pub_addr",
				"type": "address"
			},
			{
				"name": "identifying_info_for_inst",
				"type": "string"
			}
		],
		"name": "check_in",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "client_self_check_out",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "client_pub_addr",
				"type": "address"
			}
		],
		"name": "inst_client_check_out",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "identifying_info",
				"type": "string"
			},
			{
				"name": "date_of_birth",
				"type": "uint256"
			},
			{
				"name": "sex",
				"type": "uint8"
			},
			{
				"name": "gender",
				"type": "uint8"
			},
			{
				"name": "id_type",
				"type": "uint8"
			}
		],
		"name": "join_as_client",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "client_pub_addr",
				"type": "address"
			},
			{
				"name": "identifying_info",
				"type": "string"
			},
			{
				"name": "id_type",
				"type": "uint8"
			}
		],
		"name": "verify_exisiting_client",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "admin",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];
const myContract = new web3.eth.Contract(myABI, myContractAddress);

function getClient(client_public_address) {
	return myContract.methods.client_map(client_public_address).call();

}

function getInst(inst_public_address) {
	return myContract.methods.institution_map(inst_public_address).call();
}

function testPrint() {
	var client = getClient("0x12cBF23Ed1Cdb7A0A1A8d9eAE1Db31966366e194");
	for (var i = 0; i < client.len; i++) {
   		var record = client.record_metas[i];
   		var inst = getInst(record.inst_pub_addr);
   		console.log(inst.name + inst.institution_type + record.time_of_visit + inst.city + inst.state);
   	}
}
testPrint();

// class RecordMetaCardComponent extends Component {
// 		constructor(props) {
// 			super(props);
// 		}
//
//     render() {
//         return (
//             <div>
//                	<p>Institution Name: {this.props.institutionName}</p>
//                	<p>Institution Type: {this.props.institutionType}</p>
//                	<p>Time of Visit: {this.props.time}</p>
//                	<p>Location: {this.props.city}, {this.props.state}</p>
//             </div>
//
//         )
//     }
// }
//
// export default class RecordMetasComponent extends Component {
// 		constructor() {
// 			this.state = {
// 				client: null
// 			}
// 		}
//
// 		componentDidMount() {
// 			this.setState({client: getClient("0x12cBF23Ed1Cdb7A0A1A8d9eAE1Db31966366e194")});
// 		}
//
//     render() {
// 	   	var cards = [];
// 	   	for (var i = 0; i < client.len; i++) {
// 	   		var record = this.state.client.record_metas[i];
// 				var inst = getInst(record.inst_pub_addr);
// 	   		cards.push(<RecordMetaCardComponent
// 					institutionName={inst.name}
// 					institutionType={inst.institution_type}
// 					time={record.time_of_visit}
// 					city={inst.city}
// 					state={inst.state}\>);
// 	   	}
// 	       return (
// 	            <div>
// 	                {cards}
// 	            </div>
// 	        )
//     }
// }
//
// const domContainer = document.querySelector('#reactComponent');
// ReactDOM.render(React.createElement(RecordMetaCardComponent), domContainer);
