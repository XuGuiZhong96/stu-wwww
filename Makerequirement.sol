pragma solidity ^0.4.22;


contract Utils {
    
    function stringToBytes32(string memory source)  internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x)  internal pure returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}



contract Makerequirement is Utils{
  
    address owner;  //发布人地址
    
    //information of companies
    struct Company{  
        address Company_adress;
        bytes32 Company_name;
        bytes32 password;
        bytes32[] HaveEmployees;
        bytes32[] NeedTransactions;
        bytes32[] HaveTransactions;
    }
    
    //information of empolyees
    struct Employee{
        bytes32 employeeID;
        string career;//type of worker
        string addrOfwork; //employee's address
        bool isLent;     //if he has been lent
        uint releaseTime;  //relase time
        address[] transferProcess; //history
    }
    
    struct NeedTransaction{
        bytes32 transactionID;
        string career;
        uint Howlong;
        uint nums;
        uint part;
        uint all;
        string addressOfWork;
        string salaryways;
        uint salary;
        string others;
    }
    
    struct HaveTransaction{
        bytes32 transactionID;
        bytes32[] havemployees;
        uint Howlong;
        uint part;
        uint all;
        uint nums;
        string career;
        string addressOfWork;
        
    }
    
     mapping(address => Company) companies; //all companies
     
     mapping(bytes32 => Employee) employees; //all employees
     mapping(bytes32 => NeedTransaction) NeedTransactions;
     mapping(bytes32 => address) EmployeeToLender;  // find which company lend the Employee
      mapping(bytes32 => HaveTransaction) HaveTransactions;
    
     
     address[] companiesAddr; //all companies' address
     bytes32[] employeesID;   //all employees
     bytes32[] NeedTransactionsID;
     bytes32[] HaveTransactionsID;
     
     
     modifier onlyOwner(){
         if(msg.sender == owner)
         _;
     }
     
     modifier onlyOwnerOf(bytes32 _employeeID){
         require(msg.sender == EmployeeToLender[_employeeID]);
         _;
     }
     
     constructor() public{
         owner =msg.sender;
     }
     
     function getOwner() constant public returns (address){
         return owner;
     }
     
      //判断company是否已注册
     function isCompanyRegistered(address _companyAddr) internal view returns (bool) {
        bool isRegistered = false;
        for(uint i = 0; i < companiesAddr.length; i++) {
            if(companiesAddr[i] == _companyAddr) {
                return isRegistered = true;
            }
        }
        return isRegistered;
    }
   
     function isNeedTransactionExisted(bytes32 TID) internal view returns (bool) {
        bool isExisted = false;
        for(uint i = 0; i < NeedTransactionsID.length; i++) {
            if(NeedTransactionsID[i] == TID) {
                return isExisted = true;
            }
        }
        return isExisted;
      }
      
      function isHaveTransactionExisted(bytes32 TID) internal view returns (bool) {
        bool isExisted = false;
        for(uint i = 0; i < HaveTransactionsID.length; i++) {
            if(HaveTransactionsID[i] == TID) {
                return isExisted = true;
            }
        }
        return isExisted;
      }

   //发布需求
    event CompanyAddNeedTransaction(address _companyAddr, bool isSuccess, string message);
    function companyAddNeedTransaction(address new_companyAddr,string new_TID,string new_career, uint new_nums, uint New_howlong, uint new_part, uint new_all, string new_addressOfWork, string new_salaryways, uint new_salary, string new_others) public {
        bytes32 id = stringToBytes32(new_TID);
        if(!isNeedTransactionExisted(id)) {
            NeedTransactionsID.push(id);
            NeedTransactions[id].transactionID=id;
            NeedTransactions[id].addressOfWork=new_addressOfWork;
            NeedTransactions[id].salaryways=new_salaryways;
            NeedTransactions[id].salary=new_salary;
            NeedTransactions[id].Howlong=New_howlong;
            NeedTransactions[id].part=new_part;
            NeedTransactions[id].all=new_all;
            NeedTransactions[id].career=new_career;
            NeedTransactions[id].others=new_others;
            NeedTransactions[id].nums=new_nums;
            NeedTransactions[id].part=new_part;
            NeedTransactions[id].all=new_all;
            emit CompanyAddNeedTransaction(new_companyAddr, true, "发布需求成功");
            return;
        } else {
            emit CompanyAddNeedTransaction(new_companyAddr, false, "需求已经存在，发布失败");
            return;
        }
    }
    
    //发布供应
    event CompanyAddHaveTransaction(address newcompanyAddr, bool isSuccess, string message);
    function companyAddHaveTransaction(address newaddress, string newTID, string newcareer, uint newnums, uint newhowlong, uint newpart, uint newall, string newaddressOfWork) public {
        bytes32 id = stringToBytes32(newTID);
        if(!isHaveTransactionExisted(id)) {
            HaveTransactionsID.push(id);
            HaveTransactions[id].transactionID=id;
            HaveTransactions[id].nums=newnums;
            HaveTransactions[id].career=newcareer;
            HaveTransactions[id].Howlong=newhowlong;
            HaveTransactions[id].part=newpart;
            HaveTransactions[id].all=newall;
            HaveTransactions[id].addressOfWork=newaddressOfWork;
            
            
            emit CompanyAddHaveTransaction(newaddress, true, "发布供应成功");
            return;
        } else {
            emit CompanyAddHaveTransaction(newaddress, false, "供应已经存在，发布失败");
            return;
        }
    }
    
    
    
    
}


  
