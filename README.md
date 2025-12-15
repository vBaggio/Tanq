# Tanq – Gestão de Tanques e Abastecimentos

Aplicação VCL desenvolvida para o desafio técnico descrito em [`Avaliação - Delphi_.pdf`](./docs/Avalia%C3%A7%C3%A3o%20-%20Delphi_.pdf). O objetivo é operar bombas e tanques de combustível: registrar abastecimentos, controlar reposições, manter o estoque conciliado por tanque e emitir relatório consolidado.

> Os binários prontos e um banco Firebird padrão acompanham o repositório em `bin/`. Basta ajustar o `Tanq.ini` e executar o `Tanq.exe` caso não queira compilar.

## Conteúdo do repositório

| Pasta/Arquivo | Descrição |
| --- | --- |
| `bin/` | Binários prontos para uso `Tanq.exe`, `Tanq.ini`, `TANQ.FDB`, `fbclient.dll`, `TanqTests.exe` |
| `src/` | Código-fonte da aplicação (views VCL, controllers, services, repositories, entidades e conexão). |
| `sql/` | Scripts de criação/ajuste do banco (`SCRIPT.SQL`, `CRIAR_BANCO.SQL`). |
| `docs/` | Materiais de apoio do desafio (PDF do enunciado e diagrama ER). |
| `tests/` | Testes automatizados em DUnit5. |
| `Tanq.dpr` | Projeto principal |
| `TanqTests.dpr` | Testes automatizados |

## Ferramentas e tecnologias

- Delphi 12 (Community Edition utilizada no desenvolvimento);
- Banco de dados Firebird 5;
- FireDAC para acesso a dados;
- Fortes Report CE para emissão de relatórios;
- DUnit5 para testes automatizados.

## Arquitetura e práticas adotadas

- **Camadas por responsabilidade**: `View` (VCL) → `Controller` → `Service` → `Repository` → `Database`.
- **Interfaces + factories**: `IDbConnection`, repositórios (`I*Repository`) e serviços (`I*Service`) expostos via `TRepositoryFactory` e `TServiceFactory`, permitindo troca/mocks e reuso.
- **Patterns aplicados**: Repository para encapsular SQL; Service Layer para regras de negócio e validações; Factory Method para instanciar os Services, Repositories e Connections;
- **Movimentação de estoque centralizada**: toda saída (abastecimento) e entrada (reposição) gera lançamento em `TANQUE_MOVIMENTO` via `TTanqueMovimentoService`, garantindo consistência ao calcular saldo disponível.
- **Configuração externa**: `TConfigLoader` lê/escreve `Tanq.ini` e resolve caminhos relativos do banco a partir da pasta do executável; cria o arquivo com valores padrão se ausente.
- **Camadas UI desacopladas**: frames que implementam `IFrameView` são carregados dinamicamente pelo `TViewFactory` na `frmMain`.

### Diagrama entidade-relacional

O modelo de dados utilizado pelo aplicativo está ilustrado no diagrama abaixo:

![Diagrama ER](./docs/Tanq.svg)

## Funcionalidades principais

- **Gestão de bombas** (`frmBombas`/`frmBombaEdit`): listar, criar, editar e remover bombas vinculadas a tanques. Exclusão só é permitida se não houver movimentos associados.
- **Abastecimento** (`frmAbastecimento`): seleção de bomba, cálculo automático de valores (unitário, imposto, total), validação de estoque disponível e registro do abastecimento. A operação debita o tanque e grava movimento.
- **Reposição de tanque** (`frmReposicao`): seleção de tanque, validação de capacidade disponível, cálculo do saldo após entrada e registro da reposição. A operação credita o tanque e grava movimento.
- **Relatório de abastecimentos** (`frmRelatorio` + `frmRelAbastecimento`): filtro por período, geração de `DataSet` e exibição no Fortes (agrupado por dia e tanque, com totais e impostos).
- **Estoque em tempo real**: saldos são obtidos a partir de `TANQUE_MOVIMENTO` (entradas/saídas), evitando divergência entre telas.

## Fluxos rápidos de uso (UI)

1. **Abastecer**: abra "Abastecimento" → escolha a bomba → informe a quantidade → confira totais → confirmar. Estoque é debitado, valores e impostos calculados e exibidos.
2. **Reposição de Tanque**: abra "Reposição" → escolha o tanque → informe quantidade e observação opcional → confirmar. O sistema bloqueia exceder a capacidade.
3. **Bombas**: abra "Bombas" → Novo/Editar para definir descrição e tanque associado → Excluir disponível apenas para bombas sem movimentos.
4. **Relatório**: abra "Relatório" → selecione data inicial/final → Gerar. O sistema abre o preview do relatório

> O usuário logado ainda não é implementado; as telas utilizam `UsuarioId = 1` como placeholder para registrar movimentos.

## Configuração do banco de dados

- Arquivo de configuração: `Tanq.ini` (mesmo diretório do `Tanq.exe`).
- Chaves disponíveis (seção `[Database]`):

```
[Database]
host=127.0.0.1
port=3050
database=TANQ.FDB
username=SYSDBA
password=masterkey
```

- O valor `database` pode ser caminho absoluto, relativo (resolvido a partir da pasta do executável) ou alias registrado no `databases.conf` do Firebird.
- O arquivo `.FDB` **deve** existir previamente. Utilize o `TANQ.FDB` em `bin/` ou restaure/crie manualmente executando os scripts em `sql/`.
- A DLL `fbclient.dll` correta está disponibilizada na pasta bin do projeto, sempre deve estar no mesmo diretório do .exe.

## Como usar sem compilar

1. Instale o Firebird 5 (x86);
2. Abra `bin/`, ajuste `Tanq.ini` conforme necessário;
3. Execute `Tanq.exe`.

## Como compilar

1. Instale o Fortes Report CE seguindo o guia do repositório oficial: <https://github.com/fortesinformatica/fortesreport-ce>. Após instalar os packages, confira se o componente está disponível no IDE.
2. Abra `Tanq.dproj` no Delphi 12 (Community Edition utilizada).
4. Compile o projeto principal `Tanq.dpr` (Win32).

## Scripts SQL e dados

- `sql/SCRIPT.SQL` script para criar as tabelas do banco de dados e popular com alguns registros.
- O dump funcional está em `bin/TANQ.FDB`; use-o como base ou ajuste conforme seu ambiente.

## Testes

- A pasta `tests/` contém os testes em DUnit;
- Por falta de tempo, foram feitos testes apenas para o serviço que gerencia os abastecimentos.

## Possíveis extensões

- Autenticação/controle de usuários (substituir o `UsuarioId` fixo).
- Cadastro/edição de combustíveis e tanques pela UI.
- Auditoria avançada ou dashboards de consumo.
- Exportação dos relatórios em PDF/CSV diretamente da aplicação.

## Contato

- Vinícius Baggio
- E-mail: [vnc.baggio@gmail.com](mailto:vnc.baggio@gmail.com)
- LinkedIn: [linkedin.com/in/vbaggio](https://www.linkedin.com/in/vbaggio/)
