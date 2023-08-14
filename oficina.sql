CREATE DATABASE IF NOT EXISTS oficina;
USE oficina;

DROP DATABASE oficina;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE veiculo(
	id_veiculo INT auto_increment PRIMARY KEY,
    idRevisão INT,
    placa CHAR(7) NOT NULL,
    CONSTRAINT placa_id_veiculo UNIQUE (id_veiculo, placa)
);

ALTER TABLE veiculo ADD CONSTRAINT fk_eqp_mecanicos FOREIGN KEY (id_veiculo) REFERENCES EqpMecanico(idEqpMecanico),
ADD CONSTRAINT fk_conserto FOREIGN KEY (id_veiculo) REFERENCES Conserto(idConserto),
ADD CONSTRAINT fk_revisao FOREIGN KEY (idRevisão) REFERENCES Revisao(idRevisão);

DESC veiculo;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE cliente(
	idClientes INT auto_increment PRIMARY KEY,
    id_veiculo INT,
    CONSTRAINT fk_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

DESC cliente;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE PessoaFisica(
	idPessoaFisica INT auto_increment PRIMARY KEY,
    FNome VARCHAR(45) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Endereço VARCHAR(45),
    Contato CHAR(11)
);

ALTER TABLE PessoaFisica ADD CONSTRAINT unique_cpf_PessoaFisica UNIQUE (CPF);
ALTER TABLE PessoaFisica ADD CONSTRAINT fk_idClientes_pf FOREIGN KEY (idPessoaFisica) REFERENCES cliente(idClientes),
ADD CONSTRAINT fk_clinte_pf FOREIGN KEY (idClientePf) REFERENCES cliente(idClientes),
ADD CONSTRAINT fk_veiculo_pf FOREIGN KEY (idPessoaFisica) REFERENCES veiculo(id_veiculo);
DESC PessoaFisica;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE PessoaJuridica(
	idPessoaJuridica INT auto_increment PRIMARY KEY,
    RazaoSocial VARCHAR(45) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Endereço VARCHAR(45),
    Contato CHAR(11),
    CONSTRAINT unique_cnpj_PessoaJuridica UNIQUE (CNPJ)
);

ALTER TABLE PessoaJuridica ADD CONSTRAINT fk_clientes_pj FOREIGN KEY (idPessoaJuridica) REFERENCES cliente(idClientes),
ADD CONSTRAINT fk_veiculo_pj FOREIGN KEY (idPessoaJuridica) REFERENCES veiculo(id_veiculo);
DESC PessoaJuridica;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Conserto(
	idConserto INT auto_increment PRIMARY KEY,
    Descrição VARCHAR(45) NOT NULL
);
DESC Conserto;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Revisão(
	idRevisão INT auto_increment PRIMARY KEY,
    Descrição VARCHAR(45) NOT NULL
);
DESC Revisão;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Mecanico(
	idMecanico INT auto_increment PRIMARY KEY,
    FNome VARCHAR(45) NOT NULL,
    Endereço VARCHAR(45) NOT NULL,
    Especialidade VARCHAR(45) NOT NULL
);
DESC Mecanico;

-------------------------------------------------------------------------------------------------------------------
CREATE TABLE EqpMecanic(
	idEqpMecanic INT auto_increment PRIMARY KEY
);
ALTER TABLE EqpMecanic ADD CONSTRAINT fk_Mecanico FOREIGN KEY (idEqpMecanic) REFERENCES Mecanico(idMecanico);
ALTER TABLE OrdemServiço ADD CONSTRAINT fk_OrdemServiço FOREIGN KEY (idOrdemServiço) REFERENCES OrdemServiço(idOrdemServiço);
DESC EqpMecanic;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE OrdemServiço(
	idOrdemServiço INT auto_increment PRIMARY KEY,
    DataEmissão DATE,
    ValorServiço FLOAT NOT NULL,
    ValorPeça FLOAT NOT NULL,
    ValorTotal FLOAT NOT NULL,
    Status ENUM('AGUARDANDO', 'EM ANDAMENTO', 'CONCLUIDO', 'CANCELADO'),
    DataConclusão DATE
);
SELECT * FROM OrdemServiço ORDER BY DataEmissão;
SELECT * FROM OrdemServiço ORDER BY ValorTotal;
DESC OrdemServiço;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE RefPreços(
	idRefPreços INT auto_increment PRIMARY KEY,
    CONSTRAINT fk_referencia_precos FOREIGN KEY (idRefPreços) REFERENCES OrdemServiço(idOrdemServiço)
);
DESC RefPreços;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Autorização(
	idAutorização INT auto_increment PRIMARY KEY,
	autorizado BOOL DEFAULT FALSE,
    CONSTRAINT fk_autorização_cliente FOREIGN KEY (idAutorização) REFERENCES cliente(idClientes),
    CONSTRAINT fk_autorização_veiculo FOREIGN KEY (idAutorização) REFERENCES veiculo(id_veiculo),
    CONSTRAINT fk_autorização_OrdemServiço FOREIGN KEY (idAutorização) REFERENCES OrdemServiço(idOrdemServiço)
);
DESC Autorização;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE pecas(
	idpecas INT auto_increment PRIMARY KEY,
    Descrição VARCHAR(45),
    Valor FLOAT NOT NULL
);
DESC pecas;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Ospecas(
	idOspecas INT auto_increment PRIMARY KEY,
	CONSTRAINT fk_pecas FOREIGN KEY (idOspecas) REFERENCES pecas(idpecas),
    CONSTRAINT fk_os_pecas FOREIGN KEY (idOspecas) REFERENCES OrdemServiço(idOrdemServiço)
);
DESC Ospecas;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE Serviços(
	idServiços INT auto_increment PRIMARY KEY,
    Descrição VARCHAR(45),
    Valor FLOAT NOT NULL
);
DESC Serviços;

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE OrdemServiço(
	idOrdemServiço INT auto_increment PRIMARY KEY,
    CONSTRAINT fk_serviços FOREIGN KEY (idOrdemServiço) REFERENCES Serviços(idServiços),
    CONSTRAINT fk_os_serviços FOREIGN KEY (idOrdemServiço) REFERENCES OrdemServiço(idOrdemServiço)
);
DESC OrdemServiço;