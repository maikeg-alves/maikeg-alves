# Documentação de Utilização do Endpoint para Envio de Mensagens - Plataforma Meu James

## Visão Geral
A API do **Meu James** permite o envio de mensagens via WhatsApp utilizando integrações com o **Meta Business**. O James atua apenas como **intermediário**: se o sistema do cliente enviar a requisição com as informações necessárias, o James encaminha a mensagem para o WhatsApp configurado na conta do cliente.

---

## Endpoint
**URL Base:**
```
https://meujames.com/api/playsms
```

**Método:** `GET`

### Estrutura da Requisição
Parâmetros obrigatórios:
- **op** → operação a ser executada (sempre `pv` para envio de mensagem);
- **u** → usuário da conta (email do cliente);
- **h** → token de autenticação (hash gerado);
- **msg** → mensagem a ser enviada. Essa mensagem deve estar associada a um **template** configurado no WhatsApp Business;
- **to** → número(s) de telefone do(s) destinatário(s). Para múltiplos números, separar por vírgula.

### Exemplo de Requisição Simples
```
GET https://meujames.com/api/playsms?&op=pv&u=user&h=hash&msg=texto&to=telefones
```

---

## Formato da Mensagem (MSG)
A mensagem enviada deve estar relacionada a um **template do Meta Business** já configurado.

### Estrutura esperada do campo `msg`:
```json
{
  "nome_template": "NOME DO TEMPLATE",
  "params": {}
}
```
- **nome_template**: nome do template cadastrado no **Meta Business**;
- **params**: parâmetros opcionais que podem ser utilizados no template.

> ⚠️ É importante seguir este formato para que o envio seja aceito e corretamente encaminhado pelo WhatsApp.

---

## Retorno da API
- **Sucesso:**
```json
{"status":"OK","error":"0"}
```

- **Erro:**
```json
{"status":"ERR","error":"code_error"}
```

---

## Envio para Múltiplos Destinatários
É possível enviar uma única mensagem para vários números ao mesmo tempo. Basta separar os números no campo `to` por vírgula:

```
https://meujames.com/api/playsms?op=pv&u=user&h=hash&msg=texto&to=11997217411,11991234567,11999887766
```

---

## Exemplo em Node.js (Axios)
```javascript
var axios = require("axios").default;

var options = {
  method: 'GET',
  url: 'https://meujames.com/api/playsms',
  params: {
    op: 'pv',
    u: 'seu_usuario_aqui',
    h: 'seu_hash_aqui',
    msg: '{"nome_template": "NOME DO TEMPLATE", "params": {}}',
    to: '11997217411'
  },
  headers: { 'User-Agent': 'insomnia/11.6.0' }
};

axios.request(options).then(function (response) {
  console.log(response.data);
}).catch(function (error) {
  console.error(error);
});
```

---

## Observações Importantes
1. **MSG** deve sempre seguir o formato de templates configurados no Meta Business;
2. O campo **u (user)** deve ser configurado como o usuário principal da sua conta;
3. O **REST principal** deve ser utilizado para requisições, e o REST secundário pode ser usado para autenticação e gerenciamento de contas;
4. O James não cria nem gerencia os templates, apenas encaminha as mensagens para o WhatsApp;
5. É possível enviar para múltiplos números de uma só vez.

---

## Conclusão
Essa integração permite automatizar o envio de mensagens de forma escalável, aproveitando os templates do **Meta Business** e utilizando o James como camada intermediária de comunicação entre o sistema do cliente e o WhatsApp.

> Para dúvidas adicionais, entre em contato com o suporte da plataforma Meu James.

