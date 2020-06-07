pragma solidity ^0.4.18;

contract TransferenciaVeiculo {

  struct Transferencia {
    uint id;
    string placa;
    string marca;
    string detalhes;
    uint256 preco;
    address tokenProp;
    address tokenComp;
  }

  mapping (uint => Transferencia) public transferencias;
  uint transfCounter;


  //retorna transferencias realizadas
  function getTransferenciasRealizadas() public view returns (uint[]) {
    uint[] memory transferenciasIds = new uint[](transfCounter);

    uint numberOfTransf = 0;
    for(uint i = 1; i <= transfCounter; i++) {
      if(transferencias[i].tokenComp == 0x0) {
        transferenciasIds[numberOfTransf] = transferencias[i].id;
        numberOfTransf++;
      }
    }

    //copia para array de itens
    uint[] memory forTransf = new uint[](numberOfTransf);
    for(uint j = 0; j < numberOfTransf; j++) {
      forTransf[j] = transferenciasIds[j];
    }

    return forTransf;
  }

  function novaTransferencia(string _placa, string _marca, string _detalhes, uint256 _preco, address _tokenProp, address _tokenComp) payable public {
  	transfCounter++;
    transferencias[transfCounter] = Transferencia(
    	transfCounter,
        _placa,
	    _marca,
	    _detalhes,
	    _preco,
	    _tokenProp,
	    _tokenComp
    );


    _tokenProp = _tokenProp;
    Transferencia storage transf = transferencias[transfCounter];

    //não pode ser do próprio comprador
    require(msg.sender != transf.tokenProp);

    //atualiza comprador
    transf.tokenComp = msg.sender;

    //paga vendedor
    transf.tokenProp.transfer(msg.value);
  }
}
