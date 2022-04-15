pragma solidity ^0.8.4;
contract SafeMoonCoin {
    address public owner;
   
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  
    
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;

  interface IERC20 {
  
      function totalSupply() external view returns (uint256);
  
 
      function balanceOf(address account) external view returns (uint256);
  

      function transfer(address recipient, uint256 amount) external returns (bool);
  

      function allowance(address owner, address spender) external view returns (uint256);

      function approve(address spender, uint256 amount) external returns (bool);

      function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  

      event Transfer(address indexed from, address indexed to, uint256 value);
  

      event Approval(address indexed owner, address indexed spender, uint256 value);
  }


    }

     using Address for address;
  
      mapping (address => uint256) private _rOwned;
      mapping (address => uint256) private _tOwned;
      mapping (address => mapping (address => uint256)) private _allowances;
  
      mapping (address => bool) private _isExcludedFromFee;
  
      mapping (address => bool) private _isExcluded;
      address[] private _excluded;
     
      uint256 private constant MAX = ~uint256(0);
      uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
      uint256 private _rTotal = (MAX - (MAX % _tTotal));
      uint256 private _tFeeTotal;
  
      string private _name = "SafeMoonCoin";
      string private _symbol = "SMC";
      uint8 private _decimals = 9;
      
      uint256 public _taxFee = 5;
      uint256 private _previousTaxFee = _taxFee;
      
      uint256 public _liquidityFee = 5;
      uint256 private _previousLiquidityFee = _liquidityFee;
  
  
    //Function to transfer ownership
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0));
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
  
  }

     //Pause function
  
  contract Pausable is Ownable {
    event Pause();
    event Unpause();
  
    bool public paused = false;
  
  
    
    modifier whenNotPaused() {
      require(!paused);
      _;
    }
  
    
     //Pause release
    function unpause() onlyOwner whenPaused public {
      paused = false;
      emit Unpause();
    }
  }
  
  contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
  }
  
  contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
  }
  
  
  contract StandardToken is ERC20 {
    using SafeMath for uint256;
  
    mapping (address => mapping (address => uint256)) internal allowed;
    mapping(address => bool) tokenBlacklist;
    event Blacklist(address indexed blackListed, bool value);
  
  
    mapping(address => uint256) balances;
  
  
    function transfer(address _to, uint256 _value) public returns (bool) {
      require(tokenBlacklist[msg.sender] == false);
      require(_to != address(0));
      require(_value <= balances[msg.sender]);
  
      // If insufficient balanced
      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
    }
  
  
    function balanceOf(address _owner) public view returns (uint256 balance) {
      return balances[_owner];
    }
  
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
      require(tokenBlacklist[msg.sender] == false);
      require(_to != address(0));
      require(_value <= balances[_from]);
      require(_value <= allowed[_from][msg.sender]);
  
      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }
  
  
    function approve(address _spender, uint256 _value) public returns (bool) {
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
    }
  
  
    function allowance(address _owner, address _spender) public view returns (uint256) {
      return allowed[_owner][_spender];
    }
  
  
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }
  
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
      uint oldValue = allowed[msg.sender][_spender];
      if (_subtractedValue > oldValue) {
        allowed[msg.sender][_spender] = 0;
      } else {
        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
      }
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }
    
  
  
    function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
    require(tokenBlacklist[_address] != _isBlackListed);
    tokenBlacklist[_address] = _isBlackListed;
    emit Blacklist(_address, _isBlackListed);
    return true;
    }
  
  
  
  }
  
  contract PausableToken is StandardToken, Pausable {
  
    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
      return super.transfer(_to, _value);
    }
  
    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
      return super.transferFrom(_from, _to, _value);
    }
  
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
      return super.approve(_spender, _value);
    }
  
    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
      return super.increaseApproval(_spender, _addedValue);
    }
  
    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
      return super.decreaseApproval(_spender, _subtractedValue);
    }
    
    function blackListAddress(address listAddress,  bool isBlackListed) public whenNotPaused onlyOwner  returns (bool success) {
    return super._blackList(listAddress, isBlackListed);
    }
    
  }
  
  contract CoinToken is PausableToken {
      string public name;
      string public symbol;
      uint public decimals;
      event Mint(address indexed from, address indexed to, uint256 value);
      event Burn(address indexed burner, uint256 value);
  
    
      constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, address tokenOwner) public {
          name = _name;
          symbol = _symbol;
          decimals = _decimals;
          totalSupply = _supply * 10**_decimals;
          balances[tokenOwner] = totalSupply;
          owner = tokenOwner;
          emit Transfer(address(0), tokenOwner, totalSupply);
      }
            
    
    function burn(uint256 _value) public {
      _burn(msg.sender, _value);
    }
  
    function _burn(address _who, uint256 _value) internal {
      require(_value <= balances[_who]);
      balances[_who] = balances[_who].sub(_value);
      totalSupply = totalSupply.sub(_value);
      emit Burn(_who, _value);
      emit Transfer(_who, address(0), _value);
    }

       //Mintable
  
      function mint(address account, uint256 amount) onlyOwner public {
  
          totalSupply = totalSupply.add(amount);
          balances[account] = balances[account].add(amount);
          emit Mint(address(0), account, amount);
          emit Transfer(address(0), account, amount);
      }
  
      
  }
